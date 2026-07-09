import "package:flutter/material.dart";

class AppThemeTokens {
  const AppThemeTokens({
    required this.foundation,
    required this.semantic,
    required this.chart,
  });

  final FoundationColors foundation;
  final SemanticColors semantic;
  final ChartColors chart;
}

class FoundationColors {
  const FoundationColors({
    required this.bgBase,
    required this.bgElev1,
    required this.bgElev2,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.borderSubtle,
    required this.borderStrong,
    required this.accentPrimary,
    required this.accentGlow,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
  });

  final Color bgBase;
  final Color bgElev1;
  final Color bgElev2;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color borderSubtle;
  final Color borderStrong;
  final Color accentPrimary;
  final Color accentGlow;
  final Color success;
  final Color warning;
  final Color error;
  final Color info;
}

class SemanticColors {
  const SemanticColors({
    required this.surface,
    required this.text,
    required this.action,
    required this.setState,
    required this.feedback,
  });

  final SurfaceTokens surface;
  final TextTokens text;
  final ActionTokens action;
  final WorkoutStateTokens setState;
  final FeedbackTokens feedback;
}

class SurfaceTokens {
  const SurfaceTokens({
    required this.screen,
    required this.card,
    required this.overlay,
  });

  final Color screen;
  final Color card;
  final Color overlay;
}

class TextTokens {
  const TextTokens({
    required this.primary,
    required this.muted,
    required this.inverse,
    required this.disabled,
  });

  final Color primary;
  final Color muted;
  final Color inverse;
  final Color disabled;
}

class ActionTokens {
  const ActionTokens({
    required this.primaryBg,
    required this.primaryFg,
    required this.secondaryBg,
    required this.secondaryFg,
    required this.focusRing,
  });

  final Color primaryBg;
  final Color primaryFg;
  final Color secondaryBg;
  final Color secondaryFg;
  final Color focusRing;
}

class WorkoutStateTokens {
  const WorkoutStateTokens({
    required this.ready,
    required this.active,
    required this.complete,
    required this.completeDimOpacity,
  });

  final StateVisual ready;
  final StateVisual active;
  final StateVisual complete;
  final double completeDimOpacity;
}

class StateVisual {
  const StateVisual({
    required this.bg,
    required this.border,
    required this.indicator,
  });

  final Color bg;
  final Color border;
  final Color indicator;
}

class FeedbackTokens {
  const FeedbackTokens({
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
  });

  final Color success;
  final Color warning;
  final Color error;
  final Color info;
}

class ChartColors {
  const ChartColors({
    required this.chrome,
    required this.trend,
    required this.interaction,
    required this.palettes,
  });

  final ChartChrome chrome;
  final ChartTrend trend;
  final ChartInteraction interaction;
  final ChartPaletteSet palettes;
}

class ChartChrome {
  const ChartChrome({
    required this.background,
    required this.gridMajor,
    required this.gridMinor,
    required this.axisLine,
    required this.axisLabel,
    required this.tickLabel,
    required this.tooltipBg,
    required this.tooltipFg,
    required this.tooltipBorder,
  });

  final Color background;
  final Color gridMajor;
  final Color gridMinor;
  final Color axisLine;
  final Color axisLabel;
  final Color tickLabel;
  final Color tooltipBg;
  final Color tooltipFg;
  final Color tooltipBorder;
}

class ChartTrend {
  const ChartTrend({
    required this.up,
    required this.down,
    required this.flat,
  });

  final Color up;
  final Color down;
  final Color flat;
}

class ChartInteraction {
  const ChartInteraction({
    required this.crosshair,
    required this.selectionFill,
    required this.selectionBorder,
    required this.pointHighlight,
  });

  final Color crosshair;
  final Color selectionFill;
  final Color selectionBorder;
  final Color pointHighlight;
}

class ChartPaletteSet {
  const ChartPaletteSet({
    required this.vivid,
    required this.calm,
    required this.mono,
  });

  final ChartSeriesPalette vivid;
  final ChartSeriesPalette calm;
  final ChartSeriesPalette mono;
}

class ChartSeriesPalette {
  const ChartSeriesPalette({
    required this.line,
    required this.point,
    required this.area,
  });

  final List<Color> line;
  final List<Color> point;
  final List<Color> area;
}

enum ChartPaletteMode {
  vivid,
  calm,
  mono,
}

enum AppThemeId {
  graphiteTeal,
  slateLime,
  charcoalBlue,
  crimsonSilver,
}
