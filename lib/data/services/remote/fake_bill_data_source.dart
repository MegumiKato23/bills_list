import 'dart:math';

import 'package:dio/dio.dart';

import '../../models/bill_cursor.dart';
import '../../models/bill_dto.dart';
import '../../models/bill_page_dto.dart';
import 'bill_remote_data_source.dart';
import 'fake_bill_network_mode.dart';

class FakeBillDataSource implements BillRemoteDataSource {
  FakeBillDataSource({
    this.totalCount = 100000,
    this.latency = const Duration(milliseconds: 180),
    this.failureRate = 0.04,
    bool offline = false,
    FakeBillNetworkMode mode = FakeBillNetworkMode.online,
    int seed = 42,
  }) : mode = offline ? FakeBillNetworkMode.offline : mode,
       _random = Random(seed);

  final int totalCount;
  final Duration latency;
  final double failureRate;
  final Random _random;

  FakeBillNetworkMode mode;

  set offline(bool value) {
    mode = value ? FakeBillNetworkMode.offline : FakeBillNetworkMode.online;
  }

  @override
  Future<BillPageDto> fetchBills({
    required int limit,
    String? cursor,
    CancelToken? cancelToken,
  }) async {
    await Future<void>.delayed(latency);

    if (cancelToken?.isCancelled ?? false) {
      throw DioException.requestCancelled(
        requestOptions: RequestOptions(path: '/fake/bills/list'),
        reason: '分页请求已取消',
      );
    }

    _throwIfModeBlocks(cursor);

    if (_random.nextDouble() < failureRate) {
      throw DioException(
        requestOptions: RequestOptions(path: '/fake/bills/list'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/fake/bills/list'),
          statusCode: 503,
        ),
        message: '模拟服务抖动，请稍后重试',
      );
    }

    final startIndex = cursor == null ? 0 : BillCursor.decode(cursor).nextIndex;
    final safeLimit = limit.clamp(1, 100);
    final endIndex = min(startIndex + safeLimit, totalCount);

    final items = List<BillDto>.generate(
      endIndex - startIndex,
      (index) => _buildBill(startIndex + index),
      growable: false,
    );

    final hasMore = endIndex < totalCount;
    final nextCursor = hasMore ? _buildNextCursor(endIndex) : null;

    return BillPageDto(
      items: items,
      nextCursor: nextCursor,
      hasMore: hasMore,
      serverTime: DateTime.now().toUtc().toIso8601String(),
    );
  }

  void _throwIfModeBlocks(String? cursor) {
    if (mode == FakeBillNetworkMode.offline) {
      throw DioException(
        requestOptions: RequestOptions(path: '/fake/bills/list'),
        type: DioExceptionType.connectionError,
        message: '网络不可用，已切换离线数据',
      );
    }

    if (mode == FakeBillNetworkMode.loadMoreFailure && cursor != null) {
      throw DioException(
        requestOptions: RequestOptions(path: '/fake/bills/list'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/fake/bills/list'),
          statusCode: 503,
        ),
        message: '模拟分页失败，请点击重试',
      );
    }
  }

  BillDto _buildBill(int rank) {
    // 用“基础间隔 + 抖动”生成递减时间，日期分布更自然且顺序稳定。
    final minutesFromBase =
        rank * _averageGapMinutes + _pseudoRandom(rank, _gapJitterMinutes);
    final occurredAt = _baseTime.subtract(Duration(minutes: minutesFromBase));
    final idNumber = totalCount - rank;

    final type = rank % 5 == 0 ? 'income' : 'expense';
    final category = _categories[rank % _categories.length];
    final amountCents = 100 + _pseudoRandom(rank, 59900);

    return BillDto(
      id: 'bill_${idNumber.toString().padLeft(6, '0')}',
      amountCents: amountCents,
      type: type,
      categoryName: category.name,
      categoryIcon: category.icon,
      categoryColor: category.color,
      occurredAt: occurredAt.toIso8601String(),
      description: '模拟账单 #$idNumber',
      updatedAt: occurredAt.add(const Duration(seconds: 30)).toIso8601String(),
    );
  }

  int _pseudoRandom(int rank, int maxExclusive) {
    final value = (rank * 1103515245 + 12345) & 0x7fffffff;
    return value % maxExclusive;
  }

  String _buildNextCursor(int nextIndex) {
    final lastItem = _buildBill(nextIndex - 1);
    final cursor = BillCursor(
      occurredAt: DateTime.parse(lastItem.occurredAt).toUtc(),
      id: lastItem.id,
      nextIndex: nextIndex,
    );
    return cursor.encode();
  }
}

const int _averageGapMinutes = 430;
const int _gapJitterMinutes = 120;

final DateTime _baseTime = DateTime.utc(2026, 5, 19, 22);

const List<_BillCategory> _categories = <_BillCategory>[
  _BillCategory(name: '餐饮', icon: 'food', color: '#EF4444'),
  _BillCategory(name: '交通', icon: 'traffic', color: '#0EA5E9'),
  _BillCategory(name: '购物', icon: 'shopping', color: '#8B5CF6'),
  _BillCategory(name: '工资', icon: 'salary', color: '#10B981'),
  _BillCategory(name: '娱乐', icon: 'play', color: '#F59E0B'),
];

class _BillCategory {
  const _BillCategory({
    required this.name,
    required this.icon,
    required this.color,
  });

  final String name;
  final String icon;
  final String color;
}
