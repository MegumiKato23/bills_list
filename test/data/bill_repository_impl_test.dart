import 'package:bills_list/data/repositories/bill_repository_impl.dart';
import 'package:bills_list/data/services/local/app_database.dart';
import 'package:bills_list/data/services/local/bill_local_data_source.dart';
import 'package:bills_list/data/services/remote/fake_bill_data_source.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  group('BillRepositoryImpl', () {
    late AppDatabase database;
    late BillLocalDataSource localDataSource;
    late FakeBillDataSource remoteDataSource;
    late BillRepositoryImpl repository;

    setUp(() {
      database = AppDatabase.forTesting(NativeDatabase.memory());
      localDataSource = BillLocalDataSource(database);
      remoteDataSource = FakeBillDataSource(
        totalCount: 1000,
        latency: Duration.zero,
        failureRate: 0,
      );
      repository = BillRepositoryImpl(
        remoteDataSource: remoteDataSource,
        localDataSource: localDataSource,
      );
    });

    tearDown(() async {
      await database.close();
    });

    test('刷新 + 分页会落库且顺序稳定', () async {
      final first = await repository.refreshFirstPage(pageSize: 80);
      final second = await repository.loadMore(
        cursor: first.nextCursor!,
        pageSize: 80,
      );

      expect(first.success, true);
      expect(second.success, true);

      final items = await repository.readWindow(limit: 200, offset: 0);
      expect(items.length, 160);
      expect(isSortedByOccurredAndId(items), true);
    });

    test('重复刷新第一页不会产生重复数据', () async {
      final first = await repository.refreshFirstPage(pageSize: 80);
      final second = await repository.refreshFirstPage(pageSize: 80);

      expect(first.success, true);
      expect(second.success, true);

      final items = await repository.readWindow(limit: 200, offset: 0);
      expect(items.length, 80);
    });

    test('离线刷新失败时保留缓存数据', () async {
      final initial = await repository.refreshFirstPage(pageSize: 80);
      expect(initial.success, true);

      remoteDataSource.offline = true;
      final offlineResult = await repository.refreshFirstPage(pageSize: 80);

      expect(offlineResult.success, false);
      expect(offlineResult.offline, true);

      final cached = await repository.readWindow(limit: 80, offset: 0);
      expect(cached.length, 80);
      expect(cached.first.id, isNotEmpty);
    });
  });
}
