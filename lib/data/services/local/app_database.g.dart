// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BillsTable extends Bills with TableInfo<$BillsTable, Bill> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BillsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryNameMeta = const VerificationMeta(
    'categoryName',
  );
  @override
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
    'category_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIconMeta = const VerificationMeta(
    'categoryIcon',
  );
  @override
  late final GeneratedColumn<String> categoryIcon = GeneratedColumn<String>(
    'category_icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryColorValueMeta =
      const VerificationMeta('categoryColorValue');
  @override
  late final GeneratedColumn<int> categoryColorValue = GeneratedColumn<int>(
    'category_color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMillisMeta = const VerificationMeta(
    'occurredAtMillis',
  );
  @override
  late final GeneratedColumn<int> occurredAtMillis = GeneratedColumn<int>(
    'occurred_at_millis',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateTextMeta = const VerificationMeta(
    'dateText',
  );
  @override
  late final GeneratedColumn<String> dateText = GeneratedColumn<String>(
    'date_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMillisMeta = const VerificationMeta(
    'updatedAtMillis',
  );
  @override
  late final GeneratedColumn<int> updatedAtMillis = GeneratedColumn<int>(
    'updated_at_millis',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountTextMeta = const VerificationMeta(
    'amountText',
  );
  @override
  late final GeneratedColumn<String> amountText = GeneratedColumn<String>(
    'amount_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    amountCents,
    type,
    categoryName,
    categoryIcon,
    categoryColorValue,
    occurredAtMillis,
    dateText,
    description,
    updatedAtMillis,
    amountText,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bills';
  @override
  VerificationContext validateIntegrity(
    Insertable<Bill> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('category_name')) {
      context.handle(
        _categoryNameMeta,
        categoryName.isAcceptableOrUnknown(
          data['category_name']!,
          _categoryNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoryNameMeta);
    }
    if (data.containsKey('category_icon')) {
      context.handle(
        _categoryIconMeta,
        categoryIcon.isAcceptableOrUnknown(
          data['category_icon']!,
          _categoryIconMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoryIconMeta);
    }
    if (data.containsKey('category_color_value')) {
      context.handle(
        _categoryColorValueMeta,
        categoryColorValue.isAcceptableOrUnknown(
          data['category_color_value']!,
          _categoryColorValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoryColorValueMeta);
    }
    if (data.containsKey('occurred_at_millis')) {
      context.handle(
        _occurredAtMillisMeta,
        occurredAtMillis.isAcceptableOrUnknown(
          data['occurred_at_millis']!,
          _occurredAtMillisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMillisMeta);
    }
    if (data.containsKey('date_text')) {
      context.handle(
        _dateTextMeta,
        dateText.isAcceptableOrUnknown(data['date_text']!, _dateTextMeta),
      );
    } else if (isInserting) {
      context.missing(_dateTextMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('updated_at_millis')) {
      context.handle(
        _updatedAtMillisMeta,
        updatedAtMillis.isAcceptableOrUnknown(
          data['updated_at_millis']!,
          _updatedAtMillisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMillisMeta);
    }
    if (data.containsKey('amount_text')) {
      context.handle(
        _amountTextMeta,
        amountText.isAcceptableOrUnknown(data['amount_text']!, _amountTextMeta),
      );
    } else if (isInserting) {
      context.missing(_amountTextMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Bill map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bill(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      categoryName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_name'],
      )!,
      categoryIcon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_icon'],
      )!,
      categoryColorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_color_value'],
      )!,
      occurredAtMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}occurred_at_millis'],
      )!,
      dateText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_text'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      updatedAtMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_millis'],
      )!,
      amountText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}amount_text'],
      )!,
    );
  }

  @override
  $BillsTable createAlias(String alias) {
    return $BillsTable(attachedDatabase, alias);
  }
}

class Bill extends DataClass implements Insertable<Bill> {
  final String id;
  final int amountCents;
  final String type;
  final String categoryName;
  final String categoryIcon;
  final int categoryColorValue;
  final int occurredAtMillis;
  final String dateText;
  final String description;
  final int updatedAtMillis;
  final String amountText;
  const Bill({
    required this.id,
    required this.amountCents,
    required this.type,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColorValue,
    required this.occurredAtMillis,
    required this.dateText,
    required this.description,
    required this.updatedAtMillis,
    required this.amountText,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['amount_cents'] = Variable<int>(amountCents);
    map['type'] = Variable<String>(type);
    map['category_name'] = Variable<String>(categoryName);
    map['category_icon'] = Variable<String>(categoryIcon);
    map['category_color_value'] = Variable<int>(categoryColorValue);
    map['occurred_at_millis'] = Variable<int>(occurredAtMillis);
    map['date_text'] = Variable<String>(dateText);
    map['description'] = Variable<String>(description);
    map['updated_at_millis'] = Variable<int>(updatedAtMillis);
    map['amount_text'] = Variable<String>(amountText);
    return map;
  }

  BillsCompanion toCompanion(bool nullToAbsent) {
    return BillsCompanion(
      id: Value(id),
      amountCents: Value(amountCents),
      type: Value(type),
      categoryName: Value(categoryName),
      categoryIcon: Value(categoryIcon),
      categoryColorValue: Value(categoryColorValue),
      occurredAtMillis: Value(occurredAtMillis),
      dateText: Value(dateText),
      description: Value(description),
      updatedAtMillis: Value(updatedAtMillis),
      amountText: Value(amountText),
    );
  }

  factory Bill.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bill(
      id: serializer.fromJson<String>(json['id']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      type: serializer.fromJson<String>(json['type']),
      categoryName: serializer.fromJson<String>(json['categoryName']),
      categoryIcon: serializer.fromJson<String>(json['categoryIcon']),
      categoryColorValue: serializer.fromJson<int>(json['categoryColorValue']),
      occurredAtMillis: serializer.fromJson<int>(json['occurredAtMillis']),
      dateText: serializer.fromJson<String>(json['dateText']),
      description: serializer.fromJson<String>(json['description']),
      updatedAtMillis: serializer.fromJson<int>(json['updatedAtMillis']),
      amountText: serializer.fromJson<String>(json['amountText']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'amountCents': serializer.toJson<int>(amountCents),
      'type': serializer.toJson<String>(type),
      'categoryName': serializer.toJson<String>(categoryName),
      'categoryIcon': serializer.toJson<String>(categoryIcon),
      'categoryColorValue': serializer.toJson<int>(categoryColorValue),
      'occurredAtMillis': serializer.toJson<int>(occurredAtMillis),
      'dateText': serializer.toJson<String>(dateText),
      'description': serializer.toJson<String>(description),
      'updatedAtMillis': serializer.toJson<int>(updatedAtMillis),
      'amountText': serializer.toJson<String>(amountText),
    };
  }

  Bill copyWith({
    String? id,
    int? amountCents,
    String? type,
    String? categoryName,
    String? categoryIcon,
    int? categoryColorValue,
    int? occurredAtMillis,
    String? dateText,
    String? description,
    int? updatedAtMillis,
    String? amountText,
  }) => Bill(
    id: id ?? this.id,
    amountCents: amountCents ?? this.amountCents,
    type: type ?? this.type,
    categoryName: categoryName ?? this.categoryName,
    categoryIcon: categoryIcon ?? this.categoryIcon,
    categoryColorValue: categoryColorValue ?? this.categoryColorValue,
    occurredAtMillis: occurredAtMillis ?? this.occurredAtMillis,
    dateText: dateText ?? this.dateText,
    description: description ?? this.description,
    updatedAtMillis: updatedAtMillis ?? this.updatedAtMillis,
    amountText: amountText ?? this.amountText,
  );
  Bill copyWithCompanion(BillsCompanion data) {
    return Bill(
      id: data.id.present ? data.id.value : this.id,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      type: data.type.present ? data.type.value : this.type,
      categoryName: data.categoryName.present
          ? data.categoryName.value
          : this.categoryName,
      categoryIcon: data.categoryIcon.present
          ? data.categoryIcon.value
          : this.categoryIcon,
      categoryColorValue: data.categoryColorValue.present
          ? data.categoryColorValue.value
          : this.categoryColorValue,
      occurredAtMillis: data.occurredAtMillis.present
          ? data.occurredAtMillis.value
          : this.occurredAtMillis,
      dateText: data.dateText.present ? data.dateText.value : this.dateText,
      description: data.description.present
          ? data.description.value
          : this.description,
      updatedAtMillis: data.updatedAtMillis.present
          ? data.updatedAtMillis.value
          : this.updatedAtMillis,
      amountText: data.amountText.present
          ? data.amountText.value
          : this.amountText,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Bill(')
          ..write('id: $id, ')
          ..write('amountCents: $amountCents, ')
          ..write('type: $type, ')
          ..write('categoryName: $categoryName, ')
          ..write('categoryIcon: $categoryIcon, ')
          ..write('categoryColorValue: $categoryColorValue, ')
          ..write('occurredAtMillis: $occurredAtMillis, ')
          ..write('dateText: $dateText, ')
          ..write('description: $description, ')
          ..write('updatedAtMillis: $updatedAtMillis, ')
          ..write('amountText: $amountText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    amountCents,
    type,
    categoryName,
    categoryIcon,
    categoryColorValue,
    occurredAtMillis,
    dateText,
    description,
    updatedAtMillis,
    amountText,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bill &&
          other.id == this.id &&
          other.amountCents == this.amountCents &&
          other.type == this.type &&
          other.categoryName == this.categoryName &&
          other.categoryIcon == this.categoryIcon &&
          other.categoryColorValue == this.categoryColorValue &&
          other.occurredAtMillis == this.occurredAtMillis &&
          other.dateText == this.dateText &&
          other.description == this.description &&
          other.updatedAtMillis == this.updatedAtMillis &&
          other.amountText == this.amountText);
}

class BillsCompanion extends UpdateCompanion<Bill> {
  final Value<String> id;
  final Value<int> amountCents;
  final Value<String> type;
  final Value<String> categoryName;
  final Value<String> categoryIcon;
  final Value<int> categoryColorValue;
  final Value<int> occurredAtMillis;
  final Value<String> dateText;
  final Value<String> description;
  final Value<int> updatedAtMillis;
  final Value<String> amountText;
  final Value<int> rowid;
  const BillsCompanion({
    this.id = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.type = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.categoryIcon = const Value.absent(),
    this.categoryColorValue = const Value.absent(),
    this.occurredAtMillis = const Value.absent(),
    this.dateText = const Value.absent(),
    this.description = const Value.absent(),
    this.updatedAtMillis = const Value.absent(),
    this.amountText = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BillsCompanion.insert({
    required String id,
    required int amountCents,
    required String type,
    required String categoryName,
    required String categoryIcon,
    required int categoryColorValue,
    required int occurredAtMillis,
    required String dateText,
    required String description,
    required int updatedAtMillis,
    required String amountText,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       amountCents = Value(amountCents),
       type = Value(type),
       categoryName = Value(categoryName),
       categoryIcon = Value(categoryIcon),
       categoryColorValue = Value(categoryColorValue),
       occurredAtMillis = Value(occurredAtMillis),
       dateText = Value(dateText),
       description = Value(description),
       updatedAtMillis = Value(updatedAtMillis),
       amountText = Value(amountText);
  static Insertable<Bill> custom({
    Expression<String>? id,
    Expression<int>? amountCents,
    Expression<String>? type,
    Expression<String>? categoryName,
    Expression<String>? categoryIcon,
    Expression<int>? categoryColorValue,
    Expression<int>? occurredAtMillis,
    Expression<String>? dateText,
    Expression<String>? description,
    Expression<int>? updatedAtMillis,
    Expression<String>? amountText,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amountCents != null) 'amount_cents': amountCents,
      if (type != null) 'type': type,
      if (categoryName != null) 'category_name': categoryName,
      if (categoryIcon != null) 'category_icon': categoryIcon,
      if (categoryColorValue != null)
        'category_color_value': categoryColorValue,
      if (occurredAtMillis != null) 'occurred_at_millis': occurredAtMillis,
      if (dateText != null) 'date_text': dateText,
      if (description != null) 'description': description,
      if (updatedAtMillis != null) 'updated_at_millis': updatedAtMillis,
      if (amountText != null) 'amount_text': amountText,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BillsCompanion copyWith({
    Value<String>? id,
    Value<int>? amountCents,
    Value<String>? type,
    Value<String>? categoryName,
    Value<String>? categoryIcon,
    Value<int>? categoryColorValue,
    Value<int>? occurredAtMillis,
    Value<String>? dateText,
    Value<String>? description,
    Value<int>? updatedAtMillis,
    Value<String>? amountText,
    Value<int>? rowid,
  }) {
    return BillsCompanion(
      id: id ?? this.id,
      amountCents: amountCents ?? this.amountCents,
      type: type ?? this.type,
      categoryName: categoryName ?? this.categoryName,
      categoryIcon: categoryIcon ?? this.categoryIcon,
      categoryColorValue: categoryColorValue ?? this.categoryColorValue,
      occurredAtMillis: occurredAtMillis ?? this.occurredAtMillis,
      dateText: dateText ?? this.dateText,
      description: description ?? this.description,
      updatedAtMillis: updatedAtMillis ?? this.updatedAtMillis,
      amountText: amountText ?? this.amountText,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    if (categoryIcon.present) {
      map['category_icon'] = Variable<String>(categoryIcon.value);
    }
    if (categoryColorValue.present) {
      map['category_color_value'] = Variable<int>(categoryColorValue.value);
    }
    if (occurredAtMillis.present) {
      map['occurred_at_millis'] = Variable<int>(occurredAtMillis.value);
    }
    if (dateText.present) {
      map['date_text'] = Variable<String>(dateText.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (updatedAtMillis.present) {
      map['updated_at_millis'] = Variable<int>(updatedAtMillis.value);
    }
    if (amountText.present) {
      map['amount_text'] = Variable<String>(amountText.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BillsCompanion(')
          ..write('id: $id, ')
          ..write('amountCents: $amountCents, ')
          ..write('type: $type, ')
          ..write('categoryName: $categoryName, ')
          ..write('categoryIcon: $categoryIcon, ')
          ..write('categoryColorValue: $categoryColorValue, ')
          ..write('occurredAtMillis: $occurredAtMillis, ')
          ..write('dateText: $dateText, ')
          ..write('description: $description, ')
          ..write('updatedAtMillis: $updatedAtMillis, ')
          ..write('amountText: $amountText, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BillsTable bills = $BillsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [bills];
}

typedef $$BillsTableCreateCompanionBuilder =
    BillsCompanion Function({
      required String id,
      required int amountCents,
      required String type,
      required String categoryName,
      required String categoryIcon,
      required int categoryColorValue,
      required int occurredAtMillis,
      required String dateText,
      required String description,
      required int updatedAtMillis,
      required String amountText,
      Value<int> rowid,
    });
typedef $$BillsTableUpdateCompanionBuilder =
    BillsCompanion Function({
      Value<String> id,
      Value<int> amountCents,
      Value<String> type,
      Value<String> categoryName,
      Value<String> categoryIcon,
      Value<int> categoryColorValue,
      Value<int> occurredAtMillis,
      Value<String> dateText,
      Value<String> description,
      Value<int> updatedAtMillis,
      Value<String> amountText,
      Value<int> rowid,
    });

class $$BillsTableFilterComposer extends Composer<_$AppDatabase, $BillsTable> {
  $$BillsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryIcon => $composableBuilder(
    column: $table.categoryIcon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get categoryColorValue => $composableBuilder(
    column: $table.categoryColorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get occurredAtMillis => $composableBuilder(
    column: $table.occurredAtMillis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateText => $composableBuilder(
    column: $table.dateText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtMillis => $composableBuilder(
    column: $table.updatedAtMillis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get amountText => $composableBuilder(
    column: $table.amountText,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BillsTableOrderingComposer
    extends Composer<_$AppDatabase, $BillsTable> {
  $$BillsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryIcon => $composableBuilder(
    column: $table.categoryIcon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get categoryColorValue => $composableBuilder(
    column: $table.categoryColorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get occurredAtMillis => $composableBuilder(
    column: $table.occurredAtMillis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateText => $composableBuilder(
    column: $table.dateText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtMillis => $composableBuilder(
    column: $table.updatedAtMillis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get amountText => $composableBuilder(
    column: $table.amountText,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BillsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BillsTable> {
  $$BillsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryIcon => $composableBuilder(
    column: $table.categoryIcon,
    builder: (column) => column,
  );

  GeneratedColumn<int> get categoryColorValue => $composableBuilder(
    column: $table.categoryColorValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get occurredAtMillis => $composableBuilder(
    column: $table.occurredAtMillis,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dateText =>
      $composableBuilder(column: $table.dateText, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtMillis => $composableBuilder(
    column: $table.updatedAtMillis,
    builder: (column) => column,
  );

  GeneratedColumn<String> get amountText => $composableBuilder(
    column: $table.amountText,
    builder: (column) => column,
  );
}

class $$BillsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BillsTable,
          Bill,
          $$BillsTableFilterComposer,
          $$BillsTableOrderingComposer,
          $$BillsTableAnnotationComposer,
          $$BillsTableCreateCompanionBuilder,
          $$BillsTableUpdateCompanionBuilder,
          (Bill, BaseReferences<_$AppDatabase, $BillsTable, Bill>),
          Bill,
          PrefetchHooks Function()
        > {
  $$BillsTableTableManager(_$AppDatabase db, $BillsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BillsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BillsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BillsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> categoryName = const Value.absent(),
                Value<String> categoryIcon = const Value.absent(),
                Value<int> categoryColorValue = const Value.absent(),
                Value<int> occurredAtMillis = const Value.absent(),
                Value<String> dateText = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> updatedAtMillis = const Value.absent(),
                Value<String> amountText = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BillsCompanion(
                id: id,
                amountCents: amountCents,
                type: type,
                categoryName: categoryName,
                categoryIcon: categoryIcon,
                categoryColorValue: categoryColorValue,
                occurredAtMillis: occurredAtMillis,
                dateText: dateText,
                description: description,
                updatedAtMillis: updatedAtMillis,
                amountText: amountText,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int amountCents,
                required String type,
                required String categoryName,
                required String categoryIcon,
                required int categoryColorValue,
                required int occurredAtMillis,
                required String dateText,
                required String description,
                required int updatedAtMillis,
                required String amountText,
                Value<int> rowid = const Value.absent(),
              }) => BillsCompanion.insert(
                id: id,
                amountCents: amountCents,
                type: type,
                categoryName: categoryName,
                categoryIcon: categoryIcon,
                categoryColorValue: categoryColorValue,
                occurredAtMillis: occurredAtMillis,
                dateText: dateText,
                description: description,
                updatedAtMillis: updatedAtMillis,
                amountText: amountText,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BillsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BillsTable,
      Bill,
      $$BillsTableFilterComposer,
      $$BillsTableOrderingComposer,
      $$BillsTableAnnotationComposer,
      $$BillsTableCreateCompanionBuilder,
      $$BillsTableUpdateCompanionBuilder,
      (Bill, BaseReferences<_$AppDatabase, $BillsTable, Bill>),
      Bill,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BillsTableTableManager get bills =>
      $$BillsTableTableManager(_db, _db.bills);
}
