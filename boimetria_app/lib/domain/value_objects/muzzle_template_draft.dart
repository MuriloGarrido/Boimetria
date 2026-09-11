import 'package:boimetria/domain/value_objects/muzzle_embedding.dart';

class MuzzleTemplateDraft {
  const MuzzleTemplateDraft({
    required this.bovineId,
    required this.embedding,
    required this.capturedAt,
    this.cropPath,
  });

  final int bovineId;
  final MuzzleEmbedding embedding;
  final DateTime capturedAt;
  final String? cropPath;
}
