# Next Lift Design Tokens (Flutter)

## 1. Purpose
Define implementation-ready token structures for color semantics and chart styling so theme switching is deterministic and charts remain visually varied.

## 2. Token Layers
- `Foundation`: raw theme values (hex colors).
- `Semantic`: UI meaning (surfaces, text, states, controls).
- `Chart`: data-visualization tokens (series lines, points, grids, axes, tooltips).

## 3. Flutter Token Model

```dart
class AppThemeTokens {
  final FoundationColors foundation;
  final SemanticColors semantic;
  final ChartColors chart;

  const AppThemeTokens({
    required this.foundation,
    required this.semantic,
    required this.chart,
  });
}
```

### 3.1 FoundationColors

```dart
class FoundationColors {
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
```

### 3.2 SemanticColors

```dart
class SemanticColors {
  final SurfaceTokens surface;
  final TextTokens text;
  final ActionTokens action;
  final WorkoutStateTokens setState;
  final FeedbackTokens feedback;
}

class SurfaceTokens {
  final Color screen;
  final Color card;
  final Color overlay;
}

class TextTokens {
  final Color primary;
  final Color muted;
  final Color inverse;
  final Color disabled;
}

class ActionTokens {
  final Color primaryBg;
  final Color primaryFg;
  final Color secondaryBg;
  final Color secondaryFg;
  final Color focusRing;
}

class WorkoutStateTokens {
  final StateVisual ready;
  final StateVisual active;
  final StateVisual complete;
}

class StateVisual {
  final Color bg;
  final Color border;
  final Color indicator;
}

class FeedbackTokens {
  final Color success;
  final Color warning;
  final Color error;
  final Color info;
}
```

### 3.3 ChartColors

```dart
class ChartColors {
  final ChartChrome chrome;
  final ChartTrend trend;
  final ChartInteraction interaction;
  final ChartPaletteSet palettes;
}

class ChartChrome {
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
  final Color up;
  final Color down;
  final Color flat;
}

class ChartInteraction {
  final Color crosshair;
  final Color selectionFill;
  final Color selectionBorder;
  final Color pointHighlight;
}

class ChartPaletteSet {
  final ChartSeriesPalette vivid;   // high contrast
  final ChartSeriesPalette calm;    // lower contrast
  final ChartSeriesPalette mono;    // single-family fallback
}

class ChartSeriesPalette {
  final List<Color> line;   // recommended length: 8
  final List<Color> point;  // recommended length: 8
  final List<Color> area;   // optional area-fill colors (alpha-applied)
}
```

## 4. Chart Variety Rules (Locked)
- Charts must not all use a single global series set.
- Each chart chooses a palette mode:
  - `vivid` (default)
  - `calm`
  - `mono` (only where visual simplicity is needed)
- Series color assignment is deterministic:
  - `colorIndex = seriesIndex % palette.line.length`
- Point colors can be offset for variation:
  - `pointIndex = (seriesIndex + 1) % palette.point.length`
- For charts with a single series, rotate palette by chart id hash to avoid identical visuals across dashboard cards.

## 5. Theme Token Defaults

### 5.1 `graphite_teal` (default theme)
```text
line.vivid:  #3AD7C8 #7EB6FF #FFCC66 #FF8C9F #C5B3FF #5DE2A5 #6FD3FF #FFC07A
point.vivid: #66EADD #A4CCFF #FFD98E #FFA7B6 #D5C6FF #87EDBE #97E2FF #FFD1A3
line.calm:   #66BDB4 #7DA1CC #C8AE73 #C495A1 #AEA2CB #78B69A #84B6CF #C2A489
point.calm:  #87CEC8 #98B4D9 #D4BF92 #CEACB4 #BFB5D8 #92C7AD #9BC5D9 #D2BAA1
line.mono:   #3AD7C8 #33C1B3 #2CAC9F #25978B #1F8278 #196E65 #135A53 #0E4641
point.mono:  #66EADD #5ED8CB #55C6B9 #4CB4A7 #43A295 #3A9083 #317E71 #286C60
```

### 5.2 `slate_lime`
```text
line.vivid:  #B7FF3C #57D9FF #FFC857 #FF7A99 #C3A6FF #71F7A9 #8AC1FF #FFD67A
point.vivid: #CEFF77 #87E6FF #FFD98F #FFA4BA #D4BFFF #97FBC2 #AECFFF #FFE2A6
line.calm:   #93C15D #6BA8BA #C8A46C #BA7E90 #A795C8 #79B793 #88A6C8 #C6AD85
point.calm:  #A8CE7E #84B9C8 #D3B988 #C996A3 #B7A9D6 #94C5A8 #9FB6D4 #D5C09E
line.mono:   #B7FF3C #A5E637 #94CC31 #82B32C #719927 #5F8021 #4E661C #3D4D16
point.mono:  #CEFF77 #BCEB69 #ABD65C #99C24F #88AD42 #769935 #658427 #54701A
```

### 5.3 `charcoal_blue`
```text
line.vivid:  #6BB6FF #5BE7C4 #FFD166 #FF8FA3 #B8A1FF #7DEB95 #93C8FF #FFC980
point.vivid: #93CBFF #87EFD5 #FFDD8F #FFAABD #CBB9FF #A3F2B3 #B5D8FF #FFD8A7
line.calm:   #6F93BD #6FAE9E #C2A774 #B58A95 #A194C3 #7FB49A #88A3C7 #C2A689
point.calm:  #85A6CB #87BBB0 #D0B991 #C49FA8 #B4AAD2 #97C2AE #9CB2D2 #D1B89F
line.mono:   #6BB6FF #5EA2E3 #518EC8 #457AAD #386692 #2C5377 #1F3F5B #132B40
point.mono:  #93CBFF #84B8EB #75A4D8 #6791C4 #587EB0 #4A6A9D #3B5789 #2D4375
```

## 6. Settings Contract
- `UserSettings.themeId` selects one theme token bundle.
- Each chart config includes optional `paletteMode` (`vivid|calm|mono`), default `vivid`.
- Optional per-chart override:
  - `colorSeed` integer for deterministic palette rotation.

## 7. Accessibility Rules
- Minimum contrast ratio:
  - axis labels/ticks against chart background: `4.5:1`
  - primary chart lines against chart background: `3:1` minimum
- Point markers must use a stroke or halo when line color is low-contrast.

## 8. Implementation Order
1. Add token classes and theme registry.
2. Implement `graphite_teal` as default registry entry.
3. Add `slate_lime` and `charcoal_blue`.
4. Wire `themeId` selection in settings.
5. Implement chart palette selection and deterministic assignment logic.
