import 'dart:typed_data';

import 'package:boimetria/utils/percentage.dart';

class BoundingBox {
  const BoundingBox({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  final double x;
  final double y;
  final double width;
  final double height;
}

sealed class MuzzleDetection {
  const MuzzleDetection();
}

final class MuzzleDetected extends MuzzleDetection {
  const MuzzleDetected({
    required this.boundingBox,
    required this.fullImage,
    required this.croppedImage,
    required this.confidence,
  });

  final BoundingBox boundingBox;
  final Uint8List fullImage;
  final Uint8List croppedImage;

  final Percentage confidence;
}

final class MuzzleNotDetected extends MuzzleDetection {
  const MuzzleNotDetected();
}
