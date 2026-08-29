/// Pelagem do animal. Lista extensível pelo produtor.
class Coat {
  const Coat({required this.id, required this.name});

  final int id;
  final String name;

  @override
  bool operator ==(Object other) => other is Coat && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
