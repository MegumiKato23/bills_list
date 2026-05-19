import 'dart:async';
import 'dart:math';

import 'package:bills_list/app/di/providers.dart';
import 'package:bills_list/data/services/remote/fake_bill_network_mode.dart';
import 'package:bills_list/domain/entities/bill_list_item.dart';
import 'package:bills_list/domain/repositories/bill_repository.dart';
import 'package:bills_list/features/bill_list/pages/bill_list_page.dart';
import 'package:bills_list/features/bill_list/view_models/bill_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  testWidgets('有数据时渲染账单行', (WidgetTester tester) async {
    final repository = _PageFakeRepository(
      items: List<BillListItem>.generate(30, buildBillItem),
    );
    final container = _createContainer(repository);

    await tester.pumpWidget(_buildTestApp(container));
    await tester.pump();
    await tester.pump();

    expect(find.text('账单列表'), findsOneWidget);
    expect(find.text('测试分类'), findsWidgets);
  });

  testWidgets('离线失败时展示顶部离线 Banner', (WidgetTester tester) async {
    final repository = _PageFakeRepository(
      items: List<BillListItem>.generate(20, buildBillItem),
      refreshResult: SyncResult.failure(offline: true, errorMessage: '离线'),
    );
    final container = _createContainer(repository);

    await tester.pumpWidget(_buildTestApp(container));
    await tester.pump();
    await tester.pump();

    expect(find.text('当前为离线缓存数据'), findsOneWidget);
  });

  testWidgets('缓存和远端都为空时展示空状态', (WidgetTester tester) async {
    final repository = _PageFakeRepository(
      items: <BillListItem>[],
      refreshResult: SyncResult.success(nextCursor: null, hasMore: false),
    );
    final container = _createContainer(repository);

    await tester.pumpWidget(_buildTestApp(container));
    await tester.pump();
    await tester.pump();

    expect(find.text('暂无账单数据'), findsOneWidget);
  });

  testWidgets('无缓存首次刷新中展示加载态', (WidgetTester tester) async {
    final refreshCompleter = Completer<SyncResult>();
    final repository = _PageFakeRepository(
      items: <BillListItem>[],
      refreshHandler: () => refreshCompleter.future,
    );
    final container = _createContainer(repository);

    await tester.pumpWidget(_buildTestApp(container));
    await tester.pump();
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('暂无账单数据'), findsNothing);

    refreshCompleter.complete(
      SyncResult.success(nextCursor: null, hasMore: false),
    );
    await tester.pump();
  });

  testWidgets('分页失败展示底部重试文案', (WidgetTester tester) async {
    final repository = _PageFakeRepository(
      items: List<BillListItem>.generate(40, buildBillItem),
      loadMoreResult: SyncResult.failure(offline: false, errorMessage: '分页失败'),
    );
    final container = _createContainer(repository);

    await tester.pumpWidget(_buildTestApp(container));
    await tester.pump();
    await tester.pump();

    await container.read(billListControllerProvider.notifier).refresh();
    await tester.pump();

    await container.read(billListControllerProvider.notifier).loadMore();
    await tester.pump();
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -6000));
    await tester.pumpAndSettle();

    expect(find.text('加载失败，点击重试'), findsOneWidget);
  });

  testWidgets('开发菜单可切换模拟网络模式', (WidgetTester tester) async {
    final repository = _PageFakeRepository(
      items: List<BillListItem>.generate(30, buildBillItem),
    );
    final container = _createContainer(repository);

    await tester.pumpWidget(_buildTestApp(container));
    await tester.pump();
    await tester.pump();

    final beforeRefreshCalls = repository.refreshCalls;
    await tester.tap(find.byTooltip('模拟网络状态'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('离线').last);
    await tester.pump();
    await tester.pump();

    expect(
      container.read(fakeBillNetworkModeProvider),
      FakeBillNetworkMode.offline,
    );
    expect(repository.refreshCalls, greaterThan(beforeRefreshCalls));
  });
}

ProviderContainer _createContainer(_PageFakeRepository repository) {
  final container = ProviderContainer(
    overrides: <Override>[
      billRepositoryProvider.overrideWithValue(repository),
      pageSizeProvider.overrideWithValue(20),
      uiWindowSizeProvider.overrideWithValue(120),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

Widget _buildTestApp(ProviderContainer container) {
  return UncontrolledProviderScope(
    container: container,
    child: const MaterialApp(home: BillListPage()),
  );
}

class _PageFakeRepository implements BillRepository {
  _PageFakeRepository({
    required List<BillListItem> items,
    SyncResult? refreshResult,
    SyncResult? loadMoreResult,
    this.refreshHandler,
  }) : _store = List<BillListItem>.from(items),
       refreshResult =
           refreshResult ??
           SyncResult.success(nextCursor: 'cursor_1', hasMore: true),
       loadMoreResult =
           loadMoreResult ??
           SyncResult.success(nextCursor: 'cursor_2', hasMore: true);

  final List<BillListItem> _store;
  final SyncResult refreshResult;
  final SyncResult loadMoreResult;
  final Future<SyncResult> Function()? refreshHandler;
  int refreshCalls = 0;

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
    final handler = refreshHandler;
    if (handler != null) {
      return handler();
    }
    return refreshResult;
  }

  @override
  Future<SyncResult> loadMore({
    required String cursor,
    required int pageSize,
  }) async {
    if (loadMoreResult.success) {
      final start = _store.length;
      _store.addAll(
        List<BillListItem>.generate(
          pageSize,
          (index) => buildBillItem(start + index),
        ),
      );
    }
    return loadMoreResult;
  }
}
