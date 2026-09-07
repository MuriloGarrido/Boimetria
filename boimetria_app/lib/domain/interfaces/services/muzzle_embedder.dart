import 'dart:typed_data';

import 'package:boimetria/domain/shared/result.dart';
import 'package:boimetria/domain/value_objects/muzzle_embedding.dart';

abstract interface class MuzzleEmbedderService {
  Future<Result<MuzzleEmbedding>> embed(Uint8List muzzleImage);
}
