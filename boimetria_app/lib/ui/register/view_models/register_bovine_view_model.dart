import 'dart:typed_data';

import 'package:boimetria/config/dependencies.dart';
import 'package:boimetria/domain/entities/bovine.dart';
import 'package:boimetria/domain/value_objects/muzzle_detection.dart';
import 'package:boimetria/domain/policies/detection_policy.dart';
import 'package:boimetria/domain/policies/enrollment_policy.dart';
import 'package:boimetria/domain/shared/result.dart';
import 'package:boimetria/ui/register/view_models/muzzle_state.dart';
import 'package:boimetria/ui/register/view_models/register_bovine_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final registerBovineProvider =
    NotifierProvider.autoDispose<RegisterBovineViewModel, RegisterBovineState>(
      RegisterBovineViewModel.new,
    );

class RegisterBovineViewModel extends Notifier<RegisterBovineState> {
  @override
  RegisterBovineState build() => RegisterBovineState(entryDate: DateTime.now());

  void setTag(String value) => state = state.copyWith(tag: value);

  void setSex(Sex value) => state = state.copyWith(sex: value);

  void setEntryDate(DateTime value) => state = state.copyWith(entryDate: value);

  void setBirthDate(DateTime value) => state = state.copyWith(birthDate: value);

  void setWeight(String value) => state = state.copyWith(weightText: value);

  Future<void> readMuzzle(Uint8List bytes) async {
    if (state.muzzle is MuzzleDetecting) return;

    state = state.copyWith(muzzle: const MuzzleDetecting());

    final Result<MuzzleDetection?> result;
    try {
      final detector = await ref.read(muzzleDetectorProvider.future);
      result = await detector.detect(bytes);
    } on Exception catch (error) {
      if (ref.mounted) {
        state = state.copyWith(muzzle: MuzzleFailed(error.toString()));
      }
      return;
    }

    if (!ref.mounted) return;

    const floor = DetectionPolicy.minimumScore;
    const minimum = EnrollmentPolicy.minimumConfidence;

    state = state.copyWith(
      muzzle: switch (result) {
        Error(:final error) => MuzzleFailed(error.toString()),
        Ok(value: null) => MuzzleAbsent(bytes),
        Ok(value: final detection?) when detection.confidence < floor =>
          MuzzleAbsent(bytes),
        Ok(value: final detection?) when detection.confidence < minimum =>
          MuzzleLowConfidence(detection, minimum),
        Ok(value: final detection?) => MuzzleCaptured(detection),
      },
    );
  }
}
