import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../core/design_system/theme/theme_providers.dart";
import "../../core/design_system/tokens/app_theme_tokens.dart";
import "../../core/design_system/widgets/primary_action_button.dart";
import "../../core/workouts/models/workout_template.dart";
import "../../core/workouts/workout_providers.dart";
import "create_workout_screen.dart";
import "workout_detail_screen.dart";

class WorkoutLibraryScreen extends ConsumerWidget {
  const WorkoutLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = ref.watch(appThemeTokensProvider);
    final workoutTemplates = ref.watch(workoutTemplatesProvider);
    final newWorkoutDraft = ref.watch(workoutBuilderDraftProvider("new"));
    final hasNewWorkoutDraft = newWorkoutDraft.asData?.value != null;

    return Scaffold(
      appBar: AppBar(title: const Text("Workouts")),
      body: SafeArea(
        child: workoutTemplates.when(
          data: (templates) {
            if (templates.isEmpty) {
              return _WorkoutLibraryEmptyState(
                tokens: tokens,
                onCreatePressed: () => _openCreateWorkout(context, ref),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: templates.length + 1,
              itemBuilder: (context, index) {
                if (index == templates.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: PrimaryActionButton(
                      label: hasNewWorkoutDraft
                          ? "Resume Create Workout"
                          : "Create Workout",
                      tokens: tokens,
                      onPressed: () => _openCreateWorkout(context, ref),
                      cometActive: true,
                    ),
                  );
                }
                final template = templates[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _WorkoutTemplateCard(
                    tokens: tokens,
                    template: template,
                    onTap: () => _openWorkoutDetail(context, ref, template),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Text(
              "Couldn't load workouts.",
              style: TextStyle(color: tokens.semantic.text.muted),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openCreateWorkout(BuildContext context, WidgetRef ref) async {
    final created = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CreateWorkoutScreen()),
    );
    if (!context.mounted) {
      return;
    }
    ref.invalidate(workoutBuilderDraftProvider("new"));
    if (created == null) {
      return;
    }
    ref.invalidate(workoutTemplatesProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Workout template saved.")),
    );
  }

  Future<void> _openWorkoutDetail(
    BuildContext context,
    WidgetRef ref,
    WorkoutTemplate template,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WorkoutDetailScreen(template: template),
      ),
    );
    ref.invalidate(workoutTemplatesProvider);
  }
}

class _WorkoutTemplateCard extends StatelessWidget {
  const _WorkoutTemplateCard({
    required this.tokens,
    required this.template,
    required this.onTap,
  });

  final AppThemeTokens tokens;
  final WorkoutTemplate template;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final updatedLabel = MaterialLocalizations.of(
      context,
    ).formatShortDate(template.updatedAtUtc.toLocal());
    final shapeCount = template.allShapes.length;
    final exerciseCount = template.exerciseCount;
    final setCount = template.plannedSetCount;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
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
                template.name,
                style: TextStyle(
                  color: tokens.semantic.text.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "$shapeCount shapes • $exerciseCount exercises • $setCount sets",
                style: TextStyle(color: tokens.semantic.text.muted),
              ),
              const SizedBox(height: 8),
              Text(
                "Updated $updatedLabel",
                style: TextStyle(color: tokens.semantic.text.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkoutLibraryEmptyState extends StatelessWidget {
  const _WorkoutLibraryEmptyState({
    required this.tokens,
    required this.onCreatePressed,
  });

  final AppThemeTokens tokens;
  final VoidCallback onCreatePressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Spacer(flex: 2),
          Container(
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
                  "No Workouts Yet",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: tokens.semantic.text.primary,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Create your first workout template to start organizing your gym sessions.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: tokens.semantic.text.muted,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 22),
                PrimaryActionButton(
                  label: "Create Your First Workout",
                  tokens: tokens,
                  onPressed: onCreatePressed,
                  cometActive: true,
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
