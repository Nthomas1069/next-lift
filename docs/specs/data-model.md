# Next Lift Data Model Specification

## 1. Purpose
Define durable local entities for onboarding preferences, exercise/workout composition, active sessions, and derived statistics.

This document is governed by final V1 decision overrides in `docs/specs/decision-lock-v1.md`.

## 2. Storage Strategy
- Local persistence only.
- Database: Isar.
- Record all timestamps in UTC with local timezone offset metadata.
- Use immutable event records for session progression and mutable summary tables for read performance.

## 3. Entity Catalog

### 3.1 UserSettings
- `id` (singleton key)
- `weightTrackingEnabled` (bool)
- `weightUnit` (`lb|kg`)
- `weighInReminderCadence` (`off|daily|weekly|monthly`)
- `defaultMetricVisibility` (set of metric keys)
- `themeId` (`slate_lime|charcoal_blue|graphite_teal|crimson_silver`)
- `themeId` default: `graphite_teal`
- `cueSoundEnabled` (bool)
- `cueVisualEnabled` (bool)
- `cueHapticEnabled` (bool)
- `updatedAtUtc`

### 3.2 BodyweightEntry
- `id`
- `value`
- `unit` (`lb|kg`)
- `recordedAtUtc`
- `source` (`manual|onboarding`)
- `note` (optional)

### 3.3 ExerciseTemplate
- `id`
- `name`
- `normalizedName` (for uniqueness)
- `metricConfig` (array of enabled metric definitions, min length 1)
- `defaultSetConfig` (optional defaults by metric)
- `createdAtUtc`
- `updatedAtUtc`

### 3.4 MetricDefinition
- `metricKey`:
  - `weight`
  - `reps`
  - `time`
  - `left_weight`
  - `right_weight`
  - `left_reps`
  - `right_reps`
  - `left_time`
  - `right_time`
- `isRequired` (bool)
- `displayOrder` (int)
- `unitPreference` (optional)

### 3.5 WorkoutTemplate (Optional V1.1)
For V1, workouts are primarily ad-hoc sessions. This entity can remain optional or hidden.
- `id`
- `name`
- `rootFlowNodeIds`
- `createdAtUtc`
- `updatedAtUtc`

### 3.6 WorkoutSession
- `id`
- `name`
- `startedAtUtc`
- `endedAtUtc` (nullable until complete)
- `status` (`idle|running|resting|complete|abandoned`)
- `globalRestEnabled` (bool)
- `globalRestDurationSec` (int, optional)
- `flowVersion` (int)
- `statsDirty` (bool)

### 3.7 FlowNode
- `id`
- `sessionId`
- `parentNodeId` (nullable for top-level)
- `nodeType` (`shape|composite|set`)
- `shapeType` (nullable unless nodeType is shape)
- `orderIndex`
- `state` (`set_ready|set_active|set_complete`) for set nodes
- `isLocked` (bool, derived cache)
- `createdAtUtc`
- `updatedAtUtc`

### 3.8 SetRecord
- `id`
- `sessionId`
- `flowNodeId` (points to set node)
- `exerciseTemplateId`
- `startedAtUtc` (nullable)
- `completedAtUtc` (nullable)
- `values` (map keyed by metricKey)
- `isCompleted` (bool)
- `completionOrdinal` (int, immutable once assigned)

### 3.9 SessionEvent
- `id`
- `sessionId`
- `eventType`
- `payloadJson`
- `occurredAtUtc`
- `sequenceNumber` (monotonic per session)

### 3.10 RestInterval
- `id`
- `sessionId`
- `startedAtUtc`
- `endedAtUtc` (nullable)
- `plannedDurationSec`
- `actualDurationSec` (nullable until end)
- `sourceSetRecordId`
- `status` (`running|skipped|completed`)

### 3.11 DerivedStatSnapshot
- `id`
- `sessionId`
- `computedAtUtc`
- `totalVolume`
- `totalReps`
- `totalDurationSec`
- `completedSetCount`
- `exerciseCount`

### 3.12 DashboardRollup
Materialized rollups for fast chart reads.
- `id`
- `periodType` (`day|week|month`)
- `periodStartUtc`
- `periodEndUtc`
- `workoutCount`
- `volumeTotal`
- `durationTotalSec`
- `bodyweightAvg`

## 4. Relationship Summary
- `WorkoutSession` has many `FlowNode`.
- `FlowNode(set)` has one `SetRecord`.
- `WorkoutSession` has many `SessionEvent`.
- `WorkoutSession` has many `RestInterval`.
- `WorkoutSession` has many `DerivedStatSnapshot` (latest used by default).
- `ExerciseTemplate` referenced by many `SetRecord`.

## 5. Validation Rules
- Exercise template must have >=1 metric definition.
- SetRecord values must satisfy template metric requirements.
- Only one `set_active` set node per session at any time.
- `completionOrdinal` is append-only and never reused.
- Completed set can edit values but cannot clear completion state.

## 6. Derived Statistics Formulas
- `setVolume = weight * reps` where both values exist.
- For Left/Right tracking:
  - `setVolume = (left_weight * left_reps) + (right_weight * right_reps)` when present.
- `sessionVolume = sum(setVolume for completed sets)`
- `sessionDurationSec = endedAtUtc - startedAtUtc`
- `workoutFrequency(period) = count(completed sessions in period)`
- `bodyweightTrendArrow`:
  - `up` if slope > positive threshold
  - `down` if slope < negative threshold
  - `flat` otherwise

Trend thresholds are fixed constants in V1 as locked in `docs/specs/decision-lock-v1.md`.

## 7. Performance and Indexing
Recommended indices:
- `ExerciseTemplate.normalizedName` unique.
- `SetRecord.sessionId + completionOrdinal`.
- `FlowNode.sessionId + parentNodeId + orderIndex`.
- `SessionEvent.sessionId + sequenceNumber`.
- `DashboardRollup.periodType + periodStartUtc`.

## 8. Migration Strategy
- Include schema version in Isar.
- Use additive migrations for new metrics and node properties.
- Recompute `DashboardRollup` and `DerivedStatSnapshot` after breaking formula changes.

## 9. Data Retention
- All local data retained until explicit user deletion.
- Provide future export/import path (CSV/JSON) as post-V1 enhancement.
