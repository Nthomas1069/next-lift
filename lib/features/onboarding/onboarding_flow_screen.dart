import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/design_system/theme/theme_providers.dart';
import '../../core/design_system/tokens/app_theme_tokens.dart';
import '../../core/design_system/widgets/primary_action_button.dart';
import '../../core/settings/user_settings.dart';
import 'models/onboarding_step.dart';
import 'widgets/onboarding_step_card.dart';

class OnboardingFlowScreen extends ConsumerStatefulWidget {
  const OnboardingFlowScreen({
    super.key,
    required this.onComplete,
  });

  final VoidCallback onComplete;

  @override
  ConsumerState<OnboardingFlowScreen> createState() =>
      _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends ConsumerState<OnboardingFlowScreen>
    with SingleTickerProviderStateMixin {
  static const Duration _infoAutoReadyDelay = Duration(milliseconds: 1200);

  late final AnimationController _transitionController;
  late final TextEditingController _profileNameController;
  late UserSettings _draft;
  final Map<int, bool> _stepReady = {};
  Timer? _readinessTimer;

  int _index = 0;
  bool _isNavigating = false;
  bool _didInitReadiness = false;
  int _fromIndex = 0;
  int _toIndex = 0;
  double _transitionDirection = 1.0;
  bool _notificationPermissionGranted = false;
  bool _notificationPermissionApiAvailable = true;

  @override
  void initState() {
    super.initState();
    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 620),
    )..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    _draft = ref.read(themeControllerProvider).settings;
    _profileNameController = TextEditingController(text: _draft.profileName);
    _hydrateNotificationPermission();
  }

  @override
  void dispose() {
    _readinessTimer?.cancel();
    _transitionController.dispose();
    _profileNameController.dispose();
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
    final steps = _buildSteps(tokens);
    final profileNameStepIndex =
        steps.indexWhere((step) => step.id == 'profile_name');
    final hasAdvancedPastProfileNameStep =
        profileNameStepIndex != -1 && _index > profileNameStepIndex;
    final trimmedProfileName = _draft.profileName.trim();
    final appBarTitle =
        hasAdvancedPastProfileNameStep && trimmedProfileName.isNotEmpty
            ? 'Welcome, $trimmedProfileName'
            : 'Welcome';
    final isLast = _index == steps.length - 1;
    final canProceed = !_isNavigating && (_stepReady[_index] ?? false);
    final previousEnabled = _index > 0 && !_isNavigating;
    final nextEnabled = canProceed;
    final showCometOnNext = nextEnabled;
    final showCometOnPrevious = !showCometOnNext && previousEnabled;

    if (!_didInitReadiness) {
      _didInitReadiness = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        _armReadinessForCurrentStep(steps, forceRestart: true);
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text(appBarTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final cardBandHeight = _cardBandHeightFor(
                      constraints.maxHeight,
                      steps,
                    );
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: _OnboardingParallaxBackdrop(
                            visualProgress: _visualProgress,
                            tokens: tokens,
                          ),
                        ),
                        Center(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeInOut,
                            height: cardBandHeight,
                            width: double.infinity,
                            child: _CassetteDeck(
                              steps: steps,
                              currentIndex: _index,
                              fromIndex: _fromIndex,
                              toIndex: _toIndex,
                              isNavigating: _isNavigating,
                              direction: _transitionDirection,
                              progress: _transitionProgress,
                              tokens: tokens,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              _StepDots(
                count: steps.length,
                index: _index,
                activeColor: tokens.foundation.accentPrimary,
                inactiveColor: tokens.foundation.borderStrong,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _BorderedNavButton(
                      label: 'Previous',
                      enabled: previousEnabled,
                      cometActive: showCometOnPrevious,
                      tokens: tokens,
                      onPressed: !previousEnabled
                          ? null
                          : () async {
                              await _navigateToPage(_index - 1, steps);
                            },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _BorderedNavButton(
                      label: isLast ? 'Finish' : 'Next',
                      enabled: nextEnabled,
                      cometActive: showCometOnNext,
                      isPrimary: true,
                      tokens: tokens,
                      onPressed: !nextEnabled
                          ? null
                          : () async {
                              if (isLast) {
                                final finalized = _draft.copyWith(
                                  onboardingCompleted: true,
                                );
                                await ref
                                    .read(themeControllerProvider)
                                    .updateSettings(finalized);
                                widget.onComplete();
                                return;
                              }

                              await _navigateToPage(_index + 1, steps);
                            },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<OnboardingStep> _buildSteps(AppThemeTokens tokens) {
    return [
      OnboardingStep(
        id: 'welcome',
        type: OnboardingStepType.explanation,
        title: 'Build Workouts Your Way',
        body:
            'NextLift allows you to create workouts by using modular types, like circuits, AMRAPs, and more. You\'ll also create custom exercises and configure them to track metrics you select, like weight, reps, and time. Add a rest timer between sets or advance at your own pace.',
        builder: (_) => const SizedBox.shrink(),
      ),
      OnboardingStep(
        id: 'profile_name',
        type: OnboardingStepType.preference,
        title: 'Profile Name',
        body: 'Set your profile name so your plans and logs feel personal.',
        builder: (_) {
          return TextField(
            controller: _profileNameController,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter profile name',
            ),
            onChanged: (value) {
              setState(() {
                _draft = _draft.copyWith(profileName: value);
                _markCurrentStepConfirmed();
              });
            },
          );
        },
      ),
      OnboardingStep(
        id: 'weight_tracking',
        type: OnboardingStepType.preference,
        title: 'Units of Measure',
        body: 'Choose your preferred weight and distance units.',
        builder: (_) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SegmentedButton<WeightUnit>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(
                    value: WeightUnit.lb,
                    label: SizedBox(
                      width: 140,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Pounds (lbs)'),
                      ),
                    ),
                  ),
                  ButtonSegment(
                    value: WeightUnit.kg,
                    label: SizedBox(
                      width: 140,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text('Kilograms (kg)'),
                      ),
                    ),
                  ),
                ],
                selected: {_draft.weightUnit},
                onSelectionChanged: (selection) {
                  setState(() {
                    _draft = _draft.copyWith(weightUnit: selection.first);
                    _markCurrentStepConfirmed();
                  });
                },
              ),
              const SizedBox(height: 12),
              SegmentedButton<DistanceUnit>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(
                    value: DistanceUnit.mi,
                    label: SizedBox(
                      width: 140,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Miles (mi)'),
                      ),
                    ),
                  ),
                  ButtonSegment(
                    value: DistanceUnit.km,
                    label: SizedBox(
                      width: 140,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text('Kilometers (km)'),
                      ),
                    ),
                  ),
                ],
                selected: {_draft.distanceUnit},
                onSelectionChanged: (selection) {
                  setState(() {
                    _draft = _draft.copyWith(distanceUnit: selection.first);
                    _markCurrentStepConfirmed();
                  });
                },
              ),
            ],
          );
        },
      ),
      OnboardingStep(
        id: 'reminder_cadence',
        type: OnboardingStepType.preference,
        title: 'Bodyweight Tracking & Reminders',
        body:
            'Enable bodyweight tracking, then choose if and how often you want weigh-in reminders.',
        builder: (_) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _draft.weightTrackingEnabled,
                onChanged: (enabled) {
                  _setWeightTrackingEnabled(enabled);
                },
                title: const Text('Track bodyweight'),
              ),
              if (!_notificationPermissionGranted)
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 8),
                  child: Text(
                    'Allow notifications on your device to enable weigh-in reminders.',
                    style: TextStyle(color: tokens.semantic.text.muted),
                  ),
                ),
              if (!_notificationPermissionApiAvailable)
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 8),
                  child: Text(
                    'Notification permissions are unavailable in this running build.',
                    style: TextStyle(color: tokens.semantic.text.muted),
                  ),
                ),
              if (_draft.weightTrackingEnabled) ...[
                const SizedBox(height: 8),
                Text(
                  'Remind Me To Weight In',
                  style: TextStyle(
                    color: tokens.semantic.text.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                SegmentedButton<WeighInReminderCadence>(
                  showSelectedIcon: false,
                  multiSelectionEnabled: false,
                  segments: const [
                    ButtonSegment(
                        value: WeighInReminderCadence.off,
                        label: Text('Never')),
                    ButtonSegment(
                      value: WeighInReminderCadence.daily,
                      label: Text('Daily'),
                    ),
                    ButtonSegment(
                      value: WeighInReminderCadence.weekly,
                      label: Text('Weekly'),
                    ),
                    ButtonSegment(
                      value: WeighInReminderCadence.monthly,
                      label: Text('Monthly'),
                    ),
                  ],
                  selected: {_draft.weighInReminderCadence},
                  onSelectionChanged: (selection) {
                    setState(() {
                      _draft = _draft.copyWith(
                        weighInReminderCadence: selection.first,
                      );
                      _markCurrentStepConfirmed();
                    });
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  _reminderDescription(_draft.weighInReminderCadence),
                  style: TextStyle(
                      color: tokens.semantic.text.muted, height: 1.35),
                ),
                if (_draft.weighInReminderCadence !=
                    WeighInReminderCadence.off) ...[
                  const SizedBox(height: 10),
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
                        setState(() {
                          _draft = _draft.copyWith(
                            weighInReminderHour: picked.hour,
                            weighInReminderMinute: picked.minute,
                          );
                          _markCurrentStepConfirmed();
                        });
                      },
                      child: Text(
                        'Time: ${_formatReminderTime(context)}',
                      ),
                    ),
                  ),
                ],
                if (_draft.weighInReminderCadence ==
                    WeighInReminderCadence.weekly) ...[
                  const SizedBox(height: 10),
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
                        setState(() {
                          _draft = _draft.copyWith(
                            weighInReminderWeekday: weekday,
                          );
                          _markCurrentStepConfirmed();
                        });
                      },
                      child: Text(
                        'Day: ${_weekdayLabel(_draft.weighInReminderWeekday)}',
                      ),
                    ),
                  ),
                ],
                if (_draft.weighInReminderCadence ==
                    WeighInReminderCadence.monthly) ...[
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: OutlinedButton(
                      onPressed: () async {
                        final monthDay = await _pickReminderMonthDay(
                          initialDay: _draft.weighInReminderMonthDay,
                        );
                        if (monthDay == null) {
                          return;
                        }
                        setState(() {
                          _draft = _draft.copyWith(
                            weighInReminderMonthDay: monthDay,
                          );
                          _markCurrentStepConfirmed();
                        });
                      },
                      child: Text(
                        'Day of month: ${_monthDayLabel(_draft.weighInReminderMonthDay)}',
                      ),
                    ),
                  ),
                ],
              ],
            ],
          );
        },
      ),
      OnboardingStep(
        id: 'theme_choice',
        type: OnboardingStepType.preference,
        title: 'Choose Your Theme',
        body:
            'Select visual tone. Default is Graphite Teal. You can switch later anytime.',
        builder: (_) {
          return DropdownButtonFormField<AppThemeId>(
            initialValue: _draft.themeId,
            items: AppThemeId.values.map((id) {
              return DropdownMenuItem(
                value: id,
                child: Text(_themeLabel(id)),
              );
            }).toList(),
            onChanged: (id) {
              if (id == null) {
                return;
              }

              setState(() {
                _draft = _draft.copyWith(themeId: id);
                _markCurrentStepConfirmed();
              });
              ref.read(themeControllerProvider).setTheme(id);
            },
          );
        },
      ),
      OnboardingStep(
        id: 'finish',
        type: OnboardingStepType.explanation,
        title: 'Ready To Lift',
        body:
            'Your starter preferences are set. Next, we will take you to your home dashboard.',
        builder: (_) => Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: tokens.foundation.borderSubtle),
            color: tokens.foundation.bgElev2,
          ),
          child: Text(
            'Current theme: ${_themeLabel(_draft.themeId)}',
            style: TextStyle(color: tokens.semantic.text.primary),
          ),
        ),
      ),
    ];
  }

  void _markCurrentStepConfirmed() {
    _stepReady[_index] = true;
  }

  double _cardBandHeightFor(
      double availableHeight, List<OnboardingStep> steps) {
    final baseHeight = availableHeight * 0.58;
    final currentStep = steps[_index];
    if (currentStep.id != 'reminder_cadence' || !_draft.weightTrackingEnabled) {
      return baseHeight;
    }

    final extraHeight = switch (_draft.weighInReminderCadence) {
      WeighInReminderCadence.off => 68.0,
      WeighInReminderCadence.daily => 124.0,
      WeighInReminderCadence.weekly => 186.0,
      WeighInReminderCadence.monthly => 186.0,
    };

    final maxHeight = availableHeight * 0.86;
    return (baseHeight + extraHeight).clamp(baseHeight, maxHeight);
  }

  Future<void> _setWeightTrackingEnabled(bool enabled) async {
    if (!enabled) {
      setState(() {
        _draft = _draft.copyWith(
          weightTrackingEnabled: false,
          weighInReminderCadence: WeighInReminderCadence.off,
        );
        _markCurrentStepConfirmed();
      });
      return;
    }

    var status = await _getNotificationPermissionStatusSafe();
    if (status == null) {
      setState(() {
        _notificationPermissionApiAvailable = false;
        _notificationPermissionGranted = true;
        _draft = _draft.copyWith(
          weightTrackingEnabled: true,
          weighInReminderCadence:
              _draft.weighInReminderCadence == WeighInReminderCadence.off
                  ? WeighInReminderCadence.daily
                  : _draft.weighInReminderCadence,
        );
        _markCurrentStepConfirmed();
      });
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
      _draft = _draft.copyWith(
        weightTrackingEnabled: granted,
        weighInReminderCadence: granted
            ? (_draft.weighInReminderCadence == WeighInReminderCadence.off
                ? WeighInReminderCadence.daily
                : _draft.weighInReminderCadence)
            : WeighInReminderCadence.off,
      );
      _markCurrentStepConfirmed();
    });

    if (!granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Notification permission is required to enable weigh-in reminders.',
          ),
        ),
      );
    }
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
        'You will not be notified to input your current weight.',
      WeighInReminderCadence.daily =>
        'You will be sent a notification to weigh-in every day at ${_formatReminderTime(context)}.',
      WeighInReminderCadence.weekly =>
        'You will be sent a notification to weigh-in every ${_weekdayLabel(_draft.weighInReminderWeekday)} at ${_formatReminderTime(context)}.',
      WeighInReminderCadence.monthly => _draft.weighInReminderMonthDay == 0
          ? 'You will be sent a notification to weigh-in on the last day of every month at ${_formatReminderTime(context)}.'
          : 'You will be sent a notification to weigh-in on the ${_ordinal(_draft.weighInReminderMonthDay)} day of every month at ${_formatReminderTime(context)}.',
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
      1 => 'Monday',
      2 => 'Tuesday',
      3 => 'Wednesday',
      4 => 'Thursday',
      5 => 'Friday',
      6 => 'Saturday',
      7 => 'Sunday',
      _ => 'Monday',
    };
  }

  String _ordinal(int value) {
    final mod100 = value % 100;
    if (mod100 >= 11 && mod100 <= 13) {
      return '${value}th';
    }
    return switch (value % 10) {
      1 => '${value}st',
      2 => '${value}nd',
      3 => '${value}rd',
      _ => '${value}th',
    };
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
                          'Select Day of Month',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(sheetContext).pop(pendingDay);
                        },
                        child: const Text('Done'),
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

  String _monthDayLabel(int value) {
    if (value == 0) {
      return 'Last Day';
    }
    return _ordinal(value);
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
                          'Select Day',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(sheetContext).pop(pendingWeekday);
                        },
                        child: const Text('Done'),
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

  void _armReadinessForCurrentStep(
    List<OnboardingStep> steps, {
    bool forceRestart = false,
  }) {
    final current = steps[_index];
    final alreadyReady = _stepReady[_index] ?? false;

    if (alreadyReady && !forceRestart) {
      return;
    }

    _readinessTimer?.cancel();

    if (current.type == OnboardingStepType.explanation) {
      _stepReady[_index] = false;
      _readinessTimer = Timer(_infoAutoReadyDelay, () {
        if (!mounted) {
          return;
        }
        setState(() {
          _stepReady[_index] = true;
        });
      });
      return;
    }

    // Preference steps have valid defaults, so users can proceed immediately.
    _stepReady[_index] = true;
  }

  double get _transitionProgress =>
      Curves.easeInOutCubic.transform(_transitionController.value);

  double get _visualProgress {
    if (!_isNavigating) {
      return _index.toDouble();
    }
    return lerpDouble(
          _fromIndex.toDouble(),
          _toIndex.toDouble(),
          _transitionProgress,
        ) ??
        _index.toDouble();
  }

  Future<void> _navigateToPage(int page, List<OnboardingStep> steps) async {
    if (_isNavigating) {
      return;
    }
    if (page < 0 || page >= steps.length) {
      return;
    }

    setState(() {
      _isNavigating = true;
      _fromIndex = _index;
      _toIndex = page;
      _transitionDirection = page > _index ? 1.0 : -1.0;
    });

    _transitionController
      ..stop()
      ..reset();
    await _transitionController.forward();

    if (mounted) {
      setState(() {
        _index = page;
        _isNavigating = false;
      });
      _armReadinessForCurrentStep(steps, forceRestart: true);
    }
  }
}

class _CassetteDeck extends StatelessWidget {
  const _CassetteDeck({
    required this.steps,
    required this.currentIndex,
    required this.fromIndex,
    required this.toIndex,
    required this.isNavigating,
    required this.direction,
    required this.progress,
    required this.tokens,
  });

  final List<OnboardingStep> steps;
  final int currentIndex;
  final int fromIndex;
  final int toIndex;
  final bool isNavigating;
  final double direction;
  final double progress;
  final AppThemeTokens tokens;

  @override
  Widget build(BuildContext context) {
    final displayIndex = isNavigating ? fromIndex : currentIndex;
    final prevIndex = displayIndex > 0 ? displayIndex - 1 : null;
    final nextIndex = displayIndex < steps.length - 1 ? displayIndex + 1 : null;

    final cassetteTurns = isNavigating ? (0.11 * direction * progress) : 0.0;

    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: Center(
              child: Transform.rotate(
                angle: cassetteTurns * 2 * pi,
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: tokens.foundation.borderStrong
                          .withValues(alpha: 0.38),
                      width: 1.1,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: tokens.foundation.accentPrimary
                              .withValues(alpha: 0.22),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (isNavigating && prevIndex != null)
          _GhostCard(
            step: steps[prevIndex],
            tokens: tokens,
            x: -118,
            y: 44,
            scale: 0.8,
            opacity: 0.25,
          ),
        if (isNavigating && nextIndex != null)
          _GhostCard(
            step: steps[nextIndex],
            tokens: tokens,
            x: 118,
            y: 44,
            scale: 0.8,
            opacity: 0.25,
          ),
        if (!isNavigating)
          _CardPose(
            step: steps[currentIndex],
            tokens: tokens,
            x: 0,
            y: 0,
            scale: 1,
            opacity: 1,
            glow: true,
            interactive: true,
          ),
        if (isNavigating) ...[
          _CardPose(
            step: steps[fromIndex],
            tokens: tokens,
            x: lerpDouble(0, -direction * 140, progress) ?? 0,
            y: lerpDouble(0, 54, progress) ?? 0,
            scale: lerpDouble(1, 0.68, progress) ?? 0.68,
            opacity: lerpDouble(1, 0, progress) ?? 0,
          ),
          _CardPose(
            step: steps[toIndex],
            tokens: tokens,
            x: lerpDouble(direction * 145, 0, progress) ?? 0,
            y: lerpDouble(56, 0, progress) ?? 0,
            scale: _incomingScale(progress),
            opacity: lerpDouble(0, 1, Curves.easeOut.transform(progress)) ?? 1,
            glow: true,
          ),
        ],
      ],
    );
  }

  static double _incomingScale(double t) {
    if (t < 0.72) {
      return lerpDouble(0.68, 1.1, Curves.easeOut.transform(t / 0.72)) ?? 1.0;
    }
    return lerpDouble(
          1.1,
          1.0,
          Curves.easeInOut.transform((t - 0.72) / 0.28),
        ) ??
        1.0;
  }
}

class _GhostCard extends StatelessWidget {
  const _GhostCard({
    required this.step,
    required this.tokens,
    required this.x,
    required this.y,
    required this.scale,
    required this.opacity,
  });

  final OnboardingStep step;
  final AppThemeTokens tokens;
  final double x;
  final double y;
  final double scale;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return _CardPose(
      step: step,
      tokens: tokens,
      x: x,
      y: y,
      scale: scale,
      opacity: opacity,
    );
  }
}

class _CardPose extends StatelessWidget {
  const _CardPose({
    required this.step,
    required this.tokens,
    required this.x,
    required this.y,
    required this.scale,
    required this.opacity,
    this.glow = false,
    this.interactive = false,
  });

  final OnboardingStep step;
  final AppThemeTokens tokens;
  final double x;
  final double y;
  final double scale;
  final double opacity;
  final bool glow;
  final bool interactive;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !interactive,
      child: Opacity(
        opacity: opacity.clamp(0, 1),
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..translateByDouble(x, y, 0, 1)
            ..scaleByDouble(scale, scale, 1, 1),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: glow
                  ? [
                      BoxShadow(
                        color: tokens.foundation.accentGlow,
                        blurRadius: 36,
                        spreadRadius: 3,
                        offset: const Offset(0, 12),
                      ),
                    ]
                  : null,
            ),
            child: OnboardingStepCard(
              type: switch (step.type) {
                OnboardingStepType.explanation =>
                  OnboardingCardType.explanation,
                OnboardingStepType.preference => OnboardingCardType.preference,
              },
              title: step.title,
              body: step.body,
              tokens: tokens,
              child: step.builder(context),
            ),
          ),
        ),
      ),
    );
  }
}

class _StepDots extends StatelessWidget {
  const _StepDots({
    required this.count,
    required this.index,
    required this.activeColor,
    required this.inactiveColor,
  });

  final int count;
  final int index;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (dotIndex) {
        final isActive = dotIndex == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          width: isActive ? 18 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}

class _BorderedNavButton extends StatelessWidget {
  const _BorderedNavButton({
    required this.label,
    required this.enabled,
    required this.cometActive,
    required this.tokens,
    required this.onPressed,
    this.isPrimary = false,
  });

  final String label;
  final bool enabled;
  final bool cometActive;
  final bool isPrimary;
  final AppThemeTokens tokens;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final borderColor = isPrimary
        ? (enabled
            ? tokens.foundation.accentPrimary.withValues(alpha: 0.9)
            : tokens.foundation.accentPrimary.withValues(alpha: 0.35))
        : (enabled
            ? tokens.foundation.borderStrong
            : tokens.foundation.borderSubtle.withValues(alpha: 0.6));
    final textColor = enabled
        ? (isPrimary
            ? tokens.semantic.text.primary
            : tokens.semantic.text.primary.withValues(alpha: 0.9))
        : tokens.semantic.text.disabled;

    return Container(
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: TextButton(
                onPressed: onPressed,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: textColor,
                  disabledForegroundColor: tokens.semantic.text.disabled,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
                    letterSpacing: isPrimary ? 0.2 : 0.1,
                  ),
                ),
              ),
            ),
          ),
          if (cometActive)
            const Positioned(
              left: -8,
              right: -8,
              top: -8,
              bottom: -8,
              child: IgnorePointer(
                child: CometOrbit(
                  color: Colors.white,
                  borderRadius: 12,
                  bleed: 8,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _OnboardingParallaxBackdrop extends StatelessWidget {
  const _OnboardingParallaxBackdrop({
    required this.visualProgress,
    required this.tokens,
  });

  final double visualProgress;
  final AppThemeTokens tokens;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Builder(
        builder: (context) {
          final shift = (visualProgress % 1) * 0.18;
          final palette = [
            tokens.foundation.accentPrimary.withValues(alpha: 0.24),
            tokens.foundation.info.withValues(alpha: 0.18),
            tokens.foundation.warning.withValues(alpha: 0.14),
          ];
          final baseColor = tokens.foundation.bgBase;
          return Stack(
            fit: StackFit.expand,
            children: [
              Container(color: baseColor.withValues(alpha: 0.6)),
              Transform.translate(
                offset: Offset(20 - (40 * shift), -8),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(-0.65 + shift, -0.45),
                      radius: 1.15,
                      colors: [
                        palette[0],
                        palette[1],
                        baseColor.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(-12 + (30 * shift), 22),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(0.75 - shift, 0.9),
                      radius: 1.0,
                      colors: [
                        palette[2],
                        baseColor.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

String _themeLabel(AppThemeId id) {
  return switch (id) {
    AppThemeId.graphiteTeal => 'Graphite Teal',
    AppThemeId.slateLime => 'Slate Lime',
    AppThemeId.charcoalBlue => 'Charcoal Blue',
    AppThemeId.crimsonSilver => 'Crimson Silver',
  };
}
