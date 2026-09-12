import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

part 'app_database.g.dart';

class VocabularySets extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get sourceLang => text()();
  TextColumn get targetLang => text()();
  TextColumn get defaultDirection =>
      text().withDefault(const Constant('foreign_to_de'))();
  IntColumn get coverColor =>
      integer().withDefault(const Constant(0xFF0A5A5C))();
  TextColumn get coverShape =>
      text().withDefault(const Constant('asymmetric'))();
  RealColumn get lastProgress => real().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class VocabularyItems extends Table {
  TextColumn get id => text()();
  TextColumn get setId =>
      text().references(VocabularySets, #id, onDelete: KeyAction.cascade)();
  TextColumn get sourceText => text()();
  TextColumn get targetText => text()();
  TextColumn get sourceLang => text()();
  TextColumn get targetLang => text()();
  TextColumn get directionOverride => text().nullable()();
  TextColumn get exampleSentenceSource => text().nullable()();
  TextColumn get exampleSentenceTarget => text().nullable()();
  TextColumn get notes => text().withDefault(const Constant(''))();
  TextColumn get tags => text().withDefault(const Constant('[]'))();
  TextColumn get sourceOrigin => text().withDefault(const Constant('manual'))();
  TextColumn get sourceImagePath => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get dueAt => dateTime()();
  IntColumn get intervalDays => integer().withDefault(const Constant(0))();
  RealColumn get ease => real().withDefault(const Constant(2.5))();
  IntColumn get repetitions => integer().withDefault(const Constant(0))();
  IntColumn get lapses => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('new'))();
  BoolColumn get typingEnabled => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [VocabularySets, VocabularyItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<void> seedDemoIfEmpty() async {
    final existing = await select(vocabularySets).get();
    if (existing.isNotEmpty) return;

    const setId = 'demo-en-de';
    final now = DateTime.now();
    await into(vocabularySets).insert(
      VocabularySetsCompanion.insert(
        id: setId,
        name: 'Englisch Basics',
        sourceLang: 'en',
        targetLang: 'de',
        defaultDirection: const Value('foreign_to_de'),
        coverColor: const Value(0xFF0A5A5C),
        coverShape: const Value('asymmetric'),
        lastProgress: const Value(0),
        createdAt: now,
        updatedAt: now,
      ),
    );

    const demo = <(String, String, String, String)>[
      (
        'apple',
        'Apfel',
        'I eat an apple every day.',
        'Ich esse jeden Tag einen Apfel.',
      ),
      (
        'book',
        'Buch',
        'This book is interesting.',
        'Dieses Buch ist interessant.',
      ),
      (
        'window',
        'Fenster',
        'Please open the window.',
        'Bitte öffne das Fenster.',
      ),
      (
        'to learn',
        'lernen',
        'I want to learn English.',
        'Ich möchte Englisch lernen.',
      ),
      (
        'careful',
        'vorsichtig',
        'Be careful on the stairs.',
        'Sei auf der Treppe vorsichtig.',
      ),
      (
        'journey',
        'Reise',
        'The journey starts tomorrow.',
        'Die Reise beginnt morgen.',
      ),
    ];
    for (final row in demo) {
      await into(vocabularyItems).insert(
        VocabularyItemsCompanion.insert(
          id: const Uuid().v4(),
          setId: setId,
          sourceText: row.$1,
          targetText: row.$2,
          sourceLang: 'en',
          targetLang: 'de',
          exampleSentenceSource: Value(row.$3),
          exampleSentenceTarget: Value(row.$4),
          createdAt: now,
          updatedAt: now,
          dueAt: now,
        ),
      );
    }
  }

  Stream<List<VocabularySet>> watchSets() => select(vocabularySets).watch();

  Future<List<VocabularySet>> allSets() => select(vocabularySets).get();

  Future<String> exportAllAsJson() async {
    final sets = await select(vocabularySets).get();
    final items = await select(vocabularyItems).get();
    return const JsonEncoder.withIndent('  ').convert({
      'format': 'foliant-sets',
      'version': 1,
      'exported_at': DateTime.now().toIso8601String(),
      'sets': sets
          .map(
            (s) => {
              'id': s.id,
              'name': s.name,
              'source_lang': s.sourceLang,
              'target_lang': s.targetLang,
              'default_direction': s.defaultDirection,
              'cover_color': s.coverColor,
              'cover_shape': s.coverShape,
              'last_progress': s.lastProgress,
              'created_at': s.createdAt.toIso8601String(),
              'updated_at': s.updatedAt.toIso8601String(),
            },
          )
          .toList(),
      'items': items
          .map(
            (v) => {
              'id': v.id,
              'set_id': v.setId,
              'source_text': v.sourceText,
              'target_text': v.targetText,
              'source_lang': v.sourceLang,
              'target_lang': v.targetLang,
              'direction_override': v.directionOverride,
              'example_source': v.exampleSentenceSource,
              'example_target': v.exampleSentenceTarget,
              'notes': v.notes,
              'tags': v.tags,
              'source_origin': v.sourceOrigin,
              'source_image_path': v.sourceImagePath,
              'created_at': v.createdAt.toIso8601String(),
              'updated_at': v.updatedAt.toIso8601String(),
              'due_at': v.dueAt.toIso8601String(),
              'interval_days': v.intervalDays,
              'ease': v.ease,
              'repetitions': v.repetitions,
              'lapses': v.lapses,
              'status': v.status,
              'typing_enabled': v.typingEnabled,
            },
          )
          .toList(),
    });
  }

  Future<void> importFromJson(String source) async {
    final root = jsonDecode(source);
    if (root is! Map<String, dynamic> || root['format'] != 'foliant-sets') {
      throw const FormatException('Keine gültige Foliant-Exportdatei.');
    }
    final rawSets = root['sets'] as List<dynamic>? ?? const [];
    final rawItems = root['items'] as List<dynamic>? ?? const [];
    await transaction(() async {
      for (final raw in rawSets) {
        final s = raw as Map<String, dynamic>;
        await into(vocabularySets).insertOnConflictUpdate(
          VocabularySetsCompanion.insert(
            id: s['id'].toString(),
            name: s['name'].toString(),
            sourceLang: s['source_lang'].toString(),
            targetLang: s['target_lang'].toString(),
            defaultDirection: Value(
              s['default_direction']?.toString() ?? 'foreign_to_de',
            ),
            coverColor: Value(
              (s['cover_color'] as num?)?.toInt() ?? 0xFF0A5A5C,
            ),
            coverShape: Value(s['cover_shape']?.toString() ?? 'asymmetric'),
            lastProgress: Value((s['last_progress'] as num?)?.toDouble() ?? 0),
            createdAt:
                DateTime.tryParse(s['created_at']?.toString() ?? '') ??
                DateTime.now(),
            updatedAt:
                DateTime.tryParse(s['updated_at']?.toString() ?? '') ??
                DateTime.now(),
          ),
        );
      }
      for (final raw in rawItems) {
        final v = raw as Map<String, dynamic>;
        await into(vocabularyItems).insertOnConflictUpdate(
          VocabularyItemsCompanion.insert(
            id: v['id'].toString(),
            setId: v['set_id'].toString(),
            sourceText: v['source_text'].toString(),
            targetText: v['target_text'].toString(),
            sourceLang: v['source_lang'].toString(),
            targetLang: v['target_lang'].toString(),
            directionOverride: Value(v['direction_override']?.toString()),
            exampleSentenceSource: Value(v['example_source']?.toString()),
            exampleSentenceTarget: Value(v['example_target']?.toString()),
            notes: Value(v['notes']?.toString() ?? ''),
            tags: Value(v['tags']?.toString() ?? '[]'),
            sourceOrigin: Value(v['source_origin']?.toString() ?? 'manual'),
            sourceImagePath: Value(v['source_image_path']?.toString()),
            createdAt:
                DateTime.tryParse(v['created_at']?.toString() ?? '') ??
                DateTime.now(),
            updatedAt:
                DateTime.tryParse(v['updated_at']?.toString() ?? '') ??
                DateTime.now(),
            dueAt:
                DateTime.tryParse(v['due_at']?.toString() ?? '') ??
                DateTime.now(),
            intervalDays: Value((v['interval_days'] as num?)?.toInt() ?? 0),
            ease: Value((v['ease'] as num?)?.toDouble() ?? 2.5),
            repetitions: Value((v['repetitions'] as num?)?.toInt() ?? 0),
            lapses: Value((v['lapses'] as num?)?.toInt() ?? 0),
            status: Value(v['status']?.toString() ?? 'new'),
            typingEnabled: Value(v['typing_enabled'] as bool? ?? true),
          ),
        );
      }
    });
  }

  Stream<List<VocabularyItem>> watchDueItems({String? setId}) {
    final query = select(vocabularyItems)
      ..where((t) => t.dueAt.isSmallerOrEqualValue(DateTime.now()));
    if (setId != null) query.where((t) => t.setId.equals(setId));
    query.orderBy([(t) => OrderingTerm.asc(t.dueAt)]);
    return query.watch();
  }

  Future<List<VocabularyItem>> allItemsForSet(String setId) =>
      (select(vocabularyItems)..where((t) => t.setId.equals(setId))).get();

  Future<void> createSet({
    required String name,
    required String sourceLang,
    required String targetLang,
    required String direction,
  }) async {
    final now = DateTime.now();
    await into(vocabularySets).insert(
      VocabularySetsCompanion.insert(
        id: const Uuid().v4(),
        name: name,
        sourceLang: sourceLang,
        targetLang: targetLang,
        defaultDirection: Value(direction),
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<void> upsertImportedItems({
    required String setId,
    required String sourceLang,
    required String targetLang,
    required List<ImportPair> items,
    required String origin,
    String? sourceImagePath,
  }) async {
    final now = DateTime.now();
    await batch((batch) {
      batch.insertAll(
        vocabularyItems,
        items
            .where(
              (item) =>
                  item.source.trim().isNotEmpty &&
                  item.target.trim().isNotEmpty,
            )
            .map(
              (item) => VocabularyItemsCompanion.insert(
                id: const Uuid().v4(),
                setId: setId,
                sourceText: item.source.trim(),
                targetText: item.target.trim(),
                sourceLang: sourceLang,
                targetLang: targetLang,
                exampleSentenceSource: Value(item.exampleSource),
                exampleSentenceTarget: Value(item.exampleTarget),
                notes: Value(item.notes ?? ''),
                sourceOrigin: Value(origin),
                sourceImagePath: Value(sourceImagePath),
                createdAt: now,
                updatedAt: now,
                dueAt: now,
              ),
            )
            .toList(),
      );
    });
  }

  Future<void> updateSrs(VocabularyItem item, SrsSnapshot snapshot) =>
      (update(vocabularyItems)..where((t) => t.id.equals(item.id))).write(
        VocabularyItemsCompanion(
          dueAt: Value(snapshot.dueAt),
          intervalDays: Value(snapshot.intervalDays),
          ease: Value(snapshot.ease),
          repetitions: Value(snapshot.repetitions),
          lapses: Value(snapshot.lapses),
          status: Value(snapshot.status),
          updatedAt: Value(DateTime.now()),
        ),
      );
}

class ImportPair {
  ImportPair({
    required this.source,
    required this.target,
    this.exampleSource,
    this.exampleTarget,
    this.notes,
    this.confidence = 1,
  });

  String source;
  String target;
  String? exampleSource;
  String? exampleTarget;
  String? notes;
  double confidence;
}

class SrsSnapshot {
  const SrsSnapshot({
    required this.dueAt,
    required this.intervalDays,
    required this.ease,
    required this.repetitions,
    required this.lapses,
    required this.status,
  });

  final DateTime dueAt;
  final int intervalDays;
  final double ease;
  final int repetitions;
  final int lapses;
  final String status;
}

LazyDatabase _openConnection() => LazyDatabase(() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File(p.join(dir.path, 'foliant.sqlite'));
  return NativeDatabase.createInBackground(file);
});
