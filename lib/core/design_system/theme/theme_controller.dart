import "package:flutter/foundation.dart";

import "../../settings/user_settings.dart";
import "../tokens/app_theme_tokens.dart";
import "../tokens/theme_registry.dart";

abstract class UserSettingsRepository {
  Future<UserSettings?> load();
  Future<void> save(UserSettings settings);
}

class ThemeController extends ValueNotifier<AppThemeId> {
  ThemeController({
    required UserSettingsRepository repository,
  })  : _repository = repository,
        _settings = const UserSettings(),
        super(ThemeRegistry.defaultThemeId);

  final UserSettingsRepository _repository;
  UserSettings _settings;

  UserSettings get settings => _settings;

  AppThemeTokens get tokens => ThemeRegistry.resolve(value);

  Future<void> hydrate() async {
    final stored = await _repository.load();
    if (stored == null) {
      await _repository.save(_settings);
      notifyListeners();
      return;
    }

    _settings = stored;
    value = stored.themeId;
    notifyListeners();
  }

  Future<void> setTheme(AppThemeId themeId) async {
    if (themeId == value) {
      return;
    }

    _settings = _settings.copyWith(themeId: themeId);
    value = themeId;
    await _repository.save(_settings);
    notifyListeners();
  }

  Future<void> updateSettings(UserSettings updated) async {
    _settings = updated;

    if (value != updated.themeId) {
      value = updated.themeId;
    }

    await _repository.save(_settings);
    notifyListeners();
  }
}
