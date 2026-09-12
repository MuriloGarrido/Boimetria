import 'package:boimetria/domain/entities/muzzle_template.dart';
import 'package:boimetria/domain/value_objects/muzzle_embedding.dart';
import 'package:boimetria/domain/value_objects/muzzle_match.dart';
import 'package:boimetria/domain/value_objects/muzzle_template_draft.dart';

abstract interface class MuzzleTemplateRepository {
  Future<MuzzleTemplate> enroll(MuzzleTemplateDraft draft);

  Future<void> remove(int id);

  Future<MuzzleTemplate?> currentFor(int bovineId);

  Future<List<MuzzleMatch>> nearest(MuzzleEmbedding probe, {required int k});
}
