import 'package:boimetria/data/database/app_database.dart';
import 'package:boimetria/domain/entities/bovine.dart';
import 'package:boimetria/domain/interfaces/repositories/bovine_repository.dart';
import 'package:boimetria/domain/value_objects/bovine_draft.dart';
import 'package:boimetria/domain/value_objects/weight.dart';
import 'package:drift/drift.dart';

class LocalBovineRepository implements BovineRepository {
  LocalBovineRepository(this._database);

  final AppDatabase _database;

  @override
  Future<Bovine> enroll(BovineDraft draft) async {
    final id = await _database
        .into(_database.bovines)
        .insert(
          BovinesCompanion.insert(
            tag: draft.tag,
            sex: draft.sex,
            entryDate: draft.entryDate,
            birthDate: Value(draft.birthDate),
            weightKg: Value(draft.weight?.kg),
          ),
        );

    return Bovine(
      id: id,
      tag: draft.tag,
      sex: draft.sex,
      entryDate: draft.entryDate,
      birthDate: draft.birthDate,
      weight: draft.weight,
    );
  }

  @override
  Future<List<Bovine>> all() async {
    final rows = await _database.select(_database.bovines).get();
    return rows.map(_toDomain).toList();
  }

  @override
  Future<Bovine?> byId(int id) => _first((row) => row.id.equals(id));

  @override
  Future<Bovine?> byTag(String tag) => _first((row) => row.tag.equals(tag));

  Future<Bovine?> _first(Expression<bool> Function($BovinesTable) where) async {
    final query = _database.select(_database.bovines)..where(where);
    final row = await query.getSingleOrNull();

    return row == null ? null : _toDomain(row);
  }

  Bovine _toDomain(BovineRow row) => Bovine(
    id: row.id,
    tag: row.tag,
    sex: row.sex,
    entryDate: row.entryDate,
    birthDate: row.birthDate,
    weight: row.weightKg == null ? null : Weight(row.weightKg!),
  );
}
