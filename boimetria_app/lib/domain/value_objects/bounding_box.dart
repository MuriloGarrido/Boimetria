import 'package:boimetria/domain/value_objects/percentage.dart';

class BoundingBox {
  const BoundingBox({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.confidence,
  });

  final double x;
  final double y;
  final double width;
  final double height;

  final Percentage confidence;
}
