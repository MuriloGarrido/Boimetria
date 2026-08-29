/// Pasto da fazenda. Cadastrado pelo produtor — cada fazenda tem os seus,
/// então não dá pra chumbar a lista no código.
class Pasture {
  const Pasture({required this.id, required this.name});

  final int id;
  final String name;

  // Sem isto o item selecionado nunca casaria com o da lista: sao instancias
  // diferentes vindas do banco, e a comparacao cairia em identidade.
  @override
  bool operator ==(Object other) => other is Pasture && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
