import "package:flutter_riverpod/flutter_riverpod.dart";

import "../storage/database_providers.dart";
import "drafts/workout_builder_draft_store.dart";
import "models/workout_template.dart";
import "repositories/drift_workout_template_repository.dart";
import "repositories/workout_template_repository.dart";

final workoutBuilderDraftStoreProvider = Provider<WorkoutBuilderDraftStore>((
  ref,
) {
  return const WorkoutBuilderDraftStore();
});

final workoutBuilderDraftProvider =
    FutureProvider.family<WorkoutBuilderDraft?, String>((ref, draftId) {
  return ref.watch(workoutBuilderDraftStoreProvider).load(draftId);
});

final workoutTemplateRepositoryProvider = Provider<WorkoutTemplateRepository>((
  ref,
) {
  return DriftWorkoutTemplateRepository(
    database: ref.watch(appDatabaseProvider),
  );
});

final workoutTemplatesProvider = FutureProvider<List<WorkoutTemplate>>((
  ref,
) async {
  final repository = ref.watch(workoutTemplateRepositoryProvider);
  return repository.listTemplates();
});
