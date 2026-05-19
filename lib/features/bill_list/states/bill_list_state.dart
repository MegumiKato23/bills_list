import 'package:flutter/foundation.dart';

import '../../../domain/entities/bill_list_item.dart';
import 'bill_list_display_entry.dart';

@immutable
class BillListState {
  const BillListState({
    required this.items,
    required this.nextCursor,
    required this.hasMore,
    required this.isRefreshing,
    required this.isLoadingMore,
    required this.offline,
    required this.firstPageError,
    required this.loadMoreError,
    required this.windowOffset,
    required this.initialized,
    required this.displayEntries,
  });

  final List<BillListItem> items;
  final List<BillListDisplayEntry> displayEntries;
  final String? nextCursor;
  final bool hasMore;
  final bool isRefreshing;
  final bool isLoadingMore;
  final bool offline;
  final String? firstPageError;
  final String? loadMoreError;
  final int windowOffset;
  final bool initialized;

  bool get isEmpty => items.isEmpty;

  factory BillListState.initial() {
    return const BillListState(
      items: <BillListItem>[],
      nextCursor: null,
      hasMore: true,
      isRefreshing: false,
      isLoadingMore: false,
      offline: false,
      firstPageError: null,
      loadMoreError: null,
      windowOffset: 0,
      initialized: false,
      displayEntries: <BillListDisplayEntry>[],
    );
  }

  BillListState copyWith({
    List<BillListItem>? items,
    String? nextCursor,
    bool resetCursor = false,
    bool? hasMore,
    bool? isRefreshing,
    bool? isLoadingMore,
    bool? offline,
    String? firstPageError,
    bool clearFirstPageError = false,
    String? loadMoreError,
    bool clearLoadMoreError = false,
    int? windowOffset,
    bool? initialized,
  }) {
    final nextItems = items ?? this.items;
    return BillListState(
      items: nextItems,
      displayEntries: items == null
          ? displayEntries
          : buildBillListDisplayEntries(nextItems),
      nextCursor: resetCursor ? null : (nextCursor ?? this.nextCursor),
      hasMore: hasMore ?? this.hasMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      offline: offline ?? this.offline,
      firstPageError: clearFirstPageError
          ? null
          : (firstPageError ?? this.firstPageError),
      loadMoreError: clearLoadMoreError
          ? null
          : (loadMoreError ?? this.loadMoreError),
      windowOffset: windowOffset ?? this.windowOffset,
      initialized: initialized ?? this.initialized,
    );
  }
}
