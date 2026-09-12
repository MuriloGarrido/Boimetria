import 'dart:typed_data';

import 'package:boimetria/domain/value_objects/muzzle_detection.dart';

abstract interface class MuzzleDetectorService {
  Future<MuzzleDetection?> detect(Uint8List imageBytes);
}
