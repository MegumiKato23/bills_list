import 'dart:math';

import 'package:dio/dio.dart';

import '../../models/bill_cursor.dart';
import '../../models/bill_dto.dart';
import '../../models/bill_page_dto.dart';
import 'bill_remote_data_source.dart';

class FakeBillDataSource implements BillRemoteDataSource {
  FakeBillDataSource({
    this.totalCount = 100000,
    this.latency = const Duration(milliseconds: 180),
    this.failureRate = 0.04,
    this._offline = false,
    int seed = 42,
  }) : _random = Random(seed);

  final int totalCount;
  final Duration latency;
  final double failureRate;
  final Random _random;

  bool _offline;

  set offline(bool value) {
    _offline = value;
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

    if (_offline) {
      throw DioException(
        requestOptions: RequestOptions(path: '/fake/bills/list'),
        type: DioExceptionType.connectionError,
        message: '网络不可用，已切换离线数据',
      );
    }

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

  BillDto _buildBill(int rank) {
    // rank 越小表示时间越新。
    final groupIndex = rank ~/ 3;
    final occurredAt = _baseTime.subtract(Duration(minutes: groupIndex));
    final idNumber = totalCount - rank;

    final type = rank.isEven ? 'expense' : 'income';
    final category = _categories[rank % _categories.length];

    return BillDto(
      id: 'bill_${idNumber.toString().padLeft(6, '0')}',
      amountCents: 500 + (rank % 30000),
      type: type,
      categoryName: category.name,
      categoryIcon: category.icon,
      categoryColor: category.color,
      occurredAt: occurredAt.toIso8601String(),
      description: '模拟账单 #$idNumber',
      updatedAt: occurredAt.add(const Duration(seconds: 30)).toIso8601String(),
    );
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

final DateTime _baseTime = DateTime.utc(2026, 5, 19, 12);

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
