import 'dart:math' as math;
import 'dart:typed_data';

import 'package:boimetria/domain/value_objects/distance.dart';

class MuzzleEmbedding {
  MuzzleEmbedding(Float32List values, this.modelVersion)
    : values = _unit(values);

  factory MuzzleEmbedding.fromBytes(Uint8List bytes, String modelVersion) =>
      MuzzleEmbedding(
        Float32List.sublistView(Uint8List.fromList(bytes)),
        modelVersion,
      );

  final Float32List values;
  final String modelVersion;

  int get length => values.length;

  Distance distanceTo(MuzzleEmbedding other) {
    if (modelVersion != other.modelVersion) {
      throw ArgumentError.value(
        other.modelVersion,
        'other',
        'embedding from a different model than $modelVersion',
      );
    }

    var sum = 0.0;
    for (var i = 0; i < values.length; i++) {
      final difference = values[i] - other.values[i];
      sum += difference * difference;
    }

    return Distance(math.sqrt(sum));
  }

  Uint8List toBytes() =>
      Uint8List.view(values.buffer, values.offsetInBytes, values.lengthInBytes);

  static Float32List _unit(Float32List values) {
    var sum = 0.0;
    for (final value in values) {
      sum += value * value;
    }

    final norm = math.max(math.sqrt(sum), 1e-12);

    final unit = Float32List(values.length);
    for (var i = 0; i < unit.length; i++) {
      unit[i] = values[i] / norm;
    }

    return unit;
  }
}
