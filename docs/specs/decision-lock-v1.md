# Next Lift Decision Lock v1

## 1. Purpose
Resolve the open decisions identified in planning and establish a single authoritative lock for V1 implementation.

## 2. Locked Decisions

### 2.1 Rest Controls
- `Skip Rest`: enabled in V1 when global rest is enabled.
- `+15s`: enabled in V1 when global rest is enabled.
- User can disable either control in settings.
- Default setting: both controls enabled.

### 2.2 Final-Set Completion Behavior
- If the completed set is the final executable set, global rest is not started.
- The runtime moves directly to final CTA state (`Workout Complete`).
- Terminal rest is only possible if user modeled a timed `Rest` exercise in the workout flow.

### 2.3 Completed-Set Edit Recalculation Timing
- Editing values on completed sets immediately marks session stats dirty.
- Recalculation runs immediately in-memory for visible values.
- A fresh persisted `DerivedStatSnapshot` is written on a short debounce window (`300ms`) to avoid write bursts.
- If session is already complete, dashboard rollups update as part of that write cycle.

### 2.4 Dashboard KPI and Trend Thresholds (V1 Constants)
- Bodyweight trend window: last `28` days.
- Minimum entries for trend arrow: `4`.
- Trend method: linear regression slope over bodyweight entries in window.
- Thresholds:
  - `up` if slope >= `+0.25%` of mean bodyweight per week.
  - `down` if slope <= `-0.25%` of mean bodyweight per week.
  - `flat` otherwise.
- Workout frequency card: completed sessions in selected period (`week` default).
- Volume card: total session volume by period.
- Duration card: total workout duration by period.

### 2.5 Active-Workout Structural Guard Matrix

| Operation | Allowed When | Rejected When |
| --- | --- | --- |
| Append shape (bottom) | Session not complete | Session complete |
| Drag reorder upward | Source subtree all `set_ready` and every crossed target region all `set_ready` | Any crossed region contains `set_active` or `set_complete` |
| Drag augment target | Target subtree all `set_ready` and source subtree all `set_ready` | Source or target contains started/completed sets |
| Add set via shape-local plus | Shape has at least one non-complete set | Shape fully complete |
| Edit completed set values | Set is `set_complete` | Any state mutation attempt (`set_complete` rollback) |

Additional lock:
- Drag-down reorder is not supported in V1. Reordering is upward only.

### 2.6 Theme Selection and Statistics Chart Colors
- V1 ships with four selectable dark-first themes:
  - `slate_lime`
  - `charcoal_blue`
  - `graphite_teal`
  - `crimson_silver`
- Default theme is `graphite_teal`.
- User can change theme in settings at any time.
- Theme change applies globally and immediately.
- Statistics charts must use dedicated line palettes (not only single accent color) for multi-series legibility.
- Statistics charts support multiple palette modes (`vivid`, `calm`, `mono`) so charts do not all look the same.
- Each theme defines five ordered chart line tokens:
  - `chart_line_1`
  - `chart_line_2`
  - `chart_line_3`
  - `chart_line_4`
  - `chart_line_5`
- Each theme also defines point color tokens and extended series palettes in `docs/specs/design-tokens.md`.
- Locked chart color sets:
  - `slate_lime`: `#B7FF3C`, `#57D9FF`, `#FFC857`, `#FF7A99`, `#C3A6FF`
  - `charcoal_blue`: `#6BB6FF`, `#5BE7C4`, `#FFD166`, `#FF8FA3`, `#B8A1FF`
  - `graphite_teal`: `#3AD7C8`, `#7EB6FF`, `#FFCC66`, `#FF8C9F`, `#C5B3FF`
  - `crimson_silver`: `#FF1744`, `#C0C7D2`, `#FF8B6B`, `#7DE8C8`, `#D6B0FF`

## 3. Runtime Event Lock Updates
- `completeActiveSet()` must check `hasNextSet` before arming global rest.
- If `hasNextSet == false`, emit `progressionExhausted` and present final CTA.
- `skipRest()` and `+15s` are available only during `session_resting`.

## 4. Acceptance Lock Updates
- V1 QA must include:
  - final-set completion does not start terminal rest.
  - `Skip Rest` and `+15s` controls function and obey settings toggles.
  - upward-only reorder rule enforcement.
  - immediate visible stat update after completed-set edit.

## 5. Priority and Scope Rule
If any other spec conflicts with this file during V1 implementation, `decision-lock-v1.md` is the tie-breaker source until an explicit revision is approved.
