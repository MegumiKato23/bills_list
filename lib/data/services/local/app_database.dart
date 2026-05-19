import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class Bills extends Table {
  TextColumn get id => text()();

  IntColumn get amountCents => integer()();

  TextColumn get type => text()();

  TextColumn get categoryName => text()();

  TextColumn get categoryIcon => text()();

  IntColumn get categoryColorValue => integer()();

  IntColumn get occurredAtMillis => integer()();

  TextColumn get dateText => text()();

  TextColumn get description => text()();

  IntColumn get updatedAtMillis => integer()();

  TextColumn get amountText => text()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

@DriftDatabase(tables: <Type>[Bills])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      await customStatement(
        'CREATE INDEX idx_bills_occurred_id ON bills (occurred_at_millis DESC, id DESC);',
      );
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'bookkeeper_bills.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
