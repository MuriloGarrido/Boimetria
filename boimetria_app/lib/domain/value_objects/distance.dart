class Distance {
  const Distance(this.value) : assert(value >= 0);

  final double value;

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
