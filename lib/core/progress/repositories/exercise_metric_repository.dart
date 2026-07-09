import "../models/exercise_metric_entry.dart";

abstract class ExerciseMetricRepository {
  Future<List<ExerciseMetricEntry>> listEntries();
  Future<void> saveEntry(ExerciseMetricEntry entry);
  Future<void> deleteEntry(String id);
  Future<void> clear();
}
