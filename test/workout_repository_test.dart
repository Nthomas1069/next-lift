import "package:drift/native.dart";
import "package:flutter_test/flutter_test.dart";
import "package:next_lift/core/storage/app_database.dart";
import "package:next_lift/core/workouts/models/workout_template.dart";
import "package:next_lift/core/workouts/repositories/drift_workout_template_repository.dart";

void main() {
  late AppDatabase database;
  late DriftWorkoutTemplateRepository repository;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftWorkoutTemplateRepository(database: database);
    await database.into(database.exerciseTemplates).insert(
          ExerciseTemplatesCompanion.insert(
            id: "exercise-1",
            name: "Bench Press",
            normalizedName: "bench press",
            createdAtUtc: DateTime.utc(2026),
            updatedAtUtc: DateTime.utc(2026),
          ),
        );
    await database.into(database.exerciseMetricConfigs).insert(
          ExerciseMetricConfigsCompanion.insert(
            exerciseTemplateId: "exercise-1",
            metricKey: "reps",
            orderIndex: 0,
          ),
        );
  });

  tearDown(() => database.close());

  test("round trips nested semantic workout flow", () async {
    final child = _shape(
      id: "child",
      type: WorkoutShapeType.dropSet,
      parentShapeId: "combo",
    );
    final template = WorkoutTemplate(
      id: "workout",
      name: "Push Day",
      normalizedName: "push day",
      createdAtUtc: DateTime.utc(2026),
      updatedAtUtc: DateTime.utc(2026),
      version: 1,
      layoutVersion: 1,
      shapeNodes: [
        WorkoutShapeNode(
          shapeId: "combo",
          shapeType: WorkoutShapeType.combination,
          orderIndex: 0,
          exercises: const [],
          children: [child],
        ),
      ],
    );

    await repository.saveTemplate(template);
    final loaded = await repository.listTemplates();

    expect(loaded, hasLength(1));
    expect(loaded.single.shapeNodes.single.children.single.shapeId, "child");
    expect(
      loaded.single.shapeNodes.single.children.single.exercises.single
          .exerciseTemplateId,
      "exercise-1",
    );
    expect(loaded.single.plannedSetCount, 1);
  });

  test("editing a template replaces nested flow transactionally", () async {
    final initial = WorkoutTemplate(
      id: "workout",
      name: "Push Day",
      normalizedName: "push day",
      createdAtUtc: DateTime.utc(2026),
      updatedAtUtc: DateTime.utc(2026),
      version: 1,
      layoutVersion: 1,
      shapeNodes: [
        _shape(id: "shape-a", type: WorkoutShapeType.straightSet),
      ],
    );
    await repository.saveTemplate(initial);

    await repository.saveTemplate(
      initial.copyWith(
        version: 2,
        shapeNodes: [
          _shape(id: "shape-b", type: WorkoutShapeType.pyramid),
        ],
      ),
    );
    final loaded = await repository.listTemplates();

    expect(loaded.single.version, 2);
    expect(loaded.single.shapeNodes.single.shapeId, "shape-b");
    final oldShape = await (database.select(database.workoutShapeNodes)
          ..where((table) => table.shapeId.equals("shape-a")))
        .getSingleOrNull();
    expect(oldShape, null);
  });
}

WorkoutShapeNode _shape({
  required String id,
  required WorkoutShapeType type,
  String? parentShapeId,
}) {
  return WorkoutShapeNode(
    shapeId: id,
    shapeType: type,
    orderIndex: 0,
    parentShapeId: parentShapeId,
    exercises: [
      WorkoutShapeExercise(
        shapeExerciseId: "$id-exercise",
        exerciseTemplateId: "exercise-1",
        orderIndex: 0,
        plannedSets: [
          WorkoutPlannedSet(setId: "$id-set", orderIndex: 0),
        ],
      ),
    ],
  );
}
