import "package:drift/drift.dart";
import "package:drift_flutter/drift_flutter.dart";

part "app_database.g.dart";

@DataClassName("ExerciseTemplateRow")
class ExerciseTemplates extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get normalizedName => text().unique()();
  DateTimeColumn get createdAtUtc => dateTime()();
  DateTimeColumn get updatedAtUtc => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName("ExerciseMetricConfigRow")
class ExerciseMetricConfigs extends Table {
  TextColumn get exerciseTemplateId => text().references(
        ExerciseTemplates,
        #id,
        onDelete: KeyAction.cascade,
      )();
  TextColumn get metricKey => text()();
  IntColumn get orderIndex => integer()();

  @override
  Set<Column<Object>> get primaryKey => {exerciseTemplateId, metricKey};
}

@DataClassName("WorkoutTemplateRow")
class WorkoutTemplates extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get normalizedName => text().unique()();
  DateTimeColumn get createdAtUtc => dateTime()();
  DateTimeColumn get updatedAtUtc => dateTime()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  IntColumn get layoutVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName("WorkoutShapeNodeRow")
class WorkoutShapeNodes extends Table {
  TextColumn get shapeId => text()();
  TextColumn get templateId => text().references(
        WorkoutTemplates,
        #id,
        onDelete: KeyAction.cascade,
      )();
  TextColumn get parentShapeId => text().nullable()();
  TextColumn get shapeType => text()();
  IntColumn get orderIndex => integer()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {shapeId};
}

@DataClassName("WorkoutExerciseSlotRow")
class WorkoutExerciseSlots extends Table {
  TextColumn get slotId => text()();
  TextColumn get shapeId => text().references(WorkoutShapeNodes, #shapeId)();
  TextColumn get exerciseTemplateId => text().nullable()();
  TextColumn get displayLabel => text().nullable()();
  IntColumn get orderIndex => integer()();

  @override
  Set<Column<Object>> get primaryKey => {slotId};
}

@DataClassName("WorkoutShapeExerciseRow")
class WorkoutShapeExercises extends Table {
  TextColumn get shapeExerciseId => text()();
  TextColumn get shapeId => text().references(
        WorkoutShapeNodes,
        #shapeId,
        onDelete: KeyAction.cascade,
      )();
  TextColumn get exerciseTemplateId => text().references(
        ExerciseTemplates,
        #id,
        onDelete: KeyAction.restrict,
      )();
  IntColumn get orderIndex => integer()();

  @override
  Set<Column<Object>> get primaryKey => {shapeExerciseId};
}

@DataClassName("WorkoutPlannedSetRow")
class WorkoutPlannedSets extends Table {
  TextColumn get setId => text()();
  TextColumn get shapeExerciseId => text().references(
        WorkoutShapeExercises,
        #shapeExerciseId,
        onDelete: KeyAction.cascade,
      )();
  IntColumn get orderIndex => integer()();
  TextColumn get metricDefaultsJson =>
      text().withDefault(const Constant("{}"))();

  @override
  Set<Column<Object>> get primaryKey => {setId};
}

@DriftDatabase(
  tables: [
    ExerciseTemplates,
    ExerciseMetricConfigs,
    WorkoutTemplates,
    WorkoutShapeNodes,
    WorkoutExerciseSlots,
    WorkoutShapeExercises,
    WorkoutPlannedSets,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (migrator) async {
        await migrator.createAll();
      },
      onUpgrade: (migrator, from, to) async {
        if (from < 2) {
          await migrator.createTable(exerciseTemplates);
          await migrator.createTable(exerciseMetricConfigs);
          await migrator.addColumn(
              workoutTemplates, workoutTemplates.layoutVersion);
          await migrator.addColumn(
            workoutShapeNodes,
            workoutShapeNodes.parentShapeId,
          );
          await migrator.createTable(workoutShapeExercises);
          await migrator.createTable(workoutPlannedSets);
        }
      },
      beforeOpen: (details) async {
        await customStatement("PRAGMA foreign_keys = ON");
      },
    );
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(name: "next_lift");
}
