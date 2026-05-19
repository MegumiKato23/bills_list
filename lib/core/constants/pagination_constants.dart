class PaginationConstants {
  const PaginationConstants._();

  // 接口默认分页大小。
  static const int pageSize = 80;

  // UI 层常驻窗口上限，避免内存线性增长。
  static const int uiWindowMax = 800;

  // 回补窗口时每次向前扩展的条数。
  static const int uiWindowBackfillStep = 240;

  // 触发预加载时保留的屏幕数。
  static const double preloadScreenFactor = 2.5;

  // 固定行高，方便滚动窗口稳定，同时给账单卡片留出呼吸感。
  static const double billRowExtent = 88;

  // 日期分组头高度。
  static const double billDateHeaderExtent = 56;
}
