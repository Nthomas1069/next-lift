import "../design_system/tokens/app_theme_tokens.dart";
import "../design_system/tokens/theme_registry.dart";

class UserSettings {
  const UserSettings({
    this.onboardingCompleted = false,
    this.profileName = "",
    this.weightTrackingEnabled = false,
    this.weightUnit = WeightUnit.lb,
    this.distanceUnit = DistanceUnit.mi,
    this.weighInReminderCadence = WeighInReminderCadence.off,
    this.weighInReminderHour = 8,
    this.weighInReminderMinute = 0,
    this.weighInReminderWeekday = 1,
    this.weighInReminderMonthDay = 1,
    this.themeId = ThemeRegistry.defaultThemeId,
    this.cueSoundEnabled = true,
    this.cueVisualEnabled = true,
    this.cueHapticEnabled = true,
  });

  final bool onboardingCompleted;
  final String profileName;
  final bool weightTrackingEnabled;
  final WeightUnit weightUnit;
  final DistanceUnit distanceUnit;
  final WeighInReminderCadence weighInReminderCadence;
  final int weighInReminderHour;
  final int weighInReminderMinute;
  final int weighInReminderWeekday;
  final int weighInReminderMonthDay;
  final AppThemeId themeId;
  final bool cueSoundEnabled;
  final bool cueVisualEnabled;
  final bool cueHapticEnabled;

  UserSettings copyWith({
    bool? onboardingCompleted,
    String? profileName,
    bool? weightTrackingEnabled,
    WeightUnit? weightUnit,
    DistanceUnit? distanceUnit,
    WeighInReminderCadence? weighInReminderCadence,
    int? weighInReminderHour,
    int? weighInReminderMinute,
    int? weighInReminderWeekday,
    int? weighInReminderMonthDay,
    AppThemeId? themeId,
    bool? cueSoundEnabled,
    bool? cueVisualEnabled,
    bool? cueHapticEnabled,
  }) {
    return UserSettings(
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      profileName: profileName ?? this.profileName,
      weightTrackingEnabled:
          weightTrackingEnabled ?? this.weightTrackingEnabled,
      weightUnit: weightUnit ?? this.weightUnit,
      distanceUnit: distanceUnit ?? this.distanceUnit,
      weighInReminderCadence:
          weighInReminderCadence ?? this.weighInReminderCadence,
      weighInReminderHour: weighInReminderHour ?? this.weighInReminderHour,
      weighInReminderMinute:
          weighInReminderMinute ?? this.weighInReminderMinute,
      weighInReminderWeekday:
          weighInReminderWeekday ?? this.weighInReminderWeekday,
      weighInReminderMonthDay:
          weighInReminderMonthDay ?? this.weighInReminderMonthDay,
      themeId: themeId ?? this.themeId,
      cueSoundEnabled: cueSoundEnabled ?? this.cueSoundEnabled,
      cueVisualEnabled: cueVisualEnabled ?? this.cueVisualEnabled,
      cueHapticEnabled: cueHapticEnabled ?? this.cueHapticEnabled,
    );
  }

  Map<String, Object> toJson() {
    return {
      "profileName": profileName,
      "onboardingCompleted": onboardingCompleted,
      "weightTrackingEnabled": weightTrackingEnabled,
      "weightUnit": weightUnit.name,
      "distanceUnit": distanceUnit.name,
      "weighInReminderCadence": weighInReminderCadence.name,
      "weighInReminderHour": weighInReminderHour,
      "weighInReminderMinute": weighInReminderMinute,
      "weighInReminderWeekday": weighInReminderWeekday,
      "weighInReminderMonthDay": weighInReminderMonthDay,
      "themeId": themeIdToStorage(themeId),
      "cueSoundEnabled": cueSoundEnabled,
      "cueVisualEnabled": cueVisualEnabled,
      "cueHapticEnabled": cueHapticEnabled,
    };
  }

  static UserSettings fromJson(Map<String, Object?> json) {
    return UserSettings(
      profileName: json["profileName"] as String? ?? "",
      onboardingCompleted: json["onboardingCompleted"] as bool? ?? false,
      weightTrackingEnabled: json["weightTrackingEnabled"] as bool? ?? false,
      weightUnit: _weightUnitFromStorage(json["weightUnit"] as String?),
      distanceUnit: _distanceUnitFromStorage(json["distanceUnit"] as String?),
      weighInReminderCadence: _cadenceFromStorage(
        json["weighInReminderCadence"] as String?,
      ),
      weighInReminderHour: _safeHour(json["weighInReminderHour"] as int?),
      weighInReminderMinute: _safeMinute(json["weighInReminderMinute"] as int?),
      weighInReminderWeekday: _safeWeekday(json["weighInReminderWeekday"] as int?),
      weighInReminderMonthDay: _safeMonthDay(
        json["weighInReminderMonthDay"] as int?,
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

enum DistanceUnit {
  mi,
  km,
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

DistanceUnit _distanceUnitFromStorage(String? value) {
  return switch (value) {
    "km" => DistanceUnit.km,
    _ => DistanceUnit.mi,
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

int _safeHour(int? value) {
  if (value == null || value < 0 || value > 23) {
    return 8;
  }
  return value;
}

int _safeMinute(int? value) {
  if (value == null || value < 0 || value > 59) {
    return 0;
  }
  return value;
}

int _safeWeekday(int? value) {
  if (value == null || value < 1 || value > 7) {
    return 1;
  }
  return value;
}

int _safeMonthDay(int? value) {
  if (value == null || value < 0 || value > 31) {
    return 1;
  }
  return value;
}
