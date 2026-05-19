import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollCacheExtent;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/pagination_constants.dart';
import '../states/bill_list_display_entry.dart';
import '../states/bill_list_state.dart';
import '../view_models/bill_list_controller.dart';
import '../widgets/bill_date_header.dart';
import '../widgets/bill_row.dart';
import '../widgets/fake_network_mode_menu.dart';
import '../widgets/offline_banner.dart';

class BillListPage extends ConsumerStatefulWidget {
  const BillListPage({super.key});

  @override
  ConsumerState<BillListPage> createState() => _BillListPageState();
}

class _BillListPageState extends ConsumerState<BillListPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);

    Future<void>.microtask(
      () => ref.read(billListControllerProvider.notifier).initialize(),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;
    ref
        .read(billListControllerProvider.notifier)
        .onScroll(
          pixels: position.pixels,
          maxScrollExtent: position.maxScrollExtent,
          viewportDimension: position.viewportDimension,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(billListControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('账单列表'),
        actions: const <Widget>[FakeNetworkModeMenu()],
      ),
      body: Column(
        children: <Widget>[
          if (state.offline) const OfflineBanner(),
          Expanded(child: _buildContent(context, state)),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, BillListState state) {
    if (!state.initialized && state.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.isRefreshing && state.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.firstPageError != null && state.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(state.firstPageError!),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () {
                ref.read(billListControllerProvider.notifier).refresh();
              },
              child: const Text('重新加载'),
            ),
          ],
        ),
      );
    }

    if (state.items.isEmpty) {
      return const Center(child: Text('暂无账单数据'));
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(billListControllerProvider.notifier).refresh(),
      child: RawScrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        interactive: true,
        minThumbLength: 36,
        thickness: 3,
        radius: const Radius.circular(4),
        thumbColor: const Color(0xFF9CA3AF).withValues(alpha: 0.65),
        // RawScrollbar 会按内容高度自动缩短右侧滑块。
        child: CustomScrollView(
          controller: _scrollController,
          scrollCacheExtent: const ScrollCacheExtent.viewport(
            PaginationConstants.preloadScreenFactor,
          ),
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: SizedBox(
                height: state.windowOffset * PaginationConstants.billRowExtent,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((
                BuildContext context,
                int index,
              ) {
                final entry = state.displayEntries[index];
                return _buildEntry(entry);
              }, childCount: state.displayEntries.length),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: PaginationConstants.billRowExtent,
                child: _buildFooter(state),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntry(BillListDisplayEntry entry) {
    switch (entry) {
      case BillDateHeaderEntry():
        return BillDateHeader(
          key: ValueKey<String>(entry.stableKey),
          entry: entry,
        );
      case BillRowEntry():
        return BillRow(
          key: ValueKey<String>(entry.stableKey),
          bill: entry.bill,
          position: entry.position,
        );
    }
  }

  Widget _buildFooter(BillListState state) {
    if (state.isLoadingMore) {
      return const Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (state.loadMoreError != null) {
      return Align(
        alignment: Alignment.center,
        child: TextButton(
          onPressed: () {
            ref.read(billListControllerProvider.notifier).retryLoadMore();
          },
          child: const Text('加载失败，点击重试'),
        ),
      );
    }

    if (!state.hasMore) {
      return const Center(
        child: Text(
          '没有更多账单了',
          style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
