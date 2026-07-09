import "../../settings/user_settings.dart";

class BodyWeightEntry {
  const BodyWeightEntry({
    required this.id,
    required this.weight,
    required this.unit,
    required this.loggedAt,
  });

  final String id;
  final double weight;
  final WeightUnit unit;
  final DateTime loggedAt;

  Map<String, Object> toJson() {
    return {
      "id": id,
      "weight": weight,
      "unit": unit.name,
      "loggedAt": loggedAt.toIso8601String(),
    };
  }

  static BodyWeightEntry fromJson(Map<String, Object?> json) {
    final unitRaw = json["unit"] as String?;
    final loggedAtRaw = json["loggedAt"] as String?;
    final parsedLoggedAt =
        loggedAtRaw == null ? null : DateTime.tryParse(loggedAtRaw);
    return BodyWeightEntry(
      id: (json["id"] as String?) ?? "",
      weight: (json["weight"] as num?)?.toDouble() ?? 0,
      unit: switch (unitRaw) {
        "kg" => WeightUnit.kg,
        _ => WeightUnit.lb,
      },
      loggedAt: parsedLoggedAt ?? DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
