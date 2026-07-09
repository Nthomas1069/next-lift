import "package:flutter_riverpod/flutter_riverpod.dart";

import "models/body_weight_entry.dart";
import "models/exercise_metric_entry.dart";
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

final bodyWeightEntriesProvider = FutureProvider<List<BodyWeightEntry>>((ref) async {
  final repository = ref.watch(bodyWeightRepositoryProvider);
  return repository.listEntries();
});

final exerciseMetricEntriesProvider = FutureProvider<List<ExerciseMetricEntry>>((
  ref,
) async {
  final repository = ref.watch(exerciseMetricRepositoryProvider);
  return repository.listEntries();
});
