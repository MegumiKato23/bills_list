import 'dart:convert';

class BillCursor {
  const BillCursor({
    required this.occurredAt,
    required this.id,
    required this.nextIndex,
  });

  final DateTime occurredAt;
  final String id;
  final int nextIndex;

  String encode() {
    final payload = jsonEncode(<String, dynamic>{
      'occurredAt': occurredAt.toUtc().toIso8601String(),
      'id': id,
      'nextIndex': nextIndex,
    });
    return base64Url.encode(utf8.encode(payload));
  }

  static BillCursor decode(String rawCursor) {
    final decoded = utf8.decode(base64Url.decode(rawCursor));
    final map = jsonDecode(decoded) as Map<String, dynamic>;
    return BillCursor(
      occurredAt: DateTime.parse(map['occurredAt'] as String).toUtc(),
      id: map['id'] as String,
      nextIndex: map['nextIndex'] as int,
    );
  }
}
