enum WorkoutShapeType {
  straightSet,
  superSet,
  circuit,
  dropSet,
  pyramid,
  reversePyramid,
  intervals,
  combination,
}

class WorkoutPlannedSet {
  const WorkoutPlannedSet({
    required this.setId,
    required this.orderIndex,
    this.metricDefaults = const {},
  });

  final String setId;
  final int orderIndex;
  final Map<String, double?> metricDefaults;
}

class WorkoutShapeExercise {
  const WorkoutShapeExercise({
    required this.shapeExerciseId,
    required this.exerciseTemplateId,
    required this.orderIndex,
    required this.plannedSets,
  });

  final String shapeExerciseId;
  final String exerciseTemplateId;
  final int orderIndex;
  final List<WorkoutPlannedSet> plannedSets;

  WorkoutShapeExercise copyWith({
    String? shapeExerciseId,
    String? exerciseTemplateId,
    int? orderIndex,
    List<WorkoutPlannedSet>? plannedSets,
  }) {
    return WorkoutShapeExercise(
      shapeExerciseId: shapeExerciseId ?? this.shapeExerciseId,
      exerciseTemplateId: exerciseTemplateId ?? this.exerciseTemplateId,
      orderIndex: orderIndex ?? this.orderIndex,
      plannedSets: plannedSets ?? this.plannedSets,
    );
  }
}

class WorkoutShapeNode {
  const WorkoutShapeNode({
    required this.shapeId,
    required this.shapeType,
    required this.orderIndex,
    required this.exercises,
    this.parentShapeId,
    this.children = const [],
    this.note,
  });

  final String shapeId;
  final WorkoutShapeType shapeType;
  final int orderIndex;
  final String? parentShapeId;
  final List<WorkoutShapeExercise> exercises;
  final List<WorkoutShapeNode> children;
  final String? note;

  WorkoutShapeNode copyWith({
    String? shapeId,
    WorkoutShapeType? shapeType,
    int? orderIndex,
    String? parentShapeId,
    bool clearParentShapeId = false,
    List<WorkoutShapeExercise>? exercises,
    List<WorkoutShapeNode>? children,
    String? note,
  }) {
    return WorkoutShapeNode(
      shapeId: shapeId ?? this.shapeId,
      shapeType: shapeType ?? this.shapeType,
      orderIndex: orderIndex ?? this.orderIndex,
      parentShapeId:
          clearParentShapeId ? null : parentShapeId ?? this.parentShapeId,
      exercises: exercises ?? this.exercises,
      children: children ?? this.children,
      note: note ?? this.note,
    );
  }

  Iterable<WorkoutShapeNode> get depthFirst sync* {
    yield this;
    final sortedChildren = [...children]
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    for (final child in sortedChildren) {
      yield* child.depthFirst;
    }
  }

  int get plannedSetCount {
    final local = exercises.fold<int>(
      0,
      (sum, exercise) => sum + exercise.plannedSets.length,
    );
    return local +
        children.fold<int>(0, (sum, child) => sum + child.plannedSetCount);
  }
}

class WorkoutTemplate {
  const WorkoutTemplate({
    required this.id,
    required this.name,
    required this.normalizedName,
    required this.createdAtUtc,
    required this.updatedAtUtc,
    required this.version,
    required this.layoutVersion,
    required this.shapeNodes,
  });

  final String id;
  final String name;
  final String normalizedName;
  final DateTime createdAtUtc;
  final DateTime updatedAtUtc;
  final int version;
  final int layoutVersion;
  final List<WorkoutShapeNode> shapeNodes;

  factory WorkoutTemplate.create({
    required String id,
    required String name,
    required String normalizedName,
    required DateTime createdAtUtc,
    required DateTime updatedAtUtc,
    required List<WorkoutShapeNode> shapeNodes,
    int version = 1,
    int layoutVersion = 1,
  }) {
    return WorkoutTemplate(
      id: id,
      name: name,
      normalizedName: normalizedName,
      createdAtUtc: createdAtUtc,
      updatedAtUtc: updatedAtUtc,
      version: version,
      layoutVersion: layoutVersion,
      shapeNodes: shapeNodes,
    );
  }

  WorkoutTemplate copyWith({
    String? id,
    String? name,
    String? normalizedName,
    DateTime? createdAtUtc,
    DateTime? updatedAtUtc,
    int? version,
    int? layoutVersion,
    List<WorkoutShapeNode>? shapeNodes,
  }) {
    return WorkoutTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      normalizedName: normalizedName ?? this.normalizedName,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      version: version ?? this.version,
      layoutVersion: layoutVersion ?? this.layoutVersion,
      shapeNodes: shapeNodes ?? this.shapeNodes,
    );
  }

  Iterable<WorkoutShapeNode> get allShapes sync* {
    final sorted = [...shapeNodes]
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    for (final shape in sorted) {
      yield* shape.depthFirst;
    }
  }

  int get exerciseCount =>
      allShapes.fold<int>(0, (sum, shape) => sum + shape.exercises.length);

  int get plannedSetCount =>
      shapeNodes.fold<int>(0, (sum, shape) => sum + shape.plannedSetCount);
}

String normalizeWorkoutTemplateName(String name) {
  return name.trim().replaceAll(RegExp(r"\s+"), " ").toLowerCase();
}

String workoutShapeTypeToStorage(WorkoutShapeType type) {
  return switch (type) {
    WorkoutShapeType.straightSet => "straight_set",
    WorkoutShapeType.superSet => "super_set",
    WorkoutShapeType.circuit => "circuit",
    WorkoutShapeType.dropSet => "drop_set",
    WorkoutShapeType.pyramid => "pyramid",
    WorkoutShapeType.reversePyramid => "reverse_pyramid",
    WorkoutShapeType.intervals => "intervals",
    WorkoutShapeType.combination => "combination",
  };
}

WorkoutShapeType workoutShapeTypeFromStorage(String value) {
  return switch (value) {
    "super_set" => WorkoutShapeType.superSet,
    "circuit" => WorkoutShapeType.circuit,
    "drop_set" => WorkoutShapeType.dropSet,
    "pyramid" => WorkoutShapeType.pyramid,
    "reverse_pyramid" => WorkoutShapeType.reversePyramid,
    "intervals" => WorkoutShapeType.intervals,
    "combination" => WorkoutShapeType.combination,
    _ => WorkoutShapeType.straightSet,
  };
}

String workoutShapeTypeLabel(WorkoutShapeType type) {
  return switch (type) {
    WorkoutShapeType.straightSet => "Straight Set",
    WorkoutShapeType.superSet => "Superset",
    WorkoutShapeType.circuit => "Circuit",
    WorkoutShapeType.dropSet => "Drop Set",
    WorkoutShapeType.pyramid => "Pyramid",
    WorkoutShapeType.reversePyramid => "Reverse Pyramid",
    WorkoutShapeType.intervals => "Intervals",
    WorkoutShapeType.combination => "Combination",
  };
}
