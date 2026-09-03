import 'package:boimetria/utils/percentage.dart';

abstract class Thresholds {
  /// Piso: abaixo disso a leitura do focinho nao serve para identificar depois.
  static const muzzleConfidence = Percentage(0.8);
}
