import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/providers.dart';
import '../../../core/constants/pagination_constants.dart';
import '../../../domain/repositories/bill_repository.dart';
import '../states/bill_list_state.dart';

final billListControllerProvider =
    NotifierProvider<BillListController, BillListState>(BillListController.new);

class BillListController extends Notifier<BillListState> {
  bool _started = false;
  bool _isBackfilling = false;
  int _requestEpoch = 0;

  BillRepository get _repository => ref.read(billRepositoryProvider);
  int get _pageSize => ref.read(pageSizeProvider);
  int get _windowSize => ref.read(uiWindowSizeProvider);

  @override
  BillListState build() {
    return BillListState.initial();
  }

  Future<void> initialize() async {
    if (_started) {
      return;
    }
    _started = true;

    final cached = await _repository.readWindow(limit: _windowSize, offset: 0);
    state = state.copyWith(items: cached, initialized: true);

    unawaited(refresh());
  }

  Future<void> refresh() async {
    _requestEpoch += 1;
    final epoch = _requestEpoch;

    state = state.copyWith(
      isRefreshing: true,
      isLoadingMore: false,
      clearFirstPageError: true,
      clearLoadMoreError: true,
    );

    final result = await _repository.refreshFirstPage(pageSize: _pageSize);

    if (epoch != _requestEpoch) {
      return;
    }

    if (!result.success) {
      final cached = await _repository.readWindow(
        limit: _windowSize,
        offset: 0,
      );
      state = state.copyWith(
        items: cached,
        isRefreshing: false,
        offline: result.offline,
        firstPageError: cached.isEmpty ? result.errorMessage : null,
      );
      return;
    }

    final items = await _repository.readWindow(limit: _windowSize, offset: 0);

    state = state.copyWith(
      items: items,
      windowOffset: 0,
      nextCursor: result.nextCursor,
      hasMore: result.hasMore,
      offline: false,
      isRefreshing: false,
      clearFirstPageError: true,
      clearLoadMoreError: true,
    );
  }

  Future<void> loadMore() async {
    if (!_canLoadMore()) {
      return;
    }

    final cursor = state.nextCursor;
    if (cursor == null) {
      return;
    }

    final epoch = _requestEpoch;

    state = state.copyWith(isLoadingMore: true, clearLoadMoreError: true);

    final result = await _repository.loadMore(
      cursor: cursor,
      pageSize: _pageSize,
    );

    if (epoch != _requestEpoch) {
      return;
    }

    if (!result.success) {
      state = state.copyWith(
        isLoadingMore: false,
        loadMoreError: result.errorMessage,
        offline: result.offline || state.offline,
      );
      return;
    }

    final nextOffset = state.items.length >= _windowSize
        // 深度下滑后裁掉头部，避免内存继续增长。
        ? state.windowOffset + _pageSize
        : state.windowOffset;

    final items = await _repository.readWindow(
      limit: _windowSize,
      offset: nextOffset,
    );

    state = state.copyWith(
      items: items,
      windowOffset: nextOffset,
      nextCursor: result.nextCursor,
      hasMore: result.hasMore,
      isLoadingMore: false,
      offline: false,
      clearLoadMoreError: true,
    );
  }

  Future<void> retryLoadMore() {
    return loadMore();
  }

  void onScroll({
    required double pixels,
    required double maxScrollExtent,
    required double viewportDimension,
  }) {
    if (!state.initialized) {
      return;
    }

    final remaining = maxScrollExtent - pixels;
    final triggerDistance =
        viewportDimension * PaginationConstants.preloadScreenFactor;

    if (remaining < triggerDistance) {
      unawaited(loadMore());
    }

    unawaited(_backfillIfNeeded(pixels));
  }

  Future<void> _backfillIfNeeded(double pixels) async {
    if (_isBackfilling || state.windowOffset == 0) {
      return;
    }

    final topSpacer = state.windowOffset * PaginationConstants.billRowExtent;
    final trigger = topSpacer + (PaginationConstants.billRowExtent * 2);

    if (pixels > trigger) {
      return;
    }

    _isBackfilling = true;
    try {
      final newOffset = max(
        0,
        state.windowOffset - PaginationConstants.uiWindowBackfillStep,
      );
      final items = await _repository.readWindow(
        limit: _windowSize,
        offset: newOffset,
      );
      state = state.copyWith(items: items, windowOffset: newOffset);
    } finally {
      _isBackfilling = false;
    }
  }

  bool _canLoadMore() {
    return !state.isRefreshing &&
        !state.isLoadingMore &&
        state.hasMore &&
        state.nextCursor != null;
  }
}
