import 'package:flutter/material.dart';

import '../../../core/constants/pagination_constants.dart';
import '../states/bill_list_display_entry.dart';

class BillDateHeader extends StatelessWidget {
  const BillDateHeader({super.key, required this.entry});

  final BillDateHeaderEntry entry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: PaginationConstants.billDateHeaderExtent,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 18, 6),
        child: Row(
          children: <Widget>[
            Text(
              entry.monthDayText,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              entry.weekdayText,
              style: const TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
            ),
            const Spacer(),
            _SummaryText(
              label: '收',
              amount: entry.incomeText,
              color: const Color(0xFF059669),
            ),
            const SizedBox(width: 14),
            _SummaryText(
              label: '支',
              amount: entry.expenseText,
              color: const Color(0xFFDC2626),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryText extends StatelessWidget {
  const _SummaryText({
    required this.label,
    required this.amount,
    required this.color,
  });

  final String label;
  final String amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
        children: <InlineSpan>[
          TextSpan(text: '$label '),
          TextSpan(
            text: amount,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
