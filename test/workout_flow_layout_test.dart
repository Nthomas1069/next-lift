import "package:flutter_test/flutter_test.dart";
import "package:next_lift/core/workouts/models/workout_template.dart";
import "package:next_lift/features/workouts/widgets/flow/workout_flow_layout.dart";

void main() {
  const engine = WorkoutFlowLayoutEngine();

  test("layout is deterministic for the same semantic flow", () {
    final shapes = [
      _shape("straight", WorkoutShapeType.straightSet, setCount: 3),
      _shape("circuit", WorkoutShapeType.circuit, setCount: 4, orderIndex: 1),
    ];

    final first = engine.layout(shapes);
    final second = engine.layout(shapes);

    expect(first.canvasSize, second.canvasSize);
    expect(first.shapes.length, second.shapes.length);
    for (var index = 0; index < first.shapes.length; index++) {
      expect(first.shapes[index].bounds, second.shapes[index].bounds);
      expect(
        first.shapes[index].sets.map((set) => set.center),
        second.shapes[index].sets.map((set) => set.center),
      );
      for (final set in first.shapes[index].sets) {
        expect(first.shapes[index].bounds.contains(set.center), isTrue);
      }
    }
  });

  test("combination includes nested shape geometry", () {
    final child = _shape(
      "child",
      WorkoutShapeType.superSet,
      setCount: 2,
      parentShapeId: "combo",
    );
    final combination = WorkoutShapeNode(
      shapeId: "combo",
      shapeType: WorkoutShapeType.combination,
      orderIndex: 0,
      exercises: const [],
      children: [child],
    );

    final layout = engine.layout([combination]);

    expect(layout.shapes.map((shape) => shape.shape.shapeId), [
      "combo",
      "child",
    ]);
    expect(layout.shapes.last.sets, hasLength(2));
  });

  test("superset lays out paired rounds compactly", () {
    final shape = WorkoutShapeNode(
      shapeId: "superset",
      shapeType: WorkoutShapeType.superSet,
      orderIndex: 0,
      exercises: [
        _exercise("first", 0, 3),
        _exercise("second", 1, 3),
      ],
    );

    final geometry = engine.layout([shape]).shapes.single;

    expect(geometry.sets, hasLength(6));
    expect(
      (geometry.sets[0].center.dy - geometry.sets[1].center.dy).abs(),
      lessThan(12),
    );
    expect(geometry.bounds.height, lessThan(280));
  });

  test("two-exercise circuit places stations across a closed loop", () {
    final shape = WorkoutShapeNode(
      shapeId: "circuit",
      shapeType: WorkoutShapeType.circuit,
      orderIndex: 0,
      exercises: [
        _exercise("first", 0, 1),
        _exercise("second", 1, 1),
      ],
    );

    final geometry = engine.layout([shape]).shapes.single;

    expect(geometry.sets, hasLength(2));
    expect(geometry.sets.first.center.dy, geometry.sets.last.center.dy);
    expect(
      geometry.sets.first.center.dx,
      isNot(geometry.sets.last.center.dx),
    );
    expect(geometry.bounds.height, lessThan(260));
  });

  test("eight-exercise circuit uses a two-column loop", () {
    final shape = WorkoutShapeNode(
      shapeId: "circuit",
      shapeType: WorkoutShapeType.circuit,
      orderIndex: 0,
      exercises: [
        for (var index = 0; index < 8; index++)
          _exercise("exercise-$index", index, 1),
      ],
    );

    final geometry = engine.layout([shape]).shapes.single;
    final centers = geometry.sets.map((set) => set.center).toList();
    final start = centers.first;
    final rightColumn = centers.skip(1).take(4).toList();
    final leftReturn = centers.skip(5).toList();

    expect(centers, hasLength(8));
    expect(rightColumn.map((center) => center.dx).toSet(), hasLength(1));
    expect(leftReturn.map((center) => center.dx).toSet(), {start.dx});
    expect(start.dy, rightColumn.first.dy);
    expect(rightColumn.first.dy, lessThan(rightColumn.last.dy));
    expect(leftReturn.first.dy, greaterThan(leftReturn.last.dy));
    expect(start.dy, lessThan(leftReturn.last.dy));
    expect(geometry.bounds.height, lessThan(340));
  });
}

WorkoutShapeExercise _exercise(String id, int orderIndex, int setCount) {
  return WorkoutShapeExercise(
    shapeExerciseId: id,
    exerciseTemplateId: id,
    orderIndex: orderIndex,
    plannedSets: List.generate(
      setCount,
      (index) => WorkoutPlannedSet(
        setId: "$id-set-$index",
        orderIndex: index,
      ),
    ),
  );
}

WorkoutShapeNode _shape(
  String id,
  WorkoutShapeType type, {
  required int setCount,
  int orderIndex = 0,
  String? parentShapeId,
}) {
  return WorkoutShapeNode(
    shapeId: id,
    shapeType: type,
    orderIndex: orderIndex,
    parentShapeId: parentShapeId,
    exercises: [
      WorkoutShapeExercise(
        shapeExerciseId: "$id-exercise",
        exerciseTemplateId: "exercise",
        orderIndex: 0,
        plannedSets: List.generate(
          setCount,
          (index) => WorkoutPlannedSet(
            setId: "$id-set-$index",
            orderIndex: index,
          ),
        ),
      ),
    ],
  );
}
