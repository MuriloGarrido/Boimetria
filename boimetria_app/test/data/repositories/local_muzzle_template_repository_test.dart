import 'dart:io';
import 'dart:typed_data';

import 'package:boimetria/data/database/app_database.dart';
import 'package:boimetria/data/repositories/local_muzzle_template_repository.dart';
import 'package:boimetria/domain/shared/result.dart';
import 'package:boimetria/domain/value_objects/muzzle_embedding.dart';
import 'package:boimetria/domain/value_objects/muzzle_template_draft.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

final _vecLibrary = Platform.environment['SQLITE_VEC_PATH'];

const _model = 'cattlemuzzlenet-2026-08-07';

T _unwrap<T>(Result<T> result) => switch (result) {
  Ok<T>(:final value) => value,
  Error<T>(:final error) => throw error,
};

MuzzleEmbedding _embedding(int hot, {double bleed = 0.0}) {
  final values = Float32List(muzzleEmbeddingDimensions);
  values[hot] = 1.0;
  if (bleed > 0) values[(hot + 1) % muzzleEmbeddingDimensions] = bleed;
  return MuzzleEmbedding(values, _model);
}

void main() {
  if (_vecLibrary == null) {
    test(
      'sqlite-vec suite',
      () {},
      skip: 'set SQLITE_VEC_PATH to the vec0 library',
    );
    return;
  }

  late AppDatabase db;
  late LocalMuzzleTemplateRepository repository;

  setUpAll(() => loadVecExtension(_vecLibrary));

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = LocalMuzzleTemplateRepository(db, _model);
  });

  tearDown(() => db.close());

  test('the migration creates the vec0 table', () async {
    final version = await db
        .customSelect('SELECT vec_version() AS v')
        .getSingle();
    expect(version.read<String>('v'), isNotEmpty);

    final table = await db
        .customSelect(
          "SELECT name FROM sqlite_master WHERE name = 'muzzle_templates'",
        )
        .get();
    expect(table, hasLength(1));
  });

  test('enroll assigns an autoincrement id', () async {
    final first = _unwrap(
      await repository.enroll(
        MuzzleTemplateDraft(
          bovineId: 1,
          embedding: _embedding(0),
          capturedAt: DateTime(2026, 1, 1),
        ),
      ),
    );
    final second = _unwrap(
      await repository.enroll(
        MuzzleTemplateDraft(
          bovineId: 1,
          embedding: _embedding(1),
          capturedAt: DateTime(2026, 1, 2),
        ),
      ),
    );

    expect(first.id, isPositive);
    expect(second.id, greaterThan(first.id));
  });

  test('nearest ranks by distance', () async {
    for (final (bovineId, hot, bleed) in [(1, 0, 0.0), (2, 0, 0.5), (3, 300, 0.0)]) {
      await repository.enroll(
        MuzzleTemplateDraft(
          bovineId: bovineId,
          embedding: _embedding(hot, bleed: bleed),
          capturedAt: DateTime(2026, 1, 1),
        ),
      );
    }

    final matches = _unwrap(await repository.nearest(_embedding(0), k: 3));

    expect(matches.map((m) => m.template.bovineId), [1, 2, 3]);
    expect(matches.first.distance.value, closeTo(0.0, 1e-5));
    expect(matches[0].distance < matches[1].distance, isTrue);
    expect(matches[1].distance < matches[2].distance, isTrue);
  });

  test('nearest filters by model version', () async {
    await repository.enroll(
      MuzzleTemplateDraft(
        bovineId: 1,
        embedding: MuzzleEmbedding(_embedding(0).values, 'old-model'),
        capturedAt: DateTime(2026, 1, 1),
      ),
    );
    await repository.enroll(
      MuzzleTemplateDraft(
        bovineId: 2,
        embedding: _embedding(5),
        capturedAt: DateTime(2026, 1, 1),
      ),
    );

    final matches = _unwrap(await repository.nearest(_embedding(0), k: 10));

    expect(matches.map((m) => m.template.bovineId), [2]);
  });

  test('currentFor returns the latest matching template', () async {
    await repository.enroll(
      MuzzleTemplateDraft(
        bovineId: 7,
        embedding: _embedding(1),
        capturedAt: DateTime(2026, 1, 1),
        cropPath: 'old.jpg',
      ),
    );
    await repository.enroll(
      MuzzleTemplateDraft(
        bovineId: 7,
        embedding: _embedding(2),
        capturedAt: DateTime(2026, 6, 1),
        cropPath: 'new.jpg',
      ),
    );

    final current = _unwrap(await repository.currentFor(7));

    expect(current, isNotNull);
    expect(current!.cropPath, 'new.jpg');
    expect(current.capturedAt, DateTime(2026, 6, 1));
    expect(current.bovineId, 7);
  });

  test('currentFor returns null for an unknown bovine', () async {
    expect(_unwrap(await repository.currentFor(999)), isNull);
  });

  test('remove deletes the template', () async {
    final template = _unwrap(
      await repository.enroll(
        MuzzleTemplateDraft(
          bovineId: 4,
          embedding: _embedding(7),
          capturedAt: DateTime(2026, 1, 1),
        ),
      ),
    );

    _unwrap(await repository.remove(template.id));

    expect(_unwrap(await repository.currentFor(4)), isNull);
  });
}
