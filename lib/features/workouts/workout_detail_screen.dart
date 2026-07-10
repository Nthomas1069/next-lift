import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../core/design_system/theme/theme_providers.dart";
import "../../core/design_system/widgets/primary_action_button.dart";
import "../../core/exercises/exercise_providers.dart";
import "../../core/workouts/models/workout_template.dart";
import "../../core/workouts/workout_providers.dart";
import "create_workout_screen.dart";
import "widgets/flow/workout_flow_canvas.dart";

class WorkoutDetailScreen extends ConsumerStatefulWidget {
  const WorkoutDetailScreen({super.key, required this.template});

  final WorkoutTemplate template;

  @override
  ConsumerState<WorkoutDetailScreen> createState() =>
      _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends ConsumerState<WorkoutDetailScreen> {
  late WorkoutTemplate _template;

  @override
  void initState() {
    super.initState();
    _template = widget.template;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = ref.watch(appThemeTokensProvider);
    final exercises = ref.watch(exerciseTemplatesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(_template.name)),
      body: SafeArea(
        child: exercises.when(
          data: (exerciseTemplates) {
            final names = {
              for (final exercise in exerciseTemplates)
                exercise.id: exercise.name,
            };
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    children: [
                      _SummaryChip(
                        label: "${_template.allShapes.length} shapes",
                      ),
                      const SizedBox(width: 8),
                      _SummaryChip(
                        label: "${_template.exerciseCount} exercises",
                      ),
                      const SizedBox(width: 8),
                      _SummaryChip(
                        label: "${_template.plannedSetCount} sets",
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: WorkoutFlowCanvas(
                      tokens: tokens,
                      shapes: _template.shapeNodes,
                      exerciseNames: names,
                      mode: WorkoutFlowCanvasMode.preview,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      PrimaryActionButton(
                        label: "Edit Workout",
                        tokens: tokens,
                        onPressed: _editWorkout,
                      ),
                      const SizedBox(height: 12),
                      PrimaryActionButton(
                        label: "Start Workout",
                        tokens: tokens,
                        onPressed: _startWorkout,
                        cometActive: true,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => const Center(
            child: Text("Couldn't load workout exercises."),
          ),
        ),
      ),
    );
  }

  Future<void> _editWorkout() async {
    final updated = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CreateWorkoutScreen(template: _template),
      ),
    );
    if (updated is! WorkoutTemplate || !mounted) {
      return;
    }
    ref.invalidate(workoutTemplatesProvider);
    setState(() {
      _template = updated;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Workout updated.")),
    );
  }

  void _startWorkout() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Start workout flow is coming in the next phase."),
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      visualDensity: VisualDensity.compact,
    );
  }
}
