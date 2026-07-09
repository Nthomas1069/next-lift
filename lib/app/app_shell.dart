import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../core/design_system/theme/theme_providers.dart";
import "../features/home/home_screen.dart";
import "../features/onboarding/onboarding_flow_screen.dart";

class NextLiftAppShell extends ConsumerStatefulWidget {
  const NextLiftAppShell({super.key});

  @override
  ConsumerState<NextLiftAppShell> createState() => _NextLiftAppShellState();
}

class _NextLiftAppShellState extends ConsumerState<NextLiftAppShell> {
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(materialThemeProvider);
    final hydration = ref.watch(themeControllerHydrationProvider);
    final settings = ref.watch(userSettingsProvider);

    final home = hydration.when<Widget>(
      data: (_) => settings.onboardingCompleted
          ? const HomeScreen()
          : OnboardingFlowScreen(
              onComplete: () {},
            ),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => const Scaffold(
        body: Center(child: Text("Failed to load settings")),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: home,
    );
  }
}
