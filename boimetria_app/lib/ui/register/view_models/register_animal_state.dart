import 'package:boimetria/domain/entities/animal.dart';
import 'package:boimetria/domain/value_objects/weight.dart';
import 'package:boimetria/utils/decimals.dart';
import 'package:boimetria/ui/register/view_models/muzzle_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_animal_state.freezed.dart';

@freezed
class RegisterAnimalState with _$RegisterAnimalState {
  const RegisterAnimalState._();

  const factory RegisterAnimalState({
    @Default(MuzzleMissing()) MuzzleState muzzle,
    required DateTime entryDate,
    String? tag,
    Sex? sex,
    DateTime? birthDate,
    String? weightText,
    @Default(false) bool saving,
  }) = _RegisterAnimalState;

  Weight? get weight {
    final kg = Decimals.tryParse(weightText ?? '');
    return kg == null || kg <= 0 ? null : Weight(kg);
  }

  bool get canSave =>
      !saving &&
      muzzle is MuzzleCaptured &&
      tag != null &&
      tag!.trim().isNotEmpty &&
      sex != null;
}
