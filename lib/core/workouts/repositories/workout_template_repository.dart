import "../models/workout_template.dart";

abstract class WorkoutTemplateRepository {
  Future<List<WorkoutTemplate>> listTemplates();
  Future<void> saveTemplate(WorkoutTemplate template);
  Future<void> deleteTemplate(String id);
}

class DuplicateWorkoutTemplateNameException implements Exception {
  const DuplicateWorkoutTemplateNameException(this.name);

  final String name;
}
