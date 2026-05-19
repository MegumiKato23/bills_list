import 'package:dio/dio.dart';

import '../../domain/entities/bill_list_item.dart';
import '../../domain/repositories/bill_repository.dart';
import '../models/bill_page_dto.dart';
import '../services/local/bill_local_data_source.dart';
import '../services/remote/bill_remote_data_source.dart';
import '../services/remote/fake_bill_data_source.dart';

class BillRepositoryImpl implements BillRepository {
  BillRepositoryImpl({
    required this._remoteDataSource,
    required this._localDataSource,
  });

  final BillRemoteDataSource _remoteDataSource;
  final BillLocalDataSource _localDataSource;

  @override
  Future<List<BillListItem>> readWindow({
    required int limit,
    required int offset,
  }) {
    return _localDataSource.queryWindow(limit: limit, offset: offset);
  }

  @override
  Future<SyncResult> refreshFirstPage({required int pageSize}) {
    return _syncPage(limit: pageSize, cursor: null);
  }

  @override
  Future<SyncResult> loadMore({required String cursor, required int pageSize}) {
    return _syncPage(limit: pageSize, cursor: cursor);
  }

  Future<SyncResult> _syncPage({
    required int limit,
    required String? cursor,
  }) async {
    try {
      final page = await _remoteDataSource.fetchBills(
        limit: limit,
        cursor: cursor,
      );
      // Fake 数据规则变动时，首页刷新后重建缓存，避免新旧分布混在一起。
      if (cursor == null && _remoteDataSource is FakeBillDataSource) {
        await _localDataSource.clearAll();
      }
      await _localDataSource.upsertItems(_mapItems(page));
      return SyncResult.success(
        nextCursor: page.nextCursor,
        hasMore: page.hasMore,
      );
    } on DioException catch (error) {
      return SyncResult.failure(
        offline: _isOfflineError(error),
        errorMessage: error.message ?? '请求失败',
      );
    } catch (_) {
      return SyncResult.failure(offline: false, errorMessage: '请求失败，请稍后重试');
    }
  }

  List<BillListItem> _mapItems(BillPageDto page) {
    return page.items.map((dto) => dto.toEntity()).toList(growable: false);
  }

  bool _isOfflineError(DioException error) {
    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout;
  }
}
