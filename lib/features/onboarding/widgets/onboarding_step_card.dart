import "package:flutter/material.dart";

import "../../../core/design_system/tokens/app_theme_tokens.dart";

class OnboardingStepCard extends StatelessWidget {
  const OnboardingStepCard({
    super.key,
    required this.type,
    required this.title,
    required this.body,
    required this.tokens,
    this.child,
  });

  final OnboardingCardType type;
  final String title;
  final String body;
  final AppThemeTokens tokens;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final typeLabel = switch (type) {
      OnboardingCardType.explanation => "Feature",
      OnboardingCardType.preference => "Preference",
    };

    return Material(
      color: tokens.semantic.surface.card,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: tokens.foundation.borderSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              typeLabel,
              style: TextStyle(
                color: tokens.semantic.text.muted,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: tokens.semantic.text.primary,
                fontSize: 21,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: TextStyle(
                color: tokens.semantic.text.muted,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            if (child != null) ...[
              const SizedBox(height: 18),
              child!,
            ],
          ],
        ),
      ),
    );
  }
}

enum OnboardingCardType {
  explanation,
  preference,
}
