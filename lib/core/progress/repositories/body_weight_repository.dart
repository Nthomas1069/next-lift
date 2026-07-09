import "../models/body_weight_entry.dart";

abstract class BodyWeightRepository {
  Future<List<BodyWeightEntry>> listEntries();
  Future<void> saveEntry(BodyWeightEntry entry);
  Future<void> deleteEntry(String id);
  Future<void> clear();
}
