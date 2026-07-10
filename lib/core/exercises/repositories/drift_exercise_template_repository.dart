import "dart:convert";

import "package:drift/drift.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../../storage/app_database.dart";
import "../models/exercise_template.dart";
import "exercise_template_repository.dart";

class DriftExerciseTemplateRepository implements ExerciseTemplateRepository {
  DriftExerciseTemplateRepository({required AppDatabase database})
      : _database = database;

  static const _legacyStorageKey = "next_lift.exercise_templates.v1";
  static const _migrationMarker =
      "next_lift.migrations.exercise_templates_to_drift.v1";

  final AppDatabase _database;
  Future<void>? _migration;

  @override
  Future<List<ExerciseTemplate>> listTemplates() async {
    await _ensureLegacyMigrated();
    final rows = await (_database.select(_database.exerciseTemplates)
          ..orderBy([(table) => OrderingTerm.asc(table.name)]))
        .get();
    final metrics = await (_database.select(_database.exerciseMetricConfigs)
          ..orderBy([(table) => OrderingTerm.asc(table.orderIndex)]))
        .get();
    final metricsByExercise = <String, List<ExerciseMetricKey>>{};
    for (final metric in metrics) {
      metricsByExercise
          .putIfAbsent(metric.exerciseTemplateId, () => [])
          .add(exerciseMetricKeyFromStorage(metric.metricKey));
    }

    return rows
        .map(
          (row) => ExerciseTemplate(
            id: row.id,
            name: row.name,
            normalizedName: row.normalizedName,
            metricKeys: metricsByExercise[row.id] ?? const [],
            createdAtUtc: row.createdAtUtc,
            updatedAtUtc: row.updatedAtUtc,
          ),
        )
        .where((template) => template.metricKeys.isNotEmpty)
        .toList();
  }

  @override
  Future<void> saveTemplate(ExerciseTemplate template) async {
    await _ensureLegacyMigrated();
    await _database.transaction(() async {
      final duplicate = await (_database.select(_database.exerciseTemplates)
            ..where(
              (table) =>
                  table.normalizedName.equals(template.normalizedName) &
                  table.id.equals(template.id).not(),
            )
            ..limit(1))
          .getSingleOrNull();
      if (duplicate != null) {
        throw DuplicateExerciseTemplateNameException(template.name);
      }

      await _database.into(_database.exerciseTemplates).insertOnConflictUpdate(
            ExerciseTemplatesCompanion.insert(
              id: template.id,
              name: template.name,
              normalizedName: template.normalizedName,
              createdAtUtc: template.createdAtUtc,
              updatedAtUtc: template.updatedAtUtc,
            ),
          );
      await (_database.delete(_database.exerciseMetricConfigs)
            ..where(
              (table) => table.exerciseTemplateId.equals(template.id),
            ))
          .go();
      for (var index = 0; index < template.metricKeys.length; index++) {
        await _database.into(_database.exerciseMetricConfigs).insert(
              ExerciseMetricConfigsCompanion.insert(
                exerciseTemplateId: template.id,
                metricKey: metricKeyToStorage(template.metricKeys[index]),
                orderIndex: index,
              ),
            );
      }
    });
  }

  @override
  Future<void> deleteTemplate(String id) async {
    await _ensureLegacyMigrated();
    final template = await (_database.select(_database.exerciseTemplates)
          ..where((table) => table.id.equals(id)))
        .getSingleOrNull();
    if (template == null) {
      return;
    }
    final reference = await (_database.select(_database.workoutShapeExercises)
          ..where((table) => table.exerciseTemplateId.equals(id))
          ..limit(1))
        .getSingleOrNull();
    if (reference != null) {
      throw ExerciseTemplateInUseException(template.name);
    }
    await (_database.delete(_database.exerciseTemplates)
          ..where((table) => table.id.equals(id)))
        .go();
  }

  Future<void> _ensureLegacyMigrated() {
    return _migration ??= _migrateLegacyTemplates();
  }

  Future<void> _migrateLegacyTemplates() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_migrationMarker) == true) {
      return;
    }

    final existingCount = await _database.exerciseTemplates.count().getSingle();
    final raw = prefs.getString(_legacyStorageKey);
    if (existingCount == 0 && raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          final templates = decoded.whereType<Map>().map((item) {
            return ExerciseTemplate.fromJson(
              item.map((key, value) => MapEntry(key.toString(), value)),
            );
          }).where(
            (template) =>
                template.id.isNotEmpty &&
                template.name.isNotEmpty &&
                template.metricKeys.isNotEmpty,
          );
          for (final template in templates) {
            await saveTemplateWithoutMigration(template);
          }
        }
      } catch (_) {
        // Leave invalid legacy payload untouched; the Drift store remains valid.
      }
    }
    await prefs.setBool(_migrationMarker, true);
  }

  Future<void> saveTemplateWithoutMigration(ExerciseTemplate template) async {
    await _database.transaction(() async {
      await _database.into(_database.exerciseTemplates).insertOnConflictUpdate(
            ExerciseTemplatesCompanion.insert(
              id: template.id,
              name: template.name,
              normalizedName: template.normalizedName,
              createdAtUtc: template.createdAtUtc,
              updatedAtUtc: template.updatedAtUtc,
            ),
          );
      for (var index = 0; index < template.metricKeys.length; index++) {
        await _database
            .into(_database.exerciseMetricConfigs)
            .insertOnConflictUpdate(
              ExerciseMetricConfigsCompanion.insert(
                exerciseTemplateId: template.id,
                metricKey: metricKeyToStorage(template.metricKeys[index]),
                orderIndex: index,
              ),
            );
      }
    });
  }
}
