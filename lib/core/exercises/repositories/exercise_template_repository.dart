import "../models/exercise_template.dart";

abstract class ExerciseTemplateRepository {
  Future<List<ExerciseTemplate>> listTemplates();
  Future<void> saveTemplate(ExerciseTemplate template);
  Future<void> deleteTemplate(String id);
}

class DuplicateExerciseTemplateNameException implements Exception {
  const DuplicateExerciseTemplateNameException(this.name);

  final String name;
}
