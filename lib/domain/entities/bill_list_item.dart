import 'package:flutter/foundation.dart';

enum BillType { expense, income }

@immutable
class BillListItem {
  const BillListItem({
    required this.id,
    required this.amountCents,
    required this.type,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColorValue,
    required this.occurredAt,
    required this.dateText,
    required this.description,
    required this.updatedAt,
    required this.amountText,
  });

  final String id;
  final int amountCents;
  final BillType type;
  final String categoryName;
  final String categoryIcon;
  final int categoryColorValue;
  final DateTime occurredAt;
  final String dateText;
  final String description;
  final DateTime updatedAt;
  final String amountText;

  BillListItem copyWith({
    String? id,
    int? amountCents,
    BillType? type,
    String? categoryName,
    String? categoryIcon,
    int? categoryColorValue,
    DateTime? occurredAt,
    String? dateText,
    String? description,
    DateTime? updatedAt,
    String? amountText,
  }) {
    return BillListItem(
      id: id ?? this.id,
      amountCents: amountCents ?? this.amountCents,
      type: type ?? this.type,
      categoryName: categoryName ?? this.categoryName,
      categoryIcon: categoryIcon ?? this.categoryIcon,
      categoryColorValue: categoryColorValue ?? this.categoryColorValue,
      occurredAt: occurredAt ?? this.occurredAt,
      dateText: dateText ?? this.dateText,
      description: description ?? this.description,
      updatedAt: updatedAt ?? this.updatedAt,
      amountText: amountText ?? this.amountText,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is BillListItem &&
        other.id == id &&
        other.amountCents == amountCents &&
        other.type == type &&
        other.categoryName == categoryName &&
        other.categoryIcon == categoryIcon &&
        other.categoryColorValue == categoryColorValue &&
        other.occurredAt == occurredAt &&
        other.dateText == dateText &&
        other.description == description &&
        other.updatedAt == updatedAt &&
        other.amountText == amountText;
  }

  @override
  int get hashCode => Object.hash(
    id,
    amountCents,
    type,
    categoryName,
    categoryIcon,
    categoryColorValue,
    occurredAt,
    dateText,
    description,
    updatedAt,
    amountText,
  );
}
