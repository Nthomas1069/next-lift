enum ExerciseMetricKey {
  weight,
  reps,
  time,
  level,
  height,
  distance,
  leftWeight,
  rightWeight,
  leftReps,
  rightReps,
  leftTime,
  rightTime,
}

class ExerciseTemplate {
  const ExerciseTemplate({
    required this.id,
    required this.name,
    required this.normalizedName,
    required this.metricKeys,
    required this.createdAtUtc,
    required this.updatedAtUtc,
  });

  final String id;
  final String name;
  final String normalizedName;
  final List<ExerciseMetricKey> metricKeys;
  final DateTime createdAtUtc;
  final DateTime updatedAtUtc;

  Map<String, Object?> toJson() {
    return {
      "id": id,
      "name": name,
      "normalizedName": normalizedName,
      "metricKeys": metricKeys.map(metricKeyToStorage).toList(),
      "createdAtUtc": createdAtUtc.toIso8601String(),
      "updatedAtUtc": updatedAtUtc.toIso8601String(),
    };
  }

  static ExerciseTemplate fromJson(Map<String, Object?> json) {
    final createdAtRaw = json["createdAtUtc"] as String?;
    final updatedAtRaw = json["updatedAtUtc"] as String?;
    final metricKeys = (json["metricKeys"] as List?)
            ?.whereType<String>()
            .map(exerciseMetricKeyFromStorage)
            .toList() ??
        const <ExerciseMetricKey>[];

    return ExerciseTemplate(
      id: (json["id"] as String?) ?? "",
      name: (json["name"] as String?) ?? "",
      normalizedName: (json["normalizedName"] as String?) ?? "",
      metricKeys: metricKeys,
      createdAtUtc: DateTime.tryParse(createdAtRaw ?? "") ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      updatedAtUtc: DateTime.tryParse(updatedAtRaw ?? "") ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    );
  }
}

String normalizeExerciseTemplateName(String name) {
  return name.trim().replaceAll(RegExp(r"\s+"), " ").toLowerCase();
}

String metricKeyLabel(ExerciseMetricKey key) {
  return switch (key) {
    ExerciseMetricKey.weight => "Weight",
    ExerciseMetricKey.reps => "Reps",
    ExerciseMetricKey.time => "Time",
    ExerciseMetricKey.level => "Level",
    ExerciseMetricKey.height => "Height",
    ExerciseMetricKey.distance => "Distance",
    ExerciseMetricKey.leftWeight => "Left Weight",
    ExerciseMetricKey.rightWeight => "Right Weight",
    ExerciseMetricKey.leftReps => "Left Reps",
    ExerciseMetricKey.rightReps => "Right Reps",
    ExerciseMetricKey.leftTime => "Left Time",
    ExerciseMetricKey.rightTime => "Right Time",
  };
}

String metricKeyToStorage(ExerciseMetricKey key) {
  return switch (key) {
    ExerciseMetricKey.weight => "weight",
    ExerciseMetricKey.reps => "reps",
    ExerciseMetricKey.time => "time",
    ExerciseMetricKey.level => "level",
    ExerciseMetricKey.height => "height",
    ExerciseMetricKey.distance => "distance",
    ExerciseMetricKey.leftWeight => "left_weight",
    ExerciseMetricKey.rightWeight => "right_weight",
    ExerciseMetricKey.leftReps => "left_reps",
    ExerciseMetricKey.rightReps => "right_reps",
    ExerciseMetricKey.leftTime => "left_time",
    ExerciseMetricKey.rightTime => "right_time",
  };
}

ExerciseMetricKey exerciseMetricKeyFromStorage(String value) {
  return switch (value) {
    "reps" => ExerciseMetricKey.reps,
    "time" => ExerciseMetricKey.time,
    "level" => ExerciseMetricKey.level,
    "height" => ExerciseMetricKey.height,
    "distance" => ExerciseMetricKey.distance,
    "left_weight" => ExerciseMetricKey.leftWeight,
    "right_weight" => ExerciseMetricKey.rightWeight,
    "left_reps" => ExerciseMetricKey.leftReps,
    "right_reps" => ExerciseMetricKey.rightReps,
    "left_time" => ExerciseMetricKey.leftTime,
    "right_time" => ExerciseMetricKey.rightTime,
    _ => ExerciseMetricKey.weight,
  };
}
