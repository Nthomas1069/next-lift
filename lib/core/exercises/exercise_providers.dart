import "package:flutter_riverpod/flutter_riverpod.dart";

import "models/exercise_template.dart";
import "repositories/exercise_template_repository.dart";
import "repositories/shared_prefs_exercise_template_repository.dart";

final exerciseTemplateRepositoryProvider =
    Provider<ExerciseTemplateRepository>((ref) {
  return SharedPrefsExerciseTemplateRepository();
});

final exerciseTemplatesProvider =
    FutureProvider<List<ExerciseTemplate>>((ref) async {
  final repository = ref.watch(exerciseTemplateRepositoryProvider);
  return repository.listTemplates();
});
