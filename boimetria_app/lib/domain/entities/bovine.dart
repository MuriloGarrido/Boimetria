import 'package:boimetria/domain/value_objects/weight.dart';

enum Sex { male, female }

class Bovine {
  const Bovine({
    required this.id,
    required this.tag,
    required this.sex,
    required this.entryDate,
    this.birthDate,
    this.weight,
  });

  final int id;
  final String tag;
  final Sex sex;
  final DateTime entryDate;
  final DateTime? birthDate;
  final Weight? weight;

  @override
  bool operator ==(Object other) => other is Bovine && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
