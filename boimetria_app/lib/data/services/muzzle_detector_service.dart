import 'dart:typed_data';

import 'package:boimetria/domain/models/detection/muzzle_detection.dart';
import 'package:boimetria/utils/result.dart';

abstract interface class MuzzleDetectorService {
  Future<Result<MuzzleDetection>> detect(Uint8List imageBytes);
}
