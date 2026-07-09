import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../settings/shared_prefs_user_settings_repository.dart";
import "../../settings/user_settings.dart";
import "../tokens/app_theme_tokens.dart";
import "../tokens/theme_registry.dart";
import "app_theme_data.dart";
import "theme_controller.dart";

final userSettingsRepositoryProvider = Provider<UserSettingsRepository>((ref) {
  return SharedPrefsUserSettingsRepository();
});

final themeControllerProvider = ChangeNotifierProvider<ThemeController>((ref) {
  final repository = ref.watch(userSettingsRepositoryProvider);
  return ThemeController(repository: repository);
});

final themeControllerHydrationProvider = FutureProvider<void>((ref) async {
  await ref.read(themeControllerProvider).hydrate();
});

final appThemeIdProvider = Provider<AppThemeId>((ref) {
  // Ensure async hydrate is started.
  ref.watch(themeControllerHydrationProvider);
  return ref.watch(themeControllerProvider.select((controller) => controller.value));
});

final appThemeTokensProvider = Provider<AppThemeTokens>((ref) {
  final id = ref.watch(appThemeIdProvider);
  return ThemeRegistry.resolve(id);
});

final materialThemeProvider = Provider<ThemeData>((ref) {
  final tokens = ref.watch(appThemeTokensProvider);
  return buildMaterialTheme(tokens);
});

final userSettingsProvider = Provider<UserSettings>((ref) {
  return ref.watch(
    themeControllerProvider.select((controller) => controller.settings),
  );
});
