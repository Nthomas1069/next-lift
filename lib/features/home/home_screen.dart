import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../core/design_system/theme/theme_providers.dart";
import "../../core/design_system/tokens/app_theme_tokens.dart";
import "../../core/design_system/tokens/theme_registry.dart";

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedThemeId = ref.watch(appThemeIdProvider);
    final themeController = ref.watch(themeControllerProvider);
    final tokens = ref.watch(appThemeTokensProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Next Lift")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Theme"),
            const SizedBox(height: 8),
            DropdownButton<AppThemeId>(
              value: selectedThemeId,
              items: AppThemeId.values.map((id) {
                return DropdownMenuItem<AppThemeId>(
                  value: id,
                  child: Text(_labelForTheme(id)),
                );
              }).toList(),
              onChanged: (id) async {
                if (id != null) {
                  await themeController.setTheme(id);
                }
              },
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: tokens.semantic.setState.active.bg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: tokens.semantic.setState.active.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dashboard Preview",
                    style: TextStyle(
                      color: tokens.semantic.text.primary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: List<Widget>.generate(4, (index) {
                      final lineColor = chartLineColor(
                        tokens: tokens,
                        seriesIndex: index,
                        mode: ChartPaletteMode.vivid,
                        colorSeed: 1,
                      );
                      return Container(
                        width: 44,
                        height: 8,
                        decoration: BoxDecoration(
                          color: lineColor,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _labelForTheme(AppThemeId id) {
  return switch (id) {
    AppThemeId.graphiteTeal => "Graphite Teal",
    AppThemeId.slateLime => "Slate Lime",
    AppThemeId.charcoalBlue => "Charcoal Blue",
    AppThemeId.crimsonSilver => "Crimson Silver",
  };
}
