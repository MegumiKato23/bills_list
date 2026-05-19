import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/pagination_constants.dart';
import '../../data/repositories/bill_repository_impl.dart';
import '../../data/services/local/app_database.dart';
import '../../data/services/local/bill_local_data_source.dart';
import '../../data/services/remote/bill_remote_data_source.dart';
import '../../data/services/remote/dio_bill_remote_data_source.dart';
import '../../data/services/remote/fake_bill_data_source.dart';
import '../../data/services/remote/fake_bill_network_mode.dart';
import '../../domain/repositories/bill_repository.dart';

final dioProvider = Provider<Dio>((Ref ref) {
  return Dio(
    BaseOptions(
      baseUrl: 'https://example.com',
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
    ),
  );
});

final useFakeDataSourceProvider = Provider<bool>((Ref ref) => true);

final fakeBillNetworkModeProvider = StateProvider<FakeBillNetworkMode>(
  (Ref ref) => FakeBillNetworkMode.online,
);

final fakeBillDataSourceProvider = Provider<FakeBillDataSource>((Ref ref) {
  // 默认关闭随机失败，保证开发切片启动后稳定可滑动。
  return FakeBillDataSource(
    totalCount: 100000,
    failureRate: 0,
    mode: ref.watch(fakeBillNetworkModeProvider),
  );
});

final remoteDataSourceProvider = Provider<BillRemoteDataSource>((Ref ref) {
  if (ref.watch(useFakeDataSourceProvider)) {
    return ref.watch(fakeBillDataSourceProvider);
  }
  return DioBillRemoteDataSource(
    dio: ref.watch(dioProvider),
    userId: 'demo_user',
  );
});

final appDatabaseProvider = Provider<AppDatabase>((Ref ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final localDataSourceProvider = Provider<BillLocalDataSource>((Ref ref) {
  return BillLocalDataSource(ref.watch(appDatabaseProvider));
});

final billRepositoryProvider = Provider<BillRepository>((Ref ref) {
  return BillRepositoryImpl(
    remoteDataSource: ref.watch(remoteDataSourceProvider),
    localDataSource: ref.watch(localDataSourceProvider),
  );
});

final pageSizeProvider = Provider<int>(
  (Ref ref) => PaginationConstants.pageSize,
);
final uiWindowSizeProvider = Provider<int>(
  (Ref ref) => PaginationConstants.uiWindowMax,
);
