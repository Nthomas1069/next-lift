# Next Lift Workout Grammar Specification

## 1. Purpose
Define a deterministic grammar for how workouts are built, composed, augmented, and validated.

This document is governed by final V1 decision overrides in `docs/specs/decision-lock-v1.md`.

## 2. Core Concepts
- `Shape`: structural container that defines how included sets execute.
- `SetElement`: exercise-linked executable set configuration.
- `WorkoutFlow`: ordered list of top-level shapes.
- `Composite`: nested composition of primitive shapes.
- `SpatialCanvas`: navigable rendering of the deterministic flow.
- The stored flow is semantic; screen coordinates and viewport transforms are derived.
- A workout has one canonical execution path. Shape geometry may branch visually, but traversal always resolves to one next set.

## 3. Primitive Shapes
- `straight_set`
- `super_set`
- `circuit`
- `drop_set`
- `pyramid` (with `direction: up|down`)
- `intervals`

## 4. Meta Shape
- `composite`: contains one or more primitive or composite children.
- Product label: `Combination`.
- Combination children form a bounded deterministic subflow and may themselves be combinations.

## 5. Shape Minimum Validity
Each shape must satisfy:
- At least one `SetElement`.
- Every `SetElement` references a valid exercise template.
- Every referenced exercise has at least one tracked metric.

## 6. Top-Level Grammar (EBNF-Style)
```text
WorkoutFlow      = ShapeNode, { ShapeNode } ;
ShapeNode        = PrimitiveShape | CompositeShape ;
CompositeShape   = "composite", "{", ShapeNode, { ShapeNode }, "}" ;
PrimitiveShape   = StraightSet | SuperSet | Circuit | DropSet | Pyramid | Intervals ;
StraightSet      = "straight_set", "{", SetElement, { SetElement }, "}" ;
SuperSet         = "super_set", "{", SetElement, { SetElement }, "}" ;
Circuit          = "circuit", "{", SetElement, { SetElement }, "}" ;
DropSet          = "drop_set", "{", SetElement, { SetElement }, "}" ;
Pyramid          = "pyramid", "(", Direction, ")", "{", SetElement, { SetElement }, "}" ;
Intervals        = "intervals", "{", SetElement, { SetElement }, "}" ;
Direction        = "up" | "down" ;
SetElement       = ExerciseRef, SetSpec ;
```

## 7. Composition Rules

### 7.1 Series Composition
- Dropping shape above/below another top-level shape creates ordered series.
- Series operations preserve all internal shape structure.

### 7.2 Augmentation Composition
- Dropping shape onto a target shape attempts augment behavior.
- Augment is allowed only if target shape is fully unstarted (`all sets == set_ready`).
- Augment semantics depend on target shape type:
  - `straight_set`: inserted shape is expanded across set positions.
  - `super_set`: inserted shape becomes co-executed child sequence.
  - `circuit`: inserted shape becomes circuit member branch.
  - `drop_set`: inserted shape becomes per-drop nested branch.
  - `pyramid`: inserted shape maps to each pyramid rung.
  - `intervals`: inserted shape participates in each interval cycle.

If type-specific expansion is ambiguous, system must convert target into explicit `composite` representation before insertion.

### 7.3 Composite Rule
- Any legal primitive can be nested into any other via `composite`, subject to state guard rules.
- Composites must remain acyclic.

## 8. Runtime Mutation Guards

### 8.1 Append Guards
- New shapes can always be appended to bottom while session is active and not completed.
- Append creates shape with all sets in `set_ready`.

### 8.2 Reorder/Augment Guards
- Drag reorder/augment allowed only when destination target is fully `set_ready`.
- Any shape containing `set_active` or `set_complete` is locked against augmentation.
- Reorder cannot move a shape past a completed shape boundary if it would alter already executed order.
- Reorder direction in V1 is upward-only.

### 8.3 Shape-Local Add Set Guard
- Local add-set control is enabled for shapes that are not fully complete.
- Disabled once every set in the shape is `set_complete`.

## 9. Invalid Operations (Must Reject)
- Augmenting any shape that has started.
- Creating a shape with zero set elements.
- Creating exercise elements without at least one metric.
- Introducing cyclic parent-child relationships.
- Moving completed sets into future order.

## 10. Drop Resolution Priority
When a drag ends, resolution order:
1. Explicit insert-above target zone.
2. Explicit insert-below target zone.
3. Explicit augment target zone.
4. If none matched, snap back (no mutation).

## 11. Builder Feedback Contract
- Valid drop targets show pre-highlight.
- Invalid targets show blocked indicator and no state mutation.
- Successful augment shows structure morph animation confirming new relationship.
- Successful series insert shows displacement animation of neighboring shapes.

## 12. Canonical Examples

### 12.1 Legal Composite
- `super_set` containing two `circuit` children.

### 12.2 Legal Composite
- `straight_set` of `pyramid` blocks.

### 12.3 Illegal Composite
- Dragging new `circuit` onto a shape where any set is `set_complete`.

## 13. Deterministic Output Requirement
Given identical drag source, drop target, and current workout state, grammar transformation output must always be identical.

## 14. Spatial Builder Contract

### 14.1 Shape Rail
- Builder exposes a right-side rail that is collapsible to icons and expandable to icon + label.
- Rail order is fixed: `straight_set`, `super_set`, `circuit`, `drop_set`, `pyramid(up)`, `pyramid(down)`, `intervals`, `composite`.
- Shape icons use a shared dot-and-dash visual grammar and include semantic accessibility labels.

### 14.2 Palette Drop
- The first palette drop targets the canvas origin and creates a provisional shape.
- Later top-level drops append to the current chain tail.
- Drops inside a Combination append to that bounded child flow.
- A provisional shape does not become durable until its configurator is confirmed.
- Cancel or invalid configuration removes the provisional shape without mutating the flow.

### 14.3 Shape Configuration
- Exercise fields are determined by the selected exercise template's tracked metrics.
- `straight_set`, `drop_set`, `pyramid`, and `intervals` begin with one exercise-linked set; a shape-local plus appends set instances.
- `super_set` begins with two exercises. Sets render as an alternating offset weave; its plus appends a paired pass.
- `circuit` adds exercises around a ring in traversal order. Adding an exercise extends the ring.
- `composite` is configured by dropping child shapes into its bounded subsection.
- Every exercise reference is live. Renames and metric edits are reflected in workouts immediately.
- Exercise deletion is rejected while any workout references it.

### 14.4 Spatial Layout
- Layout is generated deterministically from shape type, hierarchy, and order.
- Persisted flow data must not contain device-specific canvas coordinates.
- Builder and preview use the same layout engine.
- Pan and zoom transforms are ephemeral and are not part of workout identity.

### 14.5 Shared Renderer Modes
- `builder`: palette drops, contextual additions, editing, pan, and zoom enabled.
- `preview`: read-only pan and zoom enabled.
- `execution`: structural editing guarded by runtime rules; active set is centered and focused.
- All modes preserve identical node geometry and traversal order.

### 14.6 Canonical Shape Geometry
- `straight_set`: parallel horizontal dashes with terminal dots.
- `super_set`: alternating offset rows that visually weave two exercises.
- `circuit`: exercise nodes arranged around a circular path.
- `drop_set`: right-aligned rows decreasing in length.
- `pyramid(up)`: centered rows increasing in length.
- `pyramid(down)`: centered rows decreasing in length.
- `intervals`: separated rows with a centered interval marker.
- `composite`: bounded subsection containing child shape geometry.
