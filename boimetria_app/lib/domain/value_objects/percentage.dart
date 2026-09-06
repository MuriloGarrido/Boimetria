class Percentage {
  const Percentage(this.value) : assert(value >= 0 && value <= 1);

  final double value;

  bool operator >=(Percentage other) => value >= other.value;
  bool operator <(Percentage other) => value < other.value;

  @override
  bool operator ==(Object other) => other is Percentage && other.value == value;

  @override
  int get hashCode => value.hashCode;
}
