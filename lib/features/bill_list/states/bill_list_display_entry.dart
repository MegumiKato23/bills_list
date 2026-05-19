import 'package:flutter/foundation.dart';

import '../../../core/utils/bill_display_formatter.dart';
import '../../../domain/entities/bill_list_item.dart';

@immutable
sealed class BillListDisplayEntry {
  const BillListDisplayEntry();

  String get stableKey;
}

enum BillRowGroupPosition { single, first, middle, last }

class BillDateHeaderEntry extends BillListDisplayEntry {
  const BillDateHeaderEntry({
    required this.dateKey,
    required this.monthDayText,
    required this.weekdayText,
    required this.incomeCents,
    required this.expenseCents,
    required this.incomeText,
    required this.expenseText,
  });

  final String dateKey;
  final String monthDayText;
  final String weekdayText;
  final int incomeCents;
  final int expenseCents;
  final String incomeText;
  final String expenseText;

  @override
  String get stableKey => 'date_$dateKey';
}

class BillRowEntry extends BillListDisplayEntry {
  const BillRowEntry({required this.bill, required this.position});

  final BillListItem bill;
  final BillRowGroupPosition position;

  @override
  String get stableKey => 'bill_${bill.id}';
}

List<BillListDisplayEntry> buildBillListDisplayEntries(
  List<BillListItem> items,
) {
  if (items.isEmpty) {
    return const <BillListDisplayEntry>[];
  }

  final groups = <String, _BillDateGroup>{};
  for (final item in items) {
    final localDate = item.occurredAt.toLocal();
    final dateOnly = DateTime(localDate.year, localDate.month, localDate.day);
    final dateKey = _dateKey(dateOnly);
    final group = groups.putIfAbsent(
      dateKey,
      () => _BillDateGroup(dateKey: dateKey, date: dateOnly),
    );
    group.add(item);
  }

  final entries = <BillListDisplayEntry>[];
  for (final group in groups.values) {
    entries
      ..add(group.toHeader())
      ..addAll(group.buildRows());
  }
  return List<BillListDisplayEntry>.unmodifiable(entries);
}

String _dateKey(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}

class _BillDateGroup {
  _BillDateGroup({required this.dateKey, required this.date});

  final String dateKey;
  final DateTime date;
  final List<BillListItem> items = <BillListItem>[];

  int incomeCents = 0;
  int expenseCents = 0;

  void add(BillListItem item) {
    items.add(item);
    if (item.type == BillType.income) {
      incomeCents += item.amountCents;
      return;
    }
    expenseCents += item.amountCents;
  }

  BillDateHeaderEntry toHeader() {
    return BillDateHeaderEntry(
      dateKey: dateKey,
      monthDayText: BillDisplayFormatter.formatMonthDay(date),
      weekdayText: BillDisplayFormatter.formatWeekday(date),
      incomeCents: incomeCents,
      expenseCents: expenseCents,
      incomeText: BillDisplayFormatter.formatPlainAmount(incomeCents),
      expenseText: BillDisplayFormatter.formatPlainAmount(expenseCents),
    );
  }

  Iterable<BillRowEntry> buildRows() sync* {
    for (var index = 0; index < items.length; index++) {
      yield BillRowEntry(
        bill: items[index],
        position: _positionFor(index, items.length),
      );
    }
  }

  BillRowGroupPosition _positionFor(int index, int count) {
    if (count == 1) {
      return BillRowGroupPosition.single;
    }
    if (index == 0) {
      return BillRowGroupPosition.first;
    }
    if (index == count - 1) {
      return BillRowGroupPosition.last;
    }
    return BillRowGroupPosition.middle;
  }
}
