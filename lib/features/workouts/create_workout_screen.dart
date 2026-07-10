import "dart:async";
import "dart:math";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../core/design_system/theme/theme_providers.dart";
import "../../core/design_system/widgets/primary_action_button.dart";
import "../../core/exercises/exercise_providers.dart";
import "../../core/exercises/models/exercise_template.dart";
import "../../core/workouts/drafts/workout_builder_draft_store.dart";
import "../../core/workouts/models/workout_template.dart";
import "../../core/workouts/repositories/workout_template_repository.dart";
import "../../core/workouts/workout_providers.dart";
import "widgets/flow/workout_flow_canvas.dart";
import "widgets/flow/workout_shape_rail.dart";

class CreateWorkoutScreen extends ConsumerStatefulWidget {
  const CreateWorkoutScreen({super.key, this.template});

  final WorkoutTemplate? template;

  @override
  ConsumerState<CreateWorkoutScreen> createState() =>
      _CreateWorkoutScreenState();
}

class _CreateWorkoutScreenState extends ConsumerState<CreateWorkoutScreen> {
  final _nameController = TextEditingController();
  final List<WorkoutShapeNode> _shapes = [];
  Timer? _draftSaveTimer;
  String? _lastCreatedShapeId;
  bool _isSaving = false;
  bool _draftReady = false;
  bool _draftCleared = false;
  bool _draftDirty = false;
  bool _allowPop = false;
  bool _isPopping = false;

  bool get _isEditing => widget.template != null;
  String get _draftId =>
      widget.template == null ? "new" : "edit:${widget.template!.id}";

  @override
  void initState() {
    super.initState();
    final template = widget.template;
    if (template != null) {
      _nameController.text = template.name;
      _shapes.addAll(template.shapeNodes);
      _lastCreatedShapeId = _lastShapeId(_shapes);
    }
    _nameController.addListener(_handleNameChanged);
    unawaited(_restoreDraft());
  }

  @override
  void dispose() {
    _draftSaveTimer?.cancel();
    _nameController.removeListener(_handleNameChanged);
    if (_draftReady && !_draftCleared) {
      unawaited(_saveDraftSnapshot());
    }
    _nameController.dispose();
    super.dispose();
  }

  void _handleNameChanged() {
    _scheduleDraftSave();
  }

  Future<void> _restoreDraft() async {
    final draft =
        await ref.read(workoutBuilderDraftStoreProvider).load(_draftId);
    if (!mounted) {
      return;
    }
    if (draft != null) {
      setState(() {
        _nameController.text = draft.name;
        _shapes
          ..clear()
          ..addAll(draft.shapes);
        _lastCreatedShapeId =
            draft.focusedShapeId ?? _lastShapeId(draft.shapes);
        _draftReady = true;
      });
      final label =
          draft.name.trim().isEmpty ? "Workout Draft" : draft.name.trim();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$label restored.")),
          );
        }
      });
    } else {
      setState(() {
        _draftReady = true;
      });
    }
  }

  void _scheduleDraftSave() {
    if (!_draftReady || _draftCleared) {
      return;
    }
    _draftDirty = true;
    _draftSaveTimer?.cancel();
    _draftSaveTimer = Timer(
      const Duration(milliseconds: 250),
      () => unawaited(_saveDraftSnapshot()),
    );
  }

  Future<void> _saveDraftSnapshot() async {
    if (!_draftReady || _draftCleared || !_draftDirty) {
      return;
    }
    final store = ref.read(workoutBuilderDraftStoreProvider);
    final name = _nameController.text;
    if (name.trim().isEmpty && _shapes.isEmpty) {
      await store.clear(_draftId);
      _draftDirty = false;
      return;
    }
    await store.save(
      _draftId,
      WorkoutBuilderDraft(
        name: name,
        shapes: List<WorkoutShapeNode>.of(_shapes),
        focusedShapeId: _lastCreatedShapeId,
      ),
    );
    _draftDirty = false;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = ref.watch(appThemeTokensProvider);
    final exercises = ref.watch(exerciseTemplatesProvider);
    return PopScope<Object?>(
      canPop: _allowPop,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || _isPopping) {
          return;
        }
        _isPopping = true;
        _draftSaveTimer?.cancel();
        try {
          await _saveDraftSnapshot();
        } catch (_) {
          _isPopping = false;
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Couldn't save workout draft. Try again."),
              ),
            );
          }
          return;
        }
        if (!context.mounted) {
          return;
        }
        setState(() {
          _allowPop = true;
        });
        Navigator.of(context).pop(result);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? "Edit Workout" : "Create Workout"),
        ),
        body: SafeArea(
          child: !_draftReady
              ? const Center(child: CircularProgressIndicator())
              : exercises.when(
                  data: (exerciseTemplates) {
                    final exerciseNames = {
                      for (final exercise in exerciseTemplates)
                        exercise.id: exercise.name,
                    };
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 70, 12, 76),
                            child: WorkoutFlowCanvas(
                              tokens: tokens,
                              shapes: _shapes,
                              focusedShapeId: _lastCreatedShapeId,
                              exerciseNames: exerciseNames,
                              exerciseTemplates: exerciseTemplates,
                              mode: WorkoutFlowCanvasMode.builder,
                              onShapeDropped: (type) => _addShape(
                                type,
                                exerciseTemplates,
                              ),
                              onShapeDroppedIntoCombination: (parentId, type) =>
                                  _addShape(
                                type,
                                exerciseTemplates,
                                parentShapeId: parentId,
                              ),
                              onAddSet: _addSet,
                              onRemoveSet: _removeSet,
                              onAddExercise: _addExercise,
                              onRemoveExercise: _removeExercise,
                              onExerciseSelected: _selectExercise,
                              onRemoveShape: _removeShape,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          right: 84,
                          top: 8,
                          child: Material(
                            color: tokens.semantic.surface.overlay
                                .withValues(alpha: 0.94),
                            borderRadius: BorderRadius.circular(12),
                            child: TextField(
                              controller: _nameController,
                              textCapitalization: TextCapitalization.words,
                              decoration: const InputDecoration(
                                labelText: "Workout name",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: max(
                            16,
                            MediaQuery.systemGestureInsetsOf(context).right + 8,
                          ),
                          bottom: 88,
                          child: WorkoutShapeRail(
                            tokens: tokens,
                            cometActive: _shapes.isEmpty,
                          ),
                        ),
                        Positioned(
                          left: 16,
                          right: 16,
                          bottom: 12,
                          child: PrimaryActionButton(
                            label: _isEditing
                                ? "Save Workout Changes"
                                : "Save Workout Template",
                            tokens: tokens,
                            onPressed: _isSaving ? null : _saveWorkoutTemplate,
                            isLoading: _isSaving,
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => Center(
                    child: Text(
                      "Couldn't load your exercise library.",
                      style: TextStyle(color: tokens.semantic.text.muted),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  void _addShape(
    WorkoutShapeType type,
    List<ExerciseTemplate> exercises, {
    String? parentShapeId,
  }) {
    if (exercises.isEmpty && type != WorkoutShapeType.combination) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Create an exercise before adding workout shapes."),
        ),
      );
      return;
    }
    final orderIndex = parentShapeId == null
        ? _shapes.length
        : (_findShape(parentShapeId)?.children.length ?? 0);
    final exerciseCount = switch (type) {
      WorkoutShapeType.superSet || WorkoutShapeType.circuit => 2,
      WorkoutShapeType.combination => 0,
      _ => 1,
    };
    final shape = WorkoutShapeNode(
      shapeId: _createId(),
      shapeType: type,
      orderIndex: orderIndex,
      parentShapeId: parentShapeId,
      exercises: List.generate(
        exerciseCount,
        (index) => WorkoutShapeExercise(
          shapeExerciseId: _createId(),
          exerciseTemplateId: "",
          orderIndex: index,
          plannedSets: [
            WorkoutPlannedSet(
              setId: _createId(),
              orderIndex: 0,
            ),
          ],
        ),
      ),
    );
    setState(() {
      _lastCreatedShapeId = shape.shapeId;
      if (parentShapeId == null) {
        _shapes.add(shape);
      } else {
        _replaceShape(
          parentShapeId,
          (parent) => parent.copyWith(
            children: [...parent.children, shape],
          ),
        );
      }
    });
    _scheduleDraftSave();
  }

  void _selectExercise(
    String shapeId,
    String shapeExerciseId,
    String exerciseTemplateId,
  ) {
    setState(() {
      _replaceShape(
        shapeId,
        (shape) => shape.copyWith(
          exercises: [
            for (final exercise in shape.exercises)
              exercise.shapeExerciseId == shapeExerciseId
                  ? exercise.copyWith(
                      exerciseTemplateId: exerciseTemplateId,
                    )
                  : exercise,
          ],
        ),
      );
    });
    _scheduleDraftSave();
  }

  void _addExercise(String shapeId) {
    setState(() {
      _replaceShape(
        shapeId,
        (shape) {
          if (shape.exercises.length >= 10) {
            return shape;
          }
          return shape.copyWith(
            exercises: [
              ...shape.exercises,
              WorkoutShapeExercise(
                shapeExerciseId: _createId(),
                exerciseTemplateId: "",
                orderIndex: shape.exercises.length,
                plannedSets: [
                  WorkoutPlannedSet(
                    setId: _createId(),
                    orderIndex: 0,
                  ),
                ],
              ),
            ],
          );
        },
      );
    });
    _scheduleDraftSave();
  }

  void _removeExercise(String shapeId) {
    setState(() {
      final shape = _findShape(shapeId);
      if (shape == null) {
        return;
      }
      if (shape.exercises.length <= 2) {
        _removeShapeFromFlow(shapeId);
        return;
      }
      _replaceShape(
        shapeId,
        (current) {
          final exercises = [...current.exercises]
            ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex))
            ..removeLast();
          return current.copyWith(
            exercises: [
              for (var index = 0; index < exercises.length; index++)
                exercises[index].copyWith(orderIndex: index),
            ],
          );
        },
      );
    });
    _scheduleDraftSave();
  }

  void _addSet(String shapeId, String shapeExerciseId) {
    setState(() {
      _replaceShape(shapeId, (shape) {
        final targets = shape.shapeType == WorkoutShapeType.superSet ||
                shape.shapeType == WorkoutShapeType.circuit
            ? shape.exercises
                .map((exercise) => exercise.shapeExerciseId)
                .toSet()
            : {shapeExerciseId};
        final exercises = shape.exercises.map((exercise) {
          if (!targets.contains(exercise.shapeExerciseId)) {
            return exercise;
          }
          final nextIndex = exercise.plannedSets.length;
          final defaults = exercise.plannedSets.isEmpty
              ? const <String, double?>{}
              : exercise.plannedSets.last.metricDefaults;
          return exercise.copyWith(
            plannedSets: [
              ...exercise.plannedSets,
              WorkoutPlannedSet(
                setId: _createId(),
                orderIndex: nextIndex,
                metricDefaults: defaults,
              ),
            ],
          );
        }).toList();
        return shape.copyWith(exercises: exercises);
      });
    });
    _scheduleDraftSave();
  }

  void _removeSet(String shapeId, String shapeExerciseId) {
    setState(() {
      final shape = _findShape(shapeId);
      if (shape == null) {
        return;
      }
      final grouped = shape.shapeType == WorkoutShapeType.superSet ||
          shape.shapeType == WorkoutShapeType.circuit;
      final targets = grouped
          ? shape.exercises.map((exercise) => exercise.shapeExerciseId).toSet()
          : {shapeExerciseId};
      final targetExercises = shape.exercises.where(
        (exercise) => targets.contains(exercise.shapeExerciseId),
      );
      if (targetExercises.any((exercise) => exercise.plannedSets.length <= 1)) {
        _removeShapeFromFlow(shapeId);
        return;
      }
      _replaceShape(
        shapeId,
        (current) => current.copyWith(
          exercises: [
            for (final exercise in current.exercises)
              if (targets.contains(exercise.shapeExerciseId))
                exercise.copyWith(
                  plannedSets: ([...exercise.plannedSets]..sort(
                          (a, b) => a.orderIndex.compareTo(b.orderIndex),
                        ))
                      .take(exercise.plannedSets.length - 1)
                      .toList(),
                )
              else
                exercise,
          ],
        ),
      );
    });
    _scheduleDraftSave();
  }

  void _removeShape(String shapeId) {
    setState(() {
      _removeShapeFromFlow(shapeId);
    });
    _scheduleDraftSave();
  }

  void _removeShapeFromFlow(String shapeId) {
    if (_shapes.any((shape) => shape.shapeId == shapeId)) {
      _shapes.removeWhere((shape) => shape.shapeId == shapeId);
      _reindexRoots();
      if (_lastCreatedShapeId == shapeId) {
        _lastCreatedShapeId = _lastShapeId(_shapes);
      }
      return;
    }
    for (var index = 0; index < _shapes.length; index++) {
      _shapes[index] = _removeNestedShape(_shapes[index], shapeId);
    }
    if (_lastCreatedShapeId == shapeId) {
      _lastCreatedShapeId = _lastShapeId(_shapes);
    }
  }

  WorkoutShapeNode _removeNestedShape(
    WorkoutShapeNode parent,
    String shapeId,
  ) {
    final children = parent.children
        .where((child) => child.shapeId != shapeId)
        .map((child) => _removeNestedShape(child, shapeId))
        .toList();
    return parent.copyWith(
      children: [
        for (var index = 0; index < children.length; index++)
          children[index].copyWith(orderIndex: index),
      ],
    );
  }

  WorkoutShapeNode? _findShape(String shapeId) {
    for (final root in _shapes) {
      for (final shape in root.depthFirst) {
        if (shape.shapeId == shapeId) {
          return shape;
        }
      }
    }
    return null;
  }

  String? _lastShapeId(List<WorkoutShapeNode> roots) {
    String? lastShapeId;
    for (final root in roots) {
      for (final shape in root.depthFirst) {
        lastShapeId = shape.shapeId;
      }
    }
    return lastShapeId;
  }

  void _replaceShape(
    String shapeId,
    WorkoutShapeNode Function(WorkoutShapeNode shape) update,
  ) {
    WorkoutShapeNode replace(WorkoutShapeNode shape) {
      if (shape.shapeId == shapeId) {
        return update(shape);
      }
      return shape.copyWith(children: shape.children.map(replace).toList());
    }

    for (var index = 0; index < _shapes.length; index++) {
      _shapes[index] = replace(_shapes[index]);
    }
  }

  void _reindexRoots() {
    for (var index = 0; index < _shapes.length; index++) {
      _shapes[index] = _shapes[index].copyWith(orderIndex: index);
    }
  }

  bool _isValidFlow() {
    if (_shapes.isEmpty) {
      return false;
    }
    for (final root in _shapes) {
      for (final shape in root.depthFirst) {
        if (shape.shapeType == WorkoutShapeType.combination) {
          if (shape.children.isEmpty) {
            return false;
          }
        } else if (shape.shapeType == WorkoutShapeType.circuit &&
            (shape.exercises.length < 2 || shape.exercises.length > 10)) {
          return false;
        } else if (shape.exercises.isEmpty ||
            shape.exercises.any(
              (exercise) =>
                  exercise.exerciseTemplateId.isEmpty ||
                  exercise.plannedSets.isEmpty,
            )) {
          return false;
        }
      }
    }
    return true;
  }

  Future<void> _saveWorkoutTemplate() async {
    final name = _nameController.text.trim();
    if (name.isEmpty || !_isValidFlow()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Add a workout name and complete every shape before saving.",
          ),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });
    final now = DateTime.now().toUtc();
    final existing = widget.template;
    final template = WorkoutTemplate(
      id: existing?.id ?? _createId(),
      name: name,
      normalizedName: normalizeWorkoutTemplateName(name),
      createdAtUtc: existing?.createdAtUtc ?? now,
      updatedAtUtc: now,
      version: existing == null ? 1 : existing.version + 1,
      layoutVersion: 1,
      shapeNodes: _shapes,
    );

    try {
      await ref.read(workoutTemplateRepositoryProvider).saveTemplate(template);
      _draftSaveTimer?.cancel();
      _draftCleared = true;
      try {
        await ref.read(workoutBuilderDraftStoreProvider).clear(_draftId);
      } catch (_) {
        // The saved workout remains authoritative if draft cleanup fails.
      }
      ref.invalidate(workoutTemplatesProvider);
      if (mounted) {
        Navigator.of(context).pop(template);
      }
    } on DuplicateWorkoutTemplateNameException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("A workout with that name already exists."),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Couldn't save workout. Try again.")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}

String _createId() {
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
