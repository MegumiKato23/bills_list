import 'package:dio/dio.dart';

import '../../models/bill_page_dto.dart';

abstract class BillRemoteDataSource {
  Future<BillPageDto> fetchBills({
    required int limit,
    String? cursor,
    CancelToken? cancelToken,
  });
}
