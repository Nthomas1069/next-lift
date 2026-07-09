import "dart:convert";

import "package:shared_preferences/shared_preferences.dart";

import "../design_system/theme/theme_controller.dart";
import "user_settings.dart";

class SharedPrefsUserSettingsRepository implements UserSettingsRepository {
  static const String _storageKey = "next_lift.user_settings.v1";

  @override
  Future<UserSettings?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }
      return UserSettings.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> save(UserSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = jsonEncode(settings.toJson());
    await prefs.setString(_storageKey, payload);
  }
}
