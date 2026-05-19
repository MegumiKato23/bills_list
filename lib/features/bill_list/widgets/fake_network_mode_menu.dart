import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/providers.dart';
import '../../../data/services/remote/fake_bill_network_mode.dart';
import '../view_models/bill_list_controller.dart';

class FakeNetworkModeMenu extends ConsumerWidget {
  const FakeNetworkModeMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(useFakeDataSourceProvider)) {
      return const SizedBox.shrink();
    }

    final mode = ref.watch(fakeBillNetworkModeProvider);
    return PopupMenuButton<FakeBillNetworkMode>(
      tooltip: '模拟网络状态',
      icon: Icon(_iconForMode(mode)),
      onSelected: (FakeBillNetworkMode value) {
        ref.read(fakeBillNetworkModeProvider.notifier).state = value;
        // 切换后刷新一次，方便立刻验证离线和恢复状态。
        unawaited(ref.read(billListControllerProvider.notifier).refresh());
      },
      itemBuilder: (BuildContext context) {
        return FakeBillNetworkMode.values
            .map((FakeBillNetworkMode value) {
              return PopupMenuItem<FakeBillNetworkMode>(
                value: value,
                child: Row(
                  children: <Widget>[
                    Icon(_iconForMode(value), size: 18),
                    const SizedBox(width: 8),
                    Text(_labelForMode(value)),
                    const Spacer(),
                    if (value == mode) const Icon(Icons.check, size: 18),
                  ],
                ),
              );
            })
            .toList(growable: false);
      },
    );
  }
}

String _labelForMode(FakeBillNetworkMode mode) {
  switch (mode) {
    case FakeBillNetworkMode.online:
      return '在线';
    case FakeBillNetworkMode.offline:
      return '离线';
    case FakeBillNetworkMode.loadMoreFailure:
      return '分页失败';
  }
}

IconData _iconForMode(FakeBillNetworkMode mode) {
  switch (mode) {
    case FakeBillNetworkMode.online:
      return Icons.network_check;
    case FakeBillNetworkMode.offline:
      return Icons.wifi_off;
    case FakeBillNetworkMode.loadMoreFailure:
      return Icons.error_outline;
  }
}
