enum ExerciseMetricType {
  load,
  reps,
  duration,
  distance,
  custom,
}

class ExerciseMetricEntry {
  const ExerciseMetricEntry({
    required this.id,
    required this.exerciseId,
    required this.metricType,
    required this.value,
    required this.recordedAt,
    this.unit,
  });

  final String id;
  final String exerciseId;
  final ExerciseMetricType metricType;
  final double value;
  final String? unit;
  final DateTime recordedAt;

  Map<String, Object?> toJson() {
    return {
      "id": id,
      "exerciseId": exerciseId,
      "metricType": metricType.name,
      "value": value,
      "unit": unit,
      "recordedAt": recordedAt.toIso8601String(),
    };
  }

  static ExerciseMetricEntry fromJson(Map<String, Object?> json) {
    final rawType = json["metricType"] as String?;
    final recordedAtRaw = json["recordedAt"] as String?;
    final parsedRecordedAt =
        recordedAtRaw == null ? null : DateTime.tryParse(recordedAtRaw);
    return ExerciseMetricEntry(
      id: (json["id"] as String?) ?? "",
      exerciseId: (json["exerciseId"] as String?) ?? "",
      metricType: switch (rawType) {
        "load" => ExerciseMetricType.load,
        "reps" => ExerciseMetricType.reps,
        "duration" => ExerciseMetricType.duration,
        "distance" => ExerciseMetricType.distance,
        _ => ExerciseMetricType.custom,
      },
      value: (json["value"] as num?)?.toDouble() ?? 0,
      unit: json["unit"] as String?,
      recordedAt: parsedRecordedAt ?? DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
