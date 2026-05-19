import 'package:dio/dio.dart';

import '../../models/bill_page_dto.dart';
import 'bill_remote_data_source.dart';

class DioBillRemoteDataSource implements BillRemoteDataSource {
  DioBillRemoteDataSource({required this._dio, required this._userId});

  final Dio _dio;
  final String _userId;

  @override
  Future<BillPageDto> fetchBills({
    required int limit,
    String? cursor,
    CancelToken? cancelToken,
  }) async {
    final query = <String, dynamic>{
      'userId': _userId,
      'limit': limit,
      'cursor': cursor,
    }..removeWhere((String key, dynamic value) => value == null);

    final response = await _dio.get<Map<String, dynamic>>(
      '/api/bills/list',
      queryParameters: query,
      cancelToken: cancelToken,
    );

    final body = response.data;
    if (body == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: '账单接口返回空数据',
      );
    }

    return BillPageDto.fromJson(body);
  }
}
