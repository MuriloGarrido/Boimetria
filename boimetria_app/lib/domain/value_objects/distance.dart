import 'package:boimetria/domain/value_objects/percentage.dart';

class Distance {
  const Distance(this.value) : assert(value >= 0);

  final double value;

  Percentage get similarity => Percentage((1 - value / 2).clamp(0.0, 1.0));

  bool operator <(Distance other) => value < other.value;
  bool operator <=(Distance other) => value <= other.value;
  bool operator >(Distance other) => value > other.value;
  bool operator >=(Distance other) => value >= other.value;

  @override
  bool operator ==(Object other) => other is Distance && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value.toStringAsFixed(3);
}
