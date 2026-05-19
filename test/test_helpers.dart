import 'package:bills_list/core/utils/bill_display_formatter.dart';
import 'package:bills_list/domain/entities/bill_list_item.dart';

BillListItem buildBillItem(int rank) {
  final occurredAt = DateTime.utc(
    2026,
    5,
    19,
    12,
  ).subtract(Duration(minutes: rank));
  final type = rank.isEven ? BillType.expense : BillType.income;

  return BillListItem(
    id: 'bill_${(100000 - rank).toString().padLeft(6, '0')}',
    amountCents: 1000 + rank,
    type: type,
    categoryName: '测试分类',
    categoryIcon: 'food',
    categoryColorValue: 0xFFEF4444,
    occurredAt: occurredAt,
    dateText: BillDisplayFormatter.formatDate(occurredAt),
    description: '测试账单 $rank',
    updatedAt: occurredAt.add(const Duration(seconds: 30)),
    amountText: BillDisplayFormatter.formatAmount(1000 + rank, type),
  );
}

bool isSortedByOccurredAndId(List<BillListItem> items) {
  for (var i = 1; i < items.length; i++) {
    final prev = items[i - 1];
    final curr = items[i];
    final timeCompare = prev.occurredAt.compareTo(curr.occurredAt);
    if (timeCompare < 0) {
      return false;
    }
    if (timeCompare == 0 && prev.id.compareTo(curr.id) < 0) {
      return false;
    }
  }
  return true;
}
