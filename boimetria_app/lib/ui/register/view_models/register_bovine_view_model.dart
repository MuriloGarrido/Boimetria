import 'dart:typed_data';

import 'package:boimetria/config/dependencies.dart';
import 'package:boimetria/domain/entities/bovine.dart';
import 'package:boimetria/domain/value_objects/bovine_draft.dart';
import 'package:boimetria/domain/value_objects/muzzle_detection.dart';
import 'package:boimetria/domain/value_objects/muzzle_template_draft.dart';
import 'package:boimetria/domain/policies/detection_policy.dart';
import 'package:boimetria/domain/policies/enrollment_policy.dart';
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

    final MuzzleDetection? detection;
    try {
      final detector = await ref.read(muzzleDetectorProvider.future);
      detection = await detector.detect(bytes);
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
      muzzle: switch (detection) {
        null => MuzzleAbsent(bytes),
        final found when found.confidence < floor => MuzzleAbsent(bytes),
        final found when found.confidence < minimum =>
          MuzzleLowConfidence(found, minimum),
        final found => MuzzleCaptured(found),
      },
    );
  }

  Future<void> save() async {
    final captured = state.muzzle;
    if (!state.canSave || captured is! MuzzleCaptured) return;

    state = state.copyWith(saving: true);

    try {
      final embedder = await ref.read(muzzleEmbedderProvider.future);
      final embedding = await embedder.embed(captured.detection.croppedImage);

      final bovines = ref.read(bovineRepositoryProvider);
      final templates = ref.read(muzzleTemplateRepositoryProvider);

      await ref.read(unitOfWorkProvider).run(() async {
        final bovine = await bovines.enroll(
          BovineDraft(
            tag: state.tag!.trim(),
            sex: state.sex!,
            entryDate: state.entryDate,
            birthDate: state.birthDate,
            weight: state.weight,
          ),
        );

        await templates.enroll(
          MuzzleTemplateDraft(
            bovineId: bovine.id,
            embedding: embedding,
            capturedAt: DateTime.now(),
          ),
        );
      });
    } finally {
      if (ref.mounted) state = state.copyWith(saving: false);
    }
  }
}
