import "dart:convert";

import "package:shared_preferences/shared_preferences.dart";

import "../models/exercise_metric_entry.dart";
import "exercise_metric_repository.dart";

class SharedPrefsExerciseMetricRepository implements ExerciseMetricRepository {
  static const String _storageKey = "next_lift.progress.exercise_metrics.v1";

  @override
  Future<List<ExerciseMetricEntry>> listEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) {
      return const [];
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        return const [];
      }
      final entries = decoded
          .whereType<Map>()
          .map((item) {
            final casted = item.map(
              (key, value) => MapEntry(key.toString(), value),
            );
            return ExerciseMetricEntry.fromJson(casted);
          })
          .where((entry) => entry.id.isNotEmpty && entry.exerciseId.isNotEmpty)
          .toList();
      entries.sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
      return entries;
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<void> saveEntry(ExerciseMetricEntry entry) async {
    final entries = await listEntries();
    final existingIndex = entries.indexWhere((item) => item.id == entry.id);
    if (existingIndex == -1) {
      entries.add(entry);
    } else {
      entries[existingIndex] = entry;
    }
    await _write(entries);
  }

  @override
  Future<void> deleteEntry(String id) async {
    final entries = await listEntries();
    entries.removeWhere((entry) => entry.id == id);
    await _write(entries);
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  Future<void> _write(List<ExerciseMetricEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = jsonEncode(entries.map((entry) => entry.toJson()).toList());
    await prefs.setString(_storageKey, payload);
  }
}
