import '../entities/bill_list_item.dart';

abstract class BillRepository {
  Future<List<BillListItem>> readWindow({
    required int limit,
    required int offset,
  });

  Future<SyncResult> refreshFirstPage({required int pageSize});

  Future<SyncResult> loadMore({required String cursor, required int pageSize});
}

class SyncResult {
  const SyncResult._({
    required this.success,
    required this.offline,
    this.nextCursor,
    this.hasMore = true,
    this.errorMessage,
  });

  final bool success;
  final bool offline;
  final String? nextCursor;
  final bool hasMore;
  final String? errorMessage;

  factory SyncResult.success({
    required String? nextCursor,
    required bool hasMore,
  }) {
    return SyncResult._(
      success: true,
      offline: false,
      nextCursor: nextCursor,
      hasMore: hasMore,
    );
  }

  factory SyncResult.failure({
    required bool offline,
    required String errorMessage,
  }) {
    return SyncResult._(
      success: false,
      offline: offline,
      errorMessage: errorMessage,
    );
  }
}
