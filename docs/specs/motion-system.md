# Next Lift Motion and Interaction Specification

## 1. Purpose
Define a consistent animation language that improves orientation, confidence, and tactile satisfaction without visual clutter.

## 2. Motion Principles
- Motion communicates structure and progression, not decoration.
- Every animation must serve one purpose: orient, confirm, or emphasize.
- Duration and easing remain consistent across the app.
- Reduced-motion mode must preserve clarity with minimal movement.

## 3. Timing Tokens
- `motion.xs = 120ms` (small feedback)
- `motion.sm = 180ms` (state emphasis)
- `motion.md = 240ms` (container transitions)
- `motion.lg = 320ms` (structural morphs)
- `motion.xl = 420ms` (rare major transition)

## 4. Easing Tokens
- `ease.standard = cubic(0.2, 0.0, 0.0, 1.0)`
- `ease.enter = cubic(0.0, 0.0, 0.2, 1.0)`
- `ease.exit = cubic(0.4, 0.0, 1.0, 1.0)`
- `ease.emphasis = spring-medium` (Flutter spring preset)

## 5. Visual State Mapping

### 5.1 set_ready
- Baseline elevation.
- Neutral border and full opacity.
- No persistent motion.

### 5.2 set_active
- Elevated card depth increase.
- Brighter border accent.
- Orbiting indicator (comet point) around active set border.
- Optional pulse on activation entry only.

### 5.3 set_complete
- Reduced opacity and contrast.
- Border de-emphasis.
- Brief completion confirmation flash (single cycle).

## 6. Interaction Motion Catalog

### 6.1 Builder Interactions
- Add shape:
  - New shape slides in from below and settles with `motion.md`.
  - Global plus button shifts to next append position.
- Drag over valid drop zone:
  - Target pre-highlights with subtle expansion (`motion.sm`).
- Successful series insert:
  - Neighbor cards displace smoothly (`motion.md`).
- Successful augment:
  - Parent-child connector morph with `motion.lg`.
- Invalid drop:
  - Brief reject vibration and snap-back (`motion.sm`).

### 6.2 Active Workout Interactions
- Activate set:
  - Elevation rise + border emphasis (`motion.sm`).
  - Orbit indicator starts with phase-in (`motion.sm`).
- Complete set:
  - Active visuals collapse into completed style (`motion.sm`).
  - If rest enabled, global rest module enters (`motion.md`).
- Auto-advance after rest:
  - Current rest module exits (`motion.sm`).
  - Next set activates (`motion.sm`).

### 6.3 Dashboard Interactions
- Card tap to detail:
  - Shared-axis transition from card into detail header.
- Chart range changes:
  - Data transition uses quick crossfade + line morph (`motion.md`).

## 7. Global Rest Timer UI Behavior
- Appears only during active rest.
- Uses compact pinned module near active workout controls.
- Includes countdown text, progress indicator, and optional actions (`Skip`, optional `+15s` if enabled).
- Completion cue chain:
  - visual pulse
  - optional haptic
  - optional sound

## 8. Cue System
- Sound: short neutral tone, no repetitive loops.
- Haptic:
  - light impact on set complete.
  - medium notification on rest finish.
- Visual:
  - short border pulse or timer ring pulse.

All cues are user-configurable and can be independently disabled.

## 9. Reduced Motion Mode
- Disable orbit animation; keep static active indicator.
- Replace structural morphs with crossfade + subtle scale.
- Preserve color/elevation differences for state communication.

## 10. Performance Guardrails
- Maintain 60 fps target during interactive operations.
- Avoid rebuilding entire list/tree for single-set state changes.
- Keep animation layers clipped and bounded.
- Use implicit animations for simple property changes; explicit controllers only for advanced timelines.

## 11. Motion QA Checklist
- State changes are visually unambiguous in under 300ms.
- Drag/drop feedback distinguishes valid vs invalid targets immediately.
- Completion and rest transitions never leave ambiguous active target.
- Reduced-motion mode preserves full usability and state clarity.
