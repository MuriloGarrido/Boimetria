// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BovinesTable extends Bovines with TableInfo<$BovinesTable, BovineRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BovinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tagMeta = const VerificationMeta('tag');
  @override
  late final GeneratedColumn<String> tag = GeneratedColumn<String>(
    'tag',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Sex, String> sex =
      GeneratedColumn<String>(
        'sex',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Sex>($BovinesTable.$convertersex);
  static const VerificationMeta _entryDateMeta = const VerificationMeta(
    'entryDate',
  );
  @override
  late final GeneratedColumn<DateTime> entryDate = GeneratedColumn<DateTime>(
    'entry_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  @override
  late final GeneratedColumn<DateTime> birthDate = GeneratedColumn<DateTime>(
    'birth_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tag,
    sex,
    entryDate,
    birthDate,
    weightKg,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bovines';
  @override
  VerificationContext validateIntegrity(
    Insertable<BovineRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tag')) {
      context.handle(
        _tagMeta,
        tag.isAcceptableOrUnknown(data['tag']!, _tagMeta),
      );
    } else if (isInserting) {
      context.missing(_tagMeta);
    }
    if (data.containsKey('entry_date')) {
      context.handle(
        _entryDateMeta,
        entryDate.isAcceptableOrUnknown(data['entry_date']!, _entryDateMeta),
      );
    } else if (isInserting) {
      context.missing(_entryDateMeta);
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BovineRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BovineRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag'],
      )!,
      sex: $BovinesTable.$convertersex.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sex'],
        )!,
      ),
      entryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}entry_date'],
      )!,
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birth_date'],
      ),
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      ),
    );
  }

  @override
  $BovinesTable createAlias(String alias) {
    return $BovinesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Sex, String, String> $convertersex =
      const EnumNameConverter<Sex>(Sex.values);
}

class BovineRow extends DataClass implements Insertable<BovineRow> {
  final int id;
  final String tag;
  final Sex sex;
  final DateTime entryDate;
  final DateTime? birthDate;
  final double? weightKg;
  const BovineRow({
    required this.id,
    required this.tag,
    required this.sex,
    required this.entryDate,
    this.birthDate,
    this.weightKg,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tag'] = Variable<String>(tag);
    {
      map['sex'] = Variable<String>($BovinesTable.$convertersex.toSql(sex));
    }
    map['entry_date'] = Variable<DateTime>(entryDate);
    if (!nullToAbsent || birthDate != null) {
      map['birth_date'] = Variable<DateTime>(birthDate);
    }
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    return map;
  }

  BovinesCompanion toCompanion(bool nullToAbsent) {
    return BovinesCompanion(
      id: Value(id),
      tag: Value(tag),
      sex: Value(sex),
      entryDate: Value(entryDate),
      birthDate: birthDate == null && nullToAbsent
          ? const Value.absent()
          : Value(birthDate),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
    );
  }

  factory BovineRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BovineRow(
      id: serializer.fromJson<int>(json['id']),
      tag: serializer.fromJson<String>(json['tag']),
      sex: $BovinesTable.$convertersex.fromJson(
        serializer.fromJson<String>(json['sex']),
      ),
      entryDate: serializer.fromJson<DateTime>(json['entryDate']),
      birthDate: serializer.fromJson<DateTime?>(json['birthDate']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tag': serializer.toJson<String>(tag),
      'sex': serializer.toJson<String>($BovinesTable.$convertersex.toJson(sex)),
      'entryDate': serializer.toJson<DateTime>(entryDate),
      'birthDate': serializer.toJson<DateTime?>(birthDate),
      'weightKg': serializer.toJson<double?>(weightKg),
    };
  }

  BovineRow copyWith({
    int? id,
    String? tag,
    Sex? sex,
    DateTime? entryDate,
    Value<DateTime?> birthDate = const Value.absent(),
    Value<double?> weightKg = const Value.absent(),
  }) => BovineRow(
    id: id ?? this.id,
    tag: tag ?? this.tag,
    sex: sex ?? this.sex,
    entryDate: entryDate ?? this.entryDate,
    birthDate: birthDate.present ? birthDate.value : this.birthDate,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
  );
  BovineRow copyWithCompanion(BovinesCompanion data) {
    return BovineRow(
      id: data.id.present ? data.id.value : this.id,
      tag: data.tag.present ? data.tag.value : this.tag,
      sex: data.sex.present ? data.sex.value : this.sex,
      entryDate: data.entryDate.present ? data.entryDate.value : this.entryDate,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BovineRow(')
          ..write('id: $id, ')
          ..write('tag: $tag, ')
          ..write('sex: $sex, ')
          ..write('entryDate: $entryDate, ')
          ..write('birthDate: $birthDate, ')
          ..write('weightKg: $weightKg')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tag, sex, entryDate, birthDate, weightKg);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BovineRow &&
          other.id == this.id &&
          other.tag == this.tag &&
          other.sex == this.sex &&
          other.entryDate == this.entryDate &&
          other.birthDate == this.birthDate &&
          other.weightKg == this.weightKg);
}

class BovinesCompanion extends UpdateCompanion<BovineRow> {
  final Value<int> id;
  final Value<String> tag;
  final Value<Sex> sex;
  final Value<DateTime> entryDate;
  final Value<DateTime?> birthDate;
  final Value<double?> weightKg;
  const BovinesCompanion({
    this.id = const Value.absent(),
    this.tag = const Value.absent(),
    this.sex = const Value.absent(),
    this.entryDate = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.weightKg = const Value.absent(),
  });
  BovinesCompanion.insert({
    this.id = const Value.absent(),
    required String tag,
    required Sex sex,
    required DateTime entryDate,
    this.birthDate = const Value.absent(),
    this.weightKg = const Value.absent(),
  }) : tag = Value(tag),
       sex = Value(sex),
       entryDate = Value(entryDate);
  static Insertable<BovineRow> custom({
    Expression<int>? id,
    Expression<String>? tag,
    Expression<String>? sex,
    Expression<DateTime>? entryDate,
    Expression<DateTime>? birthDate,
    Expression<double>? weightKg,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tag != null) 'tag': tag,
      if (sex != null) 'sex': sex,
      if (entryDate != null) 'entry_date': entryDate,
      if (birthDate != null) 'birth_date': birthDate,
      if (weightKg != null) 'weight_kg': weightKg,
    });
  }

  BovinesCompanion copyWith({
    Value<int>? id,
    Value<String>? tag,
    Value<Sex>? sex,
    Value<DateTime>? entryDate,
    Value<DateTime?>? birthDate,
    Value<double?>? weightKg,
  }) {
    return BovinesCompanion(
      id: id ?? this.id,
      tag: tag ?? this.tag,
      sex: sex ?? this.sex,
      entryDate: entryDate ?? this.entryDate,
      birthDate: birthDate ?? this.birthDate,
      weightKg: weightKg ?? this.weightKg,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tag.present) {
      map['tag'] = Variable<String>(tag.value);
    }
    if (sex.present) {
      map['sex'] = Variable<String>(
        $BovinesTable.$convertersex.toSql(sex.value),
      );
    }
    if (entryDate.present) {
      map['entry_date'] = Variable<DateTime>(entryDate.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<DateTime>(birthDate.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BovinesCompanion(')
          ..write('id: $id, ')
          ..write('tag: $tag, ')
          ..write('sex: $sex, ')
          ..write('entryDate: $entryDate, ')
          ..write('birthDate: $birthDate, ')
          ..write('weightKg: $weightKg')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BovinesTable bovines = $BovinesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [bovines];
}

typedef $$BovinesTableCreateCompanionBuilder =
    BovinesCompanion Function({
      Value<int> id,
      required String tag,
      required Sex sex,
      required DateTime entryDate,
      Value<DateTime?> birthDate,
      Value<double?> weightKg,
    });
typedef $$BovinesTableUpdateCompanionBuilder =
    BovinesCompanion Function({
      Value<int> id,
      Value<String> tag,
      Value<Sex> sex,
      Value<DateTime> entryDate,
      Value<DateTime?> birthDate,
      Value<double?> weightKg,
    });

class $$BovinesTableFilterComposer
    extends Composer<_$AppDatabase, $BovinesTable> {
  $$BovinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tag => $composableBuilder(
    column: $table.tag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Sex, Sex, String> get sex =>
      $composableBuilder(
        column: $table.sex,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get entryDate => $composableBuilder(
    column: $table.entryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BovinesTableOrderingComposer
    extends Composer<_$AppDatabase, $BovinesTable> {
  $$BovinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tag => $composableBuilder(
    column: $table.tag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get entryDate => $composableBuilder(
    column: $table.entryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BovinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BovinesTable> {
  $$BovinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tag =>
      $composableBuilder(column: $table.tag, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Sex, String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<DateTime> get entryDate =>
      $composableBuilder(column: $table.entryDate, builder: (column) => column);

  GeneratedColumn<DateTime> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);
}

class $$BovinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BovinesTable,
          BovineRow,
          $$BovinesTableFilterComposer,
          $$BovinesTableOrderingComposer,
          $$BovinesTableAnnotationComposer,
          $$BovinesTableCreateCompanionBuilder,
          $$BovinesTableUpdateCompanionBuilder,
          (BovineRow, BaseReferences<_$AppDatabase, $BovinesTable, BovineRow>),
          BovineRow,
          PrefetchHooks Function()
        > {
  $$BovinesTableTableManager(_$AppDatabase db, $BovinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BovinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BovinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BovinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> tag = const Value.absent(),
                Value<Sex> sex = const Value.absent(),
                Value<DateTime> entryDate = const Value.absent(),
                Value<DateTime?> birthDate = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
              }) => BovinesCompanion(
                id: id,
                tag: tag,
                sex: sex,
                entryDate: entryDate,
                birthDate: birthDate,
                weightKg: weightKg,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String tag,
                required Sex sex,
                required DateTime entryDate,
                Value<DateTime?> birthDate = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
              }) => BovinesCompanion.insert(
                id: id,
                tag: tag,
                sex: sex,
                entryDate: entryDate,
                birthDate: birthDate,
                weightKg: weightKg,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BovinesTable, BovineRow>(table),
                  BaseReferences<_$AppDatabase, $BovinesTable, BovineRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BovinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BovinesTable,
      BovineRow,
      $$BovinesTableFilterComposer,
      $$BovinesTableOrderingComposer,
      $$BovinesTableAnnotationComposer,
      $$BovinesTableCreateCompanionBuilder,
      $$BovinesTableUpdateCompanionBuilder,
      (BovineRow, BaseReferences<_$AppDatabase, $BovinesTable, BovineRow>),
      BovineRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BovinesTableTableManager get bovines =>
      $$BovinesTableTableManager(_db, _db.bovines);
}
