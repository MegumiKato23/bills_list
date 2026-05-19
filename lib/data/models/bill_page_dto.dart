import 'bill_dto.dart';

class BillPageDto {
  const BillPageDto({
    required this.items,
    required this.nextCursor,
    required this.hasMore,
    required this.serverTime,
  });

  final List<BillDto> items;
  final String? nextCursor;
  final bool hasMore;
  final String serverTime;

  factory BillPageDto.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List<dynamic>? ?? <dynamic>[])
        .cast<Map<String, dynamic>>();
    return BillPageDto(
      items: rawItems.map(BillDto.fromJson).toList(growable: false),
      nextCursor: json['nextCursor'] as String?,
      hasMore: (json['hasMore'] as bool?) ?? false,
      serverTime:
          (json['serverTime'] as String?) ??
          DateTime.now().toUtc().toIso8601String(),
    );
  }
}
