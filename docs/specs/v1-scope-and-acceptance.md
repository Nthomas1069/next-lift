# Next Lift V1 Scope and Acceptance

## 1. V1 Scope Definition
V1 is complete when a user can:
- Configure onboarding preferences and reminder cadence.
- Create exercises with one or more required tracked metrics.
- Build workouts using shape-based composition.
- Run active workouts with deterministic set progression and optional global rest.
- Complete workouts and see updated dashboard statistics.

## 2. Functional Acceptance Criteria

### 2.1 Onboarding
- User can enable or disable bodyweight tracking.
- User can choose weight unit (`lb` or `kg`).
- User can configure reminder cadence (`off`, `daily`, `weekly`, `monthly`).
- User preferences persist across app restarts.

### 2.2 Exercise Template Management
- User can create exercise with unique name.
- App prevents save when no metric is selected.
- User can include Left/Right Tracking metrics.
- Edited templates update future set creation behavior.

### 2.3 Workout Builder
- User can create named workout session.
- Global plus appends new shape at bottom.
- Shape-local plus adds set elements inside shape when allowed.
- User can drag shapes upward and reorder/augment only unstarted target shapes.
- Invalid augment/reorder attempts are rejected with clear feedback and no state corruption.

### 2.4 Active Workout Runtime
- Set transitions follow `set_ready -> set_active -> set_complete`.
- Exactly one active set exists during running phase.
- `Complete` marks active set complete.
- If global rest enabled and next set exists, rest starts and next set auto-activates on rest end.
- If no next set exists, app goes directly to `Workout Complete` CTA without starting rest.
- Completed sets remain editable for values but cannot be re-run.
- Final progression exposes `Workout Complete` action.

### 2.5 Completion and Stats
- `Workout Complete` stops session timer and blocks further structural edits.
- Completion commits derived stats.
- Dashboard reflects new session results on return.
- Editing completed-set values triggers immediate visible stat recalculation and persisted update.
- Multi-series chart lines remain distinguishable in all four supported themes.

### 2.6 Theme Settings
- User can choose one of four app themes (`slate_lime`, `charcoal_blue`, `graphite_teal`, `crimson_silver`).
- Theme change applies globally without restart.
- Selected theme persists across app restarts.

## 3. Non-Functional Acceptance Criteria
- App works fully offline.
- Startup and core interactions are responsive on modern phones.
- Motion and state feedback are consistent with motion spec.
- Reduced-motion mode preserves full task completion.
- No emoji appears in any app-provided copy or labels.

## 4. Test Matrix

### 4.1 Core Workflow Tests
- Onboard fresh user, create exercise templates, build mixed-shape workout, complete session, verify dashboard update.
- Start workout with minimum valid shape (single exercise shape), complete successfully.
- Add new shape during active session, verify append-only behavior and guard compliance.

### 4.2 Guard and Edge Tests
- Attempt augment on started shape and verify rejection.
- Attempt add-set on fully completed shape and verify disabled control.
- Edit completed set values and verify recalculated stats.
- Kill and relaunch app mid-session; verify session restoration integrity.

### 4.3 Timer Tests
- Global rest enabled: verify completion triggers rest and automatic next activation.
- Skip rest path: verify deterministic next activation.
- Plus-time path (`+15s`): verify deterministic extension behavior.
- Verify cues respect sound/haptic/visual settings.

## 5. Definition of Done (V1)
- All functional acceptance criteria pass.
- No unresolved P1/P2 defects in onboarding, builder, runtime, or stats.
- Runtime transition logs are deterministic under repeated replay.
- Documentation is synchronized across:
  - `product-spec.md`
  - `workout-grammar.md`
  - `runtime-state-machine.md`
  - `data-model.md`
  - `motion-system.md`
  - `v1-scope-and-acceptance.md`

## 6. Freeze Checklist
- Scope freeze approved (no new V1 features).
- Data model freeze approved (migration notes captured).
- Runtime event list freeze approved.
- Motion token and state visual mapping freeze approved.
- Dashboard KPI formula freeze approved.
- QA matrix baselined for implementation cycle.

## 7. Post-V1 Candidate Backlog
- Template workout library UX expansion.
- Export/import for personal backup.
- Advanced chart analytics and comparison overlays.
- Optional integrations (wearables, health platforms).
