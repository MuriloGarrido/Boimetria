/// Raça do animal. Lista extensível pelo produtor.
class Breed {
  const Breed({required this.id, required this.name});

  final int id;
  final String name;

  @override
  bool operator ==(Object other) => other is Breed && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
