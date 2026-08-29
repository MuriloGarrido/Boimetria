import 'package:boimetria/domain/models/breed/breed.dart';
import 'package:boimetria/domain/models/coat/coat.dart';
import 'package:boimetria/domain/models/pasture/pasture.dart';

enum Sex { male, female }

/// Referência leve a outro animal, usada em mãe e pai.
///
/// Guardar o [Animal] inteiro faria o pai carregar o avô, e assim por diante
/// até o topo da árvore. A tela só precisa do brinco pra exibir, e do id pra
/// gravar a FK.
class AnimalRef {
  const AnimalRef({required this.id, required this.tag});

  final int id;
  final String tag;

  @override
  bool operator ==(Object other) => other is AnimalRef && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

/// Animal já cadastrado no rebanho.
///
/// Só existe com [id]: enquanto a pessoa está preenchendo o formulário o que
/// existe é um rascunho, com todos os campos nulos e sem id.
///
/// A biometria não mora aqui. O embedding vai numa tabela própria (a busca
/// vetorial precisa disso) e um animal pode ganhar novas leituras do focinho
/// ao longo da vida, então é uma relação um-para-muitos, não um campo.
class Animal {
  const Animal({
    required this.id,
    required this.tag,
    required this.sex,
    required this.birthDate,
    required this.breed,
    required this.entryDate,
    this.weightKg,
    this.coat,
    this.pasture,
    this.mother,
    this.father,
  });

  final int id;

  /// Número do brinco. É o que o produtor usa pra falar do animal.
  final String tag;

  final Sex sex;
  final DateTime birthDate;
  final Breed breed;

  /// Quando entrou no rebanho — nem sempre igual ao nascimento (animal comprado).
  final DateTime entryDate;

  /// Peso da última pesagem. Vira histórico próprio quando existir pesagem
  /// recorrente; por ora é o valor informado no cadastro.
  final int? weightKg;

  final Coat? coat;
  final Pasture? pasture;
  final AnimalRef? mother;
  final AnimalRef? father;

  AnimalRef get ref => AnimalRef(id: id, tag: tag);

  Animal copyWith({
    String? tag,
    Sex? sex,
    DateTime? birthDate,
    Breed? breed,
    DateTime? entryDate,
    int? weightKg,
    Coat? coat,
    Pasture? pasture,
    AnimalRef? mother,
    AnimalRef? father,
  }) {
    return Animal(
      id: id,
      tag: tag ?? this.tag,
      sex: sex ?? this.sex,
      birthDate: birthDate ?? this.birthDate,
      breed: breed ?? this.breed,
      entryDate: entryDate ?? this.entryDate,
      weightKg: weightKg ?? this.weightKg,
      coat: coat ?? this.coat,
      pasture: pasture ?? this.pasture,
      mother: mother ?? this.mother,
      father: father ?? this.father,
    );
  }

  @override
  bool operator ==(Object other) => other is Animal && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
