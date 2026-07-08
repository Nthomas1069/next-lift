import "../design_system/tokens/app_theme_tokens.dart";
import "../design_system/tokens/theme_registry.dart";

class UserSettings {
  const UserSettings({
    this.weightTrackingEnabled = false,
    this.weightUnit = WeightUnit.lb,
    this.weighInReminderCadence = WeighInReminderCadence.off,
    this.themeId = ThemeRegistry.defaultThemeId,
    this.cueSoundEnabled = true,
    this.cueVisualEnabled = true,
    this.cueHapticEnabled = true,
  });

  final bool weightTrackingEnabled;
  final WeightUnit weightUnit;
  final WeighInReminderCadence weighInReminderCadence;
  final AppThemeId themeId;
  final bool cueSoundEnabled;
  final bool cueVisualEnabled;
  final bool cueHapticEnabled;

  UserSettings copyWith({
    bool? weightTrackingEnabled,
    WeightUnit? weightUnit,
    WeighInReminderCadence? weighInReminderCadence,
    AppThemeId? themeId,
    bool? cueSoundEnabled,
    bool? cueVisualEnabled,
    bool? cueHapticEnabled,
  }) {
    return UserSettings(
      weightTrackingEnabled:
          weightTrackingEnabled ?? this.weightTrackingEnabled,
      weightUnit: weightUnit ?? this.weightUnit,
      weighInReminderCadence:
          weighInReminderCadence ?? this.weighInReminderCadence,
      themeId: themeId ?? this.themeId,
      cueSoundEnabled: cueSoundEnabled ?? this.cueSoundEnabled,
      cueVisualEnabled: cueVisualEnabled ?? this.cueVisualEnabled,
      cueHapticEnabled: cueHapticEnabled ?? this.cueHapticEnabled,
    );
  }

  Map<String, Object> toJson() {
    return {
      "weightTrackingEnabled": weightTrackingEnabled,
      "weightUnit": weightUnit.name,
      "weighInReminderCadence": weighInReminderCadence.name,
      "themeId": themeIdToStorage(themeId),
      "cueSoundEnabled": cueSoundEnabled,
      "cueVisualEnabled": cueVisualEnabled,
      "cueHapticEnabled": cueHapticEnabled,
    };
  }

  static UserSettings fromJson(Map<String, Object?> json) {
    return UserSettings(
      weightTrackingEnabled: json["weightTrackingEnabled"] as bool? ?? false,
      weightUnit: _weightUnitFromStorage(json["weightUnit"] as String?),
      weighInReminderCadence: _cadenceFromStorage(
        json["weighInReminderCadence"] as String?,
      ),
      themeId: appThemeIdFromStorage(json["themeId"] as String?),
      cueSoundEnabled: json["cueSoundEnabled"] as bool? ?? true,
      cueVisualEnabled: json["cueVisualEnabled"] as bool? ?? true,
      cueHapticEnabled: json["cueHapticEnabled"] as bool? ?? true,
    );
  }
}

enum WeightUnit {
  lb,
  kg,
}

enum WeighInReminderCadence {
  off,
  daily,
  weekly,
  monthly,
}

WeightUnit _weightUnitFromStorage(String? value) {
  return switch (value) {
    "kg" => WeightUnit.kg,
    _ => WeightUnit.lb,
  };
}

WeighInReminderCadence _cadenceFromStorage(String? value) {
  return switch (value) {
    "daily" => WeighInReminderCadence.daily,
    "weekly" => WeighInReminderCadence.weekly,
    "monthly" => WeighInReminderCadence.monthly,
    _ => WeighInReminderCadence.off,
  };
}
