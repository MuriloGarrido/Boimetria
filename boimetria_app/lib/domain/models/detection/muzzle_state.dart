import 'package:boimetria/domain/models/detection/muzzle_detection.dart';

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

  final MuzzleDetected detection;
}

final class MuzzleLowConfidence extends MuzzleState {
  const MuzzleLowConfidence(this.detection);

  final MuzzleDetected detection;
}

final class MuzzleFailed extends MuzzleState {
  const MuzzleFailed(this.reason);

  final String reason;
}
