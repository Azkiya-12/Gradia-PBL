// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TugasTable extends Tugas with TableInfo<$TugasTable, TugasItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TugasTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _judulMeta = const VerificationMeta('judul');
  @override
  late final GeneratedColumn<String> judul = GeneratedColumn<String>(
    'judul',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mataKuliahMeta = const VerificationMeta(
    'mataKuliah',
  );
  @override
  late final GeneratedColumn<String> mataKuliah = GeneratedColumn<String>(
    'mata_kuliah',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tenggatMeta = const VerificationMeta(
    'tenggat',
  );
  @override
  late final GeneratedColumn<String> tenggat = GeneratedColumn<String>(
    'tenggat',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    judul,
    mataKuliah,
    tenggat,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tugas';
  @override
  VerificationContext validateIntegrity(
    Insertable<TugasItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('judul')) {
      context.handle(
        _judulMeta,
        judul.isAcceptableOrUnknown(data['judul']!, _judulMeta),
      );
    } else if (isInserting) {
      context.missing(_judulMeta);
    }
    if (data.containsKey('mata_kuliah')) {
      context.handle(
        _mataKuliahMeta,
        mataKuliah.isAcceptableOrUnknown(data['mata_kuliah']!, _mataKuliahMeta),
      );
    } else if (isInserting) {
      context.missing(_mataKuliahMeta);
    }
    if (data.containsKey('tenggat')) {
      context.handle(
        _tenggatMeta,
        tenggat.isAcceptableOrUnknown(data['tenggat']!, _tenggatMeta),
      );
    } else if (isInserting) {
      context.missing(_tenggatMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TugasItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TugasItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      judul: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}judul'],
      )!,
      mataKuliah: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mata_kuliah'],
      )!,
      tenggat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tenggat'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $TugasTable createAlias(String alias) {
    return $TugasTable(attachedDatabase, alias);
  }
}

class TugasItem extends DataClass implements Insertable<TugasItem> {
  final int id;
  final String judul;
  final String mataKuliah;
  final String tenggat;

  /// 'To-Do', 'Terkumpul', atau 'Terlewat'
  final String status;
  const TugasItem({
    required this.id,
    required this.judul,
    required this.mataKuliah,
    required this.tenggat,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['judul'] = Variable<String>(judul);
    map['mata_kuliah'] = Variable<String>(mataKuliah);
    map['tenggat'] = Variable<String>(tenggat);
    map['status'] = Variable<String>(status);
    return map;
  }

  TugasCompanion toCompanion(bool nullToAbsent) {
    return TugasCompanion(
      id: Value(id),
      judul: Value(judul),
      mataKuliah: Value(mataKuliah),
      tenggat: Value(tenggat),
      status: Value(status),
    );
  }

  factory TugasItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TugasItem(
      id: serializer.fromJson<int>(json['id']),
      judul: serializer.fromJson<String>(json['judul']),
      mataKuliah: serializer.fromJson<String>(json['mataKuliah']),
      tenggat: serializer.fromJson<String>(json['tenggat']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'judul': serializer.toJson<String>(judul),
      'mataKuliah': serializer.toJson<String>(mataKuliah),
      'tenggat': serializer.toJson<String>(tenggat),
      'status': serializer.toJson<String>(status),
    };
  }

  TugasItem copyWith({
    int? id,
    String? judul,
    String? mataKuliah,
    String? tenggat,
    String? status,
  }) => TugasItem(
    id: id ?? this.id,
    judul: judul ?? this.judul,
    mataKuliah: mataKuliah ?? this.mataKuliah,
    tenggat: tenggat ?? this.tenggat,
    status: status ?? this.status,
  );
  TugasItem copyWithCompanion(TugasCompanion data) {
    return TugasItem(
      id: data.id.present ? data.id.value : this.id,
      judul: data.judul.present ? data.judul.value : this.judul,
      mataKuliah: data.mataKuliah.present
          ? data.mataKuliah.value
          : this.mataKuliah,
      tenggat: data.tenggat.present ? data.tenggat.value : this.tenggat,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TugasItem(')
          ..write('id: $id, ')
          ..write('judul: $judul, ')
          ..write('mataKuliah: $mataKuliah, ')
          ..write('tenggat: $tenggat, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, judul, mataKuliah, tenggat, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TugasItem &&
          other.id == this.id &&
          other.judul == this.judul &&
          other.mataKuliah == this.mataKuliah &&
          other.tenggat == this.tenggat &&
          other.status == this.status);
}

class TugasCompanion extends UpdateCompanion<TugasItem> {
  final Value<int> id;
  final Value<String> judul;
  final Value<String> mataKuliah;
  final Value<String> tenggat;
  final Value<String> status;
  const TugasCompanion({
    this.id = const Value.absent(),
    this.judul = const Value.absent(),
    this.mataKuliah = const Value.absent(),
    this.tenggat = const Value.absent(),
    this.status = const Value.absent(),
  });
  TugasCompanion.insert({
    this.id = const Value.absent(),
    required String judul,
    required String mataKuliah,
    required String tenggat,
    required String status,
  }) : judul = Value(judul),
       mataKuliah = Value(mataKuliah),
       tenggat = Value(tenggat),
       status = Value(status);
  static Insertable<TugasItem> custom({
    Expression<int>? id,
    Expression<String>? judul,
    Expression<String>? mataKuliah,
    Expression<String>? tenggat,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (judul != null) 'judul': judul,
      if (mataKuliah != null) 'mata_kuliah': mataKuliah,
      if (tenggat != null) 'tenggat': tenggat,
      if (status != null) 'status': status,
    });
  }

  TugasCompanion copyWith({
    Value<int>? id,
    Value<String>? judul,
    Value<String>? mataKuliah,
    Value<String>? tenggat,
    Value<String>? status,
  }) {
    return TugasCompanion(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      mataKuliah: mataKuliah ?? this.mataKuliah,
      tenggat: tenggat ?? this.tenggat,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (judul.present) {
      map['judul'] = Variable<String>(judul.value);
    }
    if (mataKuliah.present) {
      map['mata_kuliah'] = Variable<String>(mataKuliah.value);
    }
    if (tenggat.present) {
      map['tenggat'] = Variable<String>(tenggat.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TugasCompanion(')
          ..write('id: $id, ')
          ..write('judul: $judul, ')
          ..write('mataKuliah: $mataKuliah, ')
          ..write('tenggat: $tenggat, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TugasTable tugas = $TugasTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [tugas];
}

typedef $$TugasTableCreateCompanionBuilder = TugasCompanion Function({
  Value<int> id,
  required String judul,
  required String mataKuliah,
  required String tenggat,
  required String status,
});
typedef $$TugasTableUpdateCompanionBuilder = TugasCompanion Function({
  Value<int> id,
  Value<String> judul,
  Value<String> mataKuliah,
  Value<String> tenggat,
  Value<String> status,
});

class $$TugasTableFilterComposer extends Composer<_$AppDatabase, $TugasTable> {
  $$TugasTableFilterComposer({
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

  ColumnFilters<String> get judul => $composableBuilder(
    column: $table.judul,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mataKuliah => $composableBuilder(
    column: $table.mataKuliah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tenggat => $composableBuilder(
    column: $table.tenggat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TugasTableOrderingComposer
    extends Composer<_$AppDatabase, $TugasTable> {
  $$TugasTableOrderingComposer({
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

  ColumnOrderings<String> get judul => $composableBuilder(
    column: $table.judul,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mataKuliah => $composableBuilder(
    column: $table.mataKuliah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tenggat => $composableBuilder(
    column: $table.tenggat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TugasTableAnnotationComposer
    extends Composer<_$AppDatabase, $TugasTable> {
  $$TugasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get judul =>
      $composableBuilder(column: $table.judul, builder: (column) => column);

  GeneratedColumn<String> get mataKuliah => $composableBuilder(
    column: $table.mataKuliah,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tenggat =>
      $composableBuilder(column: $table.tenggat, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$TugasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TugasTable,
          TugasItem,
          $$TugasTableFilterComposer,
          $$TugasTableOrderingComposer,
          $$TugasTableAnnotationComposer,
          $$TugasTableCreateCompanionBuilder,
          $$TugasTableUpdateCompanionBuilder,
          (TugasItem, BaseReferences<_$AppDatabase, $TugasTable, TugasItem>),
          TugasItem,
          PrefetchHooks Function()
        > {
  $$TugasTableTableManager(_$AppDatabase db, $TugasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TugasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TugasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TugasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> judul = const Value.absent(),
                Value<String> mataKuliah = const Value.absent(),
                Value<String> tenggat = const Value.absent(),
                Value<String> status = const Value.absent(),
              }) => TugasCompanion(
                id: id,
                judul: judul,
                mataKuliah: mataKuliah,
                tenggat: tenggat,
                status: status,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String judul,
                required String mataKuliah,
                required String tenggat,
                required String status,
              }) => TugasCompanion.insert(
                id: id,
                judul: judul,
                mataKuliah: mataKuliah,
                tenggat: tenggat,
                status: status,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TugasTable, TugasItem>(table),
                  BaseReferences<_$AppDatabase, $TugasTable, TugasItem>(
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

typedef $$TugasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TugasTable,
      TugasItem,
      $$TugasTableFilterComposer,
      $$TugasTableOrderingComposer,
      $$TugasTableAnnotationComposer,
      $$TugasTableCreateCompanionBuilder,
      $$TugasTableUpdateCompanionBuilder,
      (TugasItem, BaseReferences<_$AppDatabase, $TugasTable, TugasItem>),
      TugasItem,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TugasTableTableManager get tugas =>
      $$TugasTableTableManager(_db, _db.tugas);
}
