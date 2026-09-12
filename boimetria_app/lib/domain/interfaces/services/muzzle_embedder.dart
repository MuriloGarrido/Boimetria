import 'dart:typed_data';

import 'package:boimetria/domain/value_objects/muzzle_embedding.dart';

abstract interface class MuzzleEmbedderService {
  Future<MuzzleEmbedding> embed(Uint8List muzzleImage);
}
