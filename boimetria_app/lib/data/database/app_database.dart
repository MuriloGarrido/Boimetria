import 'dart:ffi';

import 'package:boimetria/domain/entities/bovine.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:sqlite3/sqlite3.dart';

part 'app_database.g.dart';

const muzzleEmbeddingDimensions = 640;

const _createMuzzleTemplates =
    'CREATE VIRTUAL TABLE IF NOT EXISTS muzzle_templates USING vec0('
    'id INTEGER PRIMARY KEY, '
    'embedding float[$muzzleEmbeddingDimensions], '
    'bovine_id INTEGER, '
    'model_version TEXT, '
    'captured_at INTEGER, '
    '+crop_path TEXT)';

void loadVecExtension([String? libraryPath]) {
  sqlite3.ensureExtensionLoaded(
    SqliteExtension.inLibrary(
      DynamicLibrary.open(libraryPath ?? 'libvec0.so'),
      'sqlite3_vec_init',
    ),
  );
}

@DataClassName('BovineRow')
class Bovines extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tag => text().unique()();
  TextColumn get sex => textEnum<Sex>()();
  DateTimeColumn get entryDate => dateTime()();
  DateTimeColumn get birthDate => dateTime().nullable()();
  RealColumn get weightKg => real().nullable()();
}

@DriftDatabase(tables: [Bovines])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(
        executor ??
            driftDatabase(
              name: 'boimetria',
              native: const DriftNativeOptions(isolateSetup: loadVecExtension),
            ),
      );

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
      await customStatement(_createMuzzleTemplates);
    },
    onUpgrade: (migrator, from, to) async {
      if (from < 3) {
        await migrator.drop(bovines);
        await migrator.createTable(bovines);
      }
      await customStatement(_createMuzzleTemplates);
    },
  );
}
