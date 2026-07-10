import "dart:math" as math;

import "package:flutter/material.dart";

import "../../../../core/design_system/tokens/app_theme_tokens.dart";
import "../../../../core/design_system/widgets/primary_action_button.dart";
import "../../../../core/workouts/models/workout_template.dart";

class WorkoutShapeRail extends StatefulWidget {
  const WorkoutShapeRail({
    super.key,
    required this.tokens,
    this.cometActive = false,
  });

  final AppThemeTokens tokens;
  final bool cometActive;

  @override
  State<WorkoutShapeRail> createState() => _WorkoutShapeRailState();
}

class _WorkoutShapeRailState extends State<WorkoutShapeRail> {
  bool _expanded = false;
  bool _showLabels = false;

  void _toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
      if (!_expanded) {
        _showLabels = false;
      }
    });
  }

  void _collapse() {
    if (!_expanded) {
      return;
    }
    setState(() {
      _expanded = false;
      _showLabels = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final expandedHeight =
        math.min(MediaQuery.sizeOf(context).height * 0.76, 524.0);
    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      alignment: Alignment.bottomRight,
      clipBehavior: _expanded ? Clip.antiAlias : Clip.none,
      child: Container(
        width: _expanded ? (_showLabels ? 184 : 72) : 52,
        height: _expanded ? expandedHeight : 52,
        clipBehavior: Clip.none,
        decoration: BoxDecoration(
          color: widget.tokens.semantic.surface.overlay.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: widget.tokens.foundation.borderSubtle),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.22),
              blurRadius: 18,
              offset: const Offset(-4, 6),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  if (_expanded)
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(6, 8, 6, 6),
                        children: [
                          for (final type in WorkoutShapeType.values)
                            _ShapeRailItem(
                              tokens: widget.tokens,
                              type: type,
                              showLabel: _showLabels,
                              onDragCompleted: _collapse,
                            ),
                        ],
                      ),
                    ),
                  if (_expanded) const Divider(height: 1),
                  if (_expanded)
                    SizedBox(
                      height: 24,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          textStyle: const TextStyle(fontSize: 10),
                        ),
                        onPressed: () {
                          setState(() {
                            _showLabels = !_showLabels;
                          });
                        },
                        child:
                            Text(_showLabels ? "Hide labels" : "Show labels"),
                      ),
                    ),
                  SizedBox(
                    height: 50,
                    child: Center(
                      child: IconButton(
                        tooltip: _expanded
                            ? "Close shape palette"
                            : "Open shape palette",
                        onPressed: _toggleExpanded,
                        icon: Icon(
                          _expanded
                              ? Icons.expand_more_rounded
                              : Icons.expand_less_rounded,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.cometActive && !_expanded)
              const Positioned(
                left: -8,
                right: -8,
                top: -8,
                bottom: -8,
                child: IgnorePointer(
                  child: CometOrbit(
                    color: Colors.white,
                    borderRadius: 16,
                    bleed: 8,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ShapeRailItem extends StatelessWidget {
  const _ShapeRailItem({
    required this.tokens,
    required this.type,
    required this.showLabel,
    required this.onDragCompleted,
  });

  final AppThemeTokens tokens;
  final WorkoutShapeType type;
  final bool showLabel;
  final VoidCallback onDragCompleted;

  @override
  Widget build(BuildContext context) {
    final label = workoutShapeTypeLabel(type);
    final content = Container(
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      padding: EdgeInsets.symmetric(horizontal: showLabel ? 10 : 2),
      decoration: BoxDecoration(
        color: tokens.foundation.bgElev1.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: tokens.foundation.borderSubtle),
      ),
      child: Row(
        mainAxisAlignment:
            showLabel ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          WorkoutShapeGlyph(
            type: type,
            color: tokens.semantic.text.primary,
            size: 30,
          ),
          if (showLabel) ...[
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: tokens.semantic.text.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );

    return Semantics(
      label: "$label. Drag to add.",
      button: true,
      child: Draggable<WorkoutShapeType>(
        data: type,
        dragAnchorStrategy: pointerDragAnchorStrategy,
        onDragCompleted: onDragCompleted,
        feedback: Material(
          color: Colors.transparent,
          child: Container(
            width: 148,
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: tokens.semantic.surface.overlay,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: tokens.foundation.accentPrimary),
              boxShadow: [
                BoxShadow(
                  color: tokens.foundation.accentGlow.withValues(alpha: 0.35),
                  blurRadius: 18,
                ),
              ],
            ),
            child: Row(
              children: [
                WorkoutShapeGlyph(
                  type: type,
                  color: tokens.semantic.text.primary,
                  size: 30,
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(
                    color: tokens.semantic.text.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        childWhenDragging: Opacity(opacity: 0.35, child: content),
        child: Tooltip(message: label, child: content),
      ),
    );
  }
}

class WorkoutShapeGlyph extends StatelessWidget {
  const WorkoutShapeGlyph({
    super.key,
    required this.type,
    required this.color,
    this.size = 32,
  });

  final WorkoutShapeType type;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _WorkoutShapeGlyphPainter(type, color)),
    );
  }
}

class _WorkoutShapeGlyphPainter extends CustomPainter {
  const _WorkoutShapeGlyphPainter(this.type, this.color);

  final WorkoutShapeType type;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final dot = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final ys = [size.height * 0.24, size.height * 0.5, size.height * 0.76];
    final left = size.width * 0.12;
    final right = size.width * 0.88;
    final dotRadius = math.max(1.8, size.width * 0.065);
    final dotGap = math.max(3.0, size.width * 0.1);

    void lineWithDot(
      double y,
      double start,
      double end, {
      bool dotLeft = false,
    }) {
      final dotCenter = dotLeft ? start : end;
      final lineStart = dotLeft ? start + dotRadius + dotGap : start;
      final lineEnd = dotLeft ? end : end - dotRadius - dotGap;
      canvas.drawLine(Offset(lineStart, y), Offset(lineEnd, y), stroke);
      canvas.drawCircle(
        Offset(dotCenter, y),
        dotRadius,
        dot,
      );
    }

    void separatedLine(Offset start, Offset end) {
      final delta = end - start;
      final distance = delta.distance;
      if (distance == 0) {
        return;
      }
      final inset = (dotRadius + dotGap) / distance;
      canvas.drawLine(
        start + (delta * inset),
        end - (delta * inset),
        stroke,
      );
    }

    switch (type) {
      case WorkoutShapeType.straightSet:
        for (final y in ys) {
          lineWithDot(y, left, right);
        }
      case WorkoutShapeType.superSet:
        lineWithDot(ys[0], left, right);
        lineWithDot(ys[1], left, right, dotLeft: true);
        lineWithDot(ys[2], left, right);
      case WorkoutShapeType.circuit:
        final points = [
          Offset(size.width / 2, size.height * 0.12),
          Offset(size.width * 0.16, size.height * 0.82),
          Offset(size.width * 0.84, size.height * 0.82),
        ];
        separatedLine(points[0], points[1]);
        separatedLine(points[1], points[2]);
        separatedLine(points[2], points[0]);
        for (final point in points) {
          canvas.drawCircle(point, dotRadius, dot);
        }
      case WorkoutShapeType.dropSet:
        for (var index = 0; index < ys.length; index++) {
          lineWithDot(ys[index], left + (index * 6), right);
        }
      case WorkoutShapeType.pyramid:
        final lengths = [0.32, 0.52, 0.72];
        for (var index = 0; index < ys.length; index++) {
          final half = size.width * lengths[index] / 2;
          lineWithDot(ys[index], size.width / 2 - half, size.width / 2 + half);
        }
      case WorkoutShapeType.reversePyramid:
        final lengths = [0.72, 0.52, 0.32];
        for (var index = 0; index < ys.length; index++) {
          final half = size.width * lengths[index] / 2;
          lineWithDot(ys[index], size.width / 2 - half, size.width / 2 + half);
        }
      case WorkoutShapeType.intervals:
        lineWithDot(ys[0], left, right);
        canvas.drawCircle(
          Offset(size.width / 2, ys[1]),
          dotRadius,
          dot,
        );
        lineWithDot(ys[2], left, right);
      case WorkoutShapeType.combination:
        final inset = size.width * 0.18;
        canvas.drawLine(
          Offset(inset, inset),
          Offset(size.width - inset, size.height - inset),
          stroke,
        );
        canvas.drawLine(
          Offset(size.width - inset, inset),
          Offset(inset, size.height - inset),
          stroke,
        );
        final points = [
          Offset(size.width * 0.5, size.height * 0.18),
          Offset(size.width * 0.82, size.height * 0.5),
          Offset(size.width * 0.5, size.height * 0.82),
          Offset(size.width * 0.18, size.height * 0.5),
        ];
        for (final point in points) {
          canvas.drawCircle(point, dotRadius, dot);
        }
    }
  }

  @override
  bool shouldRepaint(covariant _WorkoutShapeGlyphPainter oldDelegate) {
    return oldDelegate.type != type || oldDelegate.color != color;
  }
}
