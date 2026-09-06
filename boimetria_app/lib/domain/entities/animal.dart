import 'package:boimetria/domain/value_objects/weight.dart';

enum Sex { male, female }

/// Animal ja' cadastrado no rebanho.
///
/// So' existe com [id]: enquanto a pessoa preenche o formulario o que existe e'
/// um rascunho, no estado da tela.
///
/// A biometria nao mora aqui. O embedding vai numa tabela propria (a busca
/// vetorial precisa disso) e um animal pode ganhar novas leituras do focinho ao
/// longo da vida — e' um-para-muitos, nao um campo.
class Animal {
  const Animal({
    required this.id,
    required this.tag,
    required this.sex,
    required this.entryDate,
    this.birthDate,
    this.weight,
  });

  final int id;

  /// Numero do brinco. E' o que o produtor usa pra falar do animal.
  final String tag;

  final Sex sex;

  /// Quando entrou no rebanho — nem sempre igual ao nascimento (animal comprado).
  final DateTime entryDate;

  final DateTime? birthDate;
  final Weight? weight;

  @override
  bool operator ==(Object other) => other is Animal && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
