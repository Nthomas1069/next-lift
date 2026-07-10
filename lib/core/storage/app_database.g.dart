// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ExerciseTemplatesTable extends ExerciseTemplates
    with TableInfo<$ExerciseTemplatesTable, ExerciseTemplateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExerciseTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _normalizedNameMeta =
      const VerificationMeta('normalizedName');
  @override
  late final GeneratedColumn<String> normalizedName = GeneratedColumn<String>(
      'normalized_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _createdAtUtcMeta =
      const VerificationMeta('createdAtUtc');
  @override
  late final GeneratedColumn<DateTime> createdAtUtc = GeneratedColumn<DateTime>(
      'created_at_utc', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtUtcMeta =
      const VerificationMeta('updatedAtUtc');
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
      'updated_at_utc', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, normalizedName, createdAtUtc, updatedAtUtc];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_templates';
  @override
  VerificationContext validateIntegrity(
      Insertable<ExerciseTemplateRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('normalized_name')) {
      context.handle(
          _normalizedNameMeta,
          normalizedName.isAcceptableOrUnknown(
              data['normalized_name']!, _normalizedNameMeta));
    } else if (isInserting) {
      context.missing(_normalizedNameMeta);
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
          _createdAtUtcMeta,
          createdAtUtc.isAcceptableOrUnknown(
              data['created_at_utc']!, _createdAtUtcMeta));
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
          _updatedAtUtcMeta,
          updatedAtUtc.isAcceptableOrUnknown(
              data['updated_at_utc']!, _updatedAtUtcMeta));
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExerciseTemplateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseTemplateRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      normalizedName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}normalized_name'])!,
      createdAtUtc: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}created_at_utc'])!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}updated_at_utc'])!,
    );
  }

  @override
  $ExerciseTemplatesTable createAlias(String alias) {
    return $ExerciseTemplatesTable(attachedDatabase, alias);
  }
}

class ExerciseTemplateRow extends DataClass
    implements Insertable<ExerciseTemplateRow> {
  final String id;
  final String name;
  final String normalizedName;
  final DateTime createdAtUtc;
  final DateTime updatedAtUtc;
  const ExerciseTemplateRow(
      {required this.id,
      required this.name,
      required this.normalizedName,
      required this.createdAtUtc,
      required this.updatedAtUtc});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['normalized_name'] = Variable<String>(normalizedName);
    map['created_at_utc'] = Variable<DateTime>(createdAtUtc);
    map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    return map;
  }

  ExerciseTemplatesCompanion toCompanion(bool nullToAbsent) {
    return ExerciseTemplatesCompanion(
      id: Value(id),
      name: Value(name),
      normalizedName: Value(normalizedName),
      createdAtUtc: Value(createdAtUtc),
      updatedAtUtc: Value(updatedAtUtc),
    );
  }

  factory ExerciseTemplateRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseTemplateRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      normalizedName: serializer.fromJson<String>(json['normalizedName']),
      createdAtUtc: serializer.fromJson<DateTime>(json['createdAtUtc']),
      updatedAtUtc: serializer.fromJson<DateTime>(json['updatedAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'normalizedName': serializer.toJson<String>(normalizedName),
      'createdAtUtc': serializer.toJson<DateTime>(createdAtUtc),
      'updatedAtUtc': serializer.toJson<DateTime>(updatedAtUtc),
    };
  }

  ExerciseTemplateRow copyWith(
          {String? id,
          String? name,
          String? normalizedName,
          DateTime? createdAtUtc,
          DateTime? updatedAtUtc}) =>
      ExerciseTemplateRow(
        id: id ?? this.id,
        name: name ?? this.name,
        normalizedName: normalizedName ?? this.normalizedName,
        createdAtUtc: createdAtUtc ?? this.createdAtUtc,
        updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      );
  ExerciseTemplateRow copyWithCompanion(ExerciseTemplatesCompanion data) {
    return ExerciseTemplateRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      normalizedName: data.normalizedName.present
          ? data.normalizedName.value
          : this.normalizedName,
      createdAtUtc: data.createdAtUtc.present
          ? data.createdAtUtc.value
          : this.createdAtUtc,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseTemplateRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('normalizedName: $normalizedName, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, normalizedName, createdAtUtc, updatedAtUtc);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseTemplateRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.normalizedName == this.normalizedName &&
          other.createdAtUtc == this.createdAtUtc &&
          other.updatedAtUtc == this.updatedAtUtc);
}

class ExerciseTemplatesCompanion extends UpdateCompanion<ExerciseTemplateRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> normalizedName;
  final Value<DateTime> createdAtUtc;
  final Value<DateTime> updatedAtUtc;
  final Value<int> rowid;
  const ExerciseTemplatesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.normalizedName = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExerciseTemplatesCompanion.insert({
    required String id,
    required String name,
    required String normalizedName,
    required DateTime createdAtUtc,
    required DateTime updatedAtUtc,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        normalizedName = Value(normalizedName),
        createdAtUtc = Value(createdAtUtc),
        updatedAtUtc = Value(updatedAtUtc);
  static Insertable<ExerciseTemplateRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? normalizedName,
    Expression<DateTime>? createdAtUtc,
    Expression<DateTime>? updatedAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (normalizedName != null) 'normalized_name': normalizedName,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExerciseTemplatesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? normalizedName,
      Value<DateTime>? createdAtUtc,
      Value<DateTime>? updatedAtUtc,
      Value<int>? rowid}) {
    return ExerciseTemplatesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      normalizedName: normalizedName ?? this.normalizedName,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (normalizedName.present) {
      map['normalized_name'] = Variable<String>(normalizedName.value);
    }
    if (createdAtUtc.present) {
      map['created_at_utc'] = Variable<DateTime>(createdAtUtc.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('normalizedName: $normalizedName, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExerciseMetricConfigsTable extends ExerciseMetricConfigs
    with TableInfo<$ExerciseMetricConfigsTable, ExerciseMetricConfigRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExerciseMetricConfigsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _exerciseTemplateIdMeta =
      const VerificationMeta('exerciseTemplateId');
  @override
  late final GeneratedColumn<String> exerciseTemplateId =
      GeneratedColumn<String>('exercise_template_id', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'REFERENCES exercise_templates (id) ON DELETE CASCADE'));
  static const VerificationMeta _metricKeyMeta =
      const VerificationMeta('metricKey');
  @override
  late final GeneratedColumn<String> metricKey = GeneratedColumn<String>(
      'metric_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _orderIndexMeta =
      const VerificationMeta('orderIndex');
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
      'order_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [exerciseTemplateId, metricKey, orderIndex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_metric_configs';
  @override
  VerificationContext validateIntegrity(
      Insertable<ExerciseMetricConfigRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('exercise_template_id')) {
      context.handle(
          _exerciseTemplateIdMeta,
          exerciseTemplateId.isAcceptableOrUnknown(
              data['exercise_template_id']!, _exerciseTemplateIdMeta));
    } else if (isInserting) {
      context.missing(_exerciseTemplateIdMeta);
    }
    if (data.containsKey('metric_key')) {
      context.handle(_metricKeyMeta,
          metricKey.isAcceptableOrUnknown(data['metric_key']!, _metricKeyMeta));
    } else if (isInserting) {
      context.missing(_metricKeyMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
          _orderIndexMeta,
          orderIndex.isAcceptableOrUnknown(
              data['order_index']!, _orderIndexMeta));
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {exerciseTemplateId, metricKey};
  @override
  ExerciseMetricConfigRow map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseMetricConfigRow(
      exerciseTemplateId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}exercise_template_id'])!,
      metricKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metric_key'])!,
      orderIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_index'])!,
    );
  }

  @override
  $ExerciseMetricConfigsTable createAlias(String alias) {
    return $ExerciseMetricConfigsTable(attachedDatabase, alias);
  }
}

class ExerciseMetricConfigRow extends DataClass
    implements Insertable<ExerciseMetricConfigRow> {
  final String exerciseTemplateId;
  final String metricKey;
  final int orderIndex;
  const ExerciseMetricConfigRow(
      {required this.exerciseTemplateId,
      required this.metricKey,
      required this.orderIndex});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['exercise_template_id'] = Variable<String>(exerciseTemplateId);
    map['metric_key'] = Variable<String>(metricKey);
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  ExerciseMetricConfigsCompanion toCompanion(bool nullToAbsent) {
    return ExerciseMetricConfigsCompanion(
      exerciseTemplateId: Value(exerciseTemplateId),
      metricKey: Value(metricKey),
      orderIndex: Value(orderIndex),
    );
  }

  factory ExerciseMetricConfigRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseMetricConfigRow(
      exerciseTemplateId:
          serializer.fromJson<String>(json['exerciseTemplateId']),
      metricKey: serializer.fromJson<String>(json['metricKey']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'exerciseTemplateId': serializer.toJson<String>(exerciseTemplateId),
      'metricKey': serializer.toJson<String>(metricKey),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  ExerciseMetricConfigRow copyWith(
          {String? exerciseTemplateId, String? metricKey, int? orderIndex}) =>
      ExerciseMetricConfigRow(
        exerciseTemplateId: exerciseTemplateId ?? this.exerciseTemplateId,
        metricKey: metricKey ?? this.metricKey,
        orderIndex: orderIndex ?? this.orderIndex,
      );
  ExerciseMetricConfigRow copyWithCompanion(
      ExerciseMetricConfigsCompanion data) {
    return ExerciseMetricConfigRow(
      exerciseTemplateId: data.exerciseTemplateId.present
          ? data.exerciseTemplateId.value
          : this.exerciseTemplateId,
      metricKey: data.metricKey.present ? data.metricKey.value : this.metricKey,
      orderIndex:
          data.orderIndex.present ? data.orderIndex.value : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseMetricConfigRow(')
          ..write('exerciseTemplateId: $exerciseTemplateId, ')
          ..write('metricKey: $metricKey, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(exerciseTemplateId, metricKey, orderIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseMetricConfigRow &&
          other.exerciseTemplateId == this.exerciseTemplateId &&
          other.metricKey == this.metricKey &&
          other.orderIndex == this.orderIndex);
}

class ExerciseMetricConfigsCompanion
    extends UpdateCompanion<ExerciseMetricConfigRow> {
  final Value<String> exerciseTemplateId;
  final Value<String> metricKey;
  final Value<int> orderIndex;
  final Value<int> rowid;
  const ExerciseMetricConfigsCompanion({
    this.exerciseTemplateId = const Value.absent(),
    this.metricKey = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExerciseMetricConfigsCompanion.insert({
    required String exerciseTemplateId,
    required String metricKey,
    required int orderIndex,
    this.rowid = const Value.absent(),
  })  : exerciseTemplateId = Value(exerciseTemplateId),
        metricKey = Value(metricKey),
        orderIndex = Value(orderIndex);
  static Insertable<ExerciseMetricConfigRow> custom({
    Expression<String>? exerciseTemplateId,
    Expression<String>? metricKey,
    Expression<int>? orderIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (exerciseTemplateId != null)
        'exercise_template_id': exerciseTemplateId,
      if (metricKey != null) 'metric_key': metricKey,
      if (orderIndex != null) 'order_index': orderIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExerciseMetricConfigsCompanion copyWith(
      {Value<String>? exerciseTemplateId,
      Value<String>? metricKey,
      Value<int>? orderIndex,
      Value<int>? rowid}) {
    return ExerciseMetricConfigsCompanion(
      exerciseTemplateId: exerciseTemplateId ?? this.exerciseTemplateId,
      metricKey: metricKey ?? this.metricKey,
      orderIndex: orderIndex ?? this.orderIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (exerciseTemplateId.present) {
      map['exercise_template_id'] = Variable<String>(exerciseTemplateId.value);
    }
    if (metricKey.present) {
      map['metric_key'] = Variable<String>(metricKey.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseMetricConfigsCompanion(')
          ..write('exerciseTemplateId: $exerciseTemplateId, ')
          ..write('metricKey: $metricKey, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutTemplatesTable extends WorkoutTemplates
    with TableInfo<$WorkoutTemplatesTable, WorkoutTemplateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _normalizedNameMeta =
      const VerificationMeta('normalizedName');
  @override
  late final GeneratedColumn<String> normalizedName = GeneratedColumn<String>(
      'normalized_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _createdAtUtcMeta =
      const VerificationMeta('createdAtUtc');
  @override
  late final GeneratedColumn<DateTime> createdAtUtc = GeneratedColumn<DateTime>(
      'created_at_utc', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtUtcMeta =
      const VerificationMeta('updatedAtUtc');
  @override
  late final GeneratedColumn<DateTime> updatedAtUtc = GeneratedColumn<DateTime>(
      'updated_at_utc', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _layoutVersionMeta =
      const VerificationMeta('layoutVersion');
  @override
  late final GeneratedColumn<int> layoutVersion = GeneratedColumn<int>(
      'layout_version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        normalizedName,
        createdAtUtc,
        updatedAtUtc,
        version,
        layoutVersion
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_templates';
  @override
  VerificationContext validateIntegrity(Insertable<WorkoutTemplateRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('normalized_name')) {
      context.handle(
          _normalizedNameMeta,
          normalizedName.isAcceptableOrUnknown(
              data['normalized_name']!, _normalizedNameMeta));
    } else if (isInserting) {
      context.missing(_normalizedNameMeta);
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
          _createdAtUtcMeta,
          createdAtUtc.isAcceptableOrUnknown(
              data['created_at_utc']!, _createdAtUtcMeta));
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
          _updatedAtUtcMeta,
          updatedAtUtc.isAcceptableOrUnknown(
              data['updated_at_utc']!, _updatedAtUtcMeta));
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    if (data.containsKey('layout_version')) {
      context.handle(
          _layoutVersionMeta,
          layoutVersion.isAcceptableOrUnknown(
              data['layout_version']!, _layoutVersionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutTemplateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutTemplateRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      normalizedName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}normalized_name'])!,
      createdAtUtc: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}created_at_utc'])!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}updated_at_utc'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
      layoutVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}layout_version'])!,
    );
  }

  @override
  $WorkoutTemplatesTable createAlias(String alias) {
    return $WorkoutTemplatesTable(attachedDatabase, alias);
  }
}

class WorkoutTemplateRow extends DataClass
    implements Insertable<WorkoutTemplateRow> {
  final String id;
  final String name;
  final String normalizedName;
  final DateTime createdAtUtc;
  final DateTime updatedAtUtc;
  final int version;
  final int layoutVersion;
  const WorkoutTemplateRow(
      {required this.id,
      required this.name,
      required this.normalizedName,
      required this.createdAtUtc,
      required this.updatedAtUtc,
      required this.version,
      required this.layoutVersion});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['normalized_name'] = Variable<String>(normalizedName);
    map['created_at_utc'] = Variable<DateTime>(createdAtUtc);
    map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc);
    map['version'] = Variable<int>(version);
    map['layout_version'] = Variable<int>(layoutVersion);
    return map;
  }

  WorkoutTemplatesCompanion toCompanion(bool nullToAbsent) {
    return WorkoutTemplatesCompanion(
      id: Value(id),
      name: Value(name),
      normalizedName: Value(normalizedName),
      createdAtUtc: Value(createdAtUtc),
      updatedAtUtc: Value(updatedAtUtc),
      version: Value(version),
      layoutVersion: Value(layoutVersion),
    );
  }

  factory WorkoutTemplateRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutTemplateRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      normalizedName: serializer.fromJson<String>(json['normalizedName']),
      createdAtUtc: serializer.fromJson<DateTime>(json['createdAtUtc']),
      updatedAtUtc: serializer.fromJson<DateTime>(json['updatedAtUtc']),
      version: serializer.fromJson<int>(json['version']),
      layoutVersion: serializer.fromJson<int>(json['layoutVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'normalizedName': serializer.toJson<String>(normalizedName),
      'createdAtUtc': serializer.toJson<DateTime>(createdAtUtc),
      'updatedAtUtc': serializer.toJson<DateTime>(updatedAtUtc),
      'version': serializer.toJson<int>(version),
      'layoutVersion': serializer.toJson<int>(layoutVersion),
    };
  }

  WorkoutTemplateRow copyWith(
          {String? id,
          String? name,
          String? normalizedName,
          DateTime? createdAtUtc,
          DateTime? updatedAtUtc,
          int? version,
          int? layoutVersion}) =>
      WorkoutTemplateRow(
        id: id ?? this.id,
        name: name ?? this.name,
        normalizedName: normalizedName ?? this.normalizedName,
        createdAtUtc: createdAtUtc ?? this.createdAtUtc,
        updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
        version: version ?? this.version,
        layoutVersion: layoutVersion ?? this.layoutVersion,
      );
  WorkoutTemplateRow copyWithCompanion(WorkoutTemplatesCompanion data) {
    return WorkoutTemplateRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      normalizedName: data.normalizedName.present
          ? data.normalizedName.value
          : this.normalizedName,
      createdAtUtc: data.createdAtUtc.present
          ? data.createdAtUtc.value
          : this.createdAtUtc,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
      version: data.version.present ? data.version.value : this.version,
      layoutVersion: data.layoutVersion.present
          ? data.layoutVersion.value
          : this.layoutVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutTemplateRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('normalizedName: $normalizedName, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('version: $version, ')
          ..write('layoutVersion: $layoutVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, normalizedName, createdAtUtc,
      updatedAtUtc, version, layoutVersion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutTemplateRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.normalizedName == this.normalizedName &&
          other.createdAtUtc == this.createdAtUtc &&
          other.updatedAtUtc == this.updatedAtUtc &&
          other.version == this.version &&
          other.layoutVersion == this.layoutVersion);
}

class WorkoutTemplatesCompanion extends UpdateCompanion<WorkoutTemplateRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> normalizedName;
  final Value<DateTime> createdAtUtc;
  final Value<DateTime> updatedAtUtc;
  final Value<int> version;
  final Value<int> layoutVersion;
  final Value<int> rowid;
  const WorkoutTemplatesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.normalizedName = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.version = const Value.absent(),
    this.layoutVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutTemplatesCompanion.insert({
    required String id,
    required String name,
    required String normalizedName,
    required DateTime createdAtUtc,
    required DateTime updatedAtUtc,
    this.version = const Value.absent(),
    this.layoutVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        normalizedName = Value(normalizedName),
        createdAtUtc = Value(createdAtUtc),
        updatedAtUtc = Value(updatedAtUtc);
  static Insertable<WorkoutTemplateRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? normalizedName,
    Expression<DateTime>? createdAtUtc,
    Expression<DateTime>? updatedAtUtc,
    Expression<int>? version,
    Expression<int>? layoutVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (normalizedName != null) 'normalized_name': normalizedName,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (version != null) 'version': version,
      if (layoutVersion != null) 'layout_version': layoutVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutTemplatesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? normalizedName,
      Value<DateTime>? createdAtUtc,
      Value<DateTime>? updatedAtUtc,
      Value<int>? version,
      Value<int>? layoutVersion,
      Value<int>? rowid}) {
    return WorkoutTemplatesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      normalizedName: normalizedName ?? this.normalizedName,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      version: version ?? this.version,
      layoutVersion: layoutVersion ?? this.layoutVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (normalizedName.present) {
      map['normalized_name'] = Variable<String>(normalizedName.value);
    }
    if (createdAtUtc.present) {
      map['created_at_utc'] = Variable<DateTime>(createdAtUtc.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<DateTime>(updatedAtUtc.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (layoutVersion.present) {
      map['layout_version'] = Variable<int>(layoutVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('normalizedName: $normalizedName, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('version: $version, ')
          ..write('layoutVersion: $layoutVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutShapeNodesTable extends WorkoutShapeNodes
    with TableInfo<$WorkoutShapeNodesTable, WorkoutShapeNodeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutShapeNodesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _shapeIdMeta =
      const VerificationMeta('shapeId');
  @override
  late final GeneratedColumn<String> shapeId = GeneratedColumn<String>(
      'shape_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _templateIdMeta =
      const VerificationMeta('templateId');
  @override
  late final GeneratedColumn<String> templateId = GeneratedColumn<String>(
      'template_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES workout_templates (id) ON DELETE CASCADE'));
  static const VerificationMeta _parentShapeIdMeta =
      const VerificationMeta('parentShapeId');
  @override
  late final GeneratedColumn<String> parentShapeId = GeneratedColumn<String>(
      'parent_shape_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _shapeTypeMeta =
      const VerificationMeta('shapeType');
  @override
  late final GeneratedColumn<String> shapeType = GeneratedColumn<String>(
      'shape_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _orderIndexMeta =
      const VerificationMeta('orderIndex');
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
      'order_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [shapeId, templateId, parentShapeId, shapeType, orderIndex, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_shape_nodes';
  @override
  VerificationContext validateIntegrity(
      Insertable<WorkoutShapeNodeRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('shape_id')) {
      context.handle(_shapeIdMeta,
          shapeId.isAcceptableOrUnknown(data['shape_id']!, _shapeIdMeta));
    } else if (isInserting) {
      context.missing(_shapeIdMeta);
    }
    if (data.containsKey('template_id')) {
      context.handle(
          _templateIdMeta,
          templateId.isAcceptableOrUnknown(
              data['template_id']!, _templateIdMeta));
    } else if (isInserting) {
      context.missing(_templateIdMeta);
    }
    if (data.containsKey('parent_shape_id')) {
      context.handle(
          _parentShapeIdMeta,
          parentShapeId.isAcceptableOrUnknown(
              data['parent_shape_id']!, _parentShapeIdMeta));
    }
    if (data.containsKey('shape_type')) {
      context.handle(_shapeTypeMeta,
          shapeType.isAcceptableOrUnknown(data['shape_type']!, _shapeTypeMeta));
    } else if (isInserting) {
      context.missing(_shapeTypeMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
          _orderIndexMeta,
          orderIndex.isAcceptableOrUnknown(
              data['order_index']!, _orderIndexMeta));
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {shapeId};
  @override
  WorkoutShapeNodeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutShapeNodeRow(
      shapeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shape_id'])!,
      templateId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}template_id'])!,
      parentShapeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent_shape_id']),
      shapeType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shape_type'])!,
      orderIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_index'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
    );
  }

  @override
  $WorkoutShapeNodesTable createAlias(String alias) {
    return $WorkoutShapeNodesTable(attachedDatabase, alias);
  }
}

class WorkoutShapeNodeRow extends DataClass
    implements Insertable<WorkoutShapeNodeRow> {
  final String shapeId;
  final String templateId;
  final String? parentShapeId;
  final String shapeType;
  final int orderIndex;
  final String? note;
  const WorkoutShapeNodeRow(
      {required this.shapeId,
      required this.templateId,
      this.parentShapeId,
      required this.shapeType,
      required this.orderIndex,
      this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['shape_id'] = Variable<String>(shapeId);
    map['template_id'] = Variable<String>(templateId);
    if (!nullToAbsent || parentShapeId != null) {
      map['parent_shape_id'] = Variable<String>(parentShapeId);
    }
    map['shape_type'] = Variable<String>(shapeType);
    map['order_index'] = Variable<int>(orderIndex);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  WorkoutShapeNodesCompanion toCompanion(bool nullToAbsent) {
    return WorkoutShapeNodesCompanion(
      shapeId: Value(shapeId),
      templateId: Value(templateId),
      parentShapeId: parentShapeId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentShapeId),
      shapeType: Value(shapeType),
      orderIndex: Value(orderIndex),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory WorkoutShapeNodeRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutShapeNodeRow(
      shapeId: serializer.fromJson<String>(json['shapeId']),
      templateId: serializer.fromJson<String>(json['templateId']),
      parentShapeId: serializer.fromJson<String?>(json['parentShapeId']),
      shapeType: serializer.fromJson<String>(json['shapeType']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'shapeId': serializer.toJson<String>(shapeId),
      'templateId': serializer.toJson<String>(templateId),
      'parentShapeId': serializer.toJson<String?>(parentShapeId),
      'shapeType': serializer.toJson<String>(shapeType),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'note': serializer.toJson<String?>(note),
    };
  }

  WorkoutShapeNodeRow copyWith(
          {String? shapeId,
          String? templateId,
          Value<String?> parentShapeId = const Value.absent(),
          String? shapeType,
          int? orderIndex,
          Value<String?> note = const Value.absent()}) =>
      WorkoutShapeNodeRow(
        shapeId: shapeId ?? this.shapeId,
        templateId: templateId ?? this.templateId,
        parentShapeId:
            parentShapeId.present ? parentShapeId.value : this.parentShapeId,
        shapeType: shapeType ?? this.shapeType,
        orderIndex: orderIndex ?? this.orderIndex,
        note: note.present ? note.value : this.note,
      );
  WorkoutShapeNodeRow copyWithCompanion(WorkoutShapeNodesCompanion data) {
    return WorkoutShapeNodeRow(
      shapeId: data.shapeId.present ? data.shapeId.value : this.shapeId,
      templateId:
          data.templateId.present ? data.templateId.value : this.templateId,
      parentShapeId: data.parentShapeId.present
          ? data.parentShapeId.value
          : this.parentShapeId,
      shapeType: data.shapeType.present ? data.shapeType.value : this.shapeType,
      orderIndex:
          data.orderIndex.present ? data.orderIndex.value : this.orderIndex,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutShapeNodeRow(')
          ..write('shapeId: $shapeId, ')
          ..write('templateId: $templateId, ')
          ..write('parentShapeId: $parentShapeId, ')
          ..write('shapeType: $shapeType, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      shapeId, templateId, parentShapeId, shapeType, orderIndex, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutShapeNodeRow &&
          other.shapeId == this.shapeId &&
          other.templateId == this.templateId &&
          other.parentShapeId == this.parentShapeId &&
          other.shapeType == this.shapeType &&
          other.orderIndex == this.orderIndex &&
          other.note == this.note);
}

class WorkoutShapeNodesCompanion extends UpdateCompanion<WorkoutShapeNodeRow> {
  final Value<String> shapeId;
  final Value<String> templateId;
  final Value<String?> parentShapeId;
  final Value<String> shapeType;
  final Value<int> orderIndex;
  final Value<String?> note;
  final Value<int> rowid;
  const WorkoutShapeNodesCompanion({
    this.shapeId = const Value.absent(),
    this.templateId = const Value.absent(),
    this.parentShapeId = const Value.absent(),
    this.shapeType = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutShapeNodesCompanion.insert({
    required String shapeId,
    required String templateId,
    this.parentShapeId = const Value.absent(),
    required String shapeType,
    required int orderIndex,
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : shapeId = Value(shapeId),
        templateId = Value(templateId),
        shapeType = Value(shapeType),
        orderIndex = Value(orderIndex);
  static Insertable<WorkoutShapeNodeRow> custom({
    Expression<String>? shapeId,
    Expression<String>? templateId,
    Expression<String>? parentShapeId,
    Expression<String>? shapeType,
    Expression<int>? orderIndex,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (shapeId != null) 'shape_id': shapeId,
      if (templateId != null) 'template_id': templateId,
      if (parentShapeId != null) 'parent_shape_id': parentShapeId,
      if (shapeType != null) 'shape_type': shapeType,
      if (orderIndex != null) 'order_index': orderIndex,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutShapeNodesCompanion copyWith(
      {Value<String>? shapeId,
      Value<String>? templateId,
      Value<String?>? parentShapeId,
      Value<String>? shapeType,
      Value<int>? orderIndex,
      Value<String?>? note,
      Value<int>? rowid}) {
    return WorkoutShapeNodesCompanion(
      shapeId: shapeId ?? this.shapeId,
      templateId: templateId ?? this.templateId,
      parentShapeId: parentShapeId ?? this.parentShapeId,
      shapeType: shapeType ?? this.shapeType,
      orderIndex: orderIndex ?? this.orderIndex,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (shapeId.present) {
      map['shape_id'] = Variable<String>(shapeId.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<String>(templateId.value);
    }
    if (parentShapeId.present) {
      map['parent_shape_id'] = Variable<String>(parentShapeId.value);
    }
    if (shapeType.present) {
      map['shape_type'] = Variable<String>(shapeType.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutShapeNodesCompanion(')
          ..write('shapeId: $shapeId, ')
          ..write('templateId: $templateId, ')
          ..write('parentShapeId: $parentShapeId, ')
          ..write('shapeType: $shapeType, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutExerciseSlotsTable extends WorkoutExerciseSlots
    with TableInfo<$WorkoutExerciseSlotsTable, WorkoutExerciseSlotRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutExerciseSlotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _slotIdMeta = const VerificationMeta('slotId');
  @override
  late final GeneratedColumn<String> slotId = GeneratedColumn<String>(
      'slot_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _shapeIdMeta =
      const VerificationMeta('shapeId');
  @override
  late final GeneratedColumn<String> shapeId = GeneratedColumn<String>(
      'shape_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES workout_shape_nodes (shape_id)'));
  static const VerificationMeta _exerciseTemplateIdMeta =
      const VerificationMeta('exerciseTemplateId');
  @override
  late final GeneratedColumn<String> exerciseTemplateId =
      GeneratedColumn<String>('exercise_template_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _displayLabelMeta =
      const VerificationMeta('displayLabel');
  @override
  late final GeneratedColumn<String> displayLabel = GeneratedColumn<String>(
      'display_label', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _orderIndexMeta =
      const VerificationMeta('orderIndex');
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
      'order_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [slotId, shapeId, exerciseTemplateId, displayLabel, orderIndex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_exercise_slots';
  @override
  VerificationContext validateIntegrity(
      Insertable<WorkoutExerciseSlotRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('slot_id')) {
      context.handle(_slotIdMeta,
          slotId.isAcceptableOrUnknown(data['slot_id']!, _slotIdMeta));
    } else if (isInserting) {
      context.missing(_slotIdMeta);
    }
    if (data.containsKey('shape_id')) {
      context.handle(_shapeIdMeta,
          shapeId.isAcceptableOrUnknown(data['shape_id']!, _shapeIdMeta));
    } else if (isInserting) {
      context.missing(_shapeIdMeta);
    }
    if (data.containsKey('exercise_template_id')) {
      context.handle(
          _exerciseTemplateIdMeta,
          exerciseTemplateId.isAcceptableOrUnknown(
              data['exercise_template_id']!, _exerciseTemplateIdMeta));
    }
    if (data.containsKey('display_label')) {
      context.handle(
          _displayLabelMeta,
          displayLabel.isAcceptableOrUnknown(
              data['display_label']!, _displayLabelMeta));
    }
    if (data.containsKey('order_index')) {
      context.handle(
          _orderIndexMeta,
          orderIndex.isAcceptableOrUnknown(
              data['order_index']!, _orderIndexMeta));
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {slotId};
  @override
  WorkoutExerciseSlotRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutExerciseSlotRow(
      slotId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}slot_id'])!,
      shapeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shape_id'])!,
      exerciseTemplateId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}exercise_template_id']),
      displayLabel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_label']),
      orderIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_index'])!,
    );
  }

  @override
  $WorkoutExerciseSlotsTable createAlias(String alias) {
    return $WorkoutExerciseSlotsTable(attachedDatabase, alias);
  }
}

class WorkoutExerciseSlotRow extends DataClass
    implements Insertable<WorkoutExerciseSlotRow> {
  final String slotId;
  final String shapeId;
  final String? exerciseTemplateId;
  final String? displayLabel;
  final int orderIndex;
  const WorkoutExerciseSlotRow(
      {required this.slotId,
      required this.shapeId,
      this.exerciseTemplateId,
      this.displayLabel,
      required this.orderIndex});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['slot_id'] = Variable<String>(slotId);
    map['shape_id'] = Variable<String>(shapeId);
    if (!nullToAbsent || exerciseTemplateId != null) {
      map['exercise_template_id'] = Variable<String>(exerciseTemplateId);
    }
    if (!nullToAbsent || displayLabel != null) {
      map['display_label'] = Variable<String>(displayLabel);
    }
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  WorkoutExerciseSlotsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutExerciseSlotsCompanion(
      slotId: Value(slotId),
      shapeId: Value(shapeId),
      exerciseTemplateId: exerciseTemplateId == null && nullToAbsent
          ? const Value.absent()
          : Value(exerciseTemplateId),
      displayLabel: displayLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(displayLabel),
      orderIndex: Value(orderIndex),
    );
  }

  factory WorkoutExerciseSlotRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutExerciseSlotRow(
      slotId: serializer.fromJson<String>(json['slotId']),
      shapeId: serializer.fromJson<String>(json['shapeId']),
      exerciseTemplateId:
          serializer.fromJson<String?>(json['exerciseTemplateId']),
      displayLabel: serializer.fromJson<String?>(json['displayLabel']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'slotId': serializer.toJson<String>(slotId),
      'shapeId': serializer.toJson<String>(shapeId),
      'exerciseTemplateId': serializer.toJson<String?>(exerciseTemplateId),
      'displayLabel': serializer.toJson<String?>(displayLabel),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  WorkoutExerciseSlotRow copyWith(
          {String? slotId,
          String? shapeId,
          Value<String?> exerciseTemplateId = const Value.absent(),
          Value<String?> displayLabel = const Value.absent(),
          int? orderIndex}) =>
      WorkoutExerciseSlotRow(
        slotId: slotId ?? this.slotId,
        shapeId: shapeId ?? this.shapeId,
        exerciseTemplateId: exerciseTemplateId.present
            ? exerciseTemplateId.value
            : this.exerciseTemplateId,
        displayLabel:
            displayLabel.present ? displayLabel.value : this.displayLabel,
        orderIndex: orderIndex ?? this.orderIndex,
      );
  WorkoutExerciseSlotRow copyWithCompanion(WorkoutExerciseSlotsCompanion data) {
    return WorkoutExerciseSlotRow(
      slotId: data.slotId.present ? data.slotId.value : this.slotId,
      shapeId: data.shapeId.present ? data.shapeId.value : this.shapeId,
      exerciseTemplateId: data.exerciseTemplateId.present
          ? data.exerciseTemplateId.value
          : this.exerciseTemplateId,
      displayLabel: data.displayLabel.present
          ? data.displayLabel.value
          : this.displayLabel,
      orderIndex:
          data.orderIndex.present ? data.orderIndex.value : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutExerciseSlotRow(')
          ..write('slotId: $slotId, ')
          ..write('shapeId: $shapeId, ')
          ..write('exerciseTemplateId: $exerciseTemplateId, ')
          ..write('displayLabel: $displayLabel, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      slotId, shapeId, exerciseTemplateId, displayLabel, orderIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutExerciseSlotRow &&
          other.slotId == this.slotId &&
          other.shapeId == this.shapeId &&
          other.exerciseTemplateId == this.exerciseTemplateId &&
          other.displayLabel == this.displayLabel &&
          other.orderIndex == this.orderIndex);
}

class WorkoutExerciseSlotsCompanion
    extends UpdateCompanion<WorkoutExerciseSlotRow> {
  final Value<String> slotId;
  final Value<String> shapeId;
  final Value<String?> exerciseTemplateId;
  final Value<String?> displayLabel;
  final Value<int> orderIndex;
  final Value<int> rowid;
  const WorkoutExerciseSlotsCompanion({
    this.slotId = const Value.absent(),
    this.shapeId = const Value.absent(),
    this.exerciseTemplateId = const Value.absent(),
    this.displayLabel = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutExerciseSlotsCompanion.insert({
    required String slotId,
    required String shapeId,
    this.exerciseTemplateId = const Value.absent(),
    this.displayLabel = const Value.absent(),
    required int orderIndex,
    this.rowid = const Value.absent(),
  })  : slotId = Value(slotId),
        shapeId = Value(shapeId),
        orderIndex = Value(orderIndex);
  static Insertable<WorkoutExerciseSlotRow> custom({
    Expression<String>? slotId,
    Expression<String>? shapeId,
    Expression<String>? exerciseTemplateId,
    Expression<String>? displayLabel,
    Expression<int>? orderIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (slotId != null) 'slot_id': slotId,
      if (shapeId != null) 'shape_id': shapeId,
      if (exerciseTemplateId != null)
        'exercise_template_id': exerciseTemplateId,
      if (displayLabel != null) 'display_label': displayLabel,
      if (orderIndex != null) 'order_index': orderIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutExerciseSlotsCompanion copyWith(
      {Value<String>? slotId,
      Value<String>? shapeId,
      Value<String?>? exerciseTemplateId,
      Value<String?>? displayLabel,
      Value<int>? orderIndex,
      Value<int>? rowid}) {
    return WorkoutExerciseSlotsCompanion(
      slotId: slotId ?? this.slotId,
      shapeId: shapeId ?? this.shapeId,
      exerciseTemplateId: exerciseTemplateId ?? this.exerciseTemplateId,
      displayLabel: displayLabel ?? this.displayLabel,
      orderIndex: orderIndex ?? this.orderIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (slotId.present) {
      map['slot_id'] = Variable<String>(slotId.value);
    }
    if (shapeId.present) {
      map['shape_id'] = Variable<String>(shapeId.value);
    }
    if (exerciseTemplateId.present) {
      map['exercise_template_id'] = Variable<String>(exerciseTemplateId.value);
    }
    if (displayLabel.present) {
      map['display_label'] = Variable<String>(displayLabel.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutExerciseSlotsCompanion(')
          ..write('slotId: $slotId, ')
          ..write('shapeId: $shapeId, ')
          ..write('exerciseTemplateId: $exerciseTemplateId, ')
          ..write('displayLabel: $displayLabel, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutShapeExercisesTable extends WorkoutShapeExercises
    with TableInfo<$WorkoutShapeExercisesTable, WorkoutShapeExerciseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutShapeExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _shapeExerciseIdMeta =
      const VerificationMeta('shapeExerciseId');
  @override
  late final GeneratedColumn<String> shapeExerciseId = GeneratedColumn<String>(
      'shape_exercise_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _shapeIdMeta =
      const VerificationMeta('shapeId');
  @override
  late final GeneratedColumn<String> shapeId = GeneratedColumn<String>(
      'shape_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES workout_shape_nodes (shape_id) ON DELETE CASCADE'));
  static const VerificationMeta _exerciseTemplateIdMeta =
      const VerificationMeta('exerciseTemplateId');
  @override
  late final GeneratedColumn<String> exerciseTemplateId =
      GeneratedColumn<String>('exercise_template_id', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'REFERENCES exercise_templates (id) ON DELETE RESTRICT'));
  static const VerificationMeta _orderIndexMeta =
      const VerificationMeta('orderIndex');
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
      'order_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [shapeExerciseId, shapeId, exerciseTemplateId, orderIndex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_shape_exercises';
  @override
  VerificationContext validateIntegrity(
      Insertable<WorkoutShapeExerciseRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('shape_exercise_id')) {
      context.handle(
          _shapeExerciseIdMeta,
          shapeExerciseId.isAcceptableOrUnknown(
              data['shape_exercise_id']!, _shapeExerciseIdMeta));
    } else if (isInserting) {
      context.missing(_shapeExerciseIdMeta);
    }
    if (data.containsKey('shape_id')) {
      context.handle(_shapeIdMeta,
          shapeId.isAcceptableOrUnknown(data['shape_id']!, _shapeIdMeta));
    } else if (isInserting) {
      context.missing(_shapeIdMeta);
    }
    if (data.containsKey('exercise_template_id')) {
      context.handle(
          _exerciseTemplateIdMeta,
          exerciseTemplateId.isAcceptableOrUnknown(
              data['exercise_template_id']!, _exerciseTemplateIdMeta));
    } else if (isInserting) {
      context.missing(_exerciseTemplateIdMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
          _orderIndexMeta,
          orderIndex.isAcceptableOrUnknown(
              data['order_index']!, _orderIndexMeta));
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {shapeExerciseId};
  @override
  WorkoutShapeExerciseRow map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutShapeExerciseRow(
      shapeExerciseId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}shape_exercise_id'])!,
      shapeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shape_id'])!,
      exerciseTemplateId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}exercise_template_id'])!,
      orderIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_index'])!,
    );
  }

  @override
  $WorkoutShapeExercisesTable createAlias(String alias) {
    return $WorkoutShapeExercisesTable(attachedDatabase, alias);
  }
}

class WorkoutShapeExerciseRow extends DataClass
    implements Insertable<WorkoutShapeExerciseRow> {
  final String shapeExerciseId;
  final String shapeId;
  final String exerciseTemplateId;
  final int orderIndex;
  const WorkoutShapeExerciseRow(
      {required this.shapeExerciseId,
      required this.shapeId,
      required this.exerciseTemplateId,
      required this.orderIndex});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['shape_exercise_id'] = Variable<String>(shapeExerciseId);
    map['shape_id'] = Variable<String>(shapeId);
    map['exercise_template_id'] = Variable<String>(exerciseTemplateId);
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  WorkoutShapeExercisesCompanion toCompanion(bool nullToAbsent) {
    return WorkoutShapeExercisesCompanion(
      shapeExerciseId: Value(shapeExerciseId),
      shapeId: Value(shapeId),
      exerciseTemplateId: Value(exerciseTemplateId),
      orderIndex: Value(orderIndex),
    );
  }

  factory WorkoutShapeExerciseRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutShapeExerciseRow(
      shapeExerciseId: serializer.fromJson<String>(json['shapeExerciseId']),
      shapeId: serializer.fromJson<String>(json['shapeId']),
      exerciseTemplateId:
          serializer.fromJson<String>(json['exerciseTemplateId']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'shapeExerciseId': serializer.toJson<String>(shapeExerciseId),
      'shapeId': serializer.toJson<String>(shapeId),
      'exerciseTemplateId': serializer.toJson<String>(exerciseTemplateId),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  WorkoutShapeExerciseRow copyWith(
          {String? shapeExerciseId,
          String? shapeId,
          String? exerciseTemplateId,
          int? orderIndex}) =>
      WorkoutShapeExerciseRow(
        shapeExerciseId: shapeExerciseId ?? this.shapeExerciseId,
        shapeId: shapeId ?? this.shapeId,
        exerciseTemplateId: exerciseTemplateId ?? this.exerciseTemplateId,
        orderIndex: orderIndex ?? this.orderIndex,
      );
  WorkoutShapeExerciseRow copyWithCompanion(
      WorkoutShapeExercisesCompanion data) {
    return WorkoutShapeExerciseRow(
      shapeExerciseId: data.shapeExerciseId.present
          ? data.shapeExerciseId.value
          : this.shapeExerciseId,
      shapeId: data.shapeId.present ? data.shapeId.value : this.shapeId,
      exerciseTemplateId: data.exerciseTemplateId.present
          ? data.exerciseTemplateId.value
          : this.exerciseTemplateId,
      orderIndex:
          data.orderIndex.present ? data.orderIndex.value : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutShapeExerciseRow(')
          ..write('shapeExerciseId: $shapeExerciseId, ')
          ..write('shapeId: $shapeId, ')
          ..write('exerciseTemplateId: $exerciseTemplateId, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(shapeExerciseId, shapeId, exerciseTemplateId, orderIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutShapeExerciseRow &&
          other.shapeExerciseId == this.shapeExerciseId &&
          other.shapeId == this.shapeId &&
          other.exerciseTemplateId == this.exerciseTemplateId &&
          other.orderIndex == this.orderIndex);
}

class WorkoutShapeExercisesCompanion
    extends UpdateCompanion<WorkoutShapeExerciseRow> {
  final Value<String> shapeExerciseId;
  final Value<String> shapeId;
  final Value<String> exerciseTemplateId;
  final Value<int> orderIndex;
  final Value<int> rowid;
  const WorkoutShapeExercisesCompanion({
    this.shapeExerciseId = const Value.absent(),
    this.shapeId = const Value.absent(),
    this.exerciseTemplateId = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutShapeExercisesCompanion.insert({
    required String shapeExerciseId,
    required String shapeId,
    required String exerciseTemplateId,
    required int orderIndex,
    this.rowid = const Value.absent(),
  })  : shapeExerciseId = Value(shapeExerciseId),
        shapeId = Value(shapeId),
        exerciseTemplateId = Value(exerciseTemplateId),
        orderIndex = Value(orderIndex);
  static Insertable<WorkoutShapeExerciseRow> custom({
    Expression<String>? shapeExerciseId,
    Expression<String>? shapeId,
    Expression<String>? exerciseTemplateId,
    Expression<int>? orderIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (shapeExerciseId != null) 'shape_exercise_id': shapeExerciseId,
      if (shapeId != null) 'shape_id': shapeId,
      if (exerciseTemplateId != null)
        'exercise_template_id': exerciseTemplateId,
      if (orderIndex != null) 'order_index': orderIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutShapeExercisesCompanion copyWith(
      {Value<String>? shapeExerciseId,
      Value<String>? shapeId,
      Value<String>? exerciseTemplateId,
      Value<int>? orderIndex,
      Value<int>? rowid}) {
    return WorkoutShapeExercisesCompanion(
      shapeExerciseId: shapeExerciseId ?? this.shapeExerciseId,
      shapeId: shapeId ?? this.shapeId,
      exerciseTemplateId: exerciseTemplateId ?? this.exerciseTemplateId,
      orderIndex: orderIndex ?? this.orderIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (shapeExerciseId.present) {
      map['shape_exercise_id'] = Variable<String>(shapeExerciseId.value);
    }
    if (shapeId.present) {
      map['shape_id'] = Variable<String>(shapeId.value);
    }
    if (exerciseTemplateId.present) {
      map['exercise_template_id'] = Variable<String>(exerciseTemplateId.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutShapeExercisesCompanion(')
          ..write('shapeExerciseId: $shapeExerciseId, ')
          ..write('shapeId: $shapeId, ')
          ..write('exerciseTemplateId: $exerciseTemplateId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutPlannedSetsTable extends WorkoutPlannedSets
    with TableInfo<$WorkoutPlannedSetsTable, WorkoutPlannedSetRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutPlannedSetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _setIdMeta = const VerificationMeta('setId');
  @override
  late final GeneratedColumn<String> setId = GeneratedColumn<String>(
      'set_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _shapeExerciseIdMeta =
      const VerificationMeta('shapeExerciseId');
  @override
  late final GeneratedColumn<String> shapeExerciseId = GeneratedColumn<String>(
      'shape_exercise_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES workout_shape_exercises (shape_exercise_id) ON DELETE CASCADE'));
  static const VerificationMeta _orderIndexMeta =
      const VerificationMeta('orderIndex');
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
      'order_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _metricDefaultsJsonMeta =
      const VerificationMeta('metricDefaultsJson');
  @override
  late final GeneratedColumn<String> metricDefaultsJson =
      GeneratedColumn<String>('metric_defaults_json', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant("{}"));
  @override
  List<GeneratedColumn> get $columns =>
      [setId, shapeExerciseId, orderIndex, metricDefaultsJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_planned_sets';
  @override
  VerificationContext validateIntegrity(
      Insertable<WorkoutPlannedSetRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('set_id')) {
      context.handle(
          _setIdMeta, setId.isAcceptableOrUnknown(data['set_id']!, _setIdMeta));
    } else if (isInserting) {
      context.missing(_setIdMeta);
    }
    if (data.containsKey('shape_exercise_id')) {
      context.handle(
          _shapeExerciseIdMeta,
          shapeExerciseId.isAcceptableOrUnknown(
              data['shape_exercise_id']!, _shapeExerciseIdMeta));
    } else if (isInserting) {
      context.missing(_shapeExerciseIdMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
          _orderIndexMeta,
          orderIndex.isAcceptableOrUnknown(
              data['order_index']!, _orderIndexMeta));
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('metric_defaults_json')) {
      context.handle(
          _metricDefaultsJsonMeta,
          metricDefaultsJson.isAcceptableOrUnknown(
              data['metric_defaults_json']!, _metricDefaultsJsonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {setId};
  @override
  WorkoutPlannedSetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutPlannedSetRow(
      setId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}set_id'])!,
      shapeExerciseId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}shape_exercise_id'])!,
      orderIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_index'])!,
      metricDefaultsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}metric_defaults_json'])!,
    );
  }

  @override
  $WorkoutPlannedSetsTable createAlias(String alias) {
    return $WorkoutPlannedSetsTable(attachedDatabase, alias);
  }
}

class WorkoutPlannedSetRow extends DataClass
    implements Insertable<WorkoutPlannedSetRow> {
  final String setId;
  final String shapeExerciseId;
  final int orderIndex;
  final String metricDefaultsJson;
  const WorkoutPlannedSetRow(
      {required this.setId,
      required this.shapeExerciseId,
      required this.orderIndex,
      required this.metricDefaultsJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['set_id'] = Variable<String>(setId);
    map['shape_exercise_id'] = Variable<String>(shapeExerciseId);
    map['order_index'] = Variable<int>(orderIndex);
    map['metric_defaults_json'] = Variable<String>(metricDefaultsJson);
    return map;
  }

  WorkoutPlannedSetsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutPlannedSetsCompanion(
      setId: Value(setId),
      shapeExerciseId: Value(shapeExerciseId),
      orderIndex: Value(orderIndex),
      metricDefaultsJson: Value(metricDefaultsJson),
    );
  }

  factory WorkoutPlannedSetRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutPlannedSetRow(
      setId: serializer.fromJson<String>(json['setId']),
      shapeExerciseId: serializer.fromJson<String>(json['shapeExerciseId']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      metricDefaultsJson:
          serializer.fromJson<String>(json['metricDefaultsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'setId': serializer.toJson<String>(setId),
      'shapeExerciseId': serializer.toJson<String>(shapeExerciseId),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'metricDefaultsJson': serializer.toJson<String>(metricDefaultsJson),
    };
  }

  WorkoutPlannedSetRow copyWith(
          {String? setId,
          String? shapeExerciseId,
          int? orderIndex,
          String? metricDefaultsJson}) =>
      WorkoutPlannedSetRow(
        setId: setId ?? this.setId,
        shapeExerciseId: shapeExerciseId ?? this.shapeExerciseId,
        orderIndex: orderIndex ?? this.orderIndex,
        metricDefaultsJson: metricDefaultsJson ?? this.metricDefaultsJson,
      );
  WorkoutPlannedSetRow copyWithCompanion(WorkoutPlannedSetsCompanion data) {
    return WorkoutPlannedSetRow(
      setId: data.setId.present ? data.setId.value : this.setId,
      shapeExerciseId: data.shapeExerciseId.present
          ? data.shapeExerciseId.value
          : this.shapeExerciseId,
      orderIndex:
          data.orderIndex.present ? data.orderIndex.value : this.orderIndex,
      metricDefaultsJson: data.metricDefaultsJson.present
          ? data.metricDefaultsJson.value
          : this.metricDefaultsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutPlannedSetRow(')
          ..write('setId: $setId, ')
          ..write('shapeExerciseId: $shapeExerciseId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('metricDefaultsJson: $metricDefaultsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(setId, shapeExerciseId, orderIndex, metricDefaultsJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutPlannedSetRow &&
          other.setId == this.setId &&
          other.shapeExerciseId == this.shapeExerciseId &&
          other.orderIndex == this.orderIndex &&
          other.metricDefaultsJson == this.metricDefaultsJson);
}

class WorkoutPlannedSetsCompanion
    extends UpdateCompanion<WorkoutPlannedSetRow> {
  final Value<String> setId;
  final Value<String> shapeExerciseId;
  final Value<int> orderIndex;
  final Value<String> metricDefaultsJson;
  final Value<int> rowid;
  const WorkoutPlannedSetsCompanion({
    this.setId = const Value.absent(),
    this.shapeExerciseId = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.metricDefaultsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutPlannedSetsCompanion.insert({
    required String setId,
    required String shapeExerciseId,
    required int orderIndex,
    this.metricDefaultsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : setId = Value(setId),
        shapeExerciseId = Value(shapeExerciseId),
        orderIndex = Value(orderIndex);
  static Insertable<WorkoutPlannedSetRow> custom({
    Expression<String>? setId,
    Expression<String>? shapeExerciseId,
    Expression<int>? orderIndex,
    Expression<String>? metricDefaultsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (setId != null) 'set_id': setId,
      if (shapeExerciseId != null) 'shape_exercise_id': shapeExerciseId,
      if (orderIndex != null) 'order_index': orderIndex,
      if (metricDefaultsJson != null)
        'metric_defaults_json': metricDefaultsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutPlannedSetsCompanion copyWith(
      {Value<String>? setId,
      Value<String>? shapeExerciseId,
      Value<int>? orderIndex,
      Value<String>? metricDefaultsJson,
      Value<int>? rowid}) {
    return WorkoutPlannedSetsCompanion(
      setId: setId ?? this.setId,
      shapeExerciseId: shapeExerciseId ?? this.shapeExerciseId,
      orderIndex: orderIndex ?? this.orderIndex,
      metricDefaultsJson: metricDefaultsJson ?? this.metricDefaultsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (setId.present) {
      map['set_id'] = Variable<String>(setId.value);
    }
    if (shapeExerciseId.present) {
      map['shape_exercise_id'] = Variable<String>(shapeExerciseId.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (metricDefaultsJson.present) {
      map['metric_defaults_json'] = Variable<String>(metricDefaultsJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutPlannedSetsCompanion(')
          ..write('setId: $setId, ')
          ..write('shapeExerciseId: $shapeExerciseId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('metricDefaultsJson: $metricDefaultsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ExerciseTemplatesTable exerciseTemplates =
      $ExerciseTemplatesTable(this);
  late final $ExerciseMetricConfigsTable exerciseMetricConfigs =
      $ExerciseMetricConfigsTable(this);
  late final $WorkoutTemplatesTable workoutTemplates =
      $WorkoutTemplatesTable(this);
  late final $WorkoutShapeNodesTable workoutShapeNodes =
      $WorkoutShapeNodesTable(this);
  late final $WorkoutExerciseSlotsTable workoutExerciseSlots =
      $WorkoutExerciseSlotsTable(this);
  late final $WorkoutShapeExercisesTable workoutShapeExercises =
      $WorkoutShapeExercisesTable(this);
  late final $WorkoutPlannedSetsTable workoutPlannedSets =
      $WorkoutPlannedSetsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        exerciseTemplates,
        exerciseMetricConfigs,
        workoutTemplates,
        workoutShapeNodes,
        workoutExerciseSlots,
        workoutShapeExercises,
        workoutPlannedSets
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('exercise_templates',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('exercise_metric_configs', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('workout_templates',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('workout_shape_nodes', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('workout_shape_nodes',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('workout_shape_exercises', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('workout_shape_exercises',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('workout_planned_sets', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$ExerciseTemplatesTableCreateCompanionBuilder
    = ExerciseTemplatesCompanion Function({
  required String id,
  required String name,
  required String normalizedName,
  required DateTime createdAtUtc,
  required DateTime updatedAtUtc,
  Value<int> rowid,
});
typedef $$ExerciseTemplatesTableUpdateCompanionBuilder
    = ExerciseTemplatesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> normalizedName,
  Value<DateTime> createdAtUtc,
  Value<DateTime> updatedAtUtc,
  Value<int> rowid,
});

final class $$ExerciseTemplatesTableReferences extends BaseReferences<
    _$AppDatabase, $ExerciseTemplatesTable, ExerciseTemplateRow> {
  $$ExerciseTemplatesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExerciseMetricConfigsTable,
      List<ExerciseMetricConfigRow>> _exerciseMetricConfigsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.exerciseMetricConfigs,
          aliasName: $_aliasNameGenerator(db.exerciseTemplates.id,
              db.exerciseMetricConfigs.exerciseTemplateId));

  $$ExerciseMetricConfigsTableProcessedTableManager
      get exerciseMetricConfigsRefs {
    final manager = $$ExerciseMetricConfigsTableTableManager(
            $_db, $_db.exerciseMetricConfigs)
        .filter((f) =>
            f.exerciseTemplateId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_exerciseMetricConfigsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$WorkoutShapeExercisesTable,
      List<WorkoutShapeExerciseRow>> _workoutShapeExercisesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.workoutShapeExercises,
          aliasName: $_aliasNameGenerator(db.exerciseTemplates.id,
              db.workoutShapeExercises.exerciseTemplateId));

  $$WorkoutShapeExercisesTableProcessedTableManager
      get workoutShapeExercisesRefs {
    final manager = $$WorkoutShapeExercisesTableTableManager(
            $_db, $_db.workoutShapeExercises)
        .filter((f) =>
            f.exerciseTemplateId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_workoutShapeExercisesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ExerciseTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $ExerciseTemplatesTable> {
  $$ExerciseTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get normalizedName => $composableBuilder(
      column: $table.normalizedName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAtUtc => $composableBuilder(
      column: $table.createdAtUtc, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
      column: $table.updatedAtUtc, builder: (column) => ColumnFilters(column));

  Expression<bool> exerciseMetricConfigsRefs(
      Expression<bool> Function($$ExerciseMetricConfigsTableFilterComposer f)
          f) {
    final $$ExerciseMetricConfigsTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.exerciseMetricConfigs,
            getReferencedColumn: (t) => t.exerciseTemplateId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ExerciseMetricConfigsTableFilterComposer(
                  $db: $db,
                  $table: $db.exerciseMetricConfigs,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<bool> workoutShapeExercisesRefs(
      Expression<bool> Function($$WorkoutShapeExercisesTableFilterComposer f)
          f) {
    final $$WorkoutShapeExercisesTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.workoutShapeExercises,
            getReferencedColumn: (t) => t.exerciseTemplateId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$WorkoutShapeExercisesTableFilterComposer(
                  $db: $db,
                  $table: $db.workoutShapeExercises,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ExerciseTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExerciseTemplatesTable> {
  $$ExerciseTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get normalizedName => $composableBuilder(
      column: $table.normalizedName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAtUtc => $composableBuilder(
      column: $table.createdAtUtc,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
      column: $table.updatedAtUtc,
      builder: (column) => ColumnOrderings(column));
}

class $$ExerciseTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExerciseTemplatesTable> {
  $$ExerciseTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get normalizedName => $composableBuilder(
      column: $table.normalizedName, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAtUtc => $composableBuilder(
      column: $table.createdAtUtc, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
      column: $table.updatedAtUtc, builder: (column) => column);

  Expression<T> exerciseMetricConfigsRefs<T extends Object>(
      Expression<T> Function($$ExerciseMetricConfigsTableAnnotationComposer a)
          f) {
    final $$ExerciseMetricConfigsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.exerciseMetricConfigs,
            getReferencedColumn: (t) => t.exerciseTemplateId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ExerciseMetricConfigsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.exerciseMetricConfigs,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> workoutShapeExercisesRefs<T extends Object>(
      Expression<T> Function($$WorkoutShapeExercisesTableAnnotationComposer a)
          f) {
    final $$WorkoutShapeExercisesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.workoutShapeExercises,
            getReferencedColumn: (t) => t.exerciseTemplateId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$WorkoutShapeExercisesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.workoutShapeExercises,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ExerciseTemplatesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExerciseTemplatesTable,
    ExerciseTemplateRow,
    $$ExerciseTemplatesTableFilterComposer,
    $$ExerciseTemplatesTableOrderingComposer,
    $$ExerciseTemplatesTableAnnotationComposer,
    $$ExerciseTemplatesTableCreateCompanionBuilder,
    $$ExerciseTemplatesTableUpdateCompanionBuilder,
    (ExerciseTemplateRow, $$ExerciseTemplatesTableReferences),
    ExerciseTemplateRow,
    PrefetchHooks Function(
        {bool exerciseMetricConfigsRefs, bool workoutShapeExercisesRefs})> {
  $$ExerciseTemplatesTableTableManager(
      _$AppDatabase db, $ExerciseTemplatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExerciseTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExerciseTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExerciseTemplatesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> normalizedName = const Value.absent(),
            Value<DateTime> createdAtUtc = const Value.absent(),
            Value<DateTime> updatedAtUtc = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExerciseTemplatesCompanion(
            id: id,
            name: name,
            normalizedName: normalizedName,
            createdAtUtc: createdAtUtc,
            updatedAtUtc: updatedAtUtc,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String normalizedName,
            required DateTime createdAtUtc,
            required DateTime updatedAtUtc,
            Value<int> rowid = const Value.absent(),
          }) =>
              ExerciseTemplatesCompanion.insert(
            id: id,
            name: name,
            normalizedName: normalizedName,
            createdAtUtc: createdAtUtc,
            updatedAtUtc: updatedAtUtc,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ExerciseTemplatesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {exerciseMetricConfigsRefs = false,
              workoutShapeExercisesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (exerciseMetricConfigsRefs) db.exerciseMetricConfigs,
                if (workoutShapeExercisesRefs) db.workoutShapeExercises
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (exerciseMetricConfigsRefs)
                    await $_getPrefetchedData<ExerciseTemplateRow,
                            $ExerciseTemplatesTable, ExerciseMetricConfigRow>(
                        currentTable: table,
                        referencedTable: $$ExerciseTemplatesTableReferences
                            ._exerciseMetricConfigsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ExerciseTemplatesTableReferences(db, table, p0)
                                .exerciseMetricConfigsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.exerciseTemplateId == item.id),
                        typedResults: items),
                  if (workoutShapeExercisesRefs)
                    await $_getPrefetchedData<ExerciseTemplateRow,
                            $ExerciseTemplatesTable, WorkoutShapeExerciseRow>(
                        currentTable: table,
                        referencedTable: $$ExerciseTemplatesTableReferences
                            ._workoutShapeExercisesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ExerciseTemplatesTableReferences(db, table, p0)
                                .workoutShapeExercisesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.exerciseTemplateId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ExerciseTemplatesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExerciseTemplatesTable,
    ExerciseTemplateRow,
    $$ExerciseTemplatesTableFilterComposer,
    $$ExerciseTemplatesTableOrderingComposer,
    $$ExerciseTemplatesTableAnnotationComposer,
    $$ExerciseTemplatesTableCreateCompanionBuilder,
    $$ExerciseTemplatesTableUpdateCompanionBuilder,
    (ExerciseTemplateRow, $$ExerciseTemplatesTableReferences),
    ExerciseTemplateRow,
    PrefetchHooks Function(
        {bool exerciseMetricConfigsRefs, bool workoutShapeExercisesRefs})>;
typedef $$ExerciseMetricConfigsTableCreateCompanionBuilder
    = ExerciseMetricConfigsCompanion Function({
  required String exerciseTemplateId,
  required String metricKey,
  required int orderIndex,
  Value<int> rowid,
});
typedef $$ExerciseMetricConfigsTableUpdateCompanionBuilder
    = ExerciseMetricConfigsCompanion Function({
  Value<String> exerciseTemplateId,
  Value<String> metricKey,
  Value<int> orderIndex,
  Value<int> rowid,
});

final class $$ExerciseMetricConfigsTableReferences extends BaseReferences<
    _$AppDatabase, $ExerciseMetricConfigsTable, ExerciseMetricConfigRow> {
  $$ExerciseMetricConfigsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ExerciseTemplatesTable _exerciseTemplateIdTable(_$AppDatabase db) =>
      db.exerciseTemplates.createAlias($_aliasNameGenerator(
          db.exerciseMetricConfigs.exerciseTemplateId,
          db.exerciseTemplates.id));

  $$ExerciseTemplatesTableProcessedTableManager get exerciseTemplateId {
    final $_column = $_itemColumn<String>('exercise_template_id')!;

    final manager =
        $$ExerciseTemplatesTableTableManager($_db, $_db.exerciseTemplates)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseTemplateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ExerciseMetricConfigsTableFilterComposer
    extends Composer<_$AppDatabase, $ExerciseMetricConfigsTable> {
  $$ExerciseMetricConfigsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get metricKey => $composableBuilder(
      column: $table.metricKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnFilters(column));

  $$ExerciseTemplatesTableFilterComposer get exerciseTemplateId {
    final $$ExerciseTemplatesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.exerciseTemplateId,
        referencedTable: $db.exerciseTemplates,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExerciseTemplatesTableFilterComposer(
              $db: $db,
              $table: $db.exerciseTemplates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExerciseMetricConfigsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExerciseMetricConfigsTable> {
  $$ExerciseMetricConfigsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get metricKey => $composableBuilder(
      column: $table.metricKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnOrderings(column));

  $$ExerciseTemplatesTableOrderingComposer get exerciseTemplateId {
    final $$ExerciseTemplatesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.exerciseTemplateId,
        referencedTable: $db.exerciseTemplates,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExerciseTemplatesTableOrderingComposer(
              $db: $db,
              $table: $db.exerciseTemplates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExerciseMetricConfigsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExerciseMetricConfigsTable> {
  $$ExerciseMetricConfigsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get metricKey =>
      $composableBuilder(column: $table.metricKey, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => column);

  $$ExerciseTemplatesTableAnnotationComposer get exerciseTemplateId {
    final $$ExerciseTemplatesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.exerciseTemplateId,
            referencedTable: $db.exerciseTemplates,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ExerciseTemplatesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.exerciseTemplates,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$ExerciseMetricConfigsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExerciseMetricConfigsTable,
    ExerciseMetricConfigRow,
    $$ExerciseMetricConfigsTableFilterComposer,
    $$ExerciseMetricConfigsTableOrderingComposer,
    $$ExerciseMetricConfigsTableAnnotationComposer,
    $$ExerciseMetricConfigsTableCreateCompanionBuilder,
    $$ExerciseMetricConfigsTableUpdateCompanionBuilder,
    (ExerciseMetricConfigRow, $$ExerciseMetricConfigsTableReferences),
    ExerciseMetricConfigRow,
    PrefetchHooks Function({bool exerciseTemplateId})> {
  $$ExerciseMetricConfigsTableTableManager(
      _$AppDatabase db, $ExerciseMetricConfigsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExerciseMetricConfigsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ExerciseMetricConfigsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExerciseMetricConfigsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> exerciseTemplateId = const Value.absent(),
            Value<String> metricKey = const Value.absent(),
            Value<int> orderIndex = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExerciseMetricConfigsCompanion(
            exerciseTemplateId: exerciseTemplateId,
            metricKey: metricKey,
            orderIndex: orderIndex,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String exerciseTemplateId,
            required String metricKey,
            required int orderIndex,
            Value<int> rowid = const Value.absent(),
          }) =>
              ExerciseMetricConfigsCompanion.insert(
            exerciseTemplateId: exerciseTemplateId,
            metricKey: metricKey,
            orderIndex: orderIndex,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ExerciseMetricConfigsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({exerciseTemplateId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (exerciseTemplateId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.exerciseTemplateId,
                    referencedTable: $$ExerciseMetricConfigsTableReferences
                        ._exerciseTemplateIdTable(db),
                    referencedColumn: $$ExerciseMetricConfigsTableReferences
                        ._exerciseTemplateIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ExerciseMetricConfigsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ExerciseMetricConfigsTable,
        ExerciseMetricConfigRow,
        $$ExerciseMetricConfigsTableFilterComposer,
        $$ExerciseMetricConfigsTableOrderingComposer,
        $$ExerciseMetricConfigsTableAnnotationComposer,
        $$ExerciseMetricConfigsTableCreateCompanionBuilder,
        $$ExerciseMetricConfigsTableUpdateCompanionBuilder,
        (ExerciseMetricConfigRow, $$ExerciseMetricConfigsTableReferences),
        ExerciseMetricConfigRow,
        PrefetchHooks Function({bool exerciseTemplateId})>;
typedef $$WorkoutTemplatesTableCreateCompanionBuilder
    = WorkoutTemplatesCompanion Function({
  required String id,
  required String name,
  required String normalizedName,
  required DateTime createdAtUtc,
  required DateTime updatedAtUtc,
  Value<int> version,
  Value<int> layoutVersion,
  Value<int> rowid,
});
typedef $$WorkoutTemplatesTableUpdateCompanionBuilder
    = WorkoutTemplatesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> normalizedName,
  Value<DateTime> createdAtUtc,
  Value<DateTime> updatedAtUtc,
  Value<int> version,
  Value<int> layoutVersion,
  Value<int> rowid,
});

final class $$WorkoutTemplatesTableReferences extends BaseReferences<
    _$AppDatabase, $WorkoutTemplatesTable, WorkoutTemplateRow> {
  $$WorkoutTemplatesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WorkoutShapeNodesTable, List<WorkoutShapeNodeRow>>
      _workoutShapeNodesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.workoutShapeNodes,
              aliasName: $_aliasNameGenerator(
                  db.workoutTemplates.id, db.workoutShapeNodes.templateId));

  $$WorkoutShapeNodesTableProcessedTableManager get workoutShapeNodesRefs {
    final manager = $$WorkoutShapeNodesTableTableManager(
            $_db, $_db.workoutShapeNodes)
        .filter((f) => f.templateId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_workoutShapeNodesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$WorkoutTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutTemplatesTable> {
  $$WorkoutTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get normalizedName => $composableBuilder(
      column: $table.normalizedName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAtUtc => $composableBuilder(
      column: $table.createdAtUtc, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAtUtc => $composableBuilder(
      column: $table.updatedAtUtc, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get layoutVersion => $composableBuilder(
      column: $table.layoutVersion, builder: (column) => ColumnFilters(column));

  Expression<bool> workoutShapeNodesRefs(
      Expression<bool> Function($$WorkoutShapeNodesTableFilterComposer f) f) {
    final $$WorkoutShapeNodesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.workoutShapeNodes,
        getReferencedColumn: (t) => t.templateId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutShapeNodesTableFilterComposer(
              $db: $db,
              $table: $db.workoutShapeNodes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WorkoutTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutTemplatesTable> {
  $$WorkoutTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get normalizedName => $composableBuilder(
      column: $table.normalizedName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAtUtc => $composableBuilder(
      column: $table.createdAtUtc,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAtUtc => $composableBuilder(
      column: $table.updatedAtUtc,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get layoutVersion => $composableBuilder(
      column: $table.layoutVersion,
      builder: (column) => ColumnOrderings(column));
}

class $$WorkoutTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutTemplatesTable> {
  $$WorkoutTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get normalizedName => $composableBuilder(
      column: $table.normalizedName, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAtUtc => $composableBuilder(
      column: $table.createdAtUtc, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAtUtc => $composableBuilder(
      column: $table.updatedAtUtc, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get layoutVersion => $composableBuilder(
      column: $table.layoutVersion, builder: (column) => column);

  Expression<T> workoutShapeNodesRefs<T extends Object>(
      Expression<T> Function($$WorkoutShapeNodesTableAnnotationComposer a) f) {
    final $$WorkoutShapeNodesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.workoutShapeNodes,
            getReferencedColumn: (t) => t.templateId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$WorkoutShapeNodesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.workoutShapeNodes,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$WorkoutTemplatesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkoutTemplatesTable,
    WorkoutTemplateRow,
    $$WorkoutTemplatesTableFilterComposer,
    $$WorkoutTemplatesTableOrderingComposer,
    $$WorkoutTemplatesTableAnnotationComposer,
    $$WorkoutTemplatesTableCreateCompanionBuilder,
    $$WorkoutTemplatesTableUpdateCompanionBuilder,
    (WorkoutTemplateRow, $$WorkoutTemplatesTableReferences),
    WorkoutTemplateRow,
    PrefetchHooks Function({bool workoutShapeNodesRefs})> {
  $$WorkoutTemplatesTableTableManager(
      _$AppDatabase db, $WorkoutTemplatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutTemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> normalizedName = const Value.absent(),
            Value<DateTime> createdAtUtc = const Value.absent(),
            Value<DateTime> updatedAtUtc = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> layoutVersion = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutTemplatesCompanion(
            id: id,
            name: name,
            normalizedName: normalizedName,
            createdAtUtc: createdAtUtc,
            updatedAtUtc: updatedAtUtc,
            version: version,
            layoutVersion: layoutVersion,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String normalizedName,
            required DateTime createdAtUtc,
            required DateTime updatedAtUtc,
            Value<int> version = const Value.absent(),
            Value<int> layoutVersion = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutTemplatesCompanion.insert(
            id: id,
            name: name,
            normalizedName: normalizedName,
            createdAtUtc: createdAtUtc,
            updatedAtUtc: updatedAtUtc,
            version: version,
            layoutVersion: layoutVersion,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WorkoutTemplatesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({workoutShapeNodesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (workoutShapeNodesRefs) db.workoutShapeNodes
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (workoutShapeNodesRefs)
                    await $_getPrefetchedData<WorkoutTemplateRow,
                            $WorkoutTemplatesTable, WorkoutShapeNodeRow>(
                        currentTable: table,
                        referencedTable: $$WorkoutTemplatesTableReferences
                            ._workoutShapeNodesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WorkoutTemplatesTableReferences(db, table, p0)
                                .workoutShapeNodesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.templateId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$WorkoutTemplatesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WorkoutTemplatesTable,
    WorkoutTemplateRow,
    $$WorkoutTemplatesTableFilterComposer,
    $$WorkoutTemplatesTableOrderingComposer,
    $$WorkoutTemplatesTableAnnotationComposer,
    $$WorkoutTemplatesTableCreateCompanionBuilder,
    $$WorkoutTemplatesTableUpdateCompanionBuilder,
    (WorkoutTemplateRow, $$WorkoutTemplatesTableReferences),
    WorkoutTemplateRow,
    PrefetchHooks Function({bool workoutShapeNodesRefs})>;
typedef $$WorkoutShapeNodesTableCreateCompanionBuilder
    = WorkoutShapeNodesCompanion Function({
  required String shapeId,
  required String templateId,
  Value<String?> parentShapeId,
  required String shapeType,
  required int orderIndex,
  Value<String?> note,
  Value<int> rowid,
});
typedef $$WorkoutShapeNodesTableUpdateCompanionBuilder
    = WorkoutShapeNodesCompanion Function({
  Value<String> shapeId,
  Value<String> templateId,
  Value<String?> parentShapeId,
  Value<String> shapeType,
  Value<int> orderIndex,
  Value<String?> note,
  Value<int> rowid,
});

final class $$WorkoutShapeNodesTableReferences extends BaseReferences<
    _$AppDatabase, $WorkoutShapeNodesTable, WorkoutShapeNodeRow> {
  $$WorkoutShapeNodesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutTemplatesTable _templateIdTable(_$AppDatabase db) =>
      db.workoutTemplates.createAlias($_aliasNameGenerator(
          db.workoutShapeNodes.templateId, db.workoutTemplates.id));

  $$WorkoutTemplatesTableProcessedTableManager get templateId {
    final $_column = $_itemColumn<String>('template_id')!;

    final manager =
        $$WorkoutTemplatesTableTableManager($_db, $_db.workoutTemplates)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_templateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$WorkoutExerciseSlotsTable,
      List<WorkoutExerciseSlotRow>> _workoutExerciseSlotsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.workoutExerciseSlots,
          aliasName: $_aliasNameGenerator(
              db.workoutShapeNodes.shapeId, db.workoutExerciseSlots.shapeId));

  $$WorkoutExerciseSlotsTableProcessedTableManager
      get workoutExerciseSlotsRefs {
    final manager =
        $$WorkoutExerciseSlotsTableTableManager($_db, $_db.workoutExerciseSlots)
            .filter((f) =>
                f.shapeId.shapeId.sqlEquals($_itemColumn<String>('shape_id')!));

    final cache =
        $_typedResult.readTableOrNull(_workoutExerciseSlotsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$WorkoutShapeExercisesTable,
      List<WorkoutShapeExerciseRow>> _workoutShapeExercisesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.workoutShapeExercises,
          aliasName: $_aliasNameGenerator(
              db.workoutShapeNodes.shapeId, db.workoutShapeExercises.shapeId));

  $$WorkoutShapeExercisesTableProcessedTableManager
      get workoutShapeExercisesRefs {
    final manager = $$WorkoutShapeExercisesTableTableManager(
            $_db, $_db.workoutShapeExercises)
        .filter((f) =>
            f.shapeId.shapeId.sqlEquals($_itemColumn<String>('shape_id')!));

    final cache =
        $_typedResult.readTableOrNull(_workoutShapeExercisesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$WorkoutShapeNodesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutShapeNodesTable> {
  $$WorkoutShapeNodesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get shapeId => $composableBuilder(
      column: $table.shapeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get parentShapeId => $composableBuilder(
      column: $table.parentShapeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shapeType => $composableBuilder(
      column: $table.shapeType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  $$WorkoutTemplatesTableFilterComposer get templateId {
    final $$WorkoutTemplatesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.templateId,
        referencedTable: $db.workoutTemplates,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutTemplatesTableFilterComposer(
              $db: $db,
              $table: $db.workoutTemplates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> workoutExerciseSlotsRefs(
      Expression<bool> Function($$WorkoutExerciseSlotsTableFilterComposer f)
          f) {
    final $$WorkoutExerciseSlotsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shapeId,
        referencedTable: $db.workoutExerciseSlots,
        getReferencedColumn: (t) => t.shapeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutExerciseSlotsTableFilterComposer(
              $db: $db,
              $table: $db.workoutExerciseSlots,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> workoutShapeExercisesRefs(
      Expression<bool> Function($$WorkoutShapeExercisesTableFilterComposer f)
          f) {
    final $$WorkoutShapeExercisesTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.shapeId,
            referencedTable: $db.workoutShapeExercises,
            getReferencedColumn: (t) => t.shapeId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$WorkoutShapeExercisesTableFilterComposer(
                  $db: $db,
                  $table: $db.workoutShapeExercises,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$WorkoutShapeNodesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutShapeNodesTable> {
  $$WorkoutShapeNodesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get shapeId => $composableBuilder(
      column: $table.shapeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parentShapeId => $composableBuilder(
      column: $table.parentShapeId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shapeType => $composableBuilder(
      column: $table.shapeType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  $$WorkoutTemplatesTableOrderingComposer get templateId {
    final $$WorkoutTemplatesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.templateId,
        referencedTable: $db.workoutTemplates,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutTemplatesTableOrderingComposer(
              $db: $db,
              $table: $db.workoutTemplates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorkoutShapeNodesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutShapeNodesTable> {
  $$WorkoutShapeNodesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get shapeId =>
      $composableBuilder(column: $table.shapeId, builder: (column) => column);

  GeneratedColumn<String> get parentShapeId => $composableBuilder(
      column: $table.parentShapeId, builder: (column) => column);

  GeneratedColumn<String> get shapeType =>
      $composableBuilder(column: $table.shapeType, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$WorkoutTemplatesTableAnnotationComposer get templateId {
    final $$WorkoutTemplatesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.templateId,
        referencedTable: $db.workoutTemplates,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutTemplatesTableAnnotationComposer(
              $db: $db,
              $table: $db.workoutTemplates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> workoutExerciseSlotsRefs<T extends Object>(
      Expression<T> Function($$WorkoutExerciseSlotsTableAnnotationComposer a)
          f) {
    final $$WorkoutExerciseSlotsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.shapeId,
            referencedTable: $db.workoutExerciseSlots,
            getReferencedColumn: (t) => t.shapeId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$WorkoutExerciseSlotsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.workoutExerciseSlots,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> workoutShapeExercisesRefs<T extends Object>(
      Expression<T> Function($$WorkoutShapeExercisesTableAnnotationComposer a)
          f) {
    final $$WorkoutShapeExercisesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.shapeId,
            referencedTable: $db.workoutShapeExercises,
            getReferencedColumn: (t) => t.shapeId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$WorkoutShapeExercisesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.workoutShapeExercises,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$WorkoutShapeNodesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkoutShapeNodesTable,
    WorkoutShapeNodeRow,
    $$WorkoutShapeNodesTableFilterComposer,
    $$WorkoutShapeNodesTableOrderingComposer,
    $$WorkoutShapeNodesTableAnnotationComposer,
    $$WorkoutShapeNodesTableCreateCompanionBuilder,
    $$WorkoutShapeNodesTableUpdateCompanionBuilder,
    (WorkoutShapeNodeRow, $$WorkoutShapeNodesTableReferences),
    WorkoutShapeNodeRow,
    PrefetchHooks Function(
        {bool templateId,
        bool workoutExerciseSlotsRefs,
        bool workoutShapeExercisesRefs})> {
  $$WorkoutShapeNodesTableTableManager(
      _$AppDatabase db, $WorkoutShapeNodesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutShapeNodesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutShapeNodesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutShapeNodesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> shapeId = const Value.absent(),
            Value<String> templateId = const Value.absent(),
            Value<String?> parentShapeId = const Value.absent(),
            Value<String> shapeType = const Value.absent(),
            Value<int> orderIndex = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutShapeNodesCompanion(
            shapeId: shapeId,
            templateId: templateId,
            parentShapeId: parentShapeId,
            shapeType: shapeType,
            orderIndex: orderIndex,
            note: note,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String shapeId,
            required String templateId,
            Value<String?> parentShapeId = const Value.absent(),
            required String shapeType,
            required int orderIndex,
            Value<String?> note = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutShapeNodesCompanion.insert(
            shapeId: shapeId,
            templateId: templateId,
            parentShapeId: parentShapeId,
            shapeType: shapeType,
            orderIndex: orderIndex,
            note: note,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WorkoutShapeNodesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {templateId = false,
              workoutExerciseSlotsRefs = false,
              workoutShapeExercisesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (workoutExerciseSlotsRefs) db.workoutExerciseSlots,
                if (workoutShapeExercisesRefs) db.workoutShapeExercises
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (templateId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.templateId,
                    referencedTable:
                        $$WorkoutShapeNodesTableReferences._templateIdTable(db),
                    referencedColumn: $$WorkoutShapeNodesTableReferences
                        ._templateIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (workoutExerciseSlotsRefs)
                    await $_getPrefetchedData<WorkoutShapeNodeRow,
                            $WorkoutShapeNodesTable, WorkoutExerciseSlotRow>(
                        currentTable: table,
                        referencedTable: $$WorkoutShapeNodesTableReferences
                            ._workoutExerciseSlotsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WorkoutShapeNodesTableReferences(db, table, p0)
                                .workoutExerciseSlotsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.shapeId == item.shapeId),
                        typedResults: items),
                  if (workoutShapeExercisesRefs)
                    await $_getPrefetchedData<WorkoutShapeNodeRow,
                            $WorkoutShapeNodesTable, WorkoutShapeExerciseRow>(
                        currentTable: table,
                        referencedTable: $$WorkoutShapeNodesTableReferences
                            ._workoutShapeExercisesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WorkoutShapeNodesTableReferences(db, table, p0)
                                .workoutShapeExercisesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.shapeId == item.shapeId),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$WorkoutShapeNodesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WorkoutShapeNodesTable,
    WorkoutShapeNodeRow,
    $$WorkoutShapeNodesTableFilterComposer,
    $$WorkoutShapeNodesTableOrderingComposer,
    $$WorkoutShapeNodesTableAnnotationComposer,
    $$WorkoutShapeNodesTableCreateCompanionBuilder,
    $$WorkoutShapeNodesTableUpdateCompanionBuilder,
    (WorkoutShapeNodeRow, $$WorkoutShapeNodesTableReferences),
    WorkoutShapeNodeRow,
    PrefetchHooks Function(
        {bool templateId,
        bool workoutExerciseSlotsRefs,
        bool workoutShapeExercisesRefs})>;
typedef $$WorkoutExerciseSlotsTableCreateCompanionBuilder
    = WorkoutExerciseSlotsCompanion Function({
  required String slotId,
  required String shapeId,
  Value<String?> exerciseTemplateId,
  Value<String?> displayLabel,
  required int orderIndex,
  Value<int> rowid,
});
typedef $$WorkoutExerciseSlotsTableUpdateCompanionBuilder
    = WorkoutExerciseSlotsCompanion Function({
  Value<String> slotId,
  Value<String> shapeId,
  Value<String?> exerciseTemplateId,
  Value<String?> displayLabel,
  Value<int> orderIndex,
  Value<int> rowid,
});

final class $$WorkoutExerciseSlotsTableReferences extends BaseReferences<
    _$AppDatabase, $WorkoutExerciseSlotsTable, WorkoutExerciseSlotRow> {
  $$WorkoutExerciseSlotsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutShapeNodesTable _shapeIdTable(_$AppDatabase db) =>
      db.workoutShapeNodes.createAlias($_aliasNameGenerator(
          db.workoutExerciseSlots.shapeId, db.workoutShapeNodes.shapeId));

  $$WorkoutShapeNodesTableProcessedTableManager get shapeId {
    final $_column = $_itemColumn<String>('shape_id')!;

    final manager =
        $$WorkoutShapeNodesTableTableManager($_db, $_db.workoutShapeNodes)
            .filter((f) => f.shapeId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shapeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$WorkoutExerciseSlotsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutExerciseSlotsTable> {
  $$WorkoutExerciseSlotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get slotId => $composableBuilder(
      column: $table.slotId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exerciseTemplateId => $composableBuilder(
      column: $table.exerciseTemplateId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayLabel => $composableBuilder(
      column: $table.displayLabel, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnFilters(column));

  $$WorkoutShapeNodesTableFilterComposer get shapeId {
    final $$WorkoutShapeNodesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shapeId,
        referencedTable: $db.workoutShapeNodes,
        getReferencedColumn: (t) => t.shapeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutShapeNodesTableFilterComposer(
              $db: $db,
              $table: $db.workoutShapeNodes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorkoutExerciseSlotsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutExerciseSlotsTable> {
  $$WorkoutExerciseSlotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get slotId => $composableBuilder(
      column: $table.slotId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exerciseTemplateId => $composableBuilder(
      column: $table.exerciseTemplateId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayLabel => $composableBuilder(
      column: $table.displayLabel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnOrderings(column));

  $$WorkoutShapeNodesTableOrderingComposer get shapeId {
    final $$WorkoutShapeNodesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shapeId,
        referencedTable: $db.workoutShapeNodes,
        getReferencedColumn: (t) => t.shapeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutShapeNodesTableOrderingComposer(
              $db: $db,
              $table: $db.workoutShapeNodes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorkoutExerciseSlotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutExerciseSlotsTable> {
  $$WorkoutExerciseSlotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get slotId =>
      $composableBuilder(column: $table.slotId, builder: (column) => column);

  GeneratedColumn<String> get exerciseTemplateId => $composableBuilder(
      column: $table.exerciseTemplateId, builder: (column) => column);

  GeneratedColumn<String> get displayLabel => $composableBuilder(
      column: $table.displayLabel, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => column);

  $$WorkoutShapeNodesTableAnnotationComposer get shapeId {
    final $$WorkoutShapeNodesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.shapeId,
            referencedTable: $db.workoutShapeNodes,
            getReferencedColumn: (t) => t.shapeId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$WorkoutShapeNodesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.workoutShapeNodes,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$WorkoutExerciseSlotsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkoutExerciseSlotsTable,
    WorkoutExerciseSlotRow,
    $$WorkoutExerciseSlotsTableFilterComposer,
    $$WorkoutExerciseSlotsTableOrderingComposer,
    $$WorkoutExerciseSlotsTableAnnotationComposer,
    $$WorkoutExerciseSlotsTableCreateCompanionBuilder,
    $$WorkoutExerciseSlotsTableUpdateCompanionBuilder,
    (WorkoutExerciseSlotRow, $$WorkoutExerciseSlotsTableReferences),
    WorkoutExerciseSlotRow,
    PrefetchHooks Function({bool shapeId})> {
  $$WorkoutExerciseSlotsTableTableManager(
      _$AppDatabase db, $WorkoutExerciseSlotsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutExerciseSlotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutExerciseSlotsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutExerciseSlotsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> slotId = const Value.absent(),
            Value<String> shapeId = const Value.absent(),
            Value<String?> exerciseTemplateId = const Value.absent(),
            Value<String?> displayLabel = const Value.absent(),
            Value<int> orderIndex = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutExerciseSlotsCompanion(
            slotId: slotId,
            shapeId: shapeId,
            exerciseTemplateId: exerciseTemplateId,
            displayLabel: displayLabel,
            orderIndex: orderIndex,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String slotId,
            required String shapeId,
            Value<String?> exerciseTemplateId = const Value.absent(),
            Value<String?> displayLabel = const Value.absent(),
            required int orderIndex,
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutExerciseSlotsCompanion.insert(
            slotId: slotId,
            shapeId: shapeId,
            exerciseTemplateId: exerciseTemplateId,
            displayLabel: displayLabel,
            orderIndex: orderIndex,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WorkoutExerciseSlotsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({shapeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (shapeId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.shapeId,
                    referencedTable:
                        $$WorkoutExerciseSlotsTableReferences._shapeIdTable(db),
                    referencedColumn: $$WorkoutExerciseSlotsTableReferences
                        ._shapeIdTable(db)
                        .shapeId,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$WorkoutExerciseSlotsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $WorkoutExerciseSlotsTable,
        WorkoutExerciseSlotRow,
        $$WorkoutExerciseSlotsTableFilterComposer,
        $$WorkoutExerciseSlotsTableOrderingComposer,
        $$WorkoutExerciseSlotsTableAnnotationComposer,
        $$WorkoutExerciseSlotsTableCreateCompanionBuilder,
        $$WorkoutExerciseSlotsTableUpdateCompanionBuilder,
        (WorkoutExerciseSlotRow, $$WorkoutExerciseSlotsTableReferences),
        WorkoutExerciseSlotRow,
        PrefetchHooks Function({bool shapeId})>;
typedef $$WorkoutShapeExercisesTableCreateCompanionBuilder
    = WorkoutShapeExercisesCompanion Function({
  required String shapeExerciseId,
  required String shapeId,
  required String exerciseTemplateId,
  required int orderIndex,
  Value<int> rowid,
});
typedef $$WorkoutShapeExercisesTableUpdateCompanionBuilder
    = WorkoutShapeExercisesCompanion Function({
  Value<String> shapeExerciseId,
  Value<String> shapeId,
  Value<String> exerciseTemplateId,
  Value<int> orderIndex,
  Value<int> rowid,
});

final class $$WorkoutShapeExercisesTableReferences extends BaseReferences<
    _$AppDatabase, $WorkoutShapeExercisesTable, WorkoutShapeExerciseRow> {
  $$WorkoutShapeExercisesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutShapeNodesTable _shapeIdTable(_$AppDatabase db) =>
      db.workoutShapeNodes.createAlias($_aliasNameGenerator(
          db.workoutShapeExercises.shapeId, db.workoutShapeNodes.shapeId));

  $$WorkoutShapeNodesTableProcessedTableManager get shapeId {
    final $_column = $_itemColumn<String>('shape_id')!;

    final manager =
        $$WorkoutShapeNodesTableTableManager($_db, $_db.workoutShapeNodes)
            .filter((f) => f.shapeId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shapeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ExerciseTemplatesTable _exerciseTemplateIdTable(_$AppDatabase db) =>
      db.exerciseTemplates.createAlias($_aliasNameGenerator(
          db.workoutShapeExercises.exerciseTemplateId,
          db.exerciseTemplates.id));

  $$ExerciseTemplatesTableProcessedTableManager get exerciseTemplateId {
    final $_column = $_itemColumn<String>('exercise_template_id')!;

    final manager =
        $$ExerciseTemplatesTableTableManager($_db, $_db.exerciseTemplates)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseTemplateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$WorkoutPlannedSetsTable,
      List<WorkoutPlannedSetRow>> _workoutPlannedSetsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.workoutPlannedSets,
          aliasName: $_aliasNameGenerator(
              db.workoutShapeExercises.shapeExerciseId,
              db.workoutPlannedSets.shapeExerciseId));

  $$WorkoutPlannedSetsTableProcessedTableManager get workoutPlannedSetsRefs {
    final manager =
        $$WorkoutPlannedSetsTableTableManager($_db, $_db.workoutPlannedSets)
            .filter((f) => f.shapeExerciseId.shapeExerciseId
                .sqlEquals($_itemColumn<String>('shape_exercise_id')!));

    final cache =
        $_typedResult.readTableOrNull(_workoutPlannedSetsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$WorkoutShapeExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutShapeExercisesTable> {
  $$WorkoutShapeExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get shapeExerciseId => $composableBuilder(
      column: $table.shapeExerciseId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnFilters(column));

  $$WorkoutShapeNodesTableFilterComposer get shapeId {
    final $$WorkoutShapeNodesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shapeId,
        referencedTable: $db.workoutShapeNodes,
        getReferencedColumn: (t) => t.shapeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutShapeNodesTableFilterComposer(
              $db: $db,
              $table: $db.workoutShapeNodes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExerciseTemplatesTableFilterComposer get exerciseTemplateId {
    final $$ExerciseTemplatesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.exerciseTemplateId,
        referencedTable: $db.exerciseTemplates,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExerciseTemplatesTableFilterComposer(
              $db: $db,
              $table: $db.exerciseTemplates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> workoutPlannedSetsRefs(
      Expression<bool> Function($$WorkoutPlannedSetsTableFilterComposer f) f) {
    final $$WorkoutPlannedSetsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shapeExerciseId,
        referencedTable: $db.workoutPlannedSets,
        getReferencedColumn: (t) => t.shapeExerciseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutPlannedSetsTableFilterComposer(
              $db: $db,
              $table: $db.workoutPlannedSets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WorkoutShapeExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutShapeExercisesTable> {
  $$WorkoutShapeExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get shapeExerciseId => $composableBuilder(
      column: $table.shapeExerciseId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnOrderings(column));

  $$WorkoutShapeNodesTableOrderingComposer get shapeId {
    final $$WorkoutShapeNodesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.shapeId,
        referencedTable: $db.workoutShapeNodes,
        getReferencedColumn: (t) => t.shapeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutShapeNodesTableOrderingComposer(
              $db: $db,
              $table: $db.workoutShapeNodes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExerciseTemplatesTableOrderingComposer get exerciseTemplateId {
    final $$ExerciseTemplatesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.exerciseTemplateId,
        referencedTable: $db.exerciseTemplates,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExerciseTemplatesTableOrderingComposer(
              $db: $db,
              $table: $db.exerciseTemplates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorkoutShapeExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutShapeExercisesTable> {
  $$WorkoutShapeExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get shapeExerciseId => $composableBuilder(
      column: $table.shapeExerciseId, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => column);

  $$WorkoutShapeNodesTableAnnotationComposer get shapeId {
    final $$WorkoutShapeNodesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.shapeId,
            referencedTable: $db.workoutShapeNodes,
            getReferencedColumn: (t) => t.shapeId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$WorkoutShapeNodesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.workoutShapeNodes,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  $$ExerciseTemplatesTableAnnotationComposer get exerciseTemplateId {
    final $$ExerciseTemplatesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.exerciseTemplateId,
            referencedTable: $db.exerciseTemplates,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ExerciseTemplatesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.exerciseTemplates,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  Expression<T> workoutPlannedSetsRefs<T extends Object>(
      Expression<T> Function($$WorkoutPlannedSetsTableAnnotationComposer a) f) {
    final $$WorkoutPlannedSetsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.shapeExerciseId,
            referencedTable: $db.workoutPlannedSets,
            getReferencedColumn: (t) => t.shapeExerciseId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$WorkoutPlannedSetsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.workoutPlannedSets,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$WorkoutShapeExercisesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkoutShapeExercisesTable,
    WorkoutShapeExerciseRow,
    $$WorkoutShapeExercisesTableFilterComposer,
    $$WorkoutShapeExercisesTableOrderingComposer,
    $$WorkoutShapeExercisesTableAnnotationComposer,
    $$WorkoutShapeExercisesTableCreateCompanionBuilder,
    $$WorkoutShapeExercisesTableUpdateCompanionBuilder,
    (WorkoutShapeExerciseRow, $$WorkoutShapeExercisesTableReferences),
    WorkoutShapeExerciseRow,
    PrefetchHooks Function(
        {bool shapeId, bool exerciseTemplateId, bool workoutPlannedSetsRefs})> {
  $$WorkoutShapeExercisesTableTableManager(
      _$AppDatabase db, $WorkoutShapeExercisesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutShapeExercisesTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutShapeExercisesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutShapeExercisesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> shapeExerciseId = const Value.absent(),
            Value<String> shapeId = const Value.absent(),
            Value<String> exerciseTemplateId = const Value.absent(),
            Value<int> orderIndex = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutShapeExercisesCompanion(
            shapeExerciseId: shapeExerciseId,
            shapeId: shapeId,
            exerciseTemplateId: exerciseTemplateId,
            orderIndex: orderIndex,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String shapeExerciseId,
            required String shapeId,
            required String exerciseTemplateId,
            required int orderIndex,
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutShapeExercisesCompanion.insert(
            shapeExerciseId: shapeExerciseId,
            shapeId: shapeId,
            exerciseTemplateId: exerciseTemplateId,
            orderIndex: orderIndex,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WorkoutShapeExercisesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {shapeId = false,
              exerciseTemplateId = false,
              workoutPlannedSetsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (workoutPlannedSetsRefs) db.workoutPlannedSets
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (shapeId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.shapeId,
                    referencedTable: $$WorkoutShapeExercisesTableReferences
                        ._shapeIdTable(db),
                    referencedColumn: $$WorkoutShapeExercisesTableReferences
                        ._shapeIdTable(db)
                        .shapeId,
                  ) as T;
                }
                if (exerciseTemplateId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.exerciseTemplateId,
                    referencedTable: $$WorkoutShapeExercisesTableReferences
                        ._exerciseTemplateIdTable(db),
                    referencedColumn: $$WorkoutShapeExercisesTableReferences
                        ._exerciseTemplateIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (workoutPlannedSetsRefs)
                    await $_getPrefetchedData<WorkoutShapeExerciseRow,
                            $WorkoutShapeExercisesTable, WorkoutPlannedSetRow>(
                        currentTable: table,
                        referencedTable: $$WorkoutShapeExercisesTableReferences
                            ._workoutPlannedSetsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WorkoutShapeExercisesTableReferences(
                                    db, table, p0)
                                .workoutPlannedSetsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems.where(
                                (e) =>
                                    e.shapeExerciseId == item.shapeExerciseId),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$WorkoutShapeExercisesTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $WorkoutShapeExercisesTable,
        WorkoutShapeExerciseRow,
        $$WorkoutShapeExercisesTableFilterComposer,
        $$WorkoutShapeExercisesTableOrderingComposer,
        $$WorkoutShapeExercisesTableAnnotationComposer,
        $$WorkoutShapeExercisesTableCreateCompanionBuilder,
        $$WorkoutShapeExercisesTableUpdateCompanionBuilder,
        (WorkoutShapeExerciseRow, $$WorkoutShapeExercisesTableReferences),
        WorkoutShapeExerciseRow,
        PrefetchHooks Function(
            {bool shapeId,
            bool exerciseTemplateId,
            bool workoutPlannedSetsRefs})>;
typedef $$WorkoutPlannedSetsTableCreateCompanionBuilder
    = WorkoutPlannedSetsCompanion Function({
  required String setId,
  required String shapeExerciseId,
  required int orderIndex,
  Value<String> metricDefaultsJson,
  Value<int> rowid,
});
typedef $$WorkoutPlannedSetsTableUpdateCompanionBuilder
    = WorkoutPlannedSetsCompanion Function({
  Value<String> setId,
  Value<String> shapeExerciseId,
  Value<int> orderIndex,
  Value<String> metricDefaultsJson,
  Value<int> rowid,
});

final class $$WorkoutPlannedSetsTableReferences extends BaseReferences<
    _$AppDatabase, $WorkoutPlannedSetsTable, WorkoutPlannedSetRow> {
  $$WorkoutPlannedSetsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutShapeExercisesTable _shapeExerciseIdTable(_$AppDatabase db) =>
      db.workoutShapeExercises.createAlias($_aliasNameGenerator(
          db.workoutPlannedSets.shapeExerciseId,
          db.workoutShapeExercises.shapeExerciseId));

  $$WorkoutShapeExercisesTableProcessedTableManager get shapeExerciseId {
    final $_column = $_itemColumn<String>('shape_exercise_id')!;

    final manager = $$WorkoutShapeExercisesTableTableManager(
            $_db, $_db.workoutShapeExercises)
        .filter((f) => f.shapeExerciseId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shapeExerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$WorkoutPlannedSetsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutPlannedSetsTable> {
  $$WorkoutPlannedSetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get setId => $composableBuilder(
      column: $table.setId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metricDefaultsJson => $composableBuilder(
      column: $table.metricDefaultsJson,
      builder: (column) => ColumnFilters(column));

  $$WorkoutShapeExercisesTableFilterComposer get shapeExerciseId {
    final $$WorkoutShapeExercisesTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.shapeExerciseId,
            referencedTable: $db.workoutShapeExercises,
            getReferencedColumn: (t) => t.shapeExerciseId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$WorkoutShapeExercisesTableFilterComposer(
                  $db: $db,
                  $table: $db.workoutShapeExercises,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$WorkoutPlannedSetsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutPlannedSetsTable> {
  $$WorkoutPlannedSetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get setId => $composableBuilder(
      column: $table.setId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metricDefaultsJson => $composableBuilder(
      column: $table.metricDefaultsJson,
      builder: (column) => ColumnOrderings(column));

  $$WorkoutShapeExercisesTableOrderingComposer get shapeExerciseId {
    final $$WorkoutShapeExercisesTableOrderingComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.shapeExerciseId,
            referencedTable: $db.workoutShapeExercises,
            getReferencedColumn: (t) => t.shapeExerciseId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$WorkoutShapeExercisesTableOrderingComposer(
                  $db: $db,
                  $table: $db.workoutShapeExercises,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$WorkoutPlannedSetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutPlannedSetsTable> {
  $$WorkoutPlannedSetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get setId =>
      $composableBuilder(column: $table.setId, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => column);

  GeneratedColumn<String> get metricDefaultsJson => $composableBuilder(
      column: $table.metricDefaultsJson, builder: (column) => column);

  $$WorkoutShapeExercisesTableAnnotationComposer get shapeExerciseId {
    final $$WorkoutShapeExercisesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.shapeExerciseId,
            referencedTable: $db.workoutShapeExercises,
            getReferencedColumn: (t) => t.shapeExerciseId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$WorkoutShapeExercisesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.workoutShapeExercises,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$WorkoutPlannedSetsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkoutPlannedSetsTable,
    WorkoutPlannedSetRow,
    $$WorkoutPlannedSetsTableFilterComposer,
    $$WorkoutPlannedSetsTableOrderingComposer,
    $$WorkoutPlannedSetsTableAnnotationComposer,
    $$WorkoutPlannedSetsTableCreateCompanionBuilder,
    $$WorkoutPlannedSetsTableUpdateCompanionBuilder,
    (WorkoutPlannedSetRow, $$WorkoutPlannedSetsTableReferences),
    WorkoutPlannedSetRow,
    PrefetchHooks Function({bool shapeExerciseId})> {
  $$WorkoutPlannedSetsTableTableManager(
      _$AppDatabase db, $WorkoutPlannedSetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutPlannedSetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutPlannedSetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutPlannedSetsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> setId = const Value.absent(),
            Value<String> shapeExerciseId = const Value.absent(),
            Value<int> orderIndex = const Value.absent(),
            Value<String> metricDefaultsJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutPlannedSetsCompanion(
            setId: setId,
            shapeExerciseId: shapeExerciseId,
            orderIndex: orderIndex,
            metricDefaultsJson: metricDefaultsJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String setId,
            required String shapeExerciseId,
            required int orderIndex,
            Value<String> metricDefaultsJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutPlannedSetsCompanion.insert(
            setId: setId,
            shapeExerciseId: shapeExerciseId,
            orderIndex: orderIndex,
            metricDefaultsJson: metricDefaultsJson,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WorkoutPlannedSetsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({shapeExerciseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (shapeExerciseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.shapeExerciseId,
                    referencedTable: $$WorkoutPlannedSetsTableReferences
                        ._shapeExerciseIdTable(db),
                    referencedColumn: $$WorkoutPlannedSetsTableReferences
                        ._shapeExerciseIdTable(db)
                        .shapeExerciseId,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$WorkoutPlannedSetsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WorkoutPlannedSetsTable,
    WorkoutPlannedSetRow,
    $$WorkoutPlannedSetsTableFilterComposer,
    $$WorkoutPlannedSetsTableOrderingComposer,
    $$WorkoutPlannedSetsTableAnnotationComposer,
    $$WorkoutPlannedSetsTableCreateCompanionBuilder,
    $$WorkoutPlannedSetsTableUpdateCompanionBuilder,
    (WorkoutPlannedSetRow, $$WorkoutPlannedSetsTableReferences),
    WorkoutPlannedSetRow,
    PrefetchHooks Function({bool shapeExerciseId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ExerciseTemplatesTableTableManager get exerciseTemplates =>
      $$ExerciseTemplatesTableTableManager(_db, _db.exerciseTemplates);
  $$ExerciseMetricConfigsTableTableManager get exerciseMetricConfigs =>
      $$ExerciseMetricConfigsTableTableManager(_db, _db.exerciseMetricConfigs);
  $$WorkoutTemplatesTableTableManager get workoutTemplates =>
      $$WorkoutTemplatesTableTableManager(_db, _db.workoutTemplates);
  $$WorkoutShapeNodesTableTableManager get workoutShapeNodes =>
      $$WorkoutShapeNodesTableTableManager(_db, _db.workoutShapeNodes);
  $$WorkoutExerciseSlotsTableTableManager get workoutExerciseSlots =>
      $$WorkoutExerciseSlotsTableTableManager(_db, _db.workoutExerciseSlots);
  $$WorkoutShapeExercisesTableTableManager get workoutShapeExercises =>
      $$WorkoutShapeExercisesTableTableManager(_db, _db.workoutShapeExercises);
  $$WorkoutPlannedSetsTableTableManager get workoutPlannedSets =>
      $$WorkoutPlannedSetsTableTableManager(_db, _db.workoutPlannedSets);
}
