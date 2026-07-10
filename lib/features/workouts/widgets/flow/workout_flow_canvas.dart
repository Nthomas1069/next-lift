import "package:flutter/material.dart";

import "../../../../core/design_system/tokens/app_theme_tokens.dart";
import "../../../../core/design_system/widgets/primary_action_button.dart";
import "../../../../core/exercises/models/exercise_template.dart";
import "../../../../core/workouts/models/workout_template.dart";
import "workout_flow_layout.dart";

enum WorkoutFlowCanvasMode {
  builder,
  preview,
  execution,
}

class WorkoutFlowController extends ChangeNotifier {
  String? get focusedSetId => _focusedSetId;
  String? _focusedSetId;

  void focusSet(String setId) {
    if (_focusedSetId == setId) {
      return;
    }
    _focusedSetId = setId;
    notifyListeners();
  }
}

class WorkoutFlowCanvas extends StatefulWidget {
  const WorkoutFlowCanvas({
    super.key,
    required this.tokens,
    required this.shapes,
    required this.exerciseNames,
    this.exerciseTemplates = const [],
    this.mode = WorkoutFlowCanvasMode.preview,
    this.controller,
    this.focusedShapeId,
    this.onShapeDropped,
    this.onShapeDroppedIntoCombination,
    this.onAddSet,
    this.onRemoveSet,
    this.onAddExercise,
    this.onRemoveExercise,
    this.onExerciseSelected,
    this.onRemoveShape,
  });

  final AppThemeTokens tokens;
  final List<WorkoutShapeNode> shapes;
  final Map<String, String> exerciseNames;
  final List<ExerciseTemplate> exerciseTemplates;
  final WorkoutFlowCanvasMode mode;
  final WorkoutFlowController? controller;
  final String? focusedShapeId;
  final ValueChanged<WorkoutShapeType>? onShapeDropped;
  final void Function(String parentShapeId, WorkoutShapeType type)?
      onShapeDroppedIntoCombination;
  final void Function(String shapeId, String shapeExerciseId)? onAddSet;
  final void Function(String shapeId, String shapeExerciseId)? onRemoveSet;
  final ValueChanged<String>? onAddExercise;
  final ValueChanged<String>? onRemoveExercise;
  final void Function(
    String shapeId,
    String shapeExerciseId,
    String exerciseTemplateId,
  )? onExerciseSelected;
  final ValueChanged<String>? onRemoveShape;

  @override
  State<WorkoutFlowCanvas> createState() => _WorkoutFlowCanvasState();
}

class _WorkoutFlowCanvasState extends State<WorkoutFlowCanvas>
    with SingleTickerProviderStateMixin {
  final _transformationController = TransformationController();
  final _layoutEngine = const WorkoutFlowLayoutEngine();
  late final AnimationController _focusAnimation;
  Animation<Matrix4>? _matrixAnimation;
  Size _viewportSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _focusAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    )..addListener(() {
        final animation = _matrixAnimation;
        if (animation != null) {
          _transformationController.value = animation.value;
        }
      });
    widget.controller?.addListener(_handleFocusRequest);
    if (widget.focusedShapeId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _centerFocusedShape();
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant WorkoutFlowCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_handleFocusRequest);
      widget.controller?.addListener(_handleFocusRequest);
    }
    if (oldWidget.focusedShapeId != widget.focusedShapeId &&
        widget.focusedShapeId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _centerFocusedShape();
        }
      });
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleFocusRequest);
    _focusAnimation.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _handleFocusRequest() {
    final setId = widget.controller?.focusedSetId;
    if (setId == null || _viewportSize.isEmpty) {
      return;
    }
    final layout = _layoutEngine.layout(widget.shapes);
    final geometry = layout.geometryForSet(setId);
    if (geometry == null) {
      return;
    }
    const scale = 1.08;
    final target = Matrix4.identity()
      ..translateByDouble(
        (_viewportSize.width / 2) - (geometry.center.dx * scale),
        (_viewportSize.height / 2) - (geometry.center.dy * scale),
        0,
        1,
      )
      ..scaleByDouble(scale, scale, scale, 1);
    if (MediaQuery.disableAnimationsOf(context)) {
      _transformationController.value = target;
      return;
    }
    _matrixAnimation = Matrix4Tween(
      begin: _transformationController.value,
      end: target,
    ).animate(
      CurvedAnimation(parent: _focusAnimation, curve: Curves.easeOutCubic),
    );
    _focusAnimation.forward(from: 0);
  }

  void _centerFocusedShape() {
    if (_viewportSize.isEmpty || widget.shapes.isEmpty) {
      return;
    }
    final layout = _layoutEngine.layout(widget.shapes);
    if (layout.shapes.isEmpty) {
      return;
    }
    final focusedShapeId = widget.focusedShapeId;
    final focusedGeometry = layout.shapes.where(
      (geometry) => geometry.shape.shapeId == focusedShapeId,
    );
    final center =
        (focusedGeometry.isEmpty ? layout.shapes.last : focusedGeometry.first)
            .bounds
            .center;
    _transformationController.value = Matrix4.identity()
      ..translateByDouble(
        (_viewportSize.width / 2) - center.dx,
        (_viewportSize.height / 2) - center.dy,
        0,
        1,
      );
  }

  @override
  Widget build(BuildContext context) {
    final layout = _layoutEngine.layout(widget.shapes);
    return LayoutBuilder(
      builder: (context, constraints) {
        _viewportSize = Size(constraints.maxWidth, constraints.maxHeight);
        return DragTarget<WorkoutShapeType>(
          onWillAcceptWithDetails: (_) =>
              widget.mode == WorkoutFlowCanvasMode.builder &&
              widget.onShapeDropped != null,
          onAcceptWithDetails: (details) {
            widget.onShapeDropped?.call(details.data);
          },
          builder: (context, candidateData, rejectedData) {
            final highlighted = candidateData.isNotEmpty;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              decoration: BoxDecoration(
                color: widget.tokens.foundation.bgElev1.withValues(
                  alpha: highlighted ? 0.72 : 0.34,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: highlighted
                      ? widget.tokens.foundation.accentPrimary
                      : widget.tokens.foundation.borderSubtle,
                  width: highlighted ? 2 : 1,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: InteractiveViewer(
                      transformationController: _transformationController,
                      constrained: false,
                      minScale: 0.55,
                      maxScale: 2.2,
                      boundaryMargin: const EdgeInsets.all(240),
                      child: SizedBox(
                        width: layout.canvasSize.width,
                        height: layout.canvasSize.height,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned.fill(
                              child: CustomPaint(
                                painter: _FlowConnectorPainter(
                                  layout: layout,
                                  color: widget.tokens.foundation.borderStrong,
                                  accent: widget.tokens.foundation.accentPrimary
                                      .withValues(alpha: 0.72),
                                ),
                              ),
                            ),
                            for (final shapeGeometry in layout.shapes)
                              _buildShape(shapeGeometry),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (widget.shapes.isEmpty)
                    Positioned(
                      left: 16,
                      right: 72,
                      bottom: 14,
                      child: IgnorePointer(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 220,
                            child: Text(
                              highlighted
                                  ? "Release to add this\nworkout type."
                                  : "Drag and drop a workout type\nto begin.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: highlighted
                                    ? widget.tokens.semantic.text.primary
                                    : widget.tokens.semantic.text.muted,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildShape(WorkoutShapeGeometry geometry) {
    final shape = geometry.shape;
    final isCombination = shape.shapeType == WorkoutShapeType.combination;
    return Positioned.fromRect(
      rect: geometry.bounds,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: isCombination && widget.mode == WorkoutFlowCanvasMode.builder
                ? DragTarget<WorkoutShapeType>(
                    onWillAcceptWithDetails: (details) =>
                        details.data != WorkoutShapeType.combination ||
                        shape.children.isEmpty,
                    onAcceptWithDetails: (details) {
                      widget.onShapeDroppedIntoCombination
                          ?.call(shape.shapeId, details.data);
                    },
                    builder: (context, candidateData, rejectedData) {
                      return _ShapeBackdrop(
                        tokens: widget.tokens,
                        combination: true,
                        highlighted: candidateData.isNotEmpty,
                      );
                    },
                  )
                : _ShapeBackdrop(
                    tokens: widget.tokens,
                    combination: isCombination,
                    highlighted: false,
                  ),
          ),
          Positioned(
            top: 6,
            left: 40,
            right: 40,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color:
                      widget.tokens.foundation.bgElev1.withValues(alpha: 0.96),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      workoutShapeTypeLabel(shape.shapeType),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: widget.tokens.semantic.text.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (widget.mode == WorkoutFlowCanvasMode.builder &&
                        isCombination) ...[
                      const SizedBox(width: 5),
                      SizedBox.square(
                        dimension: 18,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints.tightFor(
                            width: 18,
                            height: 18,
                          ),
                          visualDensity: VisualDensity.compact,
                          tooltip: "Remove shape",
                          onPressed: () =>
                              widget.onRemoveShape?.call(shape.shapeId),
                          icon: const Icon(Icons.close_rounded, size: 14),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          for (final setGeometry in geometry.sets)
            Positioned(
              left: setGeometry.center.dx - geometry.bounds.left - 72,
              top: setGeometry.center.dy - geometry.bounds.top - 22,
              width: 144,
              height: 44,
              child: _SetNode(
                tokens: widget.tokens,
                label: widget.exerciseNames[
                        setGeometry.shapeExercise.exerciseTemplateId] ??
                    "Choose exercise",
                active:
                    widget.controller?.focusedSetId == setGeometry.set.setId,
                exerciseTemplates: widget.exerciseTemplates,
                editable: widget.mode == WorkoutFlowCanvasMode.builder,
                onExerciseSelected: (exerciseId) =>
                    widget.onExerciseSelected?.call(
                  shape.shapeId,
                  setGeometry.shapeExercise.shapeExerciseId,
                  exerciseId,
                ),
              ),
            ),
          if (widget.mode == WorkoutFlowCanvasMode.builder &&
              geometry.sets.isNotEmpty)
            Positioned(
              left: geometry.sets.last.center.dx - geometry.bounds.left - 84,
              top: geometry.sets.last.center.dy - geometry.bounds.top + 10,
              width: 24,
              height: 24,
              child: _SetCornerButton(
                tokens: widget.tokens,
                tooltip: switch (shape.shapeType) {
                  WorkoutShapeType.superSet => "Remove superset set pair",
                  WorkoutShapeType.circuit => "Remove circuit exercise",
                  _ => "Remove set",
                },
                icon: Icons.remove_rounded,
                onPressed: () {
                  if (shape.shapeType == WorkoutShapeType.circuit) {
                    widget.onRemoveExercise?.call(shape.shapeId);
                  } else {
                    widget.onRemoveSet?.call(
                      shape.shapeId,
                      geometry.sets.last.shapeExercise.shapeExerciseId,
                    );
                  }
                },
              ),
            ),
          if (widget.mode == WorkoutFlowCanvasMode.builder &&
              geometry.sets.isNotEmpty &&
              (shape.shapeType != WorkoutShapeType.circuit ||
                  shape.exercises.length < 10))
            Positioned(
              left: geometry.sets.last.center.dx - geometry.bounds.left + 60,
              top: geometry.sets.last.center.dy - geometry.bounds.top + 10,
              width: 24,
              height: 24,
              child: _SetCornerButton(
                tokens: widget.tokens,
                tooltip: switch (shape.shapeType) {
                  WorkoutShapeType.superSet => "Add superset set pair",
                  WorkoutShapeType.circuit => "Add circuit exercise",
                  _ => "Add set",
                },
                icon: Icons.add_rounded,
                onPressed: () {
                  if (shape.shapeType == WorkoutShapeType.circuit) {
                    widget.onAddExercise?.call(shape.shapeId);
                  } else {
                    widget.onAddSet?.call(
                      shape.shapeId,
                      geometry.sets.last.shapeExercise.shapeExerciseId,
                    );
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _ShapeBackdrop extends StatelessWidget {
  const _ShapeBackdrop({
    required this.tokens,
    required this.combination,
    required this.highlighted,
  });

  final AppThemeTokens tokens;
  final bool combination;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: combination
            ? tokens.foundation.bgElev2.withValues(
                alpha: highlighted ? 0.54 : 0.28,
              )
            : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: highlighted
              ? tokens.foundation.accentPrimary
              : combination
                  ? tokens.foundation.accentPrimary.withValues(alpha: 0.44)
                  : Colors.transparent,
          width: highlighted ? 2 : 1,
        ),
      ),
    );
  }
}

class _SetNode extends StatelessWidget {
  const _SetNode({
    required this.tokens,
    required this.label,
    required this.active,
    required this.exerciseTemplates,
    required this.editable,
    required this.onExerciseSelected,
  });

  final AppThemeTokens tokens;
  final String label;
  final bool active;
  final List<ExerciseTemplate> exerciseTemplates;
  final bool editable;
  final ValueChanged<String> onExerciseSelected;

  @override
  Widget build(BuildContext context) {
    final visual = active
        ? tokens.semantic.setState.active
        : tokens.semantic.setState.ready;
    final node = Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: visual.bg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: visual.border, width: active ? 2 : 1),
              boxShadow: active
                  ? [
                      BoxShadow(
                        color: tokens.foundation.accentGlow
                            .withValues(alpha: 0.28),
                        blurRadius: 18,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: tokens.semantic.text.primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        if (active)
          const Positioned(
            left: -8,
            right: -8,
            top: -8,
            bottom: -8,
            child: IgnorePointer(
              child: CometOrbit(
                color: Colors.white,
                borderRadius: 14,
                bleed: 8,
              ),
            ),
          ),
      ],
    );
    if (!editable) {
      return node;
    }
    return MenuAnchor(
      menuChildren: [
        for (final exercise in exerciseTemplates)
          MenuItemButton(
            onPressed: () => onExerciseSelected(exercise.id),
            child: Text(exercise.name),
          ),
      ],
      builder: (context, controller, child) {
        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            controller.isOpen ? controller.close() : controller.open();
          },
          child: node,
        );
      },
    );
  }
}

class _SetCornerButton extends StatelessWidget {
  const _SetCornerButton({
    required this.tokens,
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final AppThemeTokens tokens;
  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: tokens.foundation.bgElev1,
        shape: BoxShape.circle,
        border: Border.all(color: tokens.foundation.borderStrong),
      ),
      child: IconButton(
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(width: 24, height: 24),
        splashRadius: 14,
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
      ),
    );
  }
}

class _FlowConnectorPainter extends CustomPainter {
  const _FlowConnectorPainter({
    required this.layout,
    required this.color,
    required this.accent,
  });

  final WorkoutFlowLayout layout;
  final Color color;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final sortedShapes = [...layout.shapes]
      ..sort((a, b) => a.bounds.top.compareTo(b.bounds.top));
    WorkoutSetGeometry? previousLast;
    for (final shape in sortedShapes) {
      final internalPaint =
          shape.shape.shapeType == WorkoutShapeType.superSet ||
                  shape.shape.shapeType == WorkoutShapeType.circuit
              ? (Paint()
                ..color = accent
                ..strokeWidth = 2.2
                ..style = PaintingStyle.stroke
                ..strokeCap = StrokeCap.round)
              : paint;
      if (shape.shape.shapeType == WorkoutShapeType.circuit) {
        _drawCircuitPath(
          canvas,
          internalPaint,
          shape.sets.map((set) => set.center).toList(),
        );
      } else {
        for (var index = 1; index < shape.sets.length; index++) {
          _drawCurve(
            canvas,
            internalPaint,
            shape.sets[index - 1].center,
            shape.sets[index].center,
          );
        }
      }
      if (shape.sets.isNotEmpty) {
        if (previousLast != null) {
          final chainPaint = Paint()
            ..color = accent
            ..strokeWidth = 2.4
            ..style = PaintingStyle.stroke;
          _drawCurve(
            canvas,
            chainPaint,
            previousLast.center,
            shape.sets.first.center,
          );
        }
        previousLast = shape.sets.last;
      }
    }
  }

  void _drawCircuitPath(
    Canvas canvas,
    Paint paint,
    List<Offset> centers,
  ) {
    if (centers.length < 2) {
      return;
    }
    if (centers.length == 2) {
      final sorted = [...centers]..sort((a, b) => a.dx.compareTo(b.dx));
      final left = sorted.first;
      final right = sorted.last;
      final midpointX = (left.dx + right.dx) / 2;
      final top = Path()
        ..moveTo(left.dx, left.dy)
        ..quadraticBezierTo(midpointX, left.dy - 72, right.dx, right.dy);
      final bottom = Path()
        ..moveTo(left.dx, left.dy)
        ..quadraticBezierTo(midpointX, left.dy + 72, right.dx, right.dy);
      canvas
        ..drawPath(top, paint)
        ..drawPath(bottom, paint);
      return;
    }
    _drawClosedCircuit(canvas, paint, centers);
  }

  void _drawClosedCircuit(
    Canvas canvas,
    Paint paint,
    List<Offset> centers,
  ) {
    if (centers.length < 2) {
      return;
    }
    final path = Path()..moveTo(centers.first.dx, centers.first.dy);
    for (final center in centers.skip(1)) {
      path.lineTo(center.dx, center.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawCurve(Canvas canvas, Paint paint, Offset start, Offset end) {
    final delta = end - start;
    if (delta.distance <= 44) {
      return;
    }
    final direction = delta / delta.distance;
    final visibleStart = start + (direction * 22);
    final visibleEnd = end - (direction * 22);
    final midpoint = (visibleStart.dy + visibleEnd.dy) / 2;
    final path = Path()
      ..moveTo(visibleStart.dx, visibleStart.dy)
      ..cubicTo(
        visibleStart.dx,
        midpoint,
        visibleEnd.dx,
        midpoint,
        visibleEnd.dx,
        visibleEnd.dy,
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _FlowConnectorPainter oldDelegate) {
    return oldDelegate.layout != layout ||
        oldDelegate.color != color ||
        oldDelegate.accent != accent;
  }
}
