# BookKeeper Bills List

一个面向 Android 的 Flutter 账单列表项目，聚焦大数据量列表的连续滑动、无感分页、本地缓存和弱网可用性。

## 项目目标

- 支持 1 万到 10 万级账单数据连续浏览。
- 首屏优先显示本地缓存，再后台刷新第一页。
- 使用游标分页，保证排序稳定且避免深分页性能问题。
- 页面层控制内存窗口，避免对象数量随总数据量线性增长。

## 技术栈

- Flutter + Material 3
- Riverpod（状态管理与依赖注入）
- Dio（网络请求）
- Drift + SQLite（本地缓存）
- Intl（金额与日期格式化）

## 目录结构

```text
lib/
├── app/                         # 应用入口、主题、依赖注入
├── core/                        # 常量与通用工具
├── data/                        # 数据模型、数据源、仓储实现
├── domain/                      # 领域实体与仓储接口
└── features/bill_list/          # 账单列表页面与状态逻辑
```

## 核心能力

- 列表渲染：`CustomScrollView` + `SliverList` 懒加载，仅构建可见区域，支持窗口滑动与按日期分组。
- 分页策略：游标分页（按 `occurredAt DESC, id DESC` 稳定排序）。
- 本地优先：先读 SQLite，再刷新远端并回写缓存。
- 弱网可用：保留已加载内容，分页失败仅在底部提示重试。
- 假数据压测：内置 Fake 数据源，可生成 10 万条账单验证滚动与内存。

## 快速开始

### 1. 安装依赖

```bash
flutter pub get
```

### 2. 生成 Drift 代码（如有需要）

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. 运行 Android

```bash
flutter run -d <android_device_id>
```

## 可用配置

- 默认开启 Fake 数据源（见 `lib/app/di/providers.dart`）。
- 可按需调整分页大小与 UI 窗口大小（见 `lib/core/constants/pagination_constants.dart`）。

## 质量检查

```bash
flutter analyze
flutter test
```
