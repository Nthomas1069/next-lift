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
  bool _hasCompletedOnboarding = false;

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(materialThemeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: _hasCompletedOnboarding
          ? const HomeScreen()
          : OnboardingFlowScreen(
              onComplete: () {
                setState(() {
                  _hasCompletedOnboarding = true;
                });
              },
            ),
    );
  }
}
