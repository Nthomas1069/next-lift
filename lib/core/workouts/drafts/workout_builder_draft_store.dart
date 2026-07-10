import "dart:convert";

import "package:shared_preferences/shared_preferences.dart";

import "../models/workout_template.dart";

class WorkoutBuilderDraft {
  const WorkoutBuilderDraft({
    required this.name,
    required this.shapes,
    this.focusedShapeId,
  });

  final String name;
  final List<WorkoutShapeNode> shapes;
  final String? focusedShapeId;
}

class WorkoutBuilderDraftStore {
  const WorkoutBuilderDraftStore();

  static const _keyPrefix = "workout_builder_draft:";

  Future<WorkoutBuilderDraft?> load(String draftId) async {
    final preferences = await SharedPreferences.getInstance();
    final encoded = preferences.getString("$_keyPrefix$draftId");
    if (encoded == null) {
      return null;
    }
    try {
      final decoded = jsonDecode(encoded);
      if (decoded is! Map) {
        return null;
      }
      final json = Map<String, Object?>.from(decoded);
      return WorkoutBuilderDraft(
        name: json["name"] as String? ?? "",
        shapes: _decodeShapes(json["shapes"]),
        focusedShapeId: json["focusedShapeId"] as String?,
      );
    } on FormatException {
      return null;
    }
  }

  Future<void> save(String draftId, WorkoutBuilderDraft draft) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      "$_keyPrefix$draftId",
      jsonEncode({
        "name": draft.name,
        "focusedShapeId": draft.focusedShapeId,
        "shapes": draft.shapes.map(_encodeShape).toList(),
      }),
    );
  }

  Future<void> clear(String draftId) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove("$_keyPrefix$draftId");
  }

  Map<String, Object?> _encodeShape(WorkoutShapeNode shape) {
    return {
      "shapeId": shape.shapeId,
      "shapeType": workoutShapeTypeToStorage(shape.shapeType),
      "orderIndex": shape.orderIndex,
      "parentShapeId": shape.parentShapeId,
      "note": shape.note,
      "exercises": shape.exercises
          .map(
            (exercise) => {
              "shapeExerciseId": exercise.shapeExerciseId,
              "exerciseTemplateId": exercise.exerciseTemplateId,
              "orderIndex": exercise.orderIndex,
              "plannedSets": exercise.plannedSets
                  .map(
                    (set) => {
                      "setId": set.setId,
                      "orderIndex": set.orderIndex,
                      "metricDefaults": set.metricDefaults,
                    },
                  )
                  .toList(),
            },
          )
          .toList(),
      "children": shape.children.map(_encodeShape).toList(),
    };
  }

  List<WorkoutShapeNode> _decodeShapes(Object? raw) {
    if (raw is! List) {
      return const [];
    }
    return raw
        .whereType<Map>()
        .map((json) => _decodeShape(Map<String, Object?>.from(json)))
        .toList();
  }

  WorkoutShapeNode _decodeShape(Map<String, Object?> json) {
    final exercisesRaw = json["exercises"];
    final exercises = exercisesRaw is List
        ? exercisesRaw
            .whereType<Map>()
            .map(
              (raw) => _decodeExercise(Map<String, Object?>.from(raw)),
            )
            .toList()
        : <WorkoutShapeExercise>[];
    return WorkoutShapeNode(
      shapeId: json["shapeId"] as String? ?? "",
      shapeType: workoutShapeTypeFromStorage(
        json["shapeType"] as String? ?? "",
      ),
      orderIndex: (json["orderIndex"] as num?)?.toInt() ?? 0,
      parentShapeId: json["parentShapeId"] as String?,
      note: json["note"] as String?,
      exercises: exercises,
      children: _decodeShapes(json["children"]),
    );
  }

  WorkoutShapeExercise _decodeExercise(Map<String, Object?> json) {
    final setsRaw = json["plannedSets"];
    final plannedSets = setsRaw is List
        ? setsRaw
            .whereType<Map>()
            .map((raw) => _decodeSet(Map<String, Object?>.from(raw)))
            .toList()
        : <WorkoutPlannedSet>[];
    return WorkoutShapeExercise(
      shapeExerciseId: json["shapeExerciseId"] as String? ?? "",
      exerciseTemplateId: json["exerciseTemplateId"] as String? ?? "",
      orderIndex: (json["orderIndex"] as num?)?.toInt() ?? 0,
      plannedSets: plannedSets,
    );
  }

  WorkoutPlannedSet _decodeSet(Map<String, Object?> json) {
    final defaultsRaw = json["metricDefaults"];
    final defaults = <String, double?>{};
    if (defaultsRaw is Map) {
      for (final entry in defaultsRaw.entries) {
        defaults[entry.key.toString()] =
            entry.value is num ? (entry.value as num).toDouble() : null;
      }
    }
    return WorkoutPlannedSet(
      setId: json["setId"] as String? ?? "",
      orderIndex: (json["orderIndex"] as num?)?.toInt() ?? 0,
      metricDefaults: defaults,
    );
  }
}
