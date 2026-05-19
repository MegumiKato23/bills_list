import 'package:drift/drift.dart';

import '../../../domain/entities/bill_list_item.dart';
import 'app_database.dart';

class BillLocalDataSource {
  BillLocalDataSource(this._database);

  final AppDatabase _database;

  Future<List<BillListItem>> queryWindow({
    required int limit,
    required int offset,
  }) async {
    final query = _database.select(_database.bills)
      ..orderBy(<OrderingTerm Function(Bills)>[
        (Bills tbl) => OrderingTerm.desc(tbl.occurredAtMillis),
        (Bills tbl) => OrderingTerm.desc(tbl.id),
      ])
      ..limit(limit, offset: offset);

    final rows = await query.get();
    return rows.map(_toEntity).toList(growable: false);
  }

  Future<void> upsertItems(List<BillListItem> items) async {
    if (items.isEmpty) {
      return;
    }

    await _database.batch((Batch batch) {
      batch.insertAllOnConflictUpdate(
        _database.bills,
        items.map(_toCompanion).toList(growable: false),
      );
    });
  }

  Future<void> clearAll() async {
    await _database.delete(_database.bills).go();
  }

  BillsCompanion _toCompanion(BillListItem item) {
    return BillsCompanion.insert(
      id: item.id,
      amountCents: item.amountCents,
      type: item.type.name,
      categoryName: item.categoryName,
      categoryIcon: item.categoryIcon,
      categoryColorValue: item.categoryColorValue,
      occurredAtMillis: item.occurredAt.millisecondsSinceEpoch,
      dateText: item.dateText,
      description: item.description,
      updatedAtMillis: item.updatedAt.millisecondsSinceEpoch,
      amountText: item.amountText,
    );
  }

  BillListItem _toEntity(Bill row) {
    final type = row.type == BillType.income.name
        ? BillType.income
        : BillType.expense;

    return BillListItem(
      id: row.id,
      amountCents: row.amountCents,
      type: type,
      categoryName: row.categoryName,
      categoryIcon: row.categoryIcon,
      categoryColorValue: row.categoryColorValue,
      occurredAt: DateTime.fromMillisecondsSinceEpoch(
        row.occurredAtMillis,
        isUtc: true,
      ),
      dateText: row.dateText,
      description: row.description,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        row.updatedAtMillis,
        isUtc: true,
      ),
      amountText: row.amountText,
    );
  }
}
