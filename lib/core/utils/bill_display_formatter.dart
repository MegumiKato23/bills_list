import 'package:intl/intl.dart';

import '../../domain/entities/bill_list_item.dart';

class BillDisplayFormatter {
  BillDisplayFormatter._();

  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'zh_CN',
    symbol: '¥',
    decimalDigits: 2,
  );

  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  static const List<String> _weekdayTexts = <String>[
    '周一',
    '周二',
    '周三',
    '周四',
    '周五',
    '周六',
    '周日',
  ];

  static String formatAmount(int amountCents, BillType type) {
    final amount = amountCents / 100;
    final sign = type == BillType.expense ? '-' : '+';
    return '$sign${_currencyFormat.format(amount)}';
  }

  static String formatDate(DateTime occurredAt) {
    return _dateFormat.format(occurredAt.toLocal());
  }

  static String formatMonthDay(DateTime occurredAt) {
    final local = occurredAt.toLocal();
    return '${local.month}月${local.day}日';
  }

  static String formatWeekday(DateTime occurredAt) {
    return _weekdayTexts[occurredAt.toLocal().weekday - 1];
  }

  static String formatPlainAmount(int amountCents) {
    final safeAmount = amountCents.abs();
    final yuan = safeAmount ~/ 100;
    final cents = (safeAmount % 100).toString().padLeft(2, '0');
    return '$yuan.$cents';
  }

  static int parseColorToValue(String hexColor) {
    final raw = hexColor.replaceFirst('#', '').trim();
    if (raw.length == 6) {
      return int.parse('FF$raw', radix: 16);
    }
    if (raw.length == 8) {
      return int.parse(raw, radix: 16);
    }
    return 0xFF9CA3AF;
  }
}
