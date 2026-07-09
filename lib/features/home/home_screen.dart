import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../core/exercises/exercise_providers.dart";
import "../../core/progress/models/body_weight_entry.dart";
import "../../core/progress/models/exercise_metric_entry.dart";
import "../../core/progress/progress_providers.dart";
import "../../core/design_system/theme/theme_providers.dart";
import "../../core/design_system/tokens/app_theme_tokens.dart";
import "../../core/design_system/widgets/primary_action_button.dart";
import "../../core/settings/user_settings.dart";
import "../exercises/create_exercise_screen.dart";
import "../exercises/exercise_library_screen.dart";
import "../profile/profile_settings_screen.dart";

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = ref.watch(appThemeTokensProvider);
    final settings = ref.watch(userSettingsProvider);
    final bodyWeightEntries = ref.watch(bodyWeightEntriesProvider);
    final exerciseTemplates = ref.watch(exerciseTemplatesProvider);
    final exerciseMetricEntries = ref.watch(exerciseMetricEntriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Next Lift"),
        actions: [
          IconButton(
            tooltip: "Profile settings",
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ProfileSettingsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            sliver: SliverList.list(
              children: [
                _DashboardCard(
                  tokens: tokens,
                  title: "Exercise Metrics",
                  child: exerciseMetricEntries.when(
                    data: (entries) => _ExerciseMetricSummary(
                      entries: entries,
                      tokens: tokens,
                    ),
                    loading: () => const _CardLoadingHint(),
                    error: (error, stackTrace) => const _CardErrorHint(
                      message: "Couldn't load exercise metrics.",
                    ),
                  ),
                ),
                bodyWeightEntries.when(
                  data: (entries) {
                    if (!settings.weightTrackingEnabled || entries.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: _DashboardCard(
                        tokens: tokens,
                        title: "Bodyweight Tracking",
                        child: _BodyWeightSummary(
                          settings: settings,
                          entries: entries,
                          tokens: tokens,
                        ),
                      ),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (error, stackTrace) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 36),
              child: exerciseTemplates.when(
                data: (templates) {
                  if (templates.isEmpty) {
                    return Column(
                      children: [
                        const Spacer(flex: 2),
                        _ExerciseHomeEmptyState(
                          tokens: tokens,
                          onCreatePressed: () => _openCreateExercise(
                            context,
                            ref,
                          ),
                        ),
                        const Spacer(),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      const Spacer(),
                      PrimaryActionButton(
                        label: "View Exercises",
                        tokens: tokens,
                        onPressed: () => _openExerciseLibrary(context),
                      ),
                    ],
                  );
                },
                loading: () => Column(
                  children: [
                    const Spacer(),
                    _DashboardCard(
                      tokens: tokens,
                      title: "Exercises",
                      child: const _CardLoadingHint(),
                    ),
                  ],
                ),
                error: (error, stackTrace) => Column(
                  children: [
                    const Spacer(),
                    _DashboardCard(
                      tokens: tokens,
                      title: "Exercises",
                      child: const _CardErrorHint(
                        message: "Couldn't load exercises.",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openCreateExercise(BuildContext context, WidgetRef ref) async {
    final created = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CreateExerciseScreen()),
    );
    if (created == null || !context.mounted) {
      return;
    }

    ref.invalidate(exerciseTemplatesProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Exercise saved.")),
    );
    _openExerciseLibrary(context);
  }

  void _openExerciseLibrary(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ExerciseLibraryScreen(),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.tokens,
    required this.title,
    required this.child,
  });

  final AppThemeTokens tokens;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: tokens.semantic.surface.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tokens.foundation.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: tokens.semantic.text.primary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _BodyWeightSummary extends StatelessWidget {
  const _BodyWeightSummary({
    required this.settings,
    required this.entries,
    required this.tokens,
  });

  final UserSettings settings;
  final List<BodyWeightEntry> entries;
  final AppThemeTokens tokens;

  @override
  Widget build(BuildContext context) {
    final sorted = [...entries]
      ..sort((a, b) => a.loggedAt.compareTo(b.loggedAt));
    final latest = sorted.last;
    final first = sorted.first;
    final delta = latest.weight - first.weight;
    final unitLabel = latest.unit == WeightUnit.kg ? "kg" : "lbs";
    final dateLabel = MaterialLocalizations.of(
      context,
    ).formatMediumDate(latest.loggedAt);
    final cadenceLabel = _cadenceLabel(settings.weighInReminderCadence);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Latest: ${latest.weight.toStringAsFixed(1)} $unitLabel",
          style: TextStyle(
            color: tokens.semantic.text.primary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Change since first entry: ${delta >= 0 ? '+' : ''}${delta.toStringAsFixed(1)} $unitLabel",
          style: TextStyle(color: tokens.semantic.text.muted),
        ),
        const SizedBox(height: 4),
        Text(
          "Entries logged: ${entries.length} • Last updated: $dateLabel",
          style: TextStyle(color: tokens.semantic.text.muted),
        ),
        const SizedBox(height: 8),
        Text(
          "Reminder cadence: $cadenceLabel",
          style: TextStyle(color: tokens.semantic.text.muted),
        ),
      ],
    );
  }
}

class _ExerciseHomeEmptyState extends StatelessWidget {
  const _ExerciseHomeEmptyState({
    required this.tokens,
    required this.onCreatePressed,
  });

  final AppThemeTokens tokens;
  final VoidCallback onCreatePressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 220),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: tokens.foundation.bgElev1.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Let's Get Started!",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: tokens.semantic.text.primary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "The first step is to begin building your personal exercise library.",
            textAlign: TextAlign.center,
            style: TextStyle(color: tokens.semantic.text.muted, height: 1.35),
          ),
          const SizedBox(height: 22),
          PrimaryActionButton(
            label: "Create Your First Exercise",
            tokens: tokens,
            onPressed: onCreatePressed,
            cometActive: true,
          ),
        ],
      ),
    );
  }
}

class _ExerciseMetricSummary extends StatelessWidget {
  const _ExerciseMetricSummary({
    required this.entries,
    required this.tokens,
  });

  final List<ExerciseMetricEntry> entries;
  final AppThemeTokens tokens;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Text(
        "Metrics appear after workouts are logged.",
        style: TextStyle(color: tokens.semantic.text.muted, height: 1.35),
      );
    }

    final byExercise = <String, int>{};
    final byType = <ExerciseMetricType, int>{};
    for (final entry in entries) {
      byExercise.update(entry.exerciseId, (value) => value + 1,
          ifAbsent: () => 1);
      byType.update(entry.metricType, (value) => value + 1, ifAbsent: () => 1);
    }
    final uniqueExercises = byExercise.length;
    final mostTrackedType = byType.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topType = mostTrackedType.first;
    final latest = [...entries]
      ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
    final latestDate = MaterialLocalizations.of(
      context,
    ).formatMediumDate(latest.last.recordedAt);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Total metric entries: ${entries.length}",
          style: TextStyle(
            color: tokens.semantic.text.primary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Exercises tracked: $uniqueExercises",
          style: TextStyle(color: tokens.semantic.text.muted),
        ),
        const SizedBox(height: 4),
        Text(
          "Most tracked metric: ${_metricTypeLabel(topType.key)} (${topType.value})",
          style: TextStyle(color: tokens.semantic.text.muted),
        ),
        const SizedBox(height: 4),
        Text(
          "Last recorded: $latestDate",
          style: TextStyle(color: tokens.semantic.text.muted),
        ),
      ],
    );
  }
}

class _CardLoadingHint extends StatelessWidget {
  const _CardLoadingHint();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        SizedBox(width: 8),
        Text("Loading..."),
      ],
    );
  }
}

class _CardErrorHint extends StatelessWidget {
  const _CardErrorHint({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(message);
  }
}

String _metricTypeLabel(ExerciseMetricType type) {
  return switch (type) {
    ExerciseMetricType.load => "Load",
    ExerciseMetricType.reps => "Reps",
    ExerciseMetricType.duration => "Duration",
    ExerciseMetricType.distance => "Distance",
    ExerciseMetricType.custom => "Custom",
  };
}

String _cadenceLabel(WeighInReminderCadence cadence) {
  return switch (cadence) {
    WeighInReminderCadence.off => "Never",
    WeighInReminderCadence.daily => "Daily",
    WeighInReminderCadence.weekly => "Weekly",
    WeighInReminderCadence.monthly => "Monthly",
  };
}
