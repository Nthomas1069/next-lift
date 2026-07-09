import "dart:math";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../core/design_system/theme/theme_providers.dart";
import "../../core/design_system/tokens/app_theme_tokens.dart";
import "../../core/design_system/widgets/primary_action_button.dart";
import "../../core/exercises/exercise_providers.dart";
import "../../core/exercises/models/exercise_template.dart";
import "../../core/exercises/repositories/exercise_template_repository.dart";

class ExerciseDeletedResult {
  const ExerciseDeletedResult({required this.name});

  final String name;
}

class CreateExerciseScreen extends ConsumerStatefulWidget {
  const CreateExerciseScreen({super.key, this.template});

  final ExerciseTemplate? template;

  @override
  ConsumerState<CreateExerciseScreen> createState() =>
      _CreateExerciseScreenState();
}

class _CreateExerciseScreenState extends ConsumerState<CreateExerciseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _selectedMetricKeys = <ExerciseMetricKey>{};
  bool _submittedWithoutMetrics = false;
  bool _isSaving = false;

  bool get _isEditing => widget.template != null;

  @override
  void initState() {
    super.initState();
    final template = widget.template;
    if (template == null) {
      return;
    }
    _nameController.text = template.name;
    _selectedMetricKeys.addAll(template.metricKeys);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = ref.watch(appThemeTokensProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? "Edit Exercise" : "Create Exercise"),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: "Exercise name",
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter an exercise name.";
                  }
                  return null;
                },
                onFieldSubmitted: (_) => _save(),
              ),
              const SizedBox(height: 20),
              Text(
                "Tracked Metrics",
                style: TextStyle(
                  color: tokens.semantic.text.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Choose the metrics this exercise should track.",
                style:
                    TextStyle(color: tokens.semantic.text.muted, height: 1.35),
              ),
              const SizedBox(height: 12),
              _MetricSelectionCard(
                tokens: tokens,
                selectedMetricKeys: _selectedMetricKeys,
                onToggle: _toggleMetricKey,
              ),
              if (_submittedWithoutMetrics && _selectedMetricKeys.isEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  "Select at least one tracked metric.",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              PrimaryActionButton(
                label: "Save Exercise",
                tokens: tokens,
                onPressed: _isSaving ? null : _save,
                isLoading: _isSaving,
              ),
              if (_isEditing) ...[
                const SizedBox(height: 14),
                TextButton(
                  onPressed: _isSaving ? null : _confirmDelete,
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                  child: const Text("Delete Exercise"),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _toggleMetricKey(ExerciseMetricKey key, bool selected) {
    setState(() {
      if (selected) {
        _selectedMetricKeys.removeAll(_conflictingMetricKeysFor(key));
        _selectedMetricKeys.add(key);
      } else {
        _selectedMetricKeys.remove(key);
      }
    });
  }

  Future<void> _save() async {
    setState(() {
      _submittedWithoutMetrics = true;
    });
    final hasValidName = _formKey.currentState?.validate() ?? false;
    final hasMetricSelection = _selectedMetricKeys.isNotEmpty;
    if (!hasValidName || !hasMetricSelection) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Add an exercise name and at least one metric."),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final now = DateTime.now().toUtc();
    final name = _nameController.text.trim();
    final existingTemplate = widget.template;
    final template = ExerciseTemplate(
      id: existingTemplate?.id ?? _createExerciseId(),
      name: name,
      normalizedName: normalizeExerciseTemplateName(name),
      metricKeys: _selectedMetricKeys.toList(),
      createdAtUtc: existingTemplate?.createdAtUtc ?? now,
      updatedAtUtc: now,
    );

    try {
      await ref.read(exerciseTemplateRepositoryProvider).saveTemplate(template);
      ref.invalidate(exerciseTemplatesProvider);
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(template);
    } on DuplicateExerciseTemplateNameException {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("An exercise with that name already exists."),
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Couldn't save exercise. Try again."),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _confirmDelete() async {
    final template = widget.template;
    if (template == null) {
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Delete Exercise?"),
          content: const Text(
            "Deleting this exercise removes it from your library. Further tracking for this exercise will cease.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    try {
      await ref
          .read(exerciseTemplateRepositoryProvider)
          .deleteTemplate(template.id);
      ref.invalidate(exerciseTemplatesProvider);
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(ExerciseDeletedResult(name: template.name));
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Couldn't delete exercise. Try again."),
        ),
      );
    }
  }
}

String _createExerciseId() {
  final random = Random.secure();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;

  String twoHex(int value) => value.toRadixString(16).padLeft(2, "0");
  final hex = bytes.map(twoHex).join();
  return [
    hex.substring(0, 8),
    hex.substring(8, 12),
    hex.substring(12, 16),
    hex.substring(16, 20),
    hex.substring(20),
  ].join("-");
}

Set<ExerciseMetricKey> _conflictingMetricKeysFor(ExerciseMetricKey key) {
  return switch (key) {
    ExerciseMetricKey.weight => {
        ExerciseMetricKey.leftWeight,
        ExerciseMetricKey.rightWeight,
      },
    ExerciseMetricKey.leftWeight || ExerciseMetricKey.rightWeight => {
        ExerciseMetricKey.weight,
      },
    ExerciseMetricKey.reps => {
        ExerciseMetricKey.leftReps,
        ExerciseMetricKey.rightReps,
      },
    ExerciseMetricKey.leftReps || ExerciseMetricKey.rightReps => {
        ExerciseMetricKey.reps,
      },
    ExerciseMetricKey.time => {
        ExerciseMetricKey.leftTime,
        ExerciseMetricKey.rightTime,
      },
    ExerciseMetricKey.leftTime || ExerciseMetricKey.rightTime => {
        ExerciseMetricKey.time,
      },
    ExerciseMetricKey.level ||
    ExerciseMetricKey.height ||
    ExerciseMetricKey.distance =>
      const <ExerciseMetricKey>{},
  };
}

class _MetricSelectionCard extends StatelessWidget {
  const _MetricSelectionCard({
    required this.tokens,
    required this.selectedMetricKeys,
    required this.onToggle,
  });

  final AppThemeTokens tokens;
  final Set<ExerciseMetricKey> selectedMetricKeys;
  final void Function(ExerciseMetricKey key, bool selected) onToggle;

  @override
  Widget build(BuildContext context) {
    const metricGroups = [
      _MetricGroup(
        title: "Standard",
        keys: [
          ExerciseMetricKey.weight,
          ExerciseMetricKey.reps,
          ExerciseMetricKey.time,
          ExerciseMetricKey.level,
          ExerciseMetricKey.height,
          ExerciseMetricKey.distance,
        ],
      ),
      _MetricGroup(
        title: "Left / Right",
        keys: [
          ExerciseMetricKey.leftWeight,
          ExerciseMetricKey.rightWeight,
          ExerciseMetricKey.leftReps,
          ExerciseMetricKey.rightReps,
          ExerciseMetricKey.leftTime,
          ExerciseMetricKey.rightTime,
        ],
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tokens.semantic.surface.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tokens.foundation.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final group in metricGroups) ...[
            Text(
              group.title,
              style: TextStyle(
                color: tokens.semantic.text.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final key in group.keys)
                  _MetricFilterChip(
                    metricKey: key,
                    tokens: tokens,
                    selected: selectedMetricKeys.contains(key),
                    onSelected: (selected) => onToggle(key, selected),
                  ),
              ],
            ),
            if (group != metricGroups.last) const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _MetricFilterChip extends StatelessWidget {
  const _MetricFilterChip({
    required this.metricKey,
    required this.tokens,
    required this.selected,
    required this.onSelected,
  });

  final ExerciseMetricKey metricKey;
  final AppThemeTokens tokens;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = selected
        ? tokens.foundation.accentPrimary
        : tokens.semantic.text.primary;
    final borderColor = selected
        ? tokens.foundation.accentPrimary
        : tokens.foundation.borderSubtle;

    return FilterChip(
      label: Text(metricKeyLabel(metricKey)),
      selected: selected,
      showCheckmark: false,
      backgroundColor: tokens.semantic.surface.card,
      selectedColor: tokens.foundation.bgElev2,
      side: BorderSide(color: borderColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      labelStyle:
          TextStyle(color: foregroundColor, fontWeight: FontWeight.w500),
      onSelected: onSelected,
    );
  }
}

class _MetricGroup {
  const _MetricGroup({required this.title, required this.keys});

  final String title;
  final List<ExerciseMetricKey> keys;
}
