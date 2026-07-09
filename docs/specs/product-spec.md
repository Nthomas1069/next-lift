# Next Lift Product Specification

## 1. Purpose
`next-lift` is a personal, device-only fitness logging app for iOS and Android. The product prioritizes clean visual structure, refined motion, and configurable workout construction based on composable workout shapes.

## 2. Product Pillars
- Clean, legible interface with minimal visual noise.
- Shape-based workout composition, not simple linear lists.
- High interaction quality through purposeful animations.
- Local-first and offline-by-default operation.
- Strictly no emoji usage in product copy, labels, seeded content, or notifications.

## 3. V1 Scope
V1 includes end-to-end workflows:
- Onboarding and app configuration.
- Exercise template creation.
- Workout creation and editing using shape cards.
- Active workout execution with set progression.
- Dashboard with tappable stat cards and chart drill-down.

## 4. Out Of Scope (V1)
- Cloud sync, backend APIs, account systems, sharing, social features.
- Wearable integrations.
- AI recommendations/programming automation.
- Multi-user profiles.

## 5. Primary User Journeys

### 5.1 Onboarding
The user is guided through configuration screens:
1. Track bodyweight: enabled/disabled.
2. Bodyweight units: `lb` or `kg`.
3. Weigh-in reminder cadence: `daily`, `weekly`, `monthly`, or `off`.
4. Workout tracking preferences: which metric families the user wants visible by default.
5. Optional cues for timer completion: sound, visual cue, haptic cue.

Outputs:
- Saved profile preferences.
- Dashboard layout defaults.
- Reminder schedule configuration.

### 5.2 Dashboard (Landing)
The landing page displays a vertical series of stat cards/charts:
- Bodyweight chart with trend arrow (`up`, `down`, `flat`).
- Workout frequency trend.
- Volume trend.
- Duration trend.
- Multi-series graphs use theme-specific chart line palettes for clear contrast.

Each card is tappable and opens detail views with:
- Expanded chart range and interval controls.
- Summary metrics for selected date range.
- Session-level drill-down list.

### 5.3 Exercise Template Creation
Exercise creation flow:
1. Enter exercise name.
2. Select one or more tracked metrics (at least one required):
   - weight
   - reps
   - time
   - Left/Right Tracking
3. Save as reusable exercise template.

Validation:
- Name required.
- At least one metric required.
- No duplicate template names after normalization (trim + case-insensitive compare).

### 5.4 Workout Construction
Workout creation supports on-the-fly and full pre-build patterns:
- User names workout session.
- User taps global circle-plus to append a new shape to bottom.
- Each shape has local plus control to add set elements within that shape.
- User can drag shapes upward (upward-only in V1) to reorder/augment only fully unstarted shapes.
- A workout can start as long as at least one exercise-containing shape exists.
- User can continue appending as workout progresses, subject to mutation guards.

### 5.5 Active Workout
During execution:
- Exactly one set is active at any time.
- Active set is visually elevated and highlighted.
- Active set has tracked input fields.
- `Complete` marks current set complete and transitions based on timer settings.
- If global rest is enabled, completion transitions to rest and next set auto-starts when rest ends.
- If no next set exists, rest does not start and final CTA is presented immediately.
- Completed items are dimmed.
- Future items remain in normal visual state.
- When final actionable set is complete, primary CTA changes to `Workout Complete`.
- On `Workout Complete`:
  - Session timer ends.
  - Further shape/set additions are blocked.
  - Derived stats are committed.
  - Completion message and return-to-dashboard action are shown.

## 6. Information Architecture
- `Home` (dashboard cards and trends)
- `Exercise Library` (template list/create/edit)
- `Workout Builder` (shape graph editor)
- `Active Workout` (runtime progression view)
- `Settings` (units, reminders, cues, defaults)

Settings also includes:
- Theme selection with four options (`slate_lime`, `charcoal_blue`, `graphite_teal`, `crimson_silver`).
- Default selected theme is `graphite_teal`.

## 7. Feature Rules (Cross-Cutting)
- New shapes append at bottom by default.
- Drag-based augmentation is allowed only when target shape has all sets in `set_ready`.
- Shapes containing `set_active` or any `set_complete` are not augmentable.
- Completed sets can have metric values edited, but cannot be re-run.
- Shape-local set additions are allowed only while shape is not fully complete.

## 8. Non-Functional Requirements
- Offline-first startup and operation.
- Fast interaction response under normal device load.
- Deterministic state transitions and replay-safe session logs.
- Accessibility baseline: readable typography scale, minimum hit area, reduced-motion support.

## 9. Success Criteria For V1
- User can configure onboarding preferences and reminders.
- User can define reusable exercises with valid metric requirements.
- User can create and run workouts using shape-based composition.
- User can complete a full session with rest automation and progress visuals.
- Dashboard reflects newly completed workout statistics accurately.

## 10. Design Token Reference
- Token schema and chart palette behavior are defined in `docs/specs/design-tokens.md`.
