import 'package:boimetria/domain/entities/bovine.dart';
import 'package:boimetria/domain/value_objects/distance.dart';
import 'package:boimetria/domain/value_objects/muzzle_detection.dart';

sealed class IdentifyState {
  const IdentifyState();
}

final class IdentifyRunning extends IdentifyState {
  const IdentifyRunning();
}

final class IdentifyNoMuzzle extends IdentifyState {
  const IdentifyNoMuzzle();
}

final class IdentifyMatched extends IdentifyState {
  const IdentifyMatched(this.detection, this.bovine, this.distance);

  final MuzzleDetection detection;
  final Bovine bovine;
  final Distance distance;
}

final class IdentifyUnknown extends IdentifyState {
  const IdentifyUnknown(this.detection, this.nearest);

  final MuzzleDetection detection;
  final Distance? nearest;
}

final class IdentifyFailed extends IdentifyState {
  const IdentifyFailed(this.reason);

  final String reason;
}
