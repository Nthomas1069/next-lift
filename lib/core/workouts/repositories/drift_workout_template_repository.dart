import "dart:convert";

import "package:drift/drift.dart";

import "../../storage/app_database.dart";
import "../models/workout_template.dart";
import "workout_template_repository.dart";

class DriftWorkoutTemplateRepository implements WorkoutTemplateRepository {
  DriftWorkoutTemplateRepository({required AppDatabase database})
      : _database = database;

  final AppDatabase _database;

  @override
  Future<List<WorkoutTemplate>> listTemplates() async {
    final templateRows = await (_database.select(_database.workoutTemplates)
          ..orderBy([(table) => OrderingTerm.asc(table.name)]))
        .get();
    if (templateRows.isEmpty) {
      return const [];
    }

    final shapeRows = await (_database.select(_database.workoutShapeNodes)
          ..orderBy([(table) => OrderingTerm.asc(table.orderIndex)]))
        .get();
    final exerciseRows =
        await (_database.select(_database.workoutShapeExercises)
              ..orderBy([(table) => OrderingTerm.asc(table.orderIndex)]))
            .get();
    final plannedSetRows = await (_database.select(_database.workoutPlannedSets)
          ..orderBy([(table) => OrderingTerm.asc(table.orderIndex)]))
        .get();

    final setsByExercise = <String, List<WorkoutPlannedSet>>{};
    for (final set in plannedSetRows) {
      setsByExercise.putIfAbsent(set.shapeExerciseId, () => []).add(
            WorkoutPlannedSet(
              setId: set.setId,
              orderIndex: set.orderIndex,
              metricDefaults: _decodeMetricDefaults(set.metricDefaultsJson),
            ),
          );
    }

    final exercisesByShape = <String, List<WorkoutShapeExercise>>{};
    for (final exercise in exerciseRows) {
      exercisesByShape.putIfAbsent(exercise.shapeId, () => []).add(
            WorkoutShapeExercise(
              shapeExerciseId: exercise.shapeExerciseId,
              exerciseTemplateId: exercise.exerciseTemplateId,
              orderIndex: exercise.orderIndex,
              plannedSets: setsByExercise[exercise.shapeExerciseId] ?? const [],
            ),
          );
    }

    final rowsByParent = <String?, List<WorkoutShapeNodeRow>>{};
    for (final shape in shapeRows) {
      rowsByParent.putIfAbsent(shape.parentShapeId, () => []).add(shape);
    }

    return templateRows.map((template) {
      WorkoutShapeNode buildShape(WorkoutShapeNodeRow row) {
        final childRows = rowsByParent[row.shapeId] ?? const [];
        return WorkoutShapeNode(
          shapeId: row.shapeId,
          shapeType: workoutShapeTypeFromStorage(row.shapeType),
          orderIndex: row.orderIndex,
          parentShapeId: row.parentShapeId,
          exercises: exercisesByShape[row.shapeId] ?? const [],
          children: childRows.map(buildShape).toList(),
          note: row.note,
        );
      }

      final roots = (rowsByParent[null] ?? const [])
          .where((shape) => shape.templateId == template.id)
          .map(buildShape)
          .toList();
      return WorkoutTemplate(
        id: template.id,
        name: template.name,
        normalizedName: template.normalizedName,
        createdAtUtc: template.createdAtUtc,
        updatedAtUtc: template.updatedAtUtc,
        version: template.version,
        layoutVersion: template.layoutVersion,
        shapeNodes: roots,
      );
    }).toList();
  }

  @override
  Future<void> saveTemplate(WorkoutTemplate template) async {
    await _database.transaction(() async {
      final duplicate = await (_database.select(_database.workoutTemplates)
            ..where(
              (table) =>
                  table.normalizedName.equals(template.normalizedName) &
                  table.id.equals(template.id).not(),
            )
            ..limit(1))
          .getSingleOrNull();
      if (duplicate != null) {
        throw DuplicateWorkoutTemplateNameException(template.name);
      }

      await _deleteTemplateChildren(template.id);

      await _database.into(_database.workoutTemplates).insertOnConflictUpdate(
            WorkoutTemplatesCompanion.insert(
              id: template.id,
              name: template.name,
              normalizedName: template.normalizedName,
              createdAtUtc: template.createdAtUtc,
              updatedAtUtc: template.updatedAtUtc,
              version: Value(template.version),
              layoutVersion: Value(template.layoutVersion),
            ),
          );

      Future<void> insertShape(WorkoutShapeNode shape) async {
        await _database.into(_database.workoutShapeNodes).insert(
              WorkoutShapeNodesCompanion.insert(
                shapeId: shape.shapeId,
                templateId: template.id,
                parentShapeId: Value(shape.parentShapeId),
                shapeType: workoutShapeTypeToStorage(shape.shapeType),
                orderIndex: shape.orderIndex,
                note: Value(shape.note),
              ),
            );

        for (final exercise in shape.exercises) {
          await _database.into(_database.workoutShapeExercises).insert(
                WorkoutShapeExercisesCompanion.insert(
                  shapeExerciseId: exercise.shapeExerciseId,
                  shapeId: shape.shapeId,
                  exerciseTemplateId: exercise.exerciseTemplateId,
                  orderIndex: exercise.orderIndex,
                ),
              );
          for (final set in exercise.plannedSets) {
            await _database.into(_database.workoutPlannedSets).insert(
                  WorkoutPlannedSetsCompanion.insert(
                    setId: set.setId,
                    shapeExerciseId: exercise.shapeExerciseId,
                    orderIndex: set.orderIndex,
                    metricDefaultsJson: Value(jsonEncode(set.metricDefaults)),
                  ),
                );
          }
        }
        for (final child in shape.children) {
          await insertShape(
            child.parentShapeId == shape.shapeId
                ? child
                : child.copyWith(parentShapeId: shape.shapeId),
          );
        }
      }

      for (final shape in template.shapeNodes) {
        await insertShape(
          shape.parentShapeId == null
              ? shape
              : shape.copyWith(clearParentShapeId: true),
        );
      }
    });
  }

  @override
  Future<void> deleteTemplate(String id) async {
    await _database.transaction(() async {
      await _deleteTemplateChildren(id);
      await (_database.delete(_database.workoutTemplates)
            ..where((table) => table.id.equals(id)))
          .go();
    });
  }

  Future<void> _deleteTemplateChildren(String templateId) async {
    final shapes = await (_database.select(_database.workoutShapeNodes)
          ..where((table) => table.templateId.equals(templateId)))
        .get();
    for (final shape in shapes) {
      final exercises = await (_database.select(_database.workoutShapeExercises)
            ..where((table) => table.shapeId.equals(shape.shapeId)))
          .get();
      for (final exercise in exercises) {
        await (_database.delete(_database.workoutPlannedSets)
              ..where(
                (table) =>
                    table.shapeExerciseId.equals(exercise.shapeExerciseId),
              ))
            .go();
      }
      await (_database.delete(_database.workoutShapeExercises)
            ..where((table) => table.shapeId.equals(shape.shapeId)))
          .go();
    }
    await (_database.delete(_database.workoutShapeNodes)
          ..where((table) => table.templateId.equals(templateId)))
        .go();
  }
}

Map<String, double?> _decodeMetricDefaults(String raw) {
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! Map) {
      return const {};
    }
    return decoded.map((key, value) {
      return MapEntry(
        key.toString(),
        value is num ? value.toDouble() : null,
      );
    });
  } catch (_) {
    return const {};
  }
}
