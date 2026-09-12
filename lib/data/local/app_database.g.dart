// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $VocabularySetsTable extends VocabularySets
    with TableInfo<$VocabularySetsTable, VocabularySet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VocabularySetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceLangMeta = const VerificationMeta(
    'sourceLang',
  );
  @override
  late final GeneratedColumn<String> sourceLang = GeneratedColumn<String>(
    'source_lang',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetLangMeta = const VerificationMeta(
    'targetLang',
  );
  @override
  late final GeneratedColumn<String> targetLang = GeneratedColumn<String>(
    'target_lang',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultDirectionMeta = const VerificationMeta(
    'defaultDirection',
  );
  @override
  late final GeneratedColumn<String> defaultDirection = GeneratedColumn<String>(
    'default_direction',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('foreign_to_de'),
  );
  static const VerificationMeta _coverColorMeta = const VerificationMeta(
    'coverColor',
  );
  @override
  late final GeneratedColumn<int> coverColor = GeneratedColumn<int>(
    'cover_color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0xFF0A5A5C),
  );
  static const VerificationMeta _coverShapeMeta = const VerificationMeta(
    'coverShape',
  );
  @override
  late final GeneratedColumn<String> coverShape = GeneratedColumn<String>(
    'cover_shape',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('asymmetric'),
  );
  static const VerificationMeta _lastProgressMeta = const VerificationMeta(
    'lastProgress',
  );
  @override
  late final GeneratedColumn<double> lastProgress = GeneratedColumn<double>(
    'last_progress',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    sourceLang,
    targetLang,
    defaultDirection,
    coverColor,
    coverShape,
    lastProgress,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vocabulary_sets';
  @override
  VerificationContext validateIntegrity(
    Insertable<VocabularySet> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('source_lang')) {
      context.handle(
        _sourceLangMeta,
        sourceLang.isAcceptableOrUnknown(data['source_lang']!, _sourceLangMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceLangMeta);
    }
    if (data.containsKey('target_lang')) {
      context.handle(
        _targetLangMeta,
        targetLang.isAcceptableOrUnknown(data['target_lang']!, _targetLangMeta),
      );
    } else if (isInserting) {
      context.missing(_targetLangMeta);
    }
    if (data.containsKey('default_direction')) {
      context.handle(
        _defaultDirectionMeta,
        defaultDirection.isAcceptableOrUnknown(
          data['default_direction']!,
          _defaultDirectionMeta,
        ),
      );
    }
    if (data.containsKey('cover_color')) {
      context.handle(
        _coverColorMeta,
        coverColor.isAcceptableOrUnknown(data['cover_color']!, _coverColorMeta),
      );
    }
    if (data.containsKey('cover_shape')) {
      context.handle(
        _coverShapeMeta,
        coverShape.isAcceptableOrUnknown(data['cover_shape']!, _coverShapeMeta),
      );
    }
    if (data.containsKey('last_progress')) {
      context.handle(
        _lastProgressMeta,
        lastProgress.isAcceptableOrUnknown(
          data['last_progress']!,
          _lastProgressMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VocabularySet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VocabularySet(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sourceLang: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_lang'],
      )!,
      targetLang: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_lang'],
      )!,
      defaultDirection: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_direction'],
      )!,
      coverColor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cover_color'],
      )!,
      coverShape: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_shape'],
      )!,
      lastProgress: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}last_progress'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $VocabularySetsTable createAlias(String alias) {
    return $VocabularySetsTable(attachedDatabase, alias);
  }
}

class VocabularySet extends DataClass implements Insertable<VocabularySet> {
  final String id;
  final String name;
  final String sourceLang;
  final String targetLang;
  final String defaultDirection;
  final int coverColor;
  final String coverShape;
  final double lastProgress;
  final DateTime createdAt;
  final DateTime updatedAt;
  const VocabularySet({
    required this.id,
    required this.name,
    required this.sourceLang,
    required this.targetLang,
    required this.defaultDirection,
    required this.coverColor,
    required this.coverShape,
    required this.lastProgress,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['source_lang'] = Variable<String>(sourceLang);
    map['target_lang'] = Variable<String>(targetLang);
    map['default_direction'] = Variable<String>(defaultDirection);
    map['cover_color'] = Variable<int>(coverColor);
    map['cover_shape'] = Variable<String>(coverShape);
    map['last_progress'] = Variable<double>(lastProgress);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  VocabularySetsCompanion toCompanion(bool nullToAbsent) {
    return VocabularySetsCompanion(
      id: Value(id),
      name: Value(name),
      sourceLang: Value(sourceLang),
      targetLang: Value(targetLang),
      defaultDirection: Value(defaultDirection),
      coverColor: Value(coverColor),
      coverShape: Value(coverShape),
      lastProgress: Value(lastProgress),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory VocabularySet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VocabularySet(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sourceLang: serializer.fromJson<String>(json['sourceLang']),
      targetLang: serializer.fromJson<String>(json['targetLang']),
      defaultDirection: serializer.fromJson<String>(json['defaultDirection']),
      coverColor: serializer.fromJson<int>(json['coverColor']),
      coverShape: serializer.fromJson<String>(json['coverShape']),
      lastProgress: serializer.fromJson<double>(json['lastProgress']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'sourceLang': serializer.toJson<String>(sourceLang),
      'targetLang': serializer.toJson<String>(targetLang),
      'defaultDirection': serializer.toJson<String>(defaultDirection),
      'coverColor': serializer.toJson<int>(coverColor),
      'coverShape': serializer.toJson<String>(coverShape),
      'lastProgress': serializer.toJson<double>(lastProgress),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  VocabularySet copyWith({
    String? id,
    String? name,
    String? sourceLang,
    String? targetLang,
    String? defaultDirection,
    int? coverColor,
    String? coverShape,
    double? lastProgress,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => VocabularySet(
    id: id ?? this.id,
    name: name ?? this.name,
    sourceLang: sourceLang ?? this.sourceLang,
    targetLang: targetLang ?? this.targetLang,
    defaultDirection: defaultDirection ?? this.defaultDirection,
    coverColor: coverColor ?? this.coverColor,
    coverShape: coverShape ?? this.coverShape,
    lastProgress: lastProgress ?? this.lastProgress,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  VocabularySet copyWithCompanion(VocabularySetsCompanion data) {
    return VocabularySet(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      sourceLang: data.sourceLang.present
          ? data.sourceLang.value
          : this.sourceLang,
      targetLang: data.targetLang.present
          ? data.targetLang.value
          : this.targetLang,
      defaultDirection: data.defaultDirection.present
          ? data.defaultDirection.value
          : this.defaultDirection,
      coverColor: data.coverColor.present
          ? data.coverColor.value
          : this.coverColor,
      coverShape: data.coverShape.present
          ? data.coverShape.value
          : this.coverShape,
      lastProgress: data.lastProgress.present
          ? data.lastProgress.value
          : this.lastProgress,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VocabularySet(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sourceLang: $sourceLang, ')
          ..write('targetLang: $targetLang, ')
          ..write('defaultDirection: $defaultDirection, ')
          ..write('coverColor: $coverColor, ')
          ..write('coverShape: $coverShape, ')
          ..write('lastProgress: $lastProgress, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    sourceLang,
    targetLang,
    defaultDirection,
    coverColor,
    coverShape,
    lastProgress,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VocabularySet &&
          other.id == this.id &&
          other.name == this.name &&
          other.sourceLang == this.sourceLang &&
          other.targetLang == this.targetLang &&
          other.defaultDirection == this.defaultDirection &&
          other.coverColor == this.coverColor &&
          other.coverShape == this.coverShape &&
          other.lastProgress == this.lastProgress &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class VocabularySetsCompanion extends UpdateCompanion<VocabularySet> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> sourceLang;
  final Value<String> targetLang;
  final Value<String> defaultDirection;
  final Value<int> coverColor;
  final Value<String> coverShape;
  final Value<double> lastProgress;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const VocabularySetsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sourceLang = const Value.absent(),
    this.targetLang = const Value.absent(),
    this.defaultDirection = const Value.absent(),
    this.coverColor = const Value.absent(),
    this.coverShape = const Value.absent(),
    this.lastProgress = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VocabularySetsCompanion.insert({
    required String id,
    required String name,
    required String sourceLang,
    required String targetLang,
    this.defaultDirection = const Value.absent(),
    this.coverColor = const Value.absent(),
    this.coverShape = const Value.absent(),
    this.lastProgress = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       sourceLang = Value(sourceLang),
       targetLang = Value(targetLang),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<VocabularySet> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? sourceLang,
    Expression<String>? targetLang,
    Expression<String>? defaultDirection,
    Expression<int>? coverColor,
    Expression<String>? coverShape,
    Expression<double>? lastProgress,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sourceLang != null) 'source_lang': sourceLang,
      if (targetLang != null) 'target_lang': targetLang,
      if (defaultDirection != null) 'default_direction': defaultDirection,
      if (coverColor != null) 'cover_color': coverColor,
      if (coverShape != null) 'cover_shape': coverShape,
      if (lastProgress != null) 'last_progress': lastProgress,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VocabularySetsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? sourceLang,
    Value<String>? targetLang,
    Value<String>? defaultDirection,
    Value<int>? coverColor,
    Value<String>? coverShape,
    Value<double>? lastProgress,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return VocabularySetsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sourceLang: sourceLang ?? this.sourceLang,
      targetLang: targetLang ?? this.targetLang,
      defaultDirection: defaultDirection ?? this.defaultDirection,
      coverColor: coverColor ?? this.coverColor,
      coverShape: coverShape ?? this.coverShape,
      lastProgress: lastProgress ?? this.lastProgress,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (sourceLang.present) {
      map['source_lang'] = Variable<String>(sourceLang.value);
    }
    if (targetLang.present) {
      map['target_lang'] = Variable<String>(targetLang.value);
    }
    if (defaultDirection.present) {
      map['default_direction'] = Variable<String>(defaultDirection.value);
    }
    if (coverColor.present) {
      map['cover_color'] = Variable<int>(coverColor.value);
    }
    if (coverShape.present) {
      map['cover_shape'] = Variable<String>(coverShape.value);
    }
    if (lastProgress.present) {
      map['last_progress'] = Variable<double>(lastProgress.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VocabularySetsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sourceLang: $sourceLang, ')
          ..write('targetLang: $targetLang, ')
          ..write('defaultDirection: $defaultDirection, ')
          ..write('coverColor: $coverColor, ')
          ..write('coverShape: $coverShape, ')
          ..write('lastProgress: $lastProgress, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VocabularyItemsTable extends VocabularyItems
    with TableInfo<$VocabularyItemsTable, VocabularyItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VocabularyItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setIdMeta = const VerificationMeta('setId');
  @override
  late final GeneratedColumn<String> setId = GeneratedColumn<String>(
    'set_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vocabulary_sets (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _sourceTextMeta = const VerificationMeta(
    'sourceText',
  );
  @override
  late final GeneratedColumn<String> sourceText = GeneratedColumn<String>(
    'source_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetTextMeta = const VerificationMeta(
    'targetText',
  );
  @override
  late final GeneratedColumn<String> targetText = GeneratedColumn<String>(
    'target_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceLangMeta = const VerificationMeta(
    'sourceLang',
  );
  @override
  late final GeneratedColumn<String> sourceLang = GeneratedColumn<String>(
    'source_lang',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetLangMeta = const VerificationMeta(
    'targetLang',
  );
  @override
  late final GeneratedColumn<String> targetLang = GeneratedColumn<String>(
    'target_lang',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _directionOverrideMeta = const VerificationMeta(
    'directionOverride',
  );
  @override
  late final GeneratedColumn<String> directionOverride =
      GeneratedColumn<String>(
        'direction_override',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _exampleSentenceSourceMeta =
      const VerificationMeta('exampleSentenceSource');
  @override
  late final GeneratedColumn<String> exampleSentenceSource =
      GeneratedColumn<String>(
        'example_sentence_source',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _exampleSentenceTargetMeta =
      const VerificationMeta('exampleSentenceTarget');
  @override
  late final GeneratedColumn<String> exampleSentenceTarget =
      GeneratedColumn<String>(
        'example_sentence_target',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _sourceOriginMeta = const VerificationMeta(
    'sourceOrigin',
  );
  @override
  late final GeneratedColumn<String> sourceOrigin = GeneratedColumn<String>(
    'source_origin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  static const VerificationMeta _sourceImagePathMeta = const VerificationMeta(
    'sourceImagePath',
  );
  @override
  late final GeneratedColumn<String> sourceImagePath = GeneratedColumn<String>(
    'source_image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
    'due_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intervalDaysMeta = const VerificationMeta(
    'intervalDays',
  );
  @override
  late final GeneratedColumn<int> intervalDays = GeneratedColumn<int>(
    'interval_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _easeMeta = const VerificationMeta('ease');
  @override
  late final GeneratedColumn<double> ease = GeneratedColumn<double>(
    'ease',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(2.5),
  );
  static const VerificationMeta _repetitionsMeta = const VerificationMeta(
    'repetitions',
  );
  @override
  late final GeneratedColumn<int> repetitions = GeneratedColumn<int>(
    'repetitions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lapsesMeta = const VerificationMeta('lapses');
  @override
  late final GeneratedColumn<int> lapses = GeneratedColumn<int>(
    'lapses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('new'),
  );
  static const VerificationMeta _typingEnabledMeta = const VerificationMeta(
    'typingEnabled',
  );
  @override
  late final GeneratedColumn<bool> typingEnabled = GeneratedColumn<bool>(
    'typing_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("typing_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    setId,
    sourceText,
    targetText,
    sourceLang,
    targetLang,
    directionOverride,
    exampleSentenceSource,
    exampleSentenceTarget,
    notes,
    tags,
    sourceOrigin,
    sourceImagePath,
    createdAt,
    updatedAt,
    dueAt,
    intervalDays,
    ease,
    repetitions,
    lapses,
    status,
    typingEnabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vocabulary_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<VocabularyItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('set_id')) {
      context.handle(
        _setIdMeta,
        setId.isAcceptableOrUnknown(data['set_id']!, _setIdMeta),
      );
    } else if (isInserting) {
      context.missing(_setIdMeta);
    }
    if (data.containsKey('source_text')) {
      context.handle(
        _sourceTextMeta,
        sourceText.isAcceptableOrUnknown(data['source_text']!, _sourceTextMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceTextMeta);
    }
    if (data.containsKey('target_text')) {
      context.handle(
        _targetTextMeta,
        targetText.isAcceptableOrUnknown(data['target_text']!, _targetTextMeta),
      );
    } else if (isInserting) {
      context.missing(_targetTextMeta);
    }
    if (data.containsKey('source_lang')) {
      context.handle(
        _sourceLangMeta,
        sourceLang.isAcceptableOrUnknown(data['source_lang']!, _sourceLangMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceLangMeta);
    }
    if (data.containsKey('target_lang')) {
      context.handle(
        _targetLangMeta,
        targetLang.isAcceptableOrUnknown(data['target_lang']!, _targetLangMeta),
      );
    } else if (isInserting) {
      context.missing(_targetLangMeta);
    }
    if (data.containsKey('direction_override')) {
      context.handle(
        _directionOverrideMeta,
        directionOverride.isAcceptableOrUnknown(
          data['direction_override']!,
          _directionOverrideMeta,
        ),
      );
    }
    if (data.containsKey('example_sentence_source')) {
      context.handle(
        _exampleSentenceSourceMeta,
        exampleSentenceSource.isAcceptableOrUnknown(
          data['example_sentence_source']!,
          _exampleSentenceSourceMeta,
        ),
      );
    }
    if (data.containsKey('example_sentence_target')) {
      context.handle(
        _exampleSentenceTargetMeta,
        exampleSentenceTarget.isAcceptableOrUnknown(
          data['example_sentence_target']!,
          _exampleSentenceTargetMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('source_origin')) {
      context.handle(
        _sourceOriginMeta,
        sourceOrigin.isAcceptableOrUnknown(
          data['source_origin']!,
          _sourceOriginMeta,
        ),
      );
    }
    if (data.containsKey('source_image_path')) {
      context.handle(
        _sourceImagePathMeta,
        sourceImagePath.isAcceptableOrUnknown(
          data['source_image_path']!,
          _sourceImagePathMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('due_at')) {
      context.handle(
        _dueAtMeta,
        dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta),
      );
    } else if (isInserting) {
      context.missing(_dueAtMeta);
    }
    if (data.containsKey('interval_days')) {
      context.handle(
        _intervalDaysMeta,
        intervalDays.isAcceptableOrUnknown(
          data['interval_days']!,
          _intervalDaysMeta,
        ),
      );
    }
    if (data.containsKey('ease')) {
      context.handle(
        _easeMeta,
        ease.isAcceptableOrUnknown(data['ease']!, _easeMeta),
      );
    }
    if (data.containsKey('repetitions')) {
      context.handle(
        _repetitionsMeta,
        repetitions.isAcceptableOrUnknown(
          data['repetitions']!,
          _repetitionsMeta,
        ),
      );
    }
    if (data.containsKey('lapses')) {
      context.handle(
        _lapsesMeta,
        lapses.isAcceptableOrUnknown(data['lapses']!, _lapsesMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('typing_enabled')) {
      context.handle(
        _typingEnabledMeta,
        typingEnabled.isAcceptableOrUnknown(
          data['typing_enabled']!,
          _typingEnabledMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VocabularyItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VocabularyItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      setId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}set_id'],
      )!,
      sourceText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_text'],
      )!,
      targetText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_text'],
      )!,
      sourceLang: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_lang'],
      )!,
      targetLang: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_lang'],
      )!,
      directionOverride: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direction_override'],
      ),
      exampleSentenceSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}example_sentence_source'],
      ),
      exampleSentenceTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}example_sentence_target'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      )!,
      sourceOrigin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_origin'],
      )!,
      sourceImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_image_path'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      dueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_at'],
      )!,
      intervalDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_days'],
      )!,
      ease: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ease'],
      )!,
      repetitions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repetitions'],
      )!,
      lapses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lapses'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      typingEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}typing_enabled'],
      )!,
    );
  }

  @override
  $VocabularyItemsTable createAlias(String alias) {
    return $VocabularyItemsTable(attachedDatabase, alias);
  }
}

class VocabularyItem extends DataClass implements Insertable<VocabularyItem> {
  final String id;
  final String setId;
  final String sourceText;
  final String targetText;
  final String sourceLang;
  final String targetLang;
  final String? directionOverride;
  final String? exampleSentenceSource;
  final String? exampleSentenceTarget;
  final String notes;
  final String tags;
  final String sourceOrigin;
  final String? sourceImagePath;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime dueAt;
  final int intervalDays;
  final double ease;
  final int repetitions;
  final int lapses;
  final String status;
  final bool typingEnabled;
  const VocabularyItem({
    required this.id,
    required this.setId,
    required this.sourceText,
    required this.targetText,
    required this.sourceLang,
    required this.targetLang,
    this.directionOverride,
    this.exampleSentenceSource,
    this.exampleSentenceTarget,
    required this.notes,
    required this.tags,
    required this.sourceOrigin,
    this.sourceImagePath,
    required this.createdAt,
    required this.updatedAt,
    required this.dueAt,
    required this.intervalDays,
    required this.ease,
    required this.repetitions,
    required this.lapses,
    required this.status,
    required this.typingEnabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['set_id'] = Variable<String>(setId);
    map['source_text'] = Variable<String>(sourceText);
    map['target_text'] = Variable<String>(targetText);
    map['source_lang'] = Variable<String>(sourceLang);
    map['target_lang'] = Variable<String>(targetLang);
    if (!nullToAbsent || directionOverride != null) {
      map['direction_override'] = Variable<String>(directionOverride);
    }
    if (!nullToAbsent || exampleSentenceSource != null) {
      map['example_sentence_source'] = Variable<String>(exampleSentenceSource);
    }
    if (!nullToAbsent || exampleSentenceTarget != null) {
      map['example_sentence_target'] = Variable<String>(exampleSentenceTarget);
    }
    map['notes'] = Variable<String>(notes);
    map['tags'] = Variable<String>(tags);
    map['source_origin'] = Variable<String>(sourceOrigin);
    if (!nullToAbsent || sourceImagePath != null) {
      map['source_image_path'] = Variable<String>(sourceImagePath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['due_at'] = Variable<DateTime>(dueAt);
    map['interval_days'] = Variable<int>(intervalDays);
    map['ease'] = Variable<double>(ease);
    map['repetitions'] = Variable<int>(repetitions);
    map['lapses'] = Variable<int>(lapses);
    map['status'] = Variable<String>(status);
    map['typing_enabled'] = Variable<bool>(typingEnabled);
    return map;
  }

  VocabularyItemsCompanion toCompanion(bool nullToAbsent) {
    return VocabularyItemsCompanion(
      id: Value(id),
      setId: Value(setId),
      sourceText: Value(sourceText),
      targetText: Value(targetText),
      sourceLang: Value(sourceLang),
      targetLang: Value(targetLang),
      directionOverride: directionOverride == null && nullToAbsent
          ? const Value.absent()
          : Value(directionOverride),
      exampleSentenceSource: exampleSentenceSource == null && nullToAbsent
          ? const Value.absent()
          : Value(exampleSentenceSource),
      exampleSentenceTarget: exampleSentenceTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(exampleSentenceTarget),
      notes: Value(notes),
      tags: Value(tags),
      sourceOrigin: Value(sourceOrigin),
      sourceImagePath: sourceImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceImagePath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      dueAt: Value(dueAt),
      intervalDays: Value(intervalDays),
      ease: Value(ease),
      repetitions: Value(repetitions),
      lapses: Value(lapses),
      status: Value(status),
      typingEnabled: Value(typingEnabled),
    );
  }

  factory VocabularyItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VocabularyItem(
      id: serializer.fromJson<String>(json['id']),
      setId: serializer.fromJson<String>(json['setId']),
      sourceText: serializer.fromJson<String>(json['sourceText']),
      targetText: serializer.fromJson<String>(json['targetText']),
      sourceLang: serializer.fromJson<String>(json['sourceLang']),
      targetLang: serializer.fromJson<String>(json['targetLang']),
      directionOverride: serializer.fromJson<String?>(
        json['directionOverride'],
      ),
      exampleSentenceSource: serializer.fromJson<String?>(
        json['exampleSentenceSource'],
      ),
      exampleSentenceTarget: serializer.fromJson<String?>(
        json['exampleSentenceTarget'],
      ),
      notes: serializer.fromJson<String>(json['notes']),
      tags: serializer.fromJson<String>(json['tags']),
      sourceOrigin: serializer.fromJson<String>(json['sourceOrigin']),
      sourceImagePath: serializer.fromJson<String?>(json['sourceImagePath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      dueAt: serializer.fromJson<DateTime>(json['dueAt']),
      intervalDays: serializer.fromJson<int>(json['intervalDays']),
      ease: serializer.fromJson<double>(json['ease']),
      repetitions: serializer.fromJson<int>(json['repetitions']),
      lapses: serializer.fromJson<int>(json['lapses']),
      status: serializer.fromJson<String>(json['status']),
      typingEnabled: serializer.fromJson<bool>(json['typingEnabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'setId': serializer.toJson<String>(setId),
      'sourceText': serializer.toJson<String>(sourceText),
      'targetText': serializer.toJson<String>(targetText),
      'sourceLang': serializer.toJson<String>(sourceLang),
      'targetLang': serializer.toJson<String>(targetLang),
      'directionOverride': serializer.toJson<String?>(directionOverride),
      'exampleSentenceSource': serializer.toJson<String?>(
        exampleSentenceSource,
      ),
      'exampleSentenceTarget': serializer.toJson<String?>(
        exampleSentenceTarget,
      ),
      'notes': serializer.toJson<String>(notes),
      'tags': serializer.toJson<String>(tags),
      'sourceOrigin': serializer.toJson<String>(sourceOrigin),
      'sourceImagePath': serializer.toJson<String?>(sourceImagePath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'dueAt': serializer.toJson<DateTime>(dueAt),
      'intervalDays': serializer.toJson<int>(intervalDays),
      'ease': serializer.toJson<double>(ease),
      'repetitions': serializer.toJson<int>(repetitions),
      'lapses': serializer.toJson<int>(lapses),
      'status': serializer.toJson<String>(status),
      'typingEnabled': serializer.toJson<bool>(typingEnabled),
    };
  }

  VocabularyItem copyWith({
    String? id,
    String? setId,
    String? sourceText,
    String? targetText,
    String? sourceLang,
    String? targetLang,
    Value<String?> directionOverride = const Value.absent(),
    Value<String?> exampleSentenceSource = const Value.absent(),
    Value<String?> exampleSentenceTarget = const Value.absent(),
    String? notes,
    String? tags,
    String? sourceOrigin,
    Value<String?> sourceImagePath = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dueAt,
    int? intervalDays,
    double? ease,
    int? repetitions,
    int? lapses,
    String? status,
    bool? typingEnabled,
  }) => VocabularyItem(
    id: id ?? this.id,
    setId: setId ?? this.setId,
    sourceText: sourceText ?? this.sourceText,
    targetText: targetText ?? this.targetText,
    sourceLang: sourceLang ?? this.sourceLang,
    targetLang: targetLang ?? this.targetLang,
    directionOverride: directionOverride.present
        ? directionOverride.value
        : this.directionOverride,
    exampleSentenceSource: exampleSentenceSource.present
        ? exampleSentenceSource.value
        : this.exampleSentenceSource,
    exampleSentenceTarget: exampleSentenceTarget.present
        ? exampleSentenceTarget.value
        : this.exampleSentenceTarget,
    notes: notes ?? this.notes,
    tags: tags ?? this.tags,
    sourceOrigin: sourceOrigin ?? this.sourceOrigin,
    sourceImagePath: sourceImagePath.present
        ? sourceImagePath.value
        : this.sourceImagePath,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    dueAt: dueAt ?? this.dueAt,
    intervalDays: intervalDays ?? this.intervalDays,
    ease: ease ?? this.ease,
    repetitions: repetitions ?? this.repetitions,
    lapses: lapses ?? this.lapses,
    status: status ?? this.status,
    typingEnabled: typingEnabled ?? this.typingEnabled,
  );
  VocabularyItem copyWithCompanion(VocabularyItemsCompanion data) {
    return VocabularyItem(
      id: data.id.present ? data.id.value : this.id,
      setId: data.setId.present ? data.setId.value : this.setId,
      sourceText: data.sourceText.present
          ? data.sourceText.value
          : this.sourceText,
      targetText: data.targetText.present
          ? data.targetText.value
          : this.targetText,
      sourceLang: data.sourceLang.present
          ? data.sourceLang.value
          : this.sourceLang,
      targetLang: data.targetLang.present
          ? data.targetLang.value
          : this.targetLang,
      directionOverride: data.directionOverride.present
          ? data.directionOverride.value
          : this.directionOverride,
      exampleSentenceSource: data.exampleSentenceSource.present
          ? data.exampleSentenceSource.value
          : this.exampleSentenceSource,
      exampleSentenceTarget: data.exampleSentenceTarget.present
          ? data.exampleSentenceTarget.value
          : this.exampleSentenceTarget,
      notes: data.notes.present ? data.notes.value : this.notes,
      tags: data.tags.present ? data.tags.value : this.tags,
      sourceOrigin: data.sourceOrigin.present
          ? data.sourceOrigin.value
          : this.sourceOrigin,
      sourceImagePath: data.sourceImagePath.present
          ? data.sourceImagePath.value
          : this.sourceImagePath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      intervalDays: data.intervalDays.present
          ? data.intervalDays.value
          : this.intervalDays,
      ease: data.ease.present ? data.ease.value : this.ease,
      repetitions: data.repetitions.present
          ? data.repetitions.value
          : this.repetitions,
      lapses: data.lapses.present ? data.lapses.value : this.lapses,
      status: data.status.present ? data.status.value : this.status,
      typingEnabled: data.typingEnabled.present
          ? data.typingEnabled.value
          : this.typingEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VocabularyItem(')
          ..write('id: $id, ')
          ..write('setId: $setId, ')
          ..write('sourceText: $sourceText, ')
          ..write('targetText: $targetText, ')
          ..write('sourceLang: $sourceLang, ')
          ..write('targetLang: $targetLang, ')
          ..write('directionOverride: $directionOverride, ')
          ..write('exampleSentenceSource: $exampleSentenceSource, ')
          ..write('exampleSentenceTarget: $exampleSentenceTarget, ')
          ..write('notes: $notes, ')
          ..write('tags: $tags, ')
          ..write('sourceOrigin: $sourceOrigin, ')
          ..write('sourceImagePath: $sourceImagePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dueAt: $dueAt, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('ease: $ease, ')
          ..write('repetitions: $repetitions, ')
          ..write('lapses: $lapses, ')
          ..write('status: $status, ')
          ..write('typingEnabled: $typingEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    setId,
    sourceText,
    targetText,
    sourceLang,
    targetLang,
    directionOverride,
    exampleSentenceSource,
    exampleSentenceTarget,
    notes,
    tags,
    sourceOrigin,
    sourceImagePath,
    createdAt,
    updatedAt,
    dueAt,
    intervalDays,
    ease,
    repetitions,
    lapses,
    status,
    typingEnabled,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VocabularyItem &&
          other.id == this.id &&
          other.setId == this.setId &&
          other.sourceText == this.sourceText &&
          other.targetText == this.targetText &&
          other.sourceLang == this.sourceLang &&
          other.targetLang == this.targetLang &&
          other.directionOverride == this.directionOverride &&
          other.exampleSentenceSource == this.exampleSentenceSource &&
          other.exampleSentenceTarget == this.exampleSentenceTarget &&
          other.notes == this.notes &&
          other.tags == this.tags &&
          other.sourceOrigin == this.sourceOrigin &&
          other.sourceImagePath == this.sourceImagePath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.dueAt == this.dueAt &&
          other.intervalDays == this.intervalDays &&
          other.ease == this.ease &&
          other.repetitions == this.repetitions &&
          other.lapses == this.lapses &&
          other.status == this.status &&
          other.typingEnabled == this.typingEnabled);
}

class VocabularyItemsCompanion extends UpdateCompanion<VocabularyItem> {
  final Value<String> id;
  final Value<String> setId;
  final Value<String> sourceText;
  final Value<String> targetText;
  final Value<String> sourceLang;
  final Value<String> targetLang;
  final Value<String?> directionOverride;
  final Value<String?> exampleSentenceSource;
  final Value<String?> exampleSentenceTarget;
  final Value<String> notes;
  final Value<String> tags;
  final Value<String> sourceOrigin;
  final Value<String?> sourceImagePath;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime> dueAt;
  final Value<int> intervalDays;
  final Value<double> ease;
  final Value<int> repetitions;
  final Value<int> lapses;
  final Value<String> status;
  final Value<bool> typingEnabled;
  final Value<int> rowid;
  const VocabularyItemsCompanion({
    this.id = const Value.absent(),
    this.setId = const Value.absent(),
    this.sourceText = const Value.absent(),
    this.targetText = const Value.absent(),
    this.sourceLang = const Value.absent(),
    this.targetLang = const Value.absent(),
    this.directionOverride = const Value.absent(),
    this.exampleSentenceSource = const Value.absent(),
    this.exampleSentenceTarget = const Value.absent(),
    this.notes = const Value.absent(),
    this.tags = const Value.absent(),
    this.sourceOrigin = const Value.absent(),
    this.sourceImagePath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.ease = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.lapses = const Value.absent(),
    this.status = const Value.absent(),
    this.typingEnabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VocabularyItemsCompanion.insert({
    required String id,
    required String setId,
    required String sourceText,
    required String targetText,
    required String sourceLang,
    required String targetLang,
    this.directionOverride = const Value.absent(),
    this.exampleSentenceSource = const Value.absent(),
    this.exampleSentenceTarget = const Value.absent(),
    this.notes = const Value.absent(),
    this.tags = const Value.absent(),
    this.sourceOrigin = const Value.absent(),
    this.sourceImagePath = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    required DateTime dueAt,
    this.intervalDays = const Value.absent(),
    this.ease = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.lapses = const Value.absent(),
    this.status = const Value.absent(),
    this.typingEnabled = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       setId = Value(setId),
       sourceText = Value(sourceText),
       targetText = Value(targetText),
       sourceLang = Value(sourceLang),
       targetLang = Value(targetLang),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       dueAt = Value(dueAt);
  static Insertable<VocabularyItem> custom({
    Expression<String>? id,
    Expression<String>? setId,
    Expression<String>? sourceText,
    Expression<String>? targetText,
    Expression<String>? sourceLang,
    Expression<String>? targetLang,
    Expression<String>? directionOverride,
    Expression<String>? exampleSentenceSource,
    Expression<String>? exampleSentenceTarget,
    Expression<String>? notes,
    Expression<String>? tags,
    Expression<String>? sourceOrigin,
    Expression<String>? sourceImagePath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? dueAt,
    Expression<int>? intervalDays,
    Expression<double>? ease,
    Expression<int>? repetitions,
    Expression<int>? lapses,
    Expression<String>? status,
    Expression<bool>? typingEnabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (setId != null) 'set_id': setId,
      if (sourceText != null) 'source_text': sourceText,
      if (targetText != null) 'target_text': targetText,
      if (sourceLang != null) 'source_lang': sourceLang,
      if (targetLang != null) 'target_lang': targetLang,
      if (directionOverride != null) 'direction_override': directionOverride,
      if (exampleSentenceSource != null)
        'example_sentence_source': exampleSentenceSource,
      if (exampleSentenceTarget != null)
        'example_sentence_target': exampleSentenceTarget,
      if (notes != null) 'notes': notes,
      if (tags != null) 'tags': tags,
      if (sourceOrigin != null) 'source_origin': sourceOrigin,
      if (sourceImagePath != null) 'source_image_path': sourceImagePath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (dueAt != null) 'due_at': dueAt,
      if (intervalDays != null) 'interval_days': intervalDays,
      if (ease != null) 'ease': ease,
      if (repetitions != null) 'repetitions': repetitions,
      if (lapses != null) 'lapses': lapses,
      if (status != null) 'status': status,
      if (typingEnabled != null) 'typing_enabled': typingEnabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VocabularyItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? setId,
    Value<String>? sourceText,
    Value<String>? targetText,
    Value<String>? sourceLang,
    Value<String>? targetLang,
    Value<String?>? directionOverride,
    Value<String?>? exampleSentenceSource,
    Value<String?>? exampleSentenceTarget,
    Value<String>? notes,
    Value<String>? tags,
    Value<String>? sourceOrigin,
    Value<String?>? sourceImagePath,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime>? dueAt,
    Value<int>? intervalDays,
    Value<double>? ease,
    Value<int>? repetitions,
    Value<int>? lapses,
    Value<String>? status,
    Value<bool>? typingEnabled,
    Value<int>? rowid,
  }) {
    return VocabularyItemsCompanion(
      id: id ?? this.id,
      setId: setId ?? this.setId,
      sourceText: sourceText ?? this.sourceText,
      targetText: targetText ?? this.targetText,
      sourceLang: sourceLang ?? this.sourceLang,
      targetLang: targetLang ?? this.targetLang,
      directionOverride: directionOverride ?? this.directionOverride,
      exampleSentenceSource:
          exampleSentenceSource ?? this.exampleSentenceSource,
      exampleSentenceTarget:
          exampleSentenceTarget ?? this.exampleSentenceTarget,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
      sourceOrigin: sourceOrigin ?? this.sourceOrigin,
      sourceImagePath: sourceImagePath ?? this.sourceImagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dueAt: dueAt ?? this.dueAt,
      intervalDays: intervalDays ?? this.intervalDays,
      ease: ease ?? this.ease,
      repetitions: repetitions ?? this.repetitions,
      lapses: lapses ?? this.lapses,
      status: status ?? this.status,
      typingEnabled: typingEnabled ?? this.typingEnabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (setId.present) {
      map['set_id'] = Variable<String>(setId.value);
    }
    if (sourceText.present) {
      map['source_text'] = Variable<String>(sourceText.value);
    }
    if (targetText.present) {
      map['target_text'] = Variable<String>(targetText.value);
    }
    if (sourceLang.present) {
      map['source_lang'] = Variable<String>(sourceLang.value);
    }
    if (targetLang.present) {
      map['target_lang'] = Variable<String>(targetLang.value);
    }
    if (directionOverride.present) {
      map['direction_override'] = Variable<String>(directionOverride.value);
    }
    if (exampleSentenceSource.present) {
      map['example_sentence_source'] = Variable<String>(
        exampleSentenceSource.value,
      );
    }
    if (exampleSentenceTarget.present) {
      map['example_sentence_target'] = Variable<String>(
        exampleSentenceTarget.value,
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (sourceOrigin.present) {
      map['source_origin'] = Variable<String>(sourceOrigin.value);
    }
    if (sourceImagePath.present) {
      map['source_image_path'] = Variable<String>(sourceImagePath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (intervalDays.present) {
      map['interval_days'] = Variable<int>(intervalDays.value);
    }
    if (ease.present) {
      map['ease'] = Variable<double>(ease.value);
    }
    if (repetitions.present) {
      map['repetitions'] = Variable<int>(repetitions.value);
    }
    if (lapses.present) {
      map['lapses'] = Variable<int>(lapses.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (typingEnabled.present) {
      map['typing_enabled'] = Variable<bool>(typingEnabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VocabularyItemsCompanion(')
          ..write('id: $id, ')
          ..write('setId: $setId, ')
          ..write('sourceText: $sourceText, ')
          ..write('targetText: $targetText, ')
          ..write('sourceLang: $sourceLang, ')
          ..write('targetLang: $targetLang, ')
          ..write('directionOverride: $directionOverride, ')
          ..write('exampleSentenceSource: $exampleSentenceSource, ')
          ..write('exampleSentenceTarget: $exampleSentenceTarget, ')
          ..write('notes: $notes, ')
          ..write('tags: $tags, ')
          ..write('sourceOrigin: $sourceOrigin, ')
          ..write('sourceImagePath: $sourceImagePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('dueAt: $dueAt, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('ease: $ease, ')
          ..write('repetitions: $repetitions, ')
          ..write('lapses: $lapses, ')
          ..write('status: $status, ')
          ..write('typingEnabled: $typingEnabled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VocabularySetsTable vocabularySets = $VocabularySetsTable(this);
  late final $VocabularyItemsTable vocabularyItems = $VocabularyItemsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    vocabularySets,
    vocabularyItems,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'vocabulary_sets',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('vocabulary_items', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$VocabularySetsTableCreateCompanionBuilder =
    VocabularySetsCompanion Function({
      required String id,
      required String name,
      required String sourceLang,
      required String targetLang,
      Value<String> defaultDirection,
      Value<int> coverColor,
      Value<String> coverShape,
      Value<double> lastProgress,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$VocabularySetsTableUpdateCompanionBuilder =
    VocabularySetsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> sourceLang,
      Value<String> targetLang,
      Value<String> defaultDirection,
      Value<int> coverColor,
      Value<String> coverShape,
      Value<double> lastProgress,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$VocabularySetsTableReferences
    extends BaseReferences<_$AppDatabase, $VocabularySetsTable, VocabularySet> {
  $$VocabularySetsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$VocabularyItemsTable, List<VocabularyItem>>
  _vocabularyItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.vocabularyItems,
    aliasName: 'vocabulary_sets__id__vocabulary_items__set_id',
  );

  $$VocabularyItemsTableProcessedTableManager get vocabularyItemsRefs {
    final manager = $$VocabularyItemsTableTableManager(
      $_db,
      $_db.vocabularyItems,
    ).filter((f) => f.setId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _vocabularyItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VocabularySetsTableFilterComposer
    extends Composer<_$AppDatabase, $VocabularySetsTable> {
  $$VocabularySetsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceLang => $composableBuilder(
    column: $table.sourceLang,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetLang => $composableBuilder(
    column: $table.targetLang,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultDirection => $composableBuilder(
    column: $table.defaultDirection,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get coverColor => $composableBuilder(
    column: $table.coverColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverShape => $composableBuilder(
    column: $table.coverShape,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lastProgress => $composableBuilder(
    column: $table.lastProgress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> vocabularyItemsRefs(
    Expression<bool> Function($$VocabularyItemsTableFilterComposer f) f,
  ) {
    final $$VocabularyItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vocabularyItems,
      getReferencedColumn: (t) => t.setId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VocabularyItemsTableFilterComposer(
            $db: $db,
            $table: $db.vocabularyItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VocabularySetsTableOrderingComposer
    extends Composer<_$AppDatabase, $VocabularySetsTable> {
  $$VocabularySetsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceLang => $composableBuilder(
    column: $table.sourceLang,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetLang => $composableBuilder(
    column: $table.targetLang,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultDirection => $composableBuilder(
    column: $table.defaultDirection,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get coverColor => $composableBuilder(
    column: $table.coverColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverShape => $composableBuilder(
    column: $table.coverShape,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lastProgress => $composableBuilder(
    column: $table.lastProgress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VocabularySetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VocabularySetsTable> {
  $$VocabularySetsTableAnnotationComposer({
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

  GeneratedColumn<String> get sourceLang => $composableBuilder(
    column: $table.sourceLang,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetLang => $composableBuilder(
    column: $table.targetLang,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultDirection => $composableBuilder(
    column: $table.defaultDirection,
    builder: (column) => column,
  );

  GeneratedColumn<int> get coverColor => $composableBuilder(
    column: $table.coverColor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get coverShape => $composableBuilder(
    column: $table.coverShape,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lastProgress => $composableBuilder(
    column: $table.lastProgress,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> vocabularyItemsRefs<T extends Object>(
    Expression<T> Function($$VocabularyItemsTableAnnotationComposer a) f,
  ) {
    final $$VocabularyItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vocabularyItems,
      getReferencedColumn: (t) => t.setId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VocabularyItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.vocabularyItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VocabularySetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VocabularySetsTable,
          VocabularySet,
          $$VocabularySetsTableFilterComposer,
          $$VocabularySetsTableOrderingComposer,
          $$VocabularySetsTableAnnotationComposer,
          $$VocabularySetsTableCreateCompanionBuilder,
          $$VocabularySetsTableUpdateCompanionBuilder,
          (VocabularySet, $$VocabularySetsTableReferences),
          VocabularySet,
          PrefetchHooks Function({bool vocabularyItemsRefs})
        > {
  $$VocabularySetsTableTableManager(
    _$AppDatabase db,
    $VocabularySetsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VocabularySetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VocabularySetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VocabularySetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> sourceLang = const Value.absent(),
                Value<String> targetLang = const Value.absent(),
                Value<String> defaultDirection = const Value.absent(),
                Value<int> coverColor = const Value.absent(),
                Value<String> coverShape = const Value.absent(),
                Value<double> lastProgress = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VocabularySetsCompanion(
                id: id,
                name: name,
                sourceLang: sourceLang,
                targetLang: targetLang,
                defaultDirection: defaultDirection,
                coverColor: coverColor,
                coverShape: coverShape,
                lastProgress: lastProgress,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String sourceLang,
                required String targetLang,
                Value<String> defaultDirection = const Value.absent(),
                Value<int> coverColor = const Value.absent(),
                Value<String> coverShape = const Value.absent(),
                Value<double> lastProgress = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => VocabularySetsCompanion.insert(
                id: id,
                name: name,
                sourceLang: sourceLang,
                targetLang: targetLang,
                defaultDirection: defaultDirection,
                coverColor: coverColor,
                coverShape: coverShape,
                lastProgress: lastProgress,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$VocabularySetsTable, VocabularySet>(table),
                  $$VocabularySetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vocabularyItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (vocabularyItemsRefs) db.vocabularyItems,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (vocabularyItemsRefs)
                    await $_getPrefetchedData<
                      VocabularySet,
                      $VocabularySetsTable,
                      VocabularyItem
                    >(
                      currentTable: table,
                      referencedTable: $$VocabularySetsTableReferences
                          ._vocabularyItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$VocabularySetsTableReferences(
                            db,
                            table,
                            p0,
                          ).vocabularyItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.setId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$VocabularySetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VocabularySetsTable,
      VocabularySet,
      $$VocabularySetsTableFilterComposer,
      $$VocabularySetsTableOrderingComposer,
      $$VocabularySetsTableAnnotationComposer,
      $$VocabularySetsTableCreateCompanionBuilder,
      $$VocabularySetsTableUpdateCompanionBuilder,
      (VocabularySet, $$VocabularySetsTableReferences),
      VocabularySet,
      PrefetchHooks Function({bool vocabularyItemsRefs})
    >;
typedef $$VocabularyItemsTableCreateCompanionBuilder =
    VocabularyItemsCompanion Function({
      required String id,
      required String setId,
      required String sourceText,
      required String targetText,
      required String sourceLang,
      required String targetLang,
      Value<String?> directionOverride,
      Value<String?> exampleSentenceSource,
      Value<String?> exampleSentenceTarget,
      Value<String> notes,
      Value<String> tags,
      Value<String> sourceOrigin,
      Value<String?> sourceImagePath,
      required DateTime createdAt,
      required DateTime updatedAt,
      required DateTime dueAt,
      Value<int> intervalDays,
      Value<double> ease,
      Value<int> repetitions,
      Value<int> lapses,
      Value<String> status,
      Value<bool> typingEnabled,
      Value<int> rowid,
    });
typedef $$VocabularyItemsTableUpdateCompanionBuilder =
    VocabularyItemsCompanion Function({
      Value<String> id,
      Value<String> setId,
      Value<String> sourceText,
      Value<String> targetText,
      Value<String> sourceLang,
      Value<String> targetLang,
      Value<String?> directionOverride,
      Value<String?> exampleSentenceSource,
      Value<String?> exampleSentenceTarget,
      Value<String> notes,
      Value<String> tags,
      Value<String> sourceOrigin,
      Value<String?> sourceImagePath,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime> dueAt,
      Value<int> intervalDays,
      Value<double> ease,
      Value<int> repetitions,
      Value<int> lapses,
      Value<String> status,
      Value<bool> typingEnabled,
      Value<int> rowid,
    });

final class $$VocabularyItemsTableReferences
    extends
        BaseReferences<_$AppDatabase, $VocabularyItemsTable, VocabularyItem> {
  $$VocabularyItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $VocabularySetsTable _setIdTable(_$AppDatabase db) => db.vocabularySets
      .createAlias('vocabulary_items__set_id__vocabulary_sets__id');

  $$VocabularySetsTableProcessedTableManager get setId {
    final $_column = $_itemColumn<String>('set_id')!;

    final manager = $$VocabularySetsTableTableManager(
      $_db,
      $_db.vocabularySets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_setIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$VocabularyItemsTableFilterComposer
    extends Composer<_$AppDatabase, $VocabularyItemsTable> {
  $$VocabularyItemsTableFilterComposer({
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

  ColumnFilters<String> get sourceText => $composableBuilder(
    column: $table.sourceText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetText => $composableBuilder(
    column: $table.targetText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceLang => $composableBuilder(
    column: $table.sourceLang,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetLang => $composableBuilder(
    column: $table.targetLang,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get directionOverride => $composableBuilder(
    column: $table.directionOverride,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exampleSentenceSource => $composableBuilder(
    column: $table.exampleSentenceSource,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exampleSentenceTarget => $composableBuilder(
    column: $table.exampleSentenceTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceOrigin => $composableBuilder(
    column: $table.sourceOrigin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceImagePath => $composableBuilder(
    column: $table.sourceImagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ease => $composableBuilder(
    column: $table.ease,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lapses => $composableBuilder(
    column: $table.lapses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get typingEnabled => $composableBuilder(
    column: $table.typingEnabled,
    builder: (column) => ColumnFilters(column),
  );

  $$VocabularySetsTableFilterComposer get setId {
    final $$VocabularySetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.setId,
      referencedTable: $db.vocabularySets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VocabularySetsTableFilterComposer(
            $db: $db,
            $table: $db.vocabularySets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VocabularyItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $VocabularyItemsTable> {
  $$VocabularyItemsTableOrderingComposer({
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

  ColumnOrderings<String> get sourceText => $composableBuilder(
    column: $table.sourceText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetText => $composableBuilder(
    column: $table.targetText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceLang => $composableBuilder(
    column: $table.sourceLang,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetLang => $composableBuilder(
    column: $table.targetLang,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get directionOverride => $composableBuilder(
    column: $table.directionOverride,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exampleSentenceSource => $composableBuilder(
    column: $table.exampleSentenceSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exampleSentenceTarget => $composableBuilder(
    column: $table.exampleSentenceTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceOrigin => $composableBuilder(
    column: $table.sourceOrigin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceImagePath => $composableBuilder(
    column: $table.sourceImagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ease => $composableBuilder(
    column: $table.ease,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lapses => $composableBuilder(
    column: $table.lapses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get typingEnabled => $composableBuilder(
    column: $table.typingEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  $$VocabularySetsTableOrderingComposer get setId {
    final $$VocabularySetsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.setId,
      referencedTable: $db.vocabularySets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VocabularySetsTableOrderingComposer(
            $db: $db,
            $table: $db.vocabularySets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VocabularyItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VocabularyItemsTable> {
  $$VocabularyItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceText => $composableBuilder(
    column: $table.sourceText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetText => $composableBuilder(
    column: $table.targetText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceLang => $composableBuilder(
    column: $table.sourceLang,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetLang => $composableBuilder(
    column: $table.targetLang,
    builder: (column) => column,
  );

  GeneratedColumn<String> get directionOverride => $composableBuilder(
    column: $table.directionOverride,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exampleSentenceSource => $composableBuilder(
    column: $table.exampleSentenceSource,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exampleSentenceTarget => $composableBuilder(
    column: $table.exampleSentenceTarget,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get sourceOrigin => $composableBuilder(
    column: $table.sourceOrigin,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceImagePath => $composableBuilder(
    column: $table.sourceImagePath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => column,
  );

  GeneratedColumn<double> get ease =>
      $composableBuilder(column: $table.ease, builder: (column) => column);

  GeneratedColumn<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lapses =>
      $composableBuilder(column: $table.lapses, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get typingEnabled => $composableBuilder(
    column: $table.typingEnabled,
    builder: (column) => column,
  );

  $$VocabularySetsTableAnnotationComposer get setId {
    final $$VocabularySetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.setId,
      referencedTable: $db.vocabularySets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VocabularySetsTableAnnotationComposer(
            $db: $db,
            $table: $db.vocabularySets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VocabularyItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VocabularyItemsTable,
          VocabularyItem,
          $$VocabularyItemsTableFilterComposer,
          $$VocabularyItemsTableOrderingComposer,
          $$VocabularyItemsTableAnnotationComposer,
          $$VocabularyItemsTableCreateCompanionBuilder,
          $$VocabularyItemsTableUpdateCompanionBuilder,
          (VocabularyItem, $$VocabularyItemsTableReferences),
          VocabularyItem,
          PrefetchHooks Function({bool setId})
        > {
  $$VocabularyItemsTableTableManager(
    _$AppDatabase db,
    $VocabularyItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VocabularyItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VocabularyItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VocabularyItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> setId = const Value.absent(),
                Value<String> sourceText = const Value.absent(),
                Value<String> targetText = const Value.absent(),
                Value<String> sourceLang = const Value.absent(),
                Value<String> targetLang = const Value.absent(),
                Value<String?> directionOverride = const Value.absent(),
                Value<String?> exampleSentenceSource = const Value.absent(),
                Value<String?> exampleSentenceTarget = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<String> sourceOrigin = const Value.absent(),
                Value<String?> sourceImagePath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> dueAt = const Value.absent(),
                Value<int> intervalDays = const Value.absent(),
                Value<double> ease = const Value.absent(),
                Value<int> repetitions = const Value.absent(),
                Value<int> lapses = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> typingEnabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VocabularyItemsCompanion(
                id: id,
                setId: setId,
                sourceText: sourceText,
                targetText: targetText,
                sourceLang: sourceLang,
                targetLang: targetLang,
                directionOverride: directionOverride,
                exampleSentenceSource: exampleSentenceSource,
                exampleSentenceTarget: exampleSentenceTarget,
                notes: notes,
                tags: tags,
                sourceOrigin: sourceOrigin,
                sourceImagePath: sourceImagePath,
                createdAt: createdAt,
                updatedAt: updatedAt,
                dueAt: dueAt,
                intervalDays: intervalDays,
                ease: ease,
                repetitions: repetitions,
                lapses: lapses,
                status: status,
                typingEnabled: typingEnabled,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String setId,
                required String sourceText,
                required String targetText,
                required String sourceLang,
                required String targetLang,
                Value<String?> directionOverride = const Value.absent(),
                Value<String?> exampleSentenceSource = const Value.absent(),
                Value<String?> exampleSentenceTarget = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<String> sourceOrigin = const Value.absent(),
                Value<String?> sourceImagePath = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                required DateTime dueAt,
                Value<int> intervalDays = const Value.absent(),
                Value<double> ease = const Value.absent(),
                Value<int> repetitions = const Value.absent(),
                Value<int> lapses = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> typingEnabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VocabularyItemsCompanion.insert(
                id: id,
                setId: setId,
                sourceText: sourceText,
                targetText: targetText,
                sourceLang: sourceLang,
                targetLang: targetLang,
                directionOverride: directionOverride,
                exampleSentenceSource: exampleSentenceSource,
                exampleSentenceTarget: exampleSentenceTarget,
                notes: notes,
                tags: tags,
                sourceOrigin: sourceOrigin,
                sourceImagePath: sourceImagePath,
                createdAt: createdAt,
                updatedAt: updatedAt,
                dueAt: dueAt,
                intervalDays: intervalDays,
                ease: ease,
                repetitions: repetitions,
                lapses: lapses,
                status: status,
                typingEnabled: typingEnabled,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$VocabularyItemsTable, VocabularyItem>(table),
                  $$VocabularyItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({setId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (setId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.setId,
                                referencedTable:
                                    $$VocabularyItemsTableReferences
                                        ._setIdTable(db),
                                referencedColumn:
                                    $$VocabularyItemsTableReferences
                                        ._setIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$VocabularyItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VocabularyItemsTable,
      VocabularyItem,
      $$VocabularyItemsTableFilterComposer,
      $$VocabularyItemsTableOrderingComposer,
      $$VocabularyItemsTableAnnotationComposer,
      $$VocabularyItemsTableCreateCompanionBuilder,
      $$VocabularyItemsTableUpdateCompanionBuilder,
      (VocabularyItem, $$VocabularyItemsTableReferences),
      VocabularyItem,
      PrefetchHooks Function({bool setId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VocabularySetsTableTableManager get vocabularySets =>
      $$VocabularySetsTableTableManager(_db, _db.vocabularySets);
  $$VocabularyItemsTableTableManager get vocabularyItems =>
      $$VocabularyItemsTableTableManager(_db, _db.vocabularyItems);
}
