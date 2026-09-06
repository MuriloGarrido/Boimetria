import 'package:boimetria/domain/value_objects/percentage.dart';

abstract class DetectionPolicy {
  static const minimumScore = Percentage(0.5);
}
