import "dart:math";

import "package:flutter/material.dart";

import "../tokens/app_theme_tokens.dart";

class PrimaryActionButton extends StatelessWidget {
  const PrimaryActionButton({
    super.key,
    required this.label,
    required this.tokens,
    required this.onPressed,
    this.cometActive = false,
    this.isLoading = false,
  });

  final String label;
  final AppThemeTokens tokens;
  final VoidCallback? onPressed;
  final bool cometActive;
  final bool isLoading;

  static const double _borderRadius = 8;
  static const Color _cometColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    final borderColor = enabled
        ? tokens.foundation.accentPrimary.withValues(alpha: 0.9)
        : tokens.foundation.borderSubtle.withValues(alpha: 0.65);
    final textColor =
        enabled ? tokens.semantic.text.primary : tokens.semantic.text.disabled;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        border: Border.all(color: borderColor),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: TextButton(
                onPressed: isLoading ? null : onPressed,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: textColor,
                  disabledForegroundColor: tokens.semantic.text.disabled,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_borderRadius - 2),
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(textColor),
                        ),
                      )
                    : Text(
                        label,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
              ),
            ),
          ),
          if (cometActive && enabled)
            const Positioned(
              left: -8,
              right: -8,
              top: -8,
              bottom: -8,
              child: IgnorePointer(
                child: CometOrbit(
                  color: _cometColor,
                  borderRadius: _borderRadius,
                  bleed: 8,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CometOrbit extends StatefulWidget {
  const CometOrbit({
    super.key,
    required this.color,
    required this.borderRadius,
    required this.bleed,
  });

  final Color color;
  final double borderRadius;
  final double bleed;

  @override
  State<CometOrbit> createState() => _CometOrbitState();
}

class _CometOrbitState extends State<CometOrbit>
    with SingleTickerProviderStateMixin {
  static const double _referencePerimeter = 180.53;
  static const double _referenceDurationMicroseconds = 1800000;
  static const double _trailSpacing = 4;

  late final AnimationController _controller;
  bool _durationUpdateScheduled = false;

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
    if (MediaQuery.disableAnimationsOf(context)) {
      return Align(
        alignment: Alignment.topRight,
        child: _CometPoint(color: widget.color),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final perimeter = _roundedRectPerimeter(
          size,
          widget.borderRadius,
          widget.bleed,
        );
        _syncDuration(perimeter);
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
              final d = (p - (((i + 1) * _trailSpacing) / perimeter)) % 1;
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
                  child: _CometPoint(color: widget.color),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _syncDuration(double perimeter) {
    final duration = Duration(
      microseconds: (_referenceDurationMicroseconds *
              sqrt(perimeter / _referencePerimeter))
          .round(),
    );
    if (_controller.duration == duration || _durationUpdateScheduled) {
      return;
    }
    _durationUpdateScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _durationUpdateScheduled = false;
      if (!mounted || _controller.duration == duration) {
        return;
      }
      _controller
        ..duration = duration
        ..repeat();
    });
  }

  double _roundedRectPerimeter(
    Size size,
    double radius,
    double bleed,
  ) {
    final width = (size.width - (bleed * 2)).clamp(1.0, double.infinity);
    final height = (size.height - (bleed * 2)).clamp(1.0, double.infinity);
    final r = radius.clamp(0.0, width / 2).clamp(0.0, height / 2);
    return (2 * (width - (2 * r))) + (2 * (height - (2 * r))) + (2 * pi * r);
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
    final perimeter =
        straightTop + straightRight + straightBottom + straightLeft + (arc * 4);

    var d = (t % 1) * perimeter;

    if (d <= straightTop) {
      return Offset(left + r + d, top);
    }
    d -= straightTop;

    if (d <= arc) {
      final theta = -pi / 2 + (d / r);
      return Offset(
        right - r + (r * cos(theta)),
        top + r + (r * sin(theta)),
      );
    }
    d -= arc;

    if (d <= straightRight) {
      return Offset(right, top + r + d);
    }
    d -= straightRight;

    if (d <= arc) {
      final theta = d / r;
      return Offset(
        right - r + (r * cos(theta)),
        bottom - r + (r * sin(theta)),
      );
    }
    d -= arc;

    if (d <= straightBottom) {
      return Offset(right - r - d, bottom);
    }
    d -= straightBottom;

    if (d <= arc) {
      final theta = pi / 2 + (d / r);
      return Offset(
        left + r + (r * cos(theta)),
        bottom - r + (r * sin(theta)),
      );
    }
    d -= arc;

    if (d <= straightLeft) {
      return Offset(left, bottom - r - d);
    }
    d -= straightLeft;

    final theta = pi + (d / r);
    return Offset(
      left + r + (r * cos(theta)),
      top + r + (r * sin(theta)),
    );
  }
}

class _CometPoint extends StatelessWidget {
  const _CometPoint({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.6),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}
