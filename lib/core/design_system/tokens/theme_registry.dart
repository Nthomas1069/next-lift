import "package:flutter/material.dart";

import "app_theme_tokens.dart";

class ThemeRegistry {
  static const AppThemeId defaultThemeId = AppThemeId.graphiteTeal;

  static final Map<AppThemeId, AppThemeTokens> all = {
    AppThemeId.graphiteTeal: _graphiteTeal,
    AppThemeId.slateLime: _slateLime,
    AppThemeId.charcoalBlue: _charcoalBlue,
    AppThemeId.crimsonSilver: _crimsonSilver,
  };

  static AppThemeTokens resolve(AppThemeId id) {
    return all[id] ?? _graphiteTeal;
  }
}

String themeIdToStorage(AppThemeId id) {
  return switch (id) {
    AppThemeId.graphiteTeal => "graphite_teal",
    AppThemeId.slateLime => "slate_lime",
    AppThemeId.charcoalBlue => "charcoal_blue",
    AppThemeId.crimsonSilver => "crimson_silver",
  };
}

AppThemeId appThemeIdFromStorage(String? raw) {
  return switch (raw) {
    "slate_lime" => AppThemeId.slateLime,
    "charcoal_blue" => AppThemeId.charcoalBlue,
    "graphite_teal" => AppThemeId.graphiteTeal,
    "crimson_silver" => AppThemeId.crimsonSilver,
    _ => ThemeRegistry.defaultThemeId,
  };
}

Color chartLineColor({
  required AppThemeTokens tokens,
  required int seriesIndex,
  ChartPaletteMode mode = ChartPaletteMode.vivid,
  int colorSeed = 0,
}) {
  final palette = _seriesPalette(tokens, mode).line;
  final idx = (seriesIndex + colorSeed) % palette.length;
  return palette[idx];
}

Color chartPointColor({
  required AppThemeTokens tokens,
  required int seriesIndex,
  ChartPaletteMode mode = ChartPaletteMode.vivid,
  int colorSeed = 0,
}) {
  final palette = _seriesPalette(tokens, mode).point;
  final idx = (seriesIndex + 1 + colorSeed) % palette.length;
  return palette[idx];
}

ChartSeriesPalette _seriesPalette(
    AppThemeTokens tokens, ChartPaletteMode mode) {
  switch (mode) {
    case ChartPaletteMode.vivid:
      return tokens.chart.palettes.vivid;
    case ChartPaletteMode.calm:
      return tokens.chart.palettes.calm;
    case ChartPaletteMode.mono:
      return tokens.chart.palettes.mono;
  }
}

const AppThemeTokens _graphiteTeal = AppThemeTokens(
  foundation: FoundationColors(
    bgBase: Color(0xFF111517),
    bgElev1: Color(0xFF172022),
    bgElev2: Color(0xFF1D2A2D),
    textPrimary: Color(0xFFE7F1F2),
    textSecondary: Color(0xFF9EB2B4),
    textTertiary: Color(0xFF7E9396),
    borderSubtle: Color(0xFF2A3A3D),
    borderStrong: Color(0xFF3C5358),
    accentPrimary: Color(0xFF3AD7C8),
    accentGlow: Color(0x383AD7C8),
    success: Color(0xFF5DE2A5),
    warning: Color(0xFFFFCC66),
    error: Color(0xFFFF8C9F),
    info: Color(0xFF7EB6FF),
  ),
  semantic: SemanticColors(
    surface: SurfaceTokens(
      screen: Color(0xFF111517),
      card: Color(0xFF172022),
      overlay: Color(0xE61D2A2D),
    ),
    text: TextTokens(
      primary: Color(0xFFE7F1F2),
      muted: Color(0xFF9EB2B4),
      inverse: Color(0xFF111517),
      disabled: Color(0xFF6E8082),
    ),
    action: ActionTokens(
      primaryBg: Color(0xFF3AD7C8),
      primaryFg: Color(0xFF111517),
      secondaryBg: Color(0xFF1D2A2D),
      secondaryFg: Color(0xFFE7F1F2),
      focusRing: Color(0x803AD7C8),
    ),
    setState: WorkoutStateTokens(
      ready: StateVisual(
        bg: Color(0xFF172022),
        border: Color(0xFF2A3A3D),
        indicator: Color(0x00000000),
      ),
      active: StateVisual(
        bg: Color(0xFF1D2A2D),
        border: Color(0xFF3AD7C8),
        indicator: Color(0xFF3AD7C8),
      ),
      complete: StateVisual(
        bg: Color(0xFF141B1D),
        border: Color(0xFF2A3A3D),
        indicator: Color(0xFF7E9396),
      ),
      completeDimOpacity: 0.64,
    ),
    feedback: FeedbackTokens(
      success: Color(0xFF5DE2A5),
      warning: Color(0xFFFFCC66),
      error: Color(0xFFFF8C9F),
      info: Color(0xFF7EB6FF),
    ),
  ),
  chart: ChartColors(
    chrome: ChartChrome(
      background: Color(0xFF172022),
      gridMajor: Color(0x332A3A3D),
      gridMinor: Color(0x1F2A3A3D),
      axisLine: Color(0x4D3C5358),
      axisLabel: Color(0xFF9EB2B4),
      tickLabel: Color(0xFF7E9396),
      tooltipBg: Color(0xF01D2A2D),
      tooltipFg: Color(0xFFE7F1F2),
      tooltipBorder: Color(0x663C5358),
    ),
    trend: ChartTrend(
      up: Color(0xFF5DE2A5),
      down: Color(0xFFFF8C9F),
      flat: Color(0xFF7EB6FF),
    ),
    interaction: ChartInteraction(
      crosshair: Color(0x803AD7C8),
      selectionFill: Color(0x2E3AD7C8),
      selectionBorder: Color(0x803AD7C8),
      pointHighlight: Color(0xFFE7F1F2),
    ),
    palettes: ChartPaletteSet(
      vivid: ChartSeriesPalette(
        line: [
          Color(0xFF3AD7C8),
          Color(0xFF7EB6FF),
          Color(0xFFFFCC66),
          Color(0xFFFF8C9F),
          Color(0xFFC5B3FF),
          Color(0xFF5DE2A5),
          Color(0xFF6FD3FF),
          Color(0xFFFFC07A),
        ],
        point: [
          Color(0xFF66EADD),
          Color(0xFFA4CCFF),
          Color(0xFFFFD98E),
          Color(0xFFFFA7B6),
          Color(0xFFD5C6FF),
          Color(0xFF87EDBE),
          Color(0xFF97E2FF),
          Color(0xFFFFD1A3),
        ],
        area: [
          Color(0x333AD7C8),
          Color(0x337EB6FF),
          Color(0x33FFCC66),
          Color(0x33FF8C9F),
          Color(0x33C5B3FF),
          Color(0x335DE2A5),
          Color(0x336FD3FF),
          Color(0x33FFC07A),
        ],
      ),
      calm: ChartSeriesPalette(
        line: [
          Color(0xFF66BDB4),
          Color(0xFF7DA1CC),
          Color(0xFFC8AE73),
          Color(0xFFC495A1),
          Color(0xFFAEA2CB),
          Color(0xFF78B69A),
          Color(0xFF84B6CF),
          Color(0xFFC2A489),
        ],
        point: [
          Color(0xFF87CEC8),
          Color(0xFF98B4D9),
          Color(0xFFD4BF92),
          Color(0xFFCEACB4),
          Color(0xFFBFB5D8),
          Color(0xFF92C7AD),
          Color(0xFF9BC5D9),
          Color(0xFFD2BAA1),
        ],
        area: [
          Color(0x3366BDB4),
          Color(0x337DA1CC),
          Color(0x33C8AE73),
          Color(0x33C495A1),
          Color(0x33AEA2CB),
          Color(0x3378B69A),
          Color(0x3384B6CF),
          Color(0x33C2A489),
        ],
      ),
      mono: ChartSeriesPalette(
        line: [
          Color(0xFF3AD7C8),
          Color(0xFF33C1B3),
          Color(0xFF2CAC9F),
          Color(0xFF25978B),
          Color(0xFF1F8278),
          Color(0xFF196E65),
          Color(0xFF135A53),
          Color(0xFF0E4641),
        ],
        point: [
          Color(0xFF66EADD),
          Color(0xFF5ED8CB),
          Color(0xFF55C6B9),
          Color(0xFF4CB4A7),
          Color(0xFF43A295),
          Color(0xFF3A9083),
          Color(0xFF317E71),
          Color(0xFF286C60),
        ],
        area: [
          Color(0x333AD7C8),
          Color(0x3333C1B3),
          Color(0x332CAC9F),
          Color(0x3325978B),
          Color(0x331F8278),
          Color(0x33196E65),
          Color(0x33135A53),
          Color(0x330E4641),
        ],
      ),
    ),
  ),
);

const AppThemeTokens _slateLime = AppThemeTokens(
  foundation: FoundationColors(
    bgBase: Color(0xFF111418),
    bgElev1: Color(0xFF171B21),
    bgElev2: Color(0xFF1E232A),
    textPrimary: Color(0xFFEDF2F7),
    textSecondary: Color(0xFF9AA7B6),
    textTertiary: Color(0xFF7F8A96),
    borderSubtle: Color(0xFF2A313A),
    borderStrong: Color(0xFF3A4552),
    accentPrimary: Color(0xFFB7FF3C),
    accentGlow: Color(0x33B7FF3C),
    success: Color(0xFF71F7A9),
    warning: Color(0xFFFFC857),
    error: Color(0xFFFF7A99),
    info: Color(0xFF57D9FF),
  ),
  semantic: SemanticColors(
    surface: SurfaceTokens(
      screen: Color(0xFF111418),
      card: Color(0xFF171B21),
      overlay: Color(0xE61E232A),
    ),
    text: TextTokens(
      primary: Color(0xFFEDF2F7),
      muted: Color(0xFF9AA7B6),
      inverse: Color(0xFF111418),
      disabled: Color(0xFF6E7886),
    ),
    action: ActionTokens(
      primaryBg: Color(0xFFB7FF3C),
      primaryFg: Color(0xFF111418),
      secondaryBg: Color(0xFF1E232A),
      secondaryFg: Color(0xFFEDF2F7),
      focusRing: Color(0x80B7FF3C),
    ),
    setState: WorkoutStateTokens(
      ready: StateVisual(
        bg: Color(0xFF171B21),
        border: Color(0xFF2A313A),
        indicator: Color(0x00000000),
      ),
      active: StateVisual(
        bg: Color(0xFF1E232A),
        border: Color(0xFFB7FF3C),
        indicator: Color(0xFFB7FF3C),
      ),
      complete: StateVisual(
        bg: Color(0xFF14181D),
        border: Color(0xFF2A313A),
        indicator: Color(0xFF7F8A96),
      ),
      completeDimOpacity: 0.64,
    ),
    feedback: FeedbackTokens(
      success: Color(0xFF71F7A9),
      warning: Color(0xFFFFC857),
      error: Color(0xFFFF7A99),
      info: Color(0xFF57D9FF),
    ),
  ),
  chart: ChartColors(
    chrome: ChartChrome(
      background: Color(0xFF171B21),
      gridMajor: Color(0x332A313A),
      gridMinor: Color(0x1F2A313A),
      axisLine: Color(0x4D3A4552),
      axisLabel: Color(0xFF9AA7B6),
      tickLabel: Color(0xFF7F8A96),
      tooltipBg: Color(0xF01E232A),
      tooltipFg: Color(0xFFEDF2F7),
      tooltipBorder: Color(0x663A4552),
    ),
    trend: ChartTrend(
      up: Color(0xFF71F7A9),
      down: Color(0xFFFF7A99),
      flat: Color(0xFF57D9FF),
    ),
    interaction: ChartInteraction(
      crosshair: Color(0x80B7FF3C),
      selectionFill: Color(0x2EB7FF3C),
      selectionBorder: Color(0x80B7FF3C),
      pointHighlight: Color(0xFFEDF2F7),
    ),
    palettes: ChartPaletteSet(
      vivid: ChartSeriesPalette(
        line: [
          Color(0xFFB7FF3C),
          Color(0xFF57D9FF),
          Color(0xFFFFC857),
          Color(0xFFFF7A99),
          Color(0xFFC3A6FF),
          Color(0xFF71F7A9),
          Color(0xFF8AC1FF),
          Color(0xFFFFD67A),
        ],
        point: [
          Color(0xFFCEFF77),
          Color(0xFF87E6FF),
          Color(0xFFFFD98F),
          Color(0xFFFFA4BA),
          Color(0xFFD4BFFF),
          Color(0xFF97FBC2),
          Color(0xFFAECFFF),
          Color(0xFFFFE2A6),
        ],
        area: [
          Color(0x33B7FF3C),
          Color(0x3357D9FF),
          Color(0x33FFC857),
          Color(0x33FF7A99),
          Color(0x33C3A6FF),
          Color(0x3371F7A9),
          Color(0x338AC1FF),
          Color(0x33FFD67A),
        ],
      ),
      calm: ChartSeriesPalette(
        line: [
          Color(0xFF93C15D),
          Color(0xFF6BA8BA),
          Color(0xFFC8A46C),
          Color(0xFFBA7E90),
          Color(0xFFA795C8),
          Color(0xFF79B793),
          Color(0xFF88A6C8),
          Color(0xFFC6AD85),
        ],
        point: [
          Color(0xFFA8CE7E),
          Color(0xFF84B9C8),
          Color(0xFFD3B988),
          Color(0xFFC996A3),
          Color(0xFFB7A9D6),
          Color(0xFF94C5A8),
          Color(0xFF9FB6D4),
          Color(0xFFD5C09E),
        ],
        area: [
          Color(0x3393C15D),
          Color(0x336BA8BA),
          Color(0x33C8A46C),
          Color(0x33BA7E90),
          Color(0x33A795C8),
          Color(0x3379B793),
          Color(0x3388A6C8),
          Color(0x33C6AD85),
        ],
      ),
      mono: ChartSeriesPalette(
        line: [
          Color(0xFFB7FF3C),
          Color(0xFFA5E637),
          Color(0xFF94CC31),
          Color(0xFF82B32C),
          Color(0xFF719927),
          Color(0xFF5F8021),
          Color(0xFF4E661C),
          Color(0xFF3D4D16),
        ],
        point: [
          Color(0xFFCEFF77),
          Color(0xFFBCEB69),
          Color(0xFFABD65C),
          Color(0xFF99C24F),
          Color(0xFF88AD42),
          Color(0xFF769935),
          Color(0xFF658427),
          Color(0xFF54701A),
        ],
        area: [
          Color(0x33B7FF3C),
          Color(0x33A5E637),
          Color(0x3394CC31),
          Color(0x3382B32C),
          Color(0x33719927),
          Color(0x335F8021),
          Color(0x334E661C),
          Color(0x333D4D16),
        ],
      ),
    ),
  ),
);

const AppThemeTokens _charcoalBlue = AppThemeTokens(
  foundation: FoundationColors(
    bgBase: Color(0xFF121419),
    bgElev1: Color(0xFF1A1E27),
    bgElev2: Color(0xFF202634),
    textPrimary: Color(0xFFEAF0F7),
    textSecondary: Color(0xFF9EACBC),
    textTertiary: Color(0xFF808D9D),
    borderSubtle: Color(0xFF2B3442),
    borderStrong: Color(0xFF3C4B61),
    accentPrimary: Color(0xFF6BB6FF),
    accentGlow: Color(0x336BB6FF),
    success: Color(0xFF7DEB95),
    warning: Color(0xFFFFD166),
    error: Color(0xFFFF8FA3),
    info: Color(0xFF5BE7C4),
  ),
  semantic: SemanticColors(
    surface: SurfaceTokens(
      screen: Color(0xFF121419),
      card: Color(0xFF1A1E27),
      overlay: Color(0xE6202634),
    ),
    text: TextTokens(
      primary: Color(0xFFEAF0F7),
      muted: Color(0xFF9EACBC),
      inverse: Color(0xFF121419),
      disabled: Color(0xFF738095),
    ),
    action: ActionTokens(
      primaryBg: Color(0xFF6BB6FF),
      primaryFg: Color(0xFF121419),
      secondaryBg: Color(0xFF202634),
      secondaryFg: Color(0xFFEAF0F7),
      focusRing: Color(0x806BB6FF),
    ),
    setState: WorkoutStateTokens(
      ready: StateVisual(
        bg: Color(0xFF1A1E27),
        border: Color(0xFF2B3442),
        indicator: Color(0x00000000),
      ),
      active: StateVisual(
        bg: Color(0xFF202634),
        border: Color(0xFF6BB6FF),
        indicator: Color(0xFF6BB6FF),
      ),
      complete: StateVisual(
        bg: Color(0xFF171B23),
        border: Color(0xFF2B3442),
        indicator: Color(0xFF808D9D),
      ),
      completeDimOpacity: 0.64,
    ),
    feedback: FeedbackTokens(
      success: Color(0xFF7DEB95),
      warning: Color(0xFFFFD166),
      error: Color(0xFFFF8FA3),
      info: Color(0xFF5BE7C4),
    ),
  ),
  chart: ChartColors(
    chrome: ChartChrome(
      background: Color(0xFF1A1E27),
      gridMajor: Color(0x332B3442),
      gridMinor: Color(0x1F2B3442),
      axisLine: Color(0x4D3C4B61),
      axisLabel: Color(0xFF9EACBC),
      tickLabel: Color(0xFF808D9D),
      tooltipBg: Color(0xF0202634),
      tooltipFg: Color(0xFFEAF0F7),
      tooltipBorder: Color(0x663C4B61),
    ),
    trend: ChartTrend(
      up: Color(0xFF7DEB95),
      down: Color(0xFFFF8FA3),
      flat: Color(0xFF6BB6FF),
    ),
    interaction: ChartInteraction(
      crosshair: Color(0x806BB6FF),
      selectionFill: Color(0x2E6BB6FF),
      selectionBorder: Color(0x806BB6FF),
      pointHighlight: Color(0xFFEAF0F7),
    ),
    palettes: ChartPaletteSet(
      vivid: ChartSeriesPalette(
        line: [
          Color(0xFF6BB6FF),
          Color(0xFF5BE7C4),
          Color(0xFFFFD166),
          Color(0xFFFF8FA3),
          Color(0xFFB8A1FF),
          Color(0xFF7DEB95),
          Color(0xFF93C8FF),
          Color(0xFFFFC980),
        ],
        point: [
          Color(0xFF93CBFF),
          Color(0xFF87EFD5),
          Color(0xFFFFDD8F),
          Color(0xFFFFAABD),
          Color(0xFFCBB9FF),
          Color(0xFFA3F2B3),
          Color(0xFFB5D8FF),
          Color(0xFFFFD8A7),
        ],
        area: [
          Color(0x336BB6FF),
          Color(0x335BE7C4),
          Color(0x33FFD166),
          Color(0x33FF8FA3),
          Color(0x33B8A1FF),
          Color(0x337DEB95),
          Color(0x3393C8FF),
          Color(0x33FFC980),
        ],
      ),
      calm: ChartSeriesPalette(
        line: [
          Color(0xFF6F93BD),
          Color(0xFF6FAE9E),
          Color(0xFFC2A774),
          Color(0xFFB58A95),
          Color(0xFFA194C3),
          Color(0xFF7FB49A),
          Color(0xFF88A3C7),
          Color(0xFFC2A689),
        ],
        point: [
          Color(0xFF85A6CB),
          Color(0xFF87BBB0),
          Color(0xFFD0B991),
          Color(0xFFC49FA8),
          Color(0xFFB4AAD2),
          Color(0xFF97C2AE),
          Color(0xFF9CB2D2),
          Color(0xFFD1B89F),
        ],
        area: [
          Color(0x336F93BD),
          Color(0x336FAE9E),
          Color(0x33C2A774),
          Color(0x33B58A95),
          Color(0x33A194C3),
          Color(0x337FB49A),
          Color(0x3388A3C7),
          Color(0x33C2A689),
        ],
      ),
      mono: ChartSeriesPalette(
        line: [
          Color(0xFF6BB6FF),
          Color(0xFF5EA2E3),
          Color(0xFF518EC8),
          Color(0xFF457AAD),
          Color(0xFF386692),
          Color(0xFF2C5377),
          Color(0xFF1F3F5B),
          Color(0xFF132B40),
        ],
        point: [
          Color(0xFF93CBFF),
          Color(0xFF84B8EB),
          Color(0xFF75A4D8),
          Color(0xFF6791C4),
          Color(0xFF587EB0),
          Color(0xFF4A6A9D),
          Color(0xFF3B5789),
          Color(0xFF2D4375),
        ],
        area: [
          Color(0x336BB6FF),
          Color(0x335EA2E3),
          Color(0x33518EC8),
          Color(0x33457AAD),
          Color(0x33386692),
          Color(0x332C5377),
          Color(0x331F3F5B),
          Color(0x33132B40),
        ],
      ),
    ),
  ),
);

const AppThemeTokens _crimsonSilver = AppThemeTokens(
  foundation: FoundationColors(
    bgBase: Color(0xFF121113),
    bgElev1: Color(0xFF1B181C),
    bgElev2: Color(0xFF252027),
    textPrimary: Color(0xFFF1EEF3),
    textSecondary: Color(0xFFB5AFB9),
    textTertiary: Color(0xFF8D8591),
    borderSubtle: Color(0xFF3A3440),
    borderStrong: Color(0xFF5A5261),
    accentPrimary: Color(0xFFFF1744),
    accentGlow: Color(0x40FF1744),
    success: Color(0xFF6FE8B0),
    warning: Color(0xFFFFC36A),
    error: Color(0xFFFF5570),
    info: Color(0xFFB9C0CC),
  ),
  semantic: SemanticColors(
    surface: SurfaceTokens(
      screen: Color(0xFF121113),
      card: Color(0xFF1B181C),
      overlay: Color(0xE6252027),
    ),
    text: TextTokens(
      primary: Color(0xFFF1EEF3),
      muted: Color(0xFFB5AFB9),
      inverse: Color(0xFF121113),
      disabled: Color(0xFF7A7380),
    ),
    action: ActionTokens(
      primaryBg: Color(0xFF252027),
      primaryFg: Color(0xFFF1EEF3),
      secondaryBg: Color(0xFF1B181C),
      secondaryFg: Color(0xFFE0DBE3),
      focusRing: Color(0x80FF1744),
    ),
    setState: WorkoutStateTokens(
      ready: StateVisual(
        bg: Color(0xFF1B181C),
        border: Color(0xFF3A3440),
        indicator: Color(0x00000000),
      ),
      active: StateVisual(
        bg: Color(0xFF252027),
        border: Color(0xFFFF1744),
        indicator: Color(0xFFFF1744),
      ),
      complete: StateVisual(
        bg: Color(0xFF171519),
        border: Color(0xFF3A3440),
        indicator: Color(0xFF8D8591),
      ),
      completeDimOpacity: 0.64,
    ),
    feedback: FeedbackTokens(
      success: Color(0xFF6FE8B0),
      warning: Color(0xFFFFC36A),
      error: Color(0xFFFF5570),
      info: Color(0xFFB9C0CC),
    ),
  ),
  chart: ChartColors(
    chrome: ChartChrome(
      background: Color(0xFF1B181C),
      gridMajor: Color(0x333A3440),
      gridMinor: Color(0x1F3A3440),
      axisLine: Color(0x4D5A5261),
      axisLabel: Color(0xFFB5AFB9),
      tickLabel: Color(0xFF8D8591),
      tooltipBg: Color(0xF0252027),
      tooltipFg: Color(0xFFF1EEF3),
      tooltipBorder: Color(0x665A5261),
    ),
    trend: ChartTrend(
      up: Color(0xFF6FE8B0),
      down: Color(0xFFFF5570),
      flat: Color(0xFFB9C0CC),
    ),
    interaction: ChartInteraction(
      crosshair: Color(0x80FF1744),
      selectionFill: Color(0x30FF1744),
      selectionBorder: Color(0x80FF1744),
      pointHighlight: Color(0xFFF1EEF3),
    ),
    palettes: ChartPaletteSet(
      vivid: ChartSeriesPalette(
        line: [
          Color(0xFFFF1744),
          Color(0xFFC0C7D2),
          Color(0xFFFF8B6B),
          Color(0xFF7DE8C8),
          Color(0xFFD6B0FF),
          Color(0xFFFFC36A),
          Color(0xFF9FB4FF),
          Color(0xFFFF5570),
        ],
        point: [
          Color(0xFFFF7A91),
          Color(0xFFD3D8DF),
          Color(0xFFFFAA90),
          Color(0xFFA2EFD8),
          Color(0xFFE3C8FF),
          Color(0xFFFFD48E),
          Color(0xFFBAC9FF),
          Color(0xFFFF8D9A),
        ],
        area: [
          Color(0x33FF1744),
          Color(0x33C0C7D2),
          Color(0x33FF8B6B),
          Color(0x337DE8C8),
          Color(0x33D6B0FF),
          Color(0x33FFC36A),
          Color(0x339FB4FF),
          Color(0x33FF5570),
        ],
      ),
      calm: ChartSeriesPalette(
        line: [
          Color(0xFFBF5D6D),
          Color(0xFF969CA7),
          Color(0xFFC48C7D),
          Color(0xFF7FB4A6),
          Color(0xFFA992C2),
          Color(0xFFC6A077),
          Color(0xFF8EA1CC),
          Color(0xFFC06D79),
        ],
        point: [
          Color(0xFFC97C88),
          Color(0xFFA7ADB7),
          Color(0xFFD3A195),
          Color(0xFF97C2B8),
          Color(0xFFB8A7CC),
          Color(0xFFD0B28F),
          Color(0xFFA5B3D6),
          Color(0xFFCC8791),
        ],
        area: [
          Color(0x33BF5D6D),
          Color(0x33969CA7),
          Color(0x33C48C7D),
          Color(0x337FB4A6),
          Color(0x33A992C2),
          Color(0x33C6A077),
          Color(0x338EA1CC),
          Color(0x33C06D79),
        ],
      ),
      mono: ChartSeriesPalette(
        line: [
          Color(0xFFFF1744),
          Color(0xFFE3153D),
          Color(0xFFC71235),
          Color(0xFFAB102E),
          Color(0xFF900D27),
          Color(0xFF740B1F),
          Color(0xFF580818),
          Color(0xFF3D0611),
        ],
        point: [
          Color(0xFFFF7A91),
          Color(0xFFF06B84),
          Color(0xFFE25D77),
          Color(0xFFD34E69),
          Color(0xFFC53F5C),
          Color(0xFFB6304F),
          Color(0xFFA82242),
          Color(0xFF991335),
        ],
        area: [
          Color(0x33FF1744),
          Color(0x33E3153D),
          Color(0x33C71235),
          Color(0x33AB102E),
          Color(0x33900D27),
          Color(0x33740B1F),
          Color(0x33580818),
          Color(0x333D0611),
        ],
      ),
    ),
  ),
);
