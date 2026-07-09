import "dart:async";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:permission_handler/permission_handler.dart";

import "../../core/design_system/theme/theme_providers.dart";
import "../../core/design_system/tokens/app_theme_tokens.dart";
import "../../core/settings/user_settings.dart";

class ProfileSettingsScreen extends ConsumerStatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  ConsumerState<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends ConsumerState<ProfileSettingsScreen> {
  late UserSettings _draft;
  late final TextEditingController _profileNameController;
  late final FocusNode _profileNameFocusNode;
  bool _notificationPermissionGranted = false;
  bool _notificationPermissionApiAvailable = true;

  @override
  void initState() {
    super.initState();
    _draft = ref.read(themeControllerProvider).settings;
    _profileNameController = TextEditingController(text: _draft.profileName);
    _profileNameFocusNode = FocusNode()
      ..addListener(() async {
        if (_profileNameFocusNode.hasFocus) {
          return;
        }
        final trimmed = _profileNameController.text.trim();
        if (trimmed == _draft.profileName) {
          return;
        }
        await _save(_draft.copyWith(profileName: trimmed));
      });
    unawaited(_hydrateNotificationPermission());
  }

  @override
  void dispose() {
    _profileNameController.dispose();
    _profileNameFocusNode.dispose();
    super.dispose();
  }

  Future<void> _hydrateNotificationPermission() async {
    final status = await _getNotificationPermissionStatusSafe();
    if (!mounted) {
      return;
    }
    setState(() {
      _notificationPermissionGranted = status?.isGranted ?? true;
      _notificationPermissionApiAvailable = status != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = ref.watch(appThemeTokensProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("Profile & Settings")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _profileNameController,
            focusNode: _profileNameFocusNode,
            textInputAction: TextInputAction.done,
            style: TextStyle(
              color: tokens.semantic.text.primary,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              hintText: "Tap to set profile name",
              hintStyle: TextStyle(color: tokens.semantic.text.muted),
              isDense: true,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 4),
            ),
            onSubmitted: (value) async {
              final trimmed = value.trim();
              if (trimmed == _draft.profileName) {
                return;
              }
              await _save(_draft.copyWith(profileName: trimmed));
            },
          ),
          const SizedBox(height: 2),
          Text(
            "Profile name",
            style: TextStyle(color: tokens.semantic.text.muted, fontSize: 12),
          ),
          const SizedBox(height: 12),
          _SectionCard(
            tokens: tokens,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Units",
                  style: TextStyle(
                    color: tokens.semantic.text.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final segmentWidth = (constraints.maxWidth - 12) / 2;
                    return SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<WeightUnit>(
                        showSelectedIcon: false,
                        style: const ButtonStyle(
                          padding: WidgetStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                          ),
                        ),
                        segments: [
                          ButtonSegment(
                            value: WeightUnit.lb,
                            label: SizedBox(
                              width: segmentWidth,
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Pounds (lbs)"),
                              ),
                            ),
                          ),
                          ButtonSegment(
                            value: WeightUnit.kg,
                            label: SizedBox(
                              width: segmentWidth,
                              child: const Align(
                                alignment: Alignment.centerRight,
                                child: Text("Kilograms (kg)"),
                              ),
                            ),
                          ),
                        ],
                        selected: {_draft.weightUnit},
                        onSelectionChanged: (selection) async {
                          await _save(_draft.copyWith(weightUnit: selection.first));
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final segmentWidth = (constraints.maxWidth - 12) / 2;
                    return SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<DistanceUnit>(
                        showSelectedIcon: false,
                        style: const ButtonStyle(
                          padding: WidgetStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                          ),
                        ),
                        segments: [
                          ButtonSegment(
                            value: DistanceUnit.mi,
                            label: SizedBox(
                              width: segmentWidth,
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Miles (mi)"),
                              ),
                            ),
                          ),
                          ButtonSegment(
                            value: DistanceUnit.km,
                            label: SizedBox(
                              width: segmentWidth,
                              child: const Align(
                                alignment: Alignment.centerRight,
                                child: Text("Kilometers (km)"),
                              ),
                            ),
                          ),
                        ],
                        selected: {_draft.distanceUnit},
                        onSelectionChanged: (selection) async {
                          await _save(_draft.copyWith(distanceUnit: selection.first));
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _SectionCard(
            tokens: tokens,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  value: _draft.weightTrackingEnabled,
                  onChanged: _setWeightTrackingEnabled,
                  title: const Text("Track bodyweight"),
                ),
                if (!_notificationPermissionGranted)
                  Padding(
                    padding: const EdgeInsets.only(top: 2, bottom: 8),
                    child: Text(
                      "Allow notifications on your device to enable reminders.",
                      style: TextStyle(color: tokens.semantic.text.muted),
                    ),
                  ),
                if (!_notificationPermissionApiAvailable)
                  Padding(
                    padding: const EdgeInsets.only(top: 2, bottom: 8),
                    child: Text(
                      "Notification permissions are unavailable in this running build.",
                      style: TextStyle(color: tokens.semantic.text.muted),
                    ),
                  ),
                if (_draft.weightTrackingEnabled) ...[
                  Text(
                    "Remind Me To Weight In",
                    style: TextStyle(
                      color: tokens.semantic.text.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<WeighInReminderCadence>(
                    showSelectedIcon: false,
                    style: const ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    segments: const [
                      ButtonSegment(
                        value: WeighInReminderCadence.off,
                        label: Text("Never"),
                      ),
                      ButtonSegment(
                        value: WeighInReminderCadence.daily,
                        label: Text("Daily"),
                      ),
                      ButtonSegment(
                        value: WeighInReminderCadence.weekly,
                        label: Text("Weekly"),
                      ),
                      ButtonSegment(
                        value: WeighInReminderCadence.monthly,
                        label: Text("Monthly"),
                      ),
                    ],
                    selected: {_draft.weighInReminderCadence},
                    onSelectionChanged: (selection) async {
                      await _save(
                        _draft.copyWith(weighInReminderCadence: selection.first),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _reminderDescription(_draft.weighInReminderCadence),
                    style: TextStyle(color: tokens.semantic.text.muted, height: 1.35),
                  ),
                  if (_draft.weighInReminderCadence != WeighInReminderCadence.off) ...[
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: OutlinedButton(
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                              hour: _draft.weighInReminderHour,
                              minute: _draft.weighInReminderMinute,
                            ),
                          );
                          if (picked == null) {
                            return;
                          }
                          await _save(
                            _draft.copyWith(
                              weighInReminderHour: picked.hour,
                              weighInReminderMinute: picked.minute,
                            ),
                          );
                        },
                        child: Text("Time: ${_formatReminderTime(context)}"),
                      ),
                    ),
                  ],
                  if (_draft.weighInReminderCadence == WeighInReminderCadence.weekly) ...[
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: OutlinedButton(
                        onPressed: () async {
                          final weekday = await _pickReminderWeekday(
                            initialWeekday: _draft.weighInReminderWeekday,
                          );
                          if (weekday == null) {
                            return;
                          }
                          await _save(
                            _draft.copyWith(weighInReminderWeekday: weekday),
                          );
                        },
                        child: Text(
                          "Day: ${_weekdayLabel(_draft.weighInReminderWeekday)}",
                        ),
                      ),
                    ),
                  ],
                  if (_draft.weighInReminderCadence == WeighInReminderCadence.monthly) ...[
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: OutlinedButton(
                        onPressed: () async {
                          final day = await _pickReminderMonthDay(
                            initialDay: _draft.weighInReminderMonthDay,
                          );
                          if (day == null) {
                            return;
                          }
                          await _save(_draft.copyWith(weighInReminderMonthDay: day));
                        },
                        child: Text(
                          "Day of month: ${_monthDayLabel(_draft.weighInReminderMonthDay)}",
                        ),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          _SectionCard(
            tokens: tokens,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Theme",
                  style: TextStyle(
                    color: tokens.semantic.text.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<AppThemeId>(
                  initialValue: _draft.themeId,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: AppThemeId.values.map((id) {
                    return DropdownMenuItem(
                      value: id,
                      child: Text(_themeLabel(id)),
                    );
                  }).toList(),
                  onChanged: (id) async {
                    if (id == null) {
                      return;
                    }
                    await _save(_draft.copyWith(themeId: id));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save(UserSettings next) async {
    setState(() {
      _draft = next;
      if (_profileNameController.text != next.profileName) {
        _profileNameController.text = next.profileName;
      }
    });
    await ref.read(themeControllerProvider).updateSettings(next);
  }

  Future<void> _setWeightTrackingEnabled(bool enabled) async {
    if (!enabled) {
      await _save(
        _draft.copyWith(
          weightTrackingEnabled: false,
          weighInReminderCadence: WeighInReminderCadence.off,
        ),
      );
      return;
    }

    var status = await _getNotificationPermissionStatusSafe();
    if (status == null) {
      setState(() {
        _notificationPermissionApiAvailable = false;
        _notificationPermissionGranted = true;
      });
      await _save(
        _draft.copyWith(
          weightTrackingEnabled: true,
          weighInReminderCadence:
              _draft.weighInReminderCadence == WeighInReminderCadence.off
              ? WeighInReminderCadence.daily
              : _draft.weighInReminderCadence,
        ),
      );
      return;
    }

    if (!status.isGranted) {
      status = await _requestNotificationPermissionSafe();
    }
    if (!mounted) {
      return;
    }

    final granted = status?.isGranted ?? false;
    setState(() {
      _notificationPermissionGranted = granted;
      _notificationPermissionApiAvailable = status != null;
    });

    await _save(
      _draft.copyWith(
        weightTrackingEnabled: granted,
        weighInReminderCadence: granted
            ? (_draft.weighInReminderCadence == WeighInReminderCadence.off
                  ? WeighInReminderCadence.daily
                  : _draft.weighInReminderCadence)
            : WeighInReminderCadence.off,
      ),
    );
  }

  Future<PermissionStatus?> _getNotificationPermissionStatusSafe() async {
    try {
      return await Permission.notification.status;
    } on MissingPluginException {
      return null;
    }
  }

  Future<PermissionStatus?> _requestNotificationPermissionSafe() async {
    try {
      return await Permission.notification.request();
    } on MissingPluginException {
      return null;
    }
  }

  String _reminderDescription(WeighInReminderCadence cadence) {
    return switch (cadence) {
      WeighInReminderCadence.off =>
        "You will not be notified to input your current weight.",
      WeighInReminderCadence.daily =>
        "You will be sent a notification to weigh-in every day at ${_formatReminderTime(context)}.",
      WeighInReminderCadence.weekly =>
        "You will be sent a notification to weigh-in every ${_weekdayLabel(_draft.weighInReminderWeekday)} at ${_formatReminderTime(context)}.",
      WeighInReminderCadence.monthly =>
        _draft.weighInReminderMonthDay == 0
            ? "You will be sent a notification to weigh-in on the last day of every month at ${_formatReminderTime(context)}."
            : "You will be sent a notification to weigh-in on the ${_ordinal(_draft.weighInReminderMonthDay)} day of every month at ${_formatReminderTime(context)}.",
    };
  }

  String _formatReminderTime(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    return localizations.formatTimeOfDay(
      TimeOfDay(
        hour: _draft.weighInReminderHour,
        minute: _draft.weighInReminderMinute,
      ),
    );
  }

  String _weekdayLabel(int weekday) {
    return switch (weekday) {
      1 => "Monday",
      2 => "Tuesday",
      3 => "Wednesday",
      4 => "Thursday",
      5 => "Friday",
      6 => "Saturday",
      7 => "Sunday",
      _ => "Monday",
    };
  }

  String _monthDayLabel(int value) {
    if (value == 0) {
      return "Last Day";
    }
    return _ordinal(value);
  }

  String _ordinal(int value) {
    final mod100 = value % 100;
    if (mod100 >= 11 && mod100 <= 13) {
      return "${value}th";
    }
    return switch (value % 10) {
      1 => "${value}st",
      2 => "${value}nd",
      3 => "${value}rd",
      _ => "${value}th",
    };
  }

  Future<int?> _pickReminderWeekday({required int initialWeekday}) async {
    final weekdayOptions = List.generate(7, (index) => index + 1);
    var pendingWeekday = initialWeekday.clamp(1, 7);
    final initialItem = weekdayOptions.indexOf(pendingWeekday);
    return showModalBottomSheet<int>(
      context: context,
      builder: (sheetContext) {
        final controller = FixedExtentScrollController(
          initialItem: initialItem == -1 ? 0 : initialItem,
        );
        const itemExtent = 44.0;
        return SafeArea(
          top: false,
          child: SizedBox(
            height: 300,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Select Day",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(sheetContext).pop(pendingWeekday);
                        },
                        child: const Text("Done"),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      ListWheelScrollView.useDelegate(
                        controller: controller,
                        itemExtent: itemExtent,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) {
                          pendingWeekday = weekdayOptions[index];
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: weekdayOptions.length,
                          builder: (context, index) {
                            return Center(
                              child: Text(
                                _weekdayLabel(weekdayOptions[index]),
                                style: const TextStyle(fontSize: 18),
                              ),
                            );
                          },
                        ),
                      ),
                      IgnorePointer(
                        child: Center(
                          child: Container(
                            height: itemExtent,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.outline.withValues(alpha: 0.45),
                                ),
                                bottom: BorderSide(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.outline.withValues(alpha: 0.45),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<int?> _pickReminderMonthDay({required int initialDay}) async {
    final monthDayOptions = <int>[
      ...List.generate(31, (index) => index + 1),
      0,
    ];
    var pendingDay = initialDay.clamp(0, 31);
    final initialItem = monthDayOptions.indexOf(pendingDay);
    return showModalBottomSheet<int>(
      context: context,
      builder: (sheetContext) {
        final controller = FixedExtentScrollController(
          initialItem: initialItem == -1 ? 0 : initialItem,
        );
        const itemExtent = 44.0;
        return SafeArea(
          top: false,
          child: SizedBox(
            height: 300,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Select Day of Month",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(sheetContext).pop(pendingDay);
                        },
                        child: const Text("Done"),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      ListWheelScrollView.useDelegate(
                        controller: controller,
                        itemExtent: itemExtent,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) {
                          pendingDay = monthDayOptions[index];
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: 32,
                          builder: (context, index) {
                            return Center(
                              child: Text(
                                _monthDayLabel(monthDayOptions[index]),
                                style: const TextStyle(fontSize: 18),
                              ),
                            );
                          },
                        ),
                      ),
                      IgnorePointer(
                        child: Center(
                          child: Container(
                            height: itemExtent,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.outline.withValues(alpha: 0.45),
                                ),
                                bottom: BorderSide(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.outline.withValues(alpha: 0.45),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.tokens, required this.child});

  final AppThemeTokens tokens;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tokens.semantic.surface.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tokens.foundation.borderSubtle),
      ),
      child: child,
    );
  }
}

String _themeLabel(AppThemeId id) {
  return switch (id) {
    AppThemeId.graphiteTeal => "Graphite Teal",
    AppThemeId.slateLime => "Slate Lime",
    AppThemeId.charcoalBlue => "Charcoal Blue",
    AppThemeId.crimsonSilver => "Crimson Silver",
  };
}
