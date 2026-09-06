import 'package:boimetria/config/assets.dart';
import 'package:boimetria/data/services/onnx_muzzle_detector_service.dart';
import 'package:boimetria/domain/interfaces/services/muzzle_detector.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final muzzleDetectorProvider = FutureProvider<MuzzleDetectorService>((ref) {
  return OnnxMuzzleDetectorService.load(Assets.yolo);
});
