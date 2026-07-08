import "package:flutter/widgets.dart";

enum OnboardingStepType {
  explanation,
  preference,
}

class OnboardingStep {
  const OnboardingStep({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.builder,
  });

  final String id;
  final OnboardingStepType type;
  final String title;
  final String body;
  final Widget Function(BuildContext context) builder;
}
