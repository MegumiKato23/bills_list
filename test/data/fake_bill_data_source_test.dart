import 'package:bills_list/data/services/remote/fake_bill_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FakeBillDataSource', () {
    test('游标分页顺序稳定且无重复', () async {
      final dataSource = FakeBillDataSource(
        totalCount: 500,
        latency: Duration.zero,
        failureRate: 0,
      );

      final firstPage = await dataSource.fetchBills(limit: 80);
      final secondPage = await dataSource.fetchBills(
        limit: 80,
        cursor: firstPage.nextCursor,
      );

      expect(firstPage.items.length, 80);
      expect(secondPage.items.length, 80);
      expect(firstPage.hasMore, true);

      final firstIds = firstPage.items.map((item) => item.id).toSet();
      final secondIds = secondPage.items.map((item) => item.id).toSet();
      expect(firstIds.intersection(secondIds), isEmpty);

      final firstLast = firstPage.items.last;
      final secondFirst = secondPage.items.first;
      final firstTime = DateTime.parse(firstLast.occurredAt);
      final secondTime = DateTime.parse(secondFirst.occurredAt);

      expect(
        secondTime.isBefore(firstTime) ||
            (secondTime.isAtSameMomentAs(firstTime) &&
                secondFirst.id.compareTo(firstLast.id) < 0),
        true,
      );
    });

    test('离线时抛出 connectionError', () async {
      final dataSource = FakeBillDataSource(
        totalCount: 50,
        latency: Duration.zero,
        failureRate: 0,
        offline: true,
      );

      expect(
        () => dataSource.fetchBills(limit: 20),
        throwsA(
          isA<DioException>().having(
            (error) => error.type,
            'type',
            DioExceptionType.connectionError,
          ),
        ),
      );
    });
  });
}
