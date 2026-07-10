import "package:flutter_test/flutter_test.dart";
import "package:next_lift/core/workouts/drafts/workout_builder_draft_store.dart";
import "package:next_lift/core/workouts/models/workout_template.dart";
import "package:shared_preferences/shared_preferences.dart";

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test("persists and restores a nested workout builder draft", () async {
    const store = WorkoutBuilderDraftStore();
    const child = WorkoutShapeNode(
      shapeId: "child",
      shapeType: WorkoutShapeType.straightSet,
      orderIndex: 0,
      parentShapeId: "combination",
      exercises: [
        WorkoutShapeExercise(
          shapeExerciseId: "shape-exercise",
          exerciseTemplateId: "exercise",
          orderIndex: 0,
          plannedSets: [
            WorkoutPlannedSet(
              setId: "set",
              orderIndex: 0,
              metricDefaults: {"weight": 50, "reps": 8},
            ),
          ],
        ),
      ],
    );
    const draft = WorkoutBuilderDraft(
      name: "",
      focusedShapeId: "child",
      shapes: [
        WorkoutShapeNode(
          shapeId: "combination",
          shapeType: WorkoutShapeType.combination,
          orderIndex: 0,
          exercises: [],
          children: [child],
        ),
      ],
    );

    await store.save("new", draft);
    final restored = await store.load("new");

    expect(restored, isNotNull);
    expect(restored!.name, isEmpty);
    expect(restored.focusedShapeId, "child");
    expect(restored.shapes.single.children.single.shapeId, "child");
    expect(
      restored.shapes.single.children.single.exercises.single.plannedSets.single
          .metricDefaults,
      {"weight": 50.0, "reps": 8.0},
    );

    await store.clear("new");
    expect(await store.load("new"), isNull);
  });
}
