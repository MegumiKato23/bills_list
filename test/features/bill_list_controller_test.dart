import 'dart:async';
import 'dart:math';

import 'package:bills_list/app/di/providers.dart';
import 'package:bills_list/domain/entities/bill_list_item.dart';
import 'package:bills_list/domain/repositories/bill_repository.dart';
import 'package:bills_list/features/bill_list/view_models/bill_list_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  group('BillListController', () {
    test('同一时刻只触发一次加载更多', () async {
      final repository = _FakeBillRepository(
        initialItems: List<BillListItem>.generate(40, buildBillItem),
      );

      final loadMoreCompleter = Completer<SyncResult>();
      repository.loadMoreHandler = () => loadMoreCompleter.future;

      final container = ProviderContainer(
        overrides: <Override>[
          billRepositoryProvider.overrideWithValue(repository),
          pageSizeProvider.overrideWithValue(20),
          uiWindowSizeProvider.overrideWithValue(120),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(billListControllerProvider.notifier);
      await notifier.initialize();
      await _flushTasks();

      final f1 = notifier.loadMore();
      final f2 = notifier.loadMore();

      expect(repository.loadMoreCalls, 1);

      repository.appendOldItems(20);
      loadMoreCompleter.complete(
        SyncResult.success(nextCursor: 'cursor_2', hasMore: true),
      );

      await Future.wait(<Future<void>>[f1, f2]);

      final state = container.read(billListControllerProvider);
      expect(state.isLoadingMore, false);
      expect(state.items.length, 60);
      expect(repository.loadMoreCalls, 1);
    });

    test('刷新优先，旧分页结果会被忽略', () async {
      final repository = _FakeBillRepository(
        initialItems: List<BillListItem>.generate(60, buildBillItem),
      );

      final loadMoreCompleter = Completer<SyncResult>();
      repository.loadMoreHandler = () => loadMoreCompleter.future;

      final container = ProviderContainer(
        overrides: <Override>[
          billRepositoryProvider.overrideWithValue(repository),
          pageSizeProvider.overrideWithValue(20),
          uiWindowSizeProvider.overrideWithValue(80),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(billListControllerProvider.notifier);
      await notifier.initialize();
      await _flushTasks();

      final staleLoadMore = notifier.loadMore();

      repository.resetWith(
        List<BillListItem>.generate(60, (index) {
          return buildBillItem(index).copyWith(description: '刷新后$index');
        }),
      );
      repository.refreshCursor = 'refresh_cursor';

      await notifier.refresh();

      repository.appendOldItems(20);
      loadMoreCompleter.complete(
        SyncResult.success(nextCursor: 'stale_cursor', hasMore: true),
      );
      await staleLoadMore;

      final state = container.read(billListControllerProvider);
      expect(state.nextCursor, 'refresh_cursor');
      expect(state.isLoadingMore, false);
      expect(state.loadMoreError, isNull);
    });

    test('分页失败不清空列表且可重试恢复', () async {
      final repository = _FakeBillRepository(
        initialItems: List<BillListItem>.generate(50, buildBillItem),
      );

      repository.loadMoreHandler = () async {
        return SyncResult.failure(offline: false, errorMessage: '分页失败');
      };

      final container = ProviderContainer(
        overrides: <Override>[
          billRepositoryProvider.overrideWithValue(repository),
          pageSizeProvider.overrideWithValue(20),
          uiWindowSizeProvider.overrideWithValue(100),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(billListControllerProvider.notifier);
      await notifier.initialize();
      await _flushTasks();

      final before = container.read(billListControllerProvider).items.length;
      await notifier.loadMore();

      final failedState = container.read(billListControllerProvider);
      expect(failedState.items.length, before);
      expect(failedState.loadMoreError, '分页失败');

      repository.loadMoreHandler = () async {
        repository.appendOldItems(20);
        return SyncResult.success(nextCursor: 'cursor_3', hasMore: true);
      };

      await notifier.retryLoadMore();
      final successState = container.read(billListControllerProvider);
      expect(successState.loadMoreError, isNull);
      expect(successState.items.length, greaterThan(before));
    });
  });
}

Future<void> _flushTasks() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

class _FakeBillRepository implements BillRepository {
  _FakeBillRepository({required List<BillListItem> initialItems})
    : _store = List<BillListItem>.from(initialItems);

  final List<BillListItem> _store;

  int refreshCalls = 0;
  int loadMoreCalls = 0;
  String refreshCursor = 'cursor_1';

  Future<SyncResult> Function()? loadMoreHandler;

  @override
  Future<List<BillListItem>> readWindow({
    required int limit,
    required int offset,
  }) async {
    if (offset >= _store.length) {
      return <BillListItem>[];
    }
    final end = min(offset + limit, _store.length);
    return List<BillListItem>.from(_store.sublist(offset, end));
  }

  @override
  Future<SyncResult> refreshFirstPage({required int pageSize}) async {
    refreshCalls += 1;
    return SyncResult.success(nextCursor: refreshCursor, hasMore: true);
  }

  @override
  Future<SyncResult> loadMore({
    required String cursor,
    required int pageSize,
  }) async {
    loadMoreCalls += 1;
    if (loadMoreHandler != null) {
      return loadMoreHandler!();
    }
    appendOldItems(pageSize);
    return SyncResult.success(nextCursor: 'cursor_next', hasMore: true);
  }

  void appendOldItems(int count) {
    final start = _store.length;
    _store.addAll(
      List<BillListItem>.generate(
        count,
        (index) => buildBillItem(start + index),
      ),
    );
  }

  void resetWith(List<BillListItem> items) {
    _store
      ..clear()
      ..addAll(items);
  }
}
