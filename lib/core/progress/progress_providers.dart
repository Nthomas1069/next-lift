import "package:flutter_riverpod/flutter_riverpod.dart";

import "repositories/body_weight_repository.dart";
import "repositories/exercise_metric_repository.dart";
import "repositories/shared_prefs_body_weight_repository.dart";
import "repositories/shared_prefs_exercise_metric_repository.dart";

final bodyWeightRepositoryProvider = Provider<BodyWeightRepository>((ref) {
  return SharedPrefsBodyWeightRepository();
});

final exerciseMetricRepositoryProvider = Provider<ExerciseMetricRepository>((
  ref,
) {
  return SharedPrefsExerciseMetricRepository();
});
