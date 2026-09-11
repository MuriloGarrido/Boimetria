import 'dart:typed_data';

import 'package:boimetria/domain/value_objects/bounding_box.dart';
import 'package:boimetria/domain/value_objects/percentage.dart';

class MuzzleDetection {
  const MuzzleDetection({
    required this.boundingBox,
    required this.fullImage,
    required this.croppedImage,
  });

  final BoundingBox boundingBox;
  final Uint8List fullImage;
  final Uint8List croppedImage;

  Percentage get confidence => boundingBox.confidence;
}
