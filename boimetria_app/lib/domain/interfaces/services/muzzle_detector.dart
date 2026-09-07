import 'dart:typed_data';

import 'package:boimetria/domain/entities/muzzle_detection.dart';
import 'package:boimetria/domain/shared/result.dart';

abstract interface class MuzzleDetectorService {
  Future<Result<MuzzleDetection?>> detect(Uint8List imageBytes);
}
