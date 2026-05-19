import 'package:flutter/material.dart';

import '../../../core/constants/pagination_constants.dart';
import '../../../domain/entities/bill_list_item.dart';
import '../states/bill_list_display_entry.dart';

class BillRow extends StatelessWidget {
  const BillRow({super.key, required this.bill, required this.position});

  final BillListItem bill;
  final BillRowGroupPosition position;

  @override
  Widget build(BuildContext context) {
    final amountColor = bill.type == BillType.expense
        ? const Color(0xFFDC2626)
        : const Color(0xFF16A34A);

    return SizedBox(
      height: PaginationConstants.billRowExtent,
      child: Padding(
        padding: _outerPadding(),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: _borderRadius(),
            border: _border(),
            // 只给分组外沿加阴影，组内账单保持贴合。
            boxShadow: _boxShadow(),
          ),
          child: Row(
            children: <Widget>[
              const SizedBox(width: 14),
              CircleAvatar(
                radius: 20,
                backgroundColor: Color(
                  bill.categoryColorValue,
                ).withValues(alpha: 0.15),
                child: Icon(
                  _iconForCategory(bill.categoryIcon),
                  size: 19,
                  color: Color(bill.categoryColorValue),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      bill.categoryName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bill.description.isEmpty
                          ? bill.dateText
                          : bill.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    bill.amountText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: amountColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bill.dateText,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
            ],
          ),
        ),
      ),
    );
  }

  EdgeInsets _outerPadding() {
    switch (position) {
      case BillRowGroupPosition.single:
        return const EdgeInsets.symmetric(horizontal: 18, vertical: 7);
      case BillRowGroupPosition.first:
        return const EdgeInsets.fromLTRB(18, 6, 18, 0);
      case BillRowGroupPosition.middle:
        return const EdgeInsets.symmetric(horizontal: 18);
      case BillRowGroupPosition.last:
        return const EdgeInsets.fromLTRB(18, 0, 18, 6);
    }
  }

  BorderRadius _borderRadius() {
    const radius = Radius.circular(22);
    switch (position) {
      case BillRowGroupPosition.single:
        return const BorderRadius.all(radius);
      case BillRowGroupPosition.first:
        return const BorderRadius.vertical(top: radius);
      case BillRowGroupPosition.middle:
        return BorderRadius.zero;
      case BillRowGroupPosition.last:
        return const BorderRadius.vertical(bottom: radius);
    }
  }

  List<BoxShadow> _boxShadow() {
    if (position == BillRowGroupPosition.middle) {
      return const <BoxShadow>[];
    }
    return <BoxShadow>[
      BoxShadow(
        color: const Color(0xFF111827).withValues(alpha: 0.05),
        blurRadius: 14,
        offset: const Offset(0, 5),
      ),
    ];
  }

  BoxBorder _border() {
    const side = BorderSide(color: Color(0xFFE5E7EB));
    switch (position) {
      case BillRowGroupPosition.single:
        return Border.all(color: side.color);
      case BillRowGroupPosition.first:
        return const Border(top: side, left: side, right: side);
      case BillRowGroupPosition.middle:
        return const Border(left: side, right: side);
      case BillRowGroupPosition.last:
        return const Border(bottom: side, left: side, right: side);
    }
  }
}

IconData _iconForCategory(String iconName) {
  switch (iconName) {
    case 'food':
      return Icons.restaurant;
    case 'traffic':
      return Icons.directions_bus;
    case 'shopping':
      return Icons.shopping_bag;
    case 'salary':
      return Icons.account_balance_wallet;
    case 'play':
      return Icons.videogame_asset;
    default:
      return Icons.receipt_long;
  }
}
