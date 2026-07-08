import "user_settings.dart";
import "../design_system/theme/theme_controller.dart";

class InMemoryUserSettingsRepository implements UserSettingsRepository {
  UserSettings? _cached;

  @override
  Future<UserSettings?> load() async {
    return _cached;
  }

  @override
  Future<void> save(UserSettings settings) async {
    _cached = settings;
  }
}
