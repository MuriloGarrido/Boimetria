import 'dart:io';
import 'dart:typed_data';

import 'package:boimetria/data/database/app_database.dart';
import 'package:boimetria/data/repositories/local_muzzle_template_repository.dart';
import 'package:boimetria/domain/value_objects/muzzle_embedding.dart';
import 'package:boimetria/domain/value_objects/muzzle_template_draft.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

final _vecLibrary = Platform.environment['SQLITE_VEC_PATH'];

const _model = 'cattlemuzzlenet-2026-08-07';

MuzzleEmbedding _embedding(int hot, {double bleed = 0.0}) {
  final values = Float32List(muzzleEmbeddingDimensions);
  values[hot] = 1.0;
  if (bleed > 0) values[(hot + 1) % muzzleEmbeddingDimensions] = bleed;
  return MuzzleEmbedding(values, _model);
}

MuzzleTemplateDraft _draft(
  int bovineId,
  MuzzleEmbedding embedding,
  DateTime capturedAt, {
  String? cropPath,
}) => MuzzleTemplateDraft(
  bovineId: bovineId,
  embedding: embedding,
  capturedAt: capturedAt,
  cropPath: cropPath,
);

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
    final first = await repository.enroll(
      _draft(1, _embedding(0), DateTime(2026, 1, 1)),
    );
    final second = await repository.enroll(
      _draft(1, _embedding(1), DateTime(2026, 1, 2)),
    );

    expect(first.id, isPositive);
    expect(second.id, greaterThan(first.id));
  });

  test('nearest ranks by distance', () async {
    await repository.enroll(_draft(1, _embedding(0), DateTime(2026, 1, 1)));
    await repository.enroll(
      _draft(2, _embedding(0, bleed: 0.5), DateTime(2026, 1, 1)),
    );
    await repository.enroll(_draft(3, _embedding(300), DateTime(2026, 1, 1)));

    final matches = await repository.nearest(_embedding(0), k: 3);

    expect(matches.map((m) => m.template.bovineId), [1, 2, 3]);
    expect(matches.first.distance.value, closeTo(0.0, 1e-5));
    expect(matches[0].distance < matches[1].distance, isTrue);
    expect(matches[1].distance < matches[2].distance, isTrue);
  });

  test('nearest filters by model version', () async {
    await repository.enroll(
      _draft(
        1,
        MuzzleEmbedding(_embedding(0).values, 'old-model'),
        DateTime(2026, 1, 1),
      ),
    );
    await repository.enroll(_draft(2, _embedding(5), DateTime(2026, 1, 1)));

    final matches = await repository.nearest(_embedding(0), k: 10);

    expect(matches.map((m) => m.template.bovineId), [2]);
  });

  test('currentFor returns the latest matching template', () async {
    await repository.enroll(
      _draft(7, _embedding(1), DateTime(2026, 1, 1), cropPath: 'old.jpg'),
    );
    await repository.enroll(
      _draft(7, _embedding(2), DateTime(2026, 6, 1), cropPath: 'new.jpg'),
    );

    final current = await repository.currentFor(7);

    expect(current, isNotNull);
    expect(current!.cropPath, 'new.jpg');
    expect(current.capturedAt, DateTime(2026, 6, 1));
    expect(current.bovineId, 7);
  });

  test('currentFor returns null for an unknown bovine', () async {
    expect(await repository.currentFor(999), isNull);
  });

  test('remove deletes the template', () async {
    final template = await repository.enroll(
      _draft(4, _embedding(7), DateTime(2026, 1, 1)),
    );

    await repository.remove(template.id);

    expect(await repository.currentFor(4), isNull);
  });
}
