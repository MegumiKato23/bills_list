import 'package:flutter/material.dart';

import '../features/bill_list/pages/bill_list_page.dart';
import 'theme/app_theme.dart';

class BookKeeperApp extends StatelessWidget {
  const BookKeeperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookKeeper Bills',
      theme: AppTheme.light,
      home: const BillListPage(),
    );
  }
}
