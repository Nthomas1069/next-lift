import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../core/design_system/theme/theme_providers.dart";
import "../../core/design_system/tokens/app_theme_tokens.dart";
import "../../core/design_system/widgets/primary_action_button.dart";
import "../../core/exercises/exercise_providers.dart";
import "../../core/exercises/models/exercise_template.dart";
import "create_exercise_screen.dart";

class ExerciseLibraryScreen extends ConsumerWidget {
  const ExerciseLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = ref.watch(appThemeTokensProvider);
    final templates = ref.watch(exerciseTemplatesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Exercises")),
      body: SafeArea(
        child: templates.when(
          data: (items) {
            if (items.isEmpty) {
              return _ExerciseLibraryEmptyState(
                tokens: tokens,
                onCreatePressed: () => _openCreateExercise(context, ref),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                if (index == items.length) {
                  return PrimaryActionButton(
                    label: "New Exercise",
                    tokens: tokens,
                    onPressed: () => _openCreateExercise(context, ref),
                  );
                }

                return _ExerciseTemplateCard(
                  tokens: tokens,
                  template: items[index],
                  onTap: () => _openEditExercise(context, ref, items[index]),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemCount: items.length + 1,
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                "Couldn't load your exercises.",
                style: TextStyle(color: tokens.semantic.text.muted),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openCreateExercise(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final created = await Navigator.of(context).push<ExerciseTemplate>(
      MaterialPageRoute(builder: (_) => const CreateExerciseScreen()),
    );
    if (created == null || !context.mounted) {
      return;
    }
    ref.invalidate(exerciseTemplatesProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${created.name} saved.")),
    );
  }

  Future<void> _openEditExercise(
    BuildContext context,
    WidgetRef ref,
    ExerciseTemplate template,
  ) async {
    final result = await Navigator.of(context).push<Object?>(
      MaterialPageRoute(
        builder: (_) => CreateExerciseScreen(template: template),
      ),
    );
    if (result == null || !context.mounted) {
      return;
    }
    ref.invalidate(exerciseTemplatesProvider);
    if (result is ExerciseDeletedResult) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${result.name} deleted.")),
      );
      return;
    }

    if (result is! ExerciseTemplate) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${result.name} updated.")),
    );
  }
}

class _ExerciseLibraryEmptyState extends StatelessWidget {
  const _ExerciseLibraryEmptyState({
    required this.tokens,
    required this.onCreatePressed,
  });

  final AppThemeTokens tokens;
  final VoidCallback onCreatePressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: tokens.semantic.surface.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: tokens.foundation.borderSubtle),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.fitness_center_outlined,
                color: tokens.foundation.accentPrimary,
                size: 40,
              ),
              const SizedBox(height: 14),
              Text(
                "No exercises yet",
                style: TextStyle(
                  color: tokens.semantic.text.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Create reusable exercise templates so workouts know which metrics to track.",
                style: TextStyle(
                  color: tokens.semantic.text.muted,
                  height: 1.35,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              PrimaryActionButton(
                label: "Create Exercise",
                tokens: tokens,
                onPressed: onCreatePressed,
                cometActive: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExerciseTemplateCard extends StatelessWidget {
  const _ExerciseTemplateCard({
    required this.tokens,
    required this.template,
    required this.onTap,
  });

  final AppThemeTokens tokens;
  final ExerciseTemplate template;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Ink(
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
                template.name,
                style: TextStyle(
                  color: tokens.semantic.text.primary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
