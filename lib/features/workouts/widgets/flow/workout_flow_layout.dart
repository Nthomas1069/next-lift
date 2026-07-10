import "dart:math" as math;

import "package:flutter/material.dart";

import "../../../../core/workouts/models/workout_template.dart";

class WorkoutSetGeometry {
  const WorkoutSetGeometry({
    required this.set,
    required this.shapeExercise,
    required this.center,
  });

  final WorkoutPlannedSet set;
  final WorkoutShapeExercise shapeExercise;
  final Offset center;
}

class WorkoutShapeGeometry {
  const WorkoutShapeGeometry({
    required this.shape,
    required this.bounds,
    required this.sets,
  });

  final WorkoutShapeNode shape;
  final Rect bounds;
  final List<WorkoutSetGeometry> sets;
}

class WorkoutFlowLayout {
  const WorkoutFlowLayout({
    required this.canvasSize,
    required this.shapes,
  });

  final Size canvasSize;
  final List<WorkoutShapeGeometry> shapes;

  WorkoutSetGeometry? geometryForSet(String setId) {
    for (final shape in shapes) {
      for (final set in shape.sets) {
        if (set.set.setId == setId) {
          return set;
        }
      }
    }
    return null;
  }
}

class WorkoutFlowLayoutEngine {
  const WorkoutFlowLayoutEngine();

  static const double _canvasWidth = 620;
  static const double _shapeWidth = 420;
  static const double _setGap = 52;
  static const double _verticalGap = 40;

  WorkoutFlowLayout layout(List<WorkoutShapeNode> roots) {
    final sortedRoots = [...roots]
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    final geometries = <WorkoutShapeGeometry>[];
    var top = 80.0;
    for (final shape in sortedRoots) {
      final shapeGeometry = _layoutShape(
        shape,
        Offset((_canvasWidth - _shapeWidth) / 2, top),
      );
      geometries.addAll(shapeGeometry.flattened);
      top += shapeGeometry.bounds.height + _verticalGap;
    }
    return WorkoutFlowLayout(
      canvasSize: Size(_canvasWidth, math.max(640, top + 80)),
      shapes: geometries,
    );
  }

  _ShapeLayoutResult _layoutShape(WorkoutShapeNode shape, Offset origin) {
    if (shape.shapeType == WorkoutShapeType.combination) {
      return _layoutCombination(shape, origin);
    }
    final sets = _orderedSets(shape);
    final localCenters = _localCenters(shape.shapeType, sets.length);
    final lastSetY = localCenters.isEmpty
        ? 56.0
        : localCenters.map((point) => point.dy).reduce(math.max);
    final height = lastSetY + 38;
    final bounds = Rect.fromLTWH(origin.dx, origin.dy, _shapeWidth, height);
    final geometry = WorkoutShapeGeometry(
      shape: shape,
      bounds: bounds,
      sets: [
        for (var index = 0; index < sets.length; index++)
          WorkoutSetGeometry(
            set: sets[index].set,
            shapeExercise: sets[index].exercise,
            center: origin + localCenters[index],
          ),
      ],
    );
    return _ShapeLayoutResult(bounds: bounds, flattened: [geometry]);
  }

  _ShapeLayoutResult _layoutCombination(
    WorkoutShapeNode shape,
    Offset origin,
  ) {
    final children = [...shape.children]
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    final flattened = <WorkoutShapeGeometry>[];
    var childTop = origin.dy + 72;
    for (final child in children) {
      final childLayout = _layoutShape(
        child,
        Offset(origin.dx + 30, childTop),
      );
      flattened.addAll(childLayout.flattened);
      childTop += childLayout.bounds.height + 44;
    }
    final height = math.max(180.0, childTop - origin.dy + 28);
    final bounds = Rect.fromLTWH(origin.dx, origin.dy, _shapeWidth, height);
    flattened.insert(
      0,
      WorkoutShapeGeometry(shape: shape, bounds: bounds, sets: const []),
    );
    return _ShapeLayoutResult(bounds: bounds, flattened: flattened);
  }

  List<_ExerciseSetPair> _orderedSets(WorkoutShapeNode shape) {
    final exercises = [...shape.exercises]
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    final result = <_ExerciseSetPair>[];
    if (shape.shapeType == WorkoutShapeType.circuit) {
      for (final exercise in exercises) {
        if (exercise.plannedSets.isNotEmpty) {
          result.add(_ExerciseSetPair(exercise, exercise.plannedSets.first));
        }
      }
      return result;
    }
    if (shape.shapeType == WorkoutShapeType.superSet) {
      final maxSets = exercises.fold<int>(
        0,
        (count, exercise) => math.max(count, exercise.plannedSets.length),
      );
      for (var pass = 0; pass < maxSets; pass++) {
        for (final exercise in exercises) {
          if (pass < exercise.plannedSets.length) {
            result.add(
              _ExerciseSetPair(exercise, exercise.plannedSets[pass]),
            );
          }
        }
      }
      return result;
    }
    for (final exercise in exercises) {
      final sets = [...exercise.plannedSets]
        ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
      for (final set in sets) {
        result.add(_ExerciseSetPair(exercise, set));
      }
    }
    return result;
  }

  List<Offset> _localCenters(WorkoutShapeType type, int count) {
    if (count == 0) {
      return const [];
    }
    const centerX = _shapeWidth / 2;
    switch (type) {
      case WorkoutShapeType.circuit:
        if (count >= 4) {
          const top = 56.0;
          const rowGap = 72.0;
          const columnOffset = 105.0;
          final rightCount = count ~/ 2;
          final leftReturnCount = count - rightCount - 1;
          final rowCount = math.max(rightCount, leftReturnCount + 1);
          final bottom = top + ((rowCount - 1) * rowGap);
          final rightGap =
              rightCount == 1 ? 0.0 : (bottom - top) / (rightCount - 1);
          const leftReturnTop = top + rowGap;
          final leftReturnGap = leftReturnCount <= 1
              ? 0.0
              : (bottom - leftReturnTop) / (leftReturnCount - 1);
          return [
            const Offset(centerX - columnOffset, top),
            for (var index = 0; index < rightCount; index++)
              Offset(centerX + columnOffset, top + (index * rightGap)),
            for (var index = 0; index < leftReturnCount; index++)
              Offset(
                centerX - columnOffset,
                bottom - (index * leftReturnGap),
              ),
          ];
        }
        final radius = 92.0 + (count * 5);
        return List.generate(count, (index) {
          final angle = count == 2
              ? math.pi - (math.pi * index)
              : (-math.pi / 2) + ((math.pi * 2 * index) / count);
          return Offset(
            centerX + math.cos(angle) * radius,
            48 + radius + math.sin(angle) * radius,
          );
        });
      case WorkoutShapeType.superSet:
        return List.generate(
          count,
          (index) {
            final round = index ~/ 2;
            final secondExercise = index.isOdd;
            return Offset(
              centerX + (secondExercise ? 76 : -76),
              64 + (round * 52) + (secondExercise ? 6 : 0),
            );
          },
        );
      case WorkoutShapeType.dropSet:
        return List.generate(
          count,
          (index) => Offset(
            centerX + 70 - (index * 22),
            56 + (index * _setGap),
          ),
        );
      case WorkoutShapeType.pyramid:
        return List.generate(
          count,
          (index) => Offset(
            centerX + ((index - ((count - 1) / 2)) * 18),
            56 + (index * _setGap),
          ),
        );
      case WorkoutShapeType.reversePyramid:
        return List.generate(
          count,
          (index) => Offset(
            centerX + ((((count - 1) / 2) - index) * 18),
            56 + (index * _setGap),
          ),
        );
      case WorkoutShapeType.intervals:
        return List.generate(
          count,
          (index) => Offset(
            centerX,
            56 + (index * (_setGap + (index.isOdd ? 14 : 0))),
          ),
        );
      case WorkoutShapeType.straightSet:
      case WorkoutShapeType.combination:
        return List.generate(
          count,
          (index) => Offset(centerX, 56 + (index * _setGap)),
        );
    }
  }
}

class _ExerciseSetPair {
  const _ExerciseSetPair(this.exercise, this.set);

  final WorkoutShapeExercise exercise;
  final WorkoutPlannedSet set;
}

class _ShapeLayoutResult {
  const _ShapeLayoutResult({
    required this.bounds,
    required this.flattened,
  });

  final Rect bounds;
  final List<WorkoutShapeGeometry> flattened;
}
