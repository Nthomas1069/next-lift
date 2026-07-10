import "package:flutter_riverpod/flutter_riverpod.dart";

import "../storage/database_providers.dart";
import "models/exercise_template.dart";
import "repositories/drift_exercise_template_repository.dart";
import "repositories/exercise_template_repository.dart";

final exerciseTemplateRepositoryProvider =
    Provider<ExerciseTemplateRepository>((ref) {
  return DriftExerciseTemplateRepository(
    database: ref.watch(appDatabaseProvider),
  );
});

final exerciseTemplatesProvider =
    FutureProvider<List<ExerciseTemplate>>((ref) async {
  final repository = ref.watch(exerciseTemplateRepositoryProvider);
  return repository.listTemplates();
});
