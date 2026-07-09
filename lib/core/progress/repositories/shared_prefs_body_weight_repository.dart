import "dart:convert";

import "package:shared_preferences/shared_preferences.dart";

import "../models/body_weight_entry.dart";
import "body_weight_repository.dart";

class SharedPrefsBodyWeightRepository implements BodyWeightRepository {
  static const String _storageKey = "next_lift.progress.body_weight.v1";

  @override
  Future<List<BodyWeightEntry>> listEntries() async {
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
            return BodyWeightEntry.fromJson(casted);
          })
          .where((entry) => entry.id.isNotEmpty)
          .toList();
      entries.sort((a, b) => a.loggedAt.compareTo(b.loggedAt));
      return entries;
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<void> saveEntry(BodyWeightEntry entry) async {
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

  Future<void> _write(List<BodyWeightEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = jsonEncode(entries.map((entry) => entry.toJson()).toList());
    await prefs.setString(_storageKey, payload);
  }
}
