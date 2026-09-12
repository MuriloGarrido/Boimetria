import 'dart:io';
import 'dart:typed_data';

import 'package:boimetria/data/database/app_database.dart';
import 'package:boimetria/data/database/drift_unit_of_work.dart';
import 'package:boimetria/data/repositories/local_bovine_repository.dart';
import 'package:boimetria/data/repositories/local_muzzle_template_repository.dart';
import 'package:boimetria/domain/entities/bovine.dart';
import 'package:boimetria/domain/value_objects/bovine_draft.dart';
import 'package:boimetria/domain/value_objects/muzzle_embedding.dart';
import 'package:boimetria/domain/value_objects/muzzle_template_draft.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

final _vecLibrary = Platform.environment['SQLITE_VEC_PATH'];

const _model = 'cattlemuzzlenet-2026-08-07';

class _Boom implements Exception {
  const _Boom();
}

void main() {
  if (_vecLibrary == null) {
    test('unit of work suite', () {}, skip: 'set SQLITE_VEC_PATH');
    return;
  }

  late AppDatabase db;
  late DriftUnitOfWork unitOfWork;
  late LocalBovineRepository bovines;
  late LocalMuzzleTemplateRepository templates;

  setUpAll(() => loadVecExtension(_vecLibrary));

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    unitOfWork = DriftUnitOfWork(db);
    bovines = LocalBovineRepository(db);
    templates = LocalMuzzleTemplateRepository(db, _model);
  });

  tearDown(() => db.close());

  MuzzleEmbedding embedding() {
    final values = Float32List(muzzleEmbeddingDimensions);
    values[0] = 1.0;
    return MuzzleEmbedding(values, _model);
  }

  BovineDraft draft(String tag) => BovineDraft(
    tag: tag,
    sex: Sex.female,
    entryDate: DateTime(2026, 1, 1),
  );

  Future<int> templateCount() async {
    final rows = await db
        .customSelect('SELECT count(*) AS n FROM muzzle_templates')
        .getSingle();
    return rows.read<int>('n');
  }

  test('commits both tables when the action succeeds', () async {
    final bovine = await unitOfWork.run(() async {
      final enrolled = await bovines.enroll(draft('A1'));
      await templates.enroll(
        MuzzleTemplateDraft(
          bovineId: enrolled.id,
          embedding: embedding(),
          capturedAt: DateTime(2026, 1, 1),
        ),
      );
      return enrolled;
    });

    expect(await bovines.byTag('A1'), isNotNull);
    expect(await templates.currentFor(bovine.id), isNotNull);
    expect(await templateCount(), 1);
  });

  test('rolls back both tables when the action throws', () async {
    await expectLater(
      unitOfWork.run(() async {
        final enrolled = await bovines.enroll(draft('A2'));
        await templates.enroll(
          MuzzleTemplateDraft(
            bovineId: enrolled.id,
            embedding: embedding(),
            capturedAt: DateTime(2026, 1, 1),
          ),
        );
        throw const _Boom();
      }),
      throwsA(isA<_Boom>()),
    );

    expect(await bovines.byTag('A2'), isNull);
    expect(await templateCount(), 0);
  });

  test('a duplicate tag rolls the template back too', () async {
    await bovines.enroll(draft('DUP'));

    await expectLater(
      unitOfWork.run(() async {
        await templates.enroll(
          MuzzleTemplateDraft(
            bovineId: 999,
            embedding: embedding(),
            capturedAt: DateTime(2026, 1, 1),
          ),
        );
        await bovines.enroll(draft('DUP'));
      }),
      throwsA(isA<Exception>()),
    );

    expect(await templateCount(), 0);
    expect((await bovines.all()).length, 1);
  });
}
