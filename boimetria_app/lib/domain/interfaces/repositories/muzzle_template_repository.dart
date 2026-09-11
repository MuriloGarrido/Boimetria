import 'package:boimetria/domain/entities/muzzle_template.dart';
import 'package:boimetria/domain/shared/result.dart';
import 'package:boimetria/domain/value_objects/muzzle_embedding.dart';
import 'package:boimetria/domain/value_objects/muzzle_match.dart';
import 'package:boimetria/domain/value_objects/muzzle_template_draft.dart';

abstract interface class MuzzleTemplateRepository {
  Future<Result<MuzzleTemplate>> enroll(MuzzleTemplateDraft draft);

  Future<Result<void>> remove(int id);

  Future<Result<MuzzleTemplate?>> currentFor(int bovineId);

  Future<Result<List<MuzzleMatch>>> nearest(
    MuzzleEmbedding probe, {
    required int k,
  });
}
