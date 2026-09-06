class Weight {
  const Weight(this.kg) : assert(kg > 0);

  final double kg;

  @override
  bool operator ==(Object other) => other is Weight && other.kg == kg;

  @override
  int get hashCode => kg.hashCode;

  @override
  String toString() => '$kg kg';
}
