import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:next_lift/core/design_system/tokens/app_theme_tokens.dart";
import "package:next_lift/core/design_system/tokens/theme_registry.dart";
import "package:next_lift/core/design_system/widgets/primary_action_button.dart";
import "package:next_lift/core/exercises/models/exercise_template.dart";
import "package:next_lift/core/workouts/models/workout_template.dart";
import "package:next_lift/features/workouts/widgets/flow/workout_flow_canvas.dart";
import "package:next_lift/features/workouts/widgets/flow/workout_shape_rail.dart";

void main() {
  final tokens = ThemeRegistry.resolve(AppThemeId.graphiteTeal);

  testWidgets("shape palette expands upward from its toggle", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              height: 600,
              child: WorkoutShapeRail(
                tokens: tokens,
                cometActive: true,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text("Straight Set"), findsNothing);
    expect(find.byType(CometOrbit), findsOneWidget);
    await tester.tap(find.byTooltip("Open shape palette"));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text("Straight Set"), findsNothing);
    expect(find.text("Workout shapes"), findsNothing);
    expect(find.text("Show labels"), findsOneWidget);
    await tester.tap(find.text("Show labels"));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text("Straight Set"), findsOneWidget);
    expect(find.text("Combination"), findsOneWidget);
    expect(find.text("Hide labels"), findsOneWidget);
    expect(find.byTooltip("Close shape palette"), findsOneWidget);

    final draggable = tester.widget<Draggable<WorkoutShapeType>>(
      find.ancestor(
        of: find.text("Straight Set"),
        matching: find.byType(Draggable<WorkoutShapeType>),
      ),
    );
    draggable.onDragCompleted?.call();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text("Straight Set"), findsNothing);
    expect(find.byTooltip("Open shape palette"), findsOneWidget);
  });

  testWidgets("preview canvas renders live exercise names", (tester) async {
    const shape = WorkoutShapeNode(
      shapeId: "shape",
      shapeType: WorkoutShapeType.straightSet,
      orderIndex: 0,
      exercises: [
        WorkoutShapeExercise(
          shapeExerciseId: "shape-exercise",
          exerciseTemplateId: "bench",
          orderIndex: 0,
          plannedSets: [
            WorkoutPlannedSet(setId: "set", orderIndex: 0),
          ],
        ),
      ],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            height: 600,
            child: WorkoutFlowCanvas(
              tokens: tokens,
              shapes: const [shape],
              exerciseNames: const {"bench": "Bench Press"},
              focusedShapeId: "shape",
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text("Straight Set"), findsOneWidget);
    expect(find.text("Bench Press"), findsOneWidget);
    expect(
      tester.getCenter(find.text("Bench Press")).dx,
      closeTo(200, 1),
    );
  });

  testWidgets("empty builder directs attention to the shape toggle",
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            height: 600,
            child: WorkoutFlowCanvas(
              tokens: tokens,
              shapes: const [],
              exerciseNames: const {},
              mode: WorkoutFlowCanvasMode.builder,
            ),
          ),
        ),
      ),
    );

    expect(
      find.text("Drag and drop a workout type\nto begin."),
      findsOneWidget,
    );
  });

  testWidgets("builder configures exercises and sets in place", (tester) async {
    const shape = WorkoutShapeNode(
      shapeId: "shape",
      shapeType: WorkoutShapeType.straightSet,
      orderIndex: 0,
      exercises: [
        WorkoutShapeExercise(
          shapeExerciseId: "shape-exercise",
          exerciseTemplateId: "",
          orderIndex: 0,
          plannedSets: [
            WorkoutPlannedSet(setId: "set", orderIndex: 0),
          ],
        ),
      ],
    );
    final selectedExercises = <String>[];
    var addSetPressed = false;
    var removeSetPressed = false;
    final timestamp = DateTime.utc(2026);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            height: 600,
            child: WorkoutFlowCanvas(
              tokens: tokens,
              shapes: const [shape],
              exerciseNames: const {},
              exerciseTemplates: [
                ExerciseTemplate(
                  id: "bench",
                  name: "Bench Press",
                  normalizedName: "bench press",
                  metricKeys: const [
                    ExerciseMetricKey.weight,
                    ExerciseMetricKey.reps,
                  ],
                  createdAtUtc: timestamp,
                  updatedAtUtc: timestamp,
                ),
              ],
              mode: WorkoutFlowCanvasMode.builder,
              onExerciseSelected: (shapeId, shapeExerciseId, exerciseId) {
                selectedExercises.add(exerciseId);
              },
              onAddSet: (shapeId, shapeExerciseId) {
                addSetPressed = true;
              },
              onRemoveSet: (shapeId, shapeExerciseId) {
                removeSetPressed = true;
              },
            ),
          ),
        ),
      ),
    );

    expect(find.text("Choose exercise"), findsOneWidget);
    await tester.tap(find.text("Choose exercise"));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(MenuItemButton, "Bench Press"));
    await tester.pumpAndSettle();
    expect(selectedExercises, ["bench"]);

    await tester.tap(find.byTooltip("Add set"));
    expect(addSetPressed, isTrue);
    await tester.tap(find.byTooltip("Remove set"));
    expect(removeSetPressed, isTrue);
  });
}
