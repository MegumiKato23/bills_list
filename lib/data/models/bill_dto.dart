import '../../core/utils/bill_display_formatter.dart';
import '../../domain/entities/bill_list_item.dart';

class BillDto {
  const BillDto({
    required this.id,
    required this.amountCents,
    required this.type,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
    required this.occurredAt,
    required this.description,
    required this.updatedAt,
  });

  final String id;
  final int amountCents;
  final String type;
  final String categoryName;
  final String categoryIcon;
  final String categoryColor;
  final String description;
  final String occurredAt;
  final String updatedAt;

  factory BillDto.fromJson(Map<String, dynamic> json) {
    return BillDto(
      id: json['id'] as String,
      amountCents: json['amountCents'] as int,
      type: json['type'] as String,
      categoryName: json['categoryName'] as String,
      categoryIcon: json['categoryIcon'] as String,
      categoryColor: json['categoryColor'] as String,
      description: (json['description'] as String?) ?? '',
      occurredAt: json['occurredAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }

  BillListItem toEntity() {
    final occurredAtTime = DateTime.parse(occurredAt).toUtc();
    final updatedAtTime = DateTime.parse(updatedAt).toUtc();
    final billType = type == 'income' ? BillType.income : BillType.expense;

    return BillListItem(
      id: id,
      amountCents: amountCents,
      type: billType,
      categoryName: categoryName,
      categoryIcon: categoryIcon,
      categoryColorValue: BillDisplayFormatter.parseColorToValue(categoryColor),
      occurredAt: occurredAtTime,
      dateText: BillDisplayFormatter.formatDate(occurredAtTime),
      description: description,
      updatedAt: updatedAtTime,
      amountText: BillDisplayFormatter.formatAmount(amountCents, billType),
    );
  }
}
