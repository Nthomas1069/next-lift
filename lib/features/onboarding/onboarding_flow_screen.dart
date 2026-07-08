import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_system/theme/theme_providers.dart';
import '../../core/design_system/tokens/app_theme_tokens.dart';
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
  ConsumerState<OnboardingFlowScreen> createState() => _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends ConsumerState<OnboardingFlowScreen>
    with SingleTickerProviderStateMixin {
  static const Duration _infoAutoReadyDelay = Duration(milliseconds: 1200);

  late final AnimationController _transitionController;
  late UserSettings _draft;
  final Map<int, bool> _stepReady = {};
  Timer? _readinessTimer;

  int _index = 0;
  bool _isNavigating = false;
  bool _didInitReadiness = false;
  int _fromIndex = 0;
  int _toIndex = 0;
  double _transitionDirection = 1.0;

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
    _draft = const UserSettings();
  }

  @override
  void dispose() {
    _readinessTimer?.cancel();
    _transitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = ref.watch(appThemeTokensProvider);
    final steps = _buildSteps(tokens);
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
      appBar: AppBar(title: const Text('Welcome')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final cardBandHeight = constraints.maxHeight * 0.58;
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: _OnboardingParallaxBackdrop(
                            visualProgress: _visualProgress,
                            tokens: tokens,
                          ),
                        ),
                        Center(
                          child: SizedBox(
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
                                await ref
                                    .read(themeControllerProvider)
                                    .updateSettings(_draft);
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
            'Create workouts from modular shapes, then run them with clean state-aware guidance.',
        builder: (_) => const SizedBox.shrink(),
      ),
      OnboardingStep(
        id: 'weight_tracking',
        type: OnboardingStepType.preference,
        title: 'Bodyweight Tracking',
        body:
            'Enable bodyweight tracking and choose your preferred measurement unit.',
        builder: (_) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _draft.weightTrackingEnabled,
                onChanged: (enabled) {
                  setState(() {
                    _draft = _draft.copyWith(weightTrackingEnabled: enabled);
                    _markCurrentStepConfirmed();
                  });
                },
                title: const Text('Track bodyweight'),
              ),
              const SizedBox(height: 8),
              SegmentedButton<WeightUnit>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(value: WeightUnit.lb, label: Text('lb')),
                  ButtonSegment(value: WeightUnit.kg, label: Text('kg')),
                ],
                selected: {_draft.weightUnit},
                onSelectionChanged: (selection) {
                  setState(() {
                    _draft = _draft.copyWith(weightUnit: selection.first);
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
        title: 'Weigh-In Reminders',
        body: 'Pick reminder cadence now. You can edit this later in settings.',
        builder: (_) {
          return SegmentedButton<WeighInReminderCadence>(
            showSelectedIcon: false,
            multiSelectionEnabled: false,
            segments: const [
              ButtonSegment(value: WeighInReminderCadence.off, label: Text('Off')),
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
                      color: tokens.foundation.borderStrong.withValues(alpha: 0.38),
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
                          color:
                              tokens.foundation.accentPrimary.withValues(alpha: 0.22),
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
                OnboardingStepType.explanation => OnboardingCardType.explanation,
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
            Positioned(
              left: -8,
              right: -8,
              top: -8,
              bottom: -8,
              child: IgnorePointer(
                child: _CometOrbit(
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

class _CometOrbit extends StatefulWidget {
  const _CometOrbit({
    required this.color,
    required this.borderRadius,
    required this.bleed,
  });

  final Color color;
  final double borderRadius;
  final double bleed;

  @override
  State<_CometOrbit> createState() => _CometOrbitState();
}

class _CometOrbitState extends State<_CometOrbit>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final p = _controller.value;
            final point = _pointAlongRoundedRect(
              size,
              p,
              widget.borderRadius,
              widget.bleed,
            );
            final trailPoints = List<Offset>.generate(5, (i) {
              final d = (p - ((i + 1) * 0.022)) % 1;
              return _pointAlongRoundedRect(
                size,
                d < 0 ? d + 1 : d,
                widget.borderRadius,
                widget.bleed,
              );
            });

            return Stack(
              children: [
                for (var i = 0; i < trailPoints.length; i++)
                  Positioned(
                    left: trailPoints[i].dx - (2.4 - (i * 0.3)),
                    top: trailPoints[i].dy - (2.4 - (i * 0.3)),
                    child: Container(
                      width: 4.8 - (i * 0.6),
                      height: 4.8 - (i * 0.6),
                      decoration: BoxDecoration(
                        color: widget.color.withValues(
                          alpha: 0.38 - (i * 0.06),
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                Positioned(
                  left: point.dx - 3,
                  top: point.dy - 3,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: widget.color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withValues(alpha: 0.6),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Offset _pointAlongRoundedRect(
    Size size,
    double t,
    double radius,
    double bleed,
  ) {
    final left = bleed;
    final top = bleed;
    final right = size.width - bleed;
    final bottom = size.height - bleed;
    final width = (right - left).clamp(1.0, double.infinity);
    final height = (bottom - top).clamp(1.0, double.infinity);
    final r = radius.clamp(0.0, width / 2).clamp(0.0, height / 2);

    final straightTop = width - (2 * r);
    final straightRight = height - (2 * r);
    final straightBottom = straightTop;
    final straightLeft = straightRight;
    final arc = (pi / 2) * r;
    final perimeter = straightTop +
        straightRight +
        straightBottom +
        straightLeft +
        (arc * 4);

    var d = (t % 1) * perimeter;

    // Top edge.
    if (d <= straightTop) {
      return Offset(left + r + d, top);
    }
    d -= straightTop;

    // Top-right arc.
    if (d <= arc) {
      final theta = -pi / 2 + (d / r);
      return Offset(
        right - r + (r * cos(theta)),
        top + r + (r * sin(theta)),
      );
    }
    d -= arc;

    // Right edge.
    if (d <= straightRight) {
      return Offset(right, top + r + d);
    }
    d -= straightRight;

    // Bottom-right arc.
    if (d <= arc) {
      final theta = d / r;
      return Offset(
        right - r + (r * cos(theta)),
        bottom - r + (r * sin(theta)),
      );
    }
    d -= arc;

    // Bottom edge.
    if (d <= straightBottom) {
      return Offset(right - r - d, bottom);
    }
    d -= straightBottom;

    // Bottom-left arc.
    if (d <= arc) {
      final theta = pi / 2 + (d / r);
      return Offset(
        left + r + (r * cos(theta)),
        bottom - r + (r * sin(theta)),
      );
    }
    d -= arc;

    // Left edge.
    if (d <= straightLeft) {
      return Offset(left, bottom - r - d);
    }
    d -= straightLeft;

    // Top-left arc.
    final theta = pi + (d / r);
    return Offset(
      left + r + (r * cos(theta)),
      top + r + (r * sin(theta)),
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
  };
}
