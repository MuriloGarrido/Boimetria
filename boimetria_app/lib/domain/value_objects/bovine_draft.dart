import 'package:boimetria/domain/entities/bovine.dart';
import 'package:boimetria/domain/value_objects/weight.dart';

class BovineDraft {
  const BovineDraft({
    required this.tag,
    required this.sex,
    required this.entryDate,
    this.birthDate,
    this.weight,
  });

  final String tag;
  final Sex sex;
  final DateTime entryDate;
  final DateTime? birthDate;
  final Weight? weight;
}
