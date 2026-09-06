import 'package:boimetria/domain/value_objects/percentage.dart';

abstract class EnrollmentPolicy {
  static const minimumConfidence = Percentage(0.8);
}
