import 'package:boimetria/data/database/app_database.dart';
import 'package:boimetria/domain/entities/muzzle_template.dart';
import 'package:boimetria/domain/interfaces/repositories/muzzle_template_repository.dart';
import 'package:boimetria/domain/value_objects/distance.dart';
import 'package:boimetria/domain/value_objects/muzzle_embedding.dart';
import 'package:boimetria/domain/value_objects/muzzle_match.dart';
import 'package:boimetria/domain/value_objects/muzzle_template_draft.dart';
import 'package:drift/drift.dart';

class LocalMuzzleTemplateRepository implements MuzzleTemplateRepository {
  LocalMuzzleTemplateRepository(this._database, this._modelVersion);

  final AppDatabase _database;
  final String _modelVersion;

  @override
  Future<MuzzleTemplate> enroll(MuzzleTemplateDraft draft) async {
    final id = await _database.customInsert(
      'INSERT INTO muzzle_templates'
      '(embedding, bovine_id, model_version, captured_at, crop_path) '
      'VALUES (?, ?, ?, ?, ?)',
      variables: [
        Variable<Uint8List>(draft.embedding.toBytes()),
        Variable<int>(draft.bovineId),
        Variable<String>(draft.embedding.modelVersion),
        Variable<int>(draft.capturedAt.millisecondsSinceEpoch),
        Variable<String>(draft.cropPath),
      ],
    );

    return MuzzleTemplate(
      id: id,
      bovineId: draft.bovineId,
      modelVersion: draft.embedding.modelVersion,
      capturedAt: draft.capturedAt,
      cropPath: draft.cropPath,
    );
  }

  @override
  Future<void> remove(int id) => _database.customStatement(
    'DELETE FROM muzzle_templates WHERE id = ?',
    [id],
  );

  @override
  Future<MuzzleTemplate?> currentFor(int bovineId) async {
    final rows = await _database
        .customSelect(
          'SELECT id, bovine_id, model_version, captured_at, crop_path '
          'FROM muzzle_templates '
          'WHERE bovine_id = ? AND model_version = ? '
          'ORDER BY captured_at DESC, id DESC '
          'LIMIT 1',
          variables: [
            Variable<int>(bovineId),
            Variable<String>(_modelVersion),
          ],
        )
        .get();

    return rows.isEmpty ? null : _toDomain(rows.first);
  }

  @override
  Future<List<MuzzleMatch>> nearest(
    MuzzleEmbedding probe, {
    required int k,
  }) async {
    final rows = await _database
        .customSelect(
          'SELECT id, bovine_id, model_version, captured_at, crop_path, '
          'distance FROM muzzle_templates '
          'WHERE embedding MATCH ? AND k = ? AND model_version = ? '
          'ORDER BY distance',
          variables: [
            Variable<Uint8List>(probe.toBytes()),
            Variable<int>(k),
            Variable<String>(probe.modelVersion),
          ],
        )
        .get();

    return [
      for (final row in rows)
        MuzzleMatch(
          template: _toDomain(row),
          distance: Distance(row.read<double>('distance')),
        ),
    ];
  }

  MuzzleTemplate _toDomain(QueryRow row) => MuzzleTemplate(
    id: row.read<int>('id'),
    bovineId: row.read<int>('bovine_id'),
    modelVersion: row.read<String>('model_version'),
    capturedAt: DateTime.fromMillisecondsSinceEpoch(
      row.read<int>('captured_at'),
    ),
    cropPath: row.readNullable<String>('crop_path'),
  );
}
