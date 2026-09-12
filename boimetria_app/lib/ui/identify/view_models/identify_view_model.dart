import 'dart:typed_data';

import 'package:boimetria/config/dependencies.dart';
import 'package:boimetria/domain/policies/detection_policy.dart';
import 'package:boimetria/domain/policies/identification_policy.dart';
import 'package:boimetria/ui/identify/view_models/identify_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final identifyProvider =
    NotifierProvider.autoDispose<IdentifyViewModel, IdentifyState>(
      IdentifyViewModel.new,
    );

class IdentifyViewModel extends Notifier<IdentifyState> {
  @override
  IdentifyState build() => const IdentifyRunning();

  Future<void> identify(Uint8List photo) async {
    state = const IdentifyRunning();

    try {
      final detector = await ref.read(muzzleDetectorProvider.future);
      final detection = await detector.detect(photo);

      if (!ref.mounted) return;

      if (detection == null ||
          detection.confidence < DetectionPolicy.minimumScore) {
        state = const IdentifyNoMuzzle();
        return;
      }

      final embedder = await ref.read(muzzleEmbedderProvider.future);
      final embedding = await embedder.embed(detection.croppedImage);

      final matches = await ref
          .read(muzzleTemplateRepositoryProvider)
          .nearest(embedding, k: IdentificationPolicy.candidates);

      if (!ref.mounted) return;

      if (matches.isEmpty ||
          matches.first.distance > IdentificationPolicy.maximumDistance) {
        state = IdentifyUnknown(
          detection,
          matches.isEmpty ? null : matches.first.distance,
        );
        return;
      }

      final match = matches.first;
      final bovine = await ref
          .read(bovineRepositoryProvider)
          .byId(match.template.bovineId);

      if (!ref.mounted) return;

      state = bovine == null
          ? IdentifyUnknown(detection, match.distance)
          : IdentifyMatched(detection, bovine, match.distance);
    } on Exception catch (error) {
      if (ref.mounted) state = IdentifyFailed(error.toString());
    }
  }
}
