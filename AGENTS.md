# BookKeeper Flutter 账单列表项目说明

本项目规划为一个全新的 Flutter Android 应用，应用首期只实现账单列表显示部分，重点解决真实使用中上万账单数据的连续滑动、无感分页加载、弱网可用、数据一致性和内存稳定问题。

## 产品目标

- 只做 Android 端 Flutter 应用，页面聚焦账单列表，不做完整记账闭环。
- 支持 1 万到 10 万级账单数据的连续浏览。
- 首屏尽快可见，有缓存时优先显示缓存，无缓存时只请求第一页。
- 滑动接近底部时自动预加载下一页，用户不应明显感知“等数据”。
- Flutter UI 不全量持有账单数据，内存占用应随缓存窗口稳定，而不是随总账单数线性增长。
- 列表顺序以账单发生时间倒序为准，发生时间相同再按账单 id 倒序，保证分页顺序稳定。

## 技术架构

整体采用“Flutter 懒渲染列表 + 本地 SQLite 缓存 + 远端游标分页接口”的架构。

```text
Flutter Android
  -> BillListPage
  -> BillListController
  -> BillRepository
  -> Local Cache SQLite
  -> Remote API Cursor Pagination
```

### 推荐技术栈

- Flutter：构建 Android UI。
- Dio：网络请求、超时、拦截器、取消请求、统一错误处理。
- Riverpod：管理列表状态、仓储依赖和页面生命周期。
- Drift + SQLite：本地缓存、索引查询、去重和离线可读。
- Intl：金额和日期展示格式化。

## 目录建议

```text
lib/
├── main.dart
├── app/
│   ├── app.dart                 # 应用入口 Widget
│   ├── router/                  # 路由配置
│   ├── theme/                   # 主题、颜色、字体
│   └── di/                      # 依赖注入
│
├── core/
│   ├── constants/               # 全局常量
│   ├── utils/                   # 通用工具方法
│   ├── widgets/                 # 通用组件
│   ├── errors/                  # 异常、失败模型
│   └── result/                  # Result、状态封装
│
├── data/
│   ├── models/                  # 接口/数据库数据模型
│   ├── services/
        ├── local/               # 本地缓存
        └── remote/              # 远程接口
│   └── repositories/            # Repository 实现
│
├── domain/
│   ├── entities/                # 业务实体
│   ├── repositories/            # Repository 抽象接口
│   └── use_cases/               # 复杂业务逻辑，可选
│
└── features/
    └── bill_list/
        ├── pages/               # 页面
        ├── widgets/             # 当前功能专属组件
        ├── view_models/         # 页面状态和交互逻辑
        └── states/              # UI 状态类，可选
```

## 核心模块

### 列表页面

- 使用 `ListView.builder`，`itemCount` 为当前列表长度，只构建可见区域。
- `cacheExtent` 设置为视口高度的 2~3 倍（如 `MediaQuery.of(context).size.height * 2`），确保快速滑动时预构建充足但不浪费内存。
- 账单行高度尽量稳定。若 UI 固定高度，优先使用 `itemExtent`（默认 72.0）；若需要适配大字体，可使用受控的最小高度。
- `BillRow` 必须拆成独立 widget，以账单 `id` 作为 `key`，避免整页状态变化导致复杂 item 反复重建。
- 不在 `build()` 中做排序、日期解析、金额复杂格式化、颜色解析或网络请求。

### 状态控制器

- `BillListController` 负责首屏加载、下拉刷新、加载更多、错误恢复和请求防重。
- 同一时刻只允许一个加载更多请求。
- 下拉刷新优先级高于加载更多；刷新开始时应取消或忽略旧的加载更多结果。
- 加载更多失败时不能清空已显示列表，只在底部展示重试入口。

### 仓储层

- `BillRepository` 对页面隐藏“远端 + 本地缓存”的细节。
- 首屏流程：先读 SQLite 缓存并显示，再请求远端第一页，成功后 upsert 到 SQLite。
- 分页流程：按游标请求远端下一页，写入 SQLite，再由本地查询驱动 UI 更新。
- 真实接口不可用时，可用 `FakeBillDataSource` 生成 10 万条假数据做滑动和内存压测。

### 本地缓存

- SQLite 表以账单 id 为主键，接口重复返回数据时通过 upsert 去重。
- 本地排序使用索引，不在 Dart 数组里全量排序。
- 已缓存数据可在离线状态下展示，页面顶部以轻量 Banner 提示"当前为离线数据"（浅黄色背景 + 小字文案，不遮挡列表内容）。网络恢复后自动消失。
- 删除、修改、新增账单时先更新本地缓存，再按远端结果确认或回滚。

## 数据模型

列表只返回渲染所需字段，避免把用户对象、完整交易对象、大备注等无关数据带入列表。

```json
{
  "id": "bill_uuid",
  "amountCents": 2590,
  "type": "expense",
  "categoryName": "餐饮",
  "categoryIcon": "food",
  "categoryColor": "#EF4444",
  "occurredAt": "2026-05-19T10:30:00Z",
  "dateText": "2026-05-19",
  "description": "午餐",
  "updatedAt": "2026-05-19T10:31:00Z"
}
```

金额核心字段使用 `amountCents` 这类整数（`int`，以"分"为单位），不使用 `Double` 作为金额计算和存储的核心字段。前端展示时通过 `Intl` 格式化为 `¥25.90`。

## 远端接口约束

账单列表接口使用游标分页，不使用 offset 分页。

```http
GET /api/bills/list?userId={userId}&limit=80&cursor={cursor}
```

响应结构：

```json
{
  "items": [],
  "nextCursor": "encoded_cursor",
  "hasMore": true,
  "serverTime": "2026-05-19T10:30:00Z"
}
```

游标内容至少包含：

```json
{
  "occurredAt": "2026-05-19T10:30:00Z",
  "id": "bill_uuid"
}
```

服务端查询必须稳定：

```sql
WHERE user_id = :userId
  AND (
    occurred_at < :cursorOccurredAt
    OR (occurred_at = :cursorOccurredAt AND id < :cursorId)
  )
ORDER BY occurred_at DESC, id DESC
LIMIT :limit
```

推荐服务端索引：

```sql
CREATE INDEX idx_bills_user_date_id
ON bills(user_id, occurred_at DESC, id DESC);
```

## 加载策略

- 默认分页大小：`pageSize = 80`，最大不超过 100。
- 首屏：优先显示 SQLite 缓存，再后台刷新第一页。
- 预加载阈值：当剩余滚动距离小于 2 到 3 屏高度时加载下一页。
- 防重：使用 `isLoadingMore`、请求 key 或 `CancelToken` 避免重复分页请求。
- 弱网：已有列表继续可读，底部展示轻量加载或重试，不使用全屏 loading 覆盖已有内容。
- 空状态：只有缓存和远端第一页都为空时，才展示真正的空列表。
- 错误状态：首屏错误和分页错误分开处理，分页错误不能影响已加载数据。

## 内存策略

- Flutter 页面层不应无限保存所有账单对象。
- 数据长期保存到 SQLite，UI 层只持有当前查询窗口或有限分页缓存。
- 建议首版常驻 300 到 800 条列表数据；具体数量通过 Profile 模式验证后调整。
- 如果连续深度滚动，应允许释放远离当前视口的数据对象，必要时从 SQLite 重新读取。
- 图标优先使用本地映射或系统图标，不在列表行中加载大量网络图片。
- `ScrollController`、请求取消对象和监听器必须在生命周期结束时释放。

## 验收标准

- 使用假数据源生成 10 万条账单，列表可以连续滑动。
- 无缓存时首屏只请求第一页，不允许全量请求。
- 有缓存时首屏应快速显示本地数据，再后台刷新。
- 快速滑动不会产生重复分页请求。
- 连续滑动 5 分钟后内存曲线应趋于稳定，不能持续线性上涨。
- 断网后可以查看已缓存账单，分页失败不清空列表。
- 新增、修改、删除账单后，列表顺序和本地缓存保持一致。
- Profile 模式下滚动时大多数帧应控制在 16ms 内。
- 完成代码后至少运行 `flutter analyze` 和相关单元测试；性能相关修改需要在 `flutter run --profile` 下验证。

## 开发约束

- 代码需要简短中文注释，但不要写无意义注释。
- 优先保证代码简洁易懂，避免为了“可扩展”提前引入复杂抽象。
- 函数尽量小，控制圈复杂度，重复逻辑应提取到合适的私有方法或工具函数。
- 模块边界保持清晰：页面只处理 UI，控制器处理状态，仓储处理数据来源，本地数据源处理 SQLite，远端数据源处理 API。
- 不在列表 item 中发起网络请求。
- 不在 `build()` 中做重计算。
- 不把完整账单详情模型用于列表。
- 不用 offset 做深分页。
- 不用 `Double` 作为金额核心存储字段。

## 行为准则

### 1. 编码前先明确目标

- 先说明假设和成功标准。
- 如果需求存在多种理解，先列出取舍。
- 不确定的数据结构、接口契约或性能目标，不要默默猜。

### 2. 简单优先

- 用能解决问题的最少代码。
- 不添加需求之外的功能。
- 不为一次性代码增加复杂抽象。
- 如果实现明显变复杂，先重新审视是不是模块边界错了。

### 3. 外科手术式修改

- 只改和当前任务直接相关的内容。- 不顺手重构无关代码。
- 匹配项目现有风格。
- 删除因本次修改产生的无用代码，但不要删除原本存在且无关的代码。

### 4. 验证驱动

多步骤任务应给出可验证计划：

```text
1. 实现列表本地假数据源 -> 验证：10 万条数据可滑动
2. 接入 SQLite 缓存 -> 验证：断网后已缓存数据可显示
3. 接入远端游标分页 -> 验证：无重复请求，分页顺序稳定
4. Profile 性能验证 -> 验证：帧耗时和内存曲线达标
```

## 意外情况记录区

如果后续开发中遇到会影响 AI 代理判断的项目事实，请记录在这里，避免重复踩坑。

- 暂无。
