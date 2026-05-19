import 'package:flutter/material.dart';

import '../../../domain/entities/bill_list_item.dart';

class BillRow extends StatelessWidget {
  const BillRow({super.key, required this.bill});

  final BillListItem bill;

  @override
  Widget build(BuildContext context) {
    final amountColor = bill.type == BillType.expense
        ? const Color(0xFFDC2626)
        : const Color(0xFF16A34A);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: <Widget>[
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 16,
              backgroundColor: Color(
                bill.categoryColorValue,
              ).withValues(alpha: 0.15),
              child: Icon(
                _iconForCategory(bill.categoryIcon),
                size: 16,
                color: Color(bill.categoryColorValue),
              ),
            ),
            const SizedBox(width: 10),
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
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    bill.description.isEmpty ? bill.dateText : bill.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  bill.amountText,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: amountColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  bill.dateText,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
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
