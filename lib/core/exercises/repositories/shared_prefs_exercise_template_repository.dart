import "dart:convert";

import "package:shared_preferences/shared_preferences.dart";

import "../models/exercise_template.dart";
import "exercise_template_repository.dart";

class SharedPrefsExerciseTemplateRepository
    implements ExerciseTemplateRepository {
  static const String _storageKey = "next_lift.exercise_templates.v1";

  @override
  Future<List<ExerciseTemplate>> listTemplates() async {
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
      final templates = decoded
          .whereType<Map>()
          .map((item) {
            final casted = item.map(
              (key, value) => MapEntry(key.toString(), value),
            );
            return ExerciseTemplate.fromJson(casted);
          })
          .where(
            (template) =>
                template.id.isNotEmpty &&
                template.name.isNotEmpty &&
                template.metricKeys.isNotEmpty,
          )
          .toList();
      templates.sort((a, b) => a.name.compareTo(b.name));
      return templates;
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<void> saveTemplate(ExerciseTemplate template) async {
    final templates = [...await listTemplates()];
    final duplicate = templates.any(
      (item) =>
          item.id != template.id &&
          item.normalizedName == template.normalizedName,
    );
    if (duplicate) {
      throw DuplicateExerciseTemplateNameException(template.name);
    }

    final existingIndex =
        templates.indexWhere((item) => item.id == template.id);
    if (existingIndex == -1) {
      templates.add(template);
    } else {
      templates[existingIndex] = template;
    }
    await _write(templates);
  }

  @override
  Future<void> deleteTemplate(String id) async {
    final templates = [...await listTemplates()];
    templates.removeWhere((template) => template.id == id);
    await _write(templates);
  }

  Future<void> _write(List<ExerciseTemplate> templates) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = jsonEncode(
      templates.map((template) => template.toJson()).toList(),
    );
    await prefs.setString(_storageKey, payload);
  }
}
