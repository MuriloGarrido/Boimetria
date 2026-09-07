import 'dart:typed_data';

import 'package:boimetria/domain/entities/muzzle_detection.dart';
import 'package:boimetria/domain/value_objects/percentage.dart';

sealed class MuzzleState {
  const MuzzleState();
}

final class MuzzleMissing extends MuzzleState {
  const MuzzleMissing();
}

final class MuzzleDetecting extends MuzzleState {
  const MuzzleDetecting();
}

final class MuzzleCaptured extends MuzzleState {
  const MuzzleCaptured(this.detection);

  final MuzzleDetection detection;
}

final class MuzzleLowConfidence extends MuzzleState {
  const MuzzleLowConfidence(this.detection, this.minimum);

  final MuzzleDetection detection;
  final Percentage minimum;
}

final class MuzzleAbsent extends MuzzleState {
  const MuzzleAbsent(this.photo);

  final Uint8List photo;
}

final class MuzzleFailed extends MuzzleState {
  const MuzzleFailed(this.reason);

  final String reason;
}
