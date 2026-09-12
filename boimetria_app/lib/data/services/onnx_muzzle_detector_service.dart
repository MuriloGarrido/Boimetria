import 'dart:math' as math;

import 'package:boimetria/domain/interfaces/services/muzzle_detector.dart';
import 'package:boimetria/domain/value_objects/bounding_box.dart';
import 'package:boimetria/domain/value_objects/muzzle_detection.dart';
import 'package:boimetria/domain/exceptions/muzzle_detection_failure.dart';
import 'package:boimetria/domain/value_objects/percentage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_onnxruntime/flutter_onnxruntime.dart';
import 'package:image/image.dart' as img;

const _inputSize = 640;

class OnnxMuzzleDetectorService implements MuzzleDetectorService {
  OnnxMuzzleDetectorService._(this._session);

  final OrtSession _session;

  static Future<OnnxMuzzleDetectorService> load(String modelAsset) async {
    try {
      final session = await OnnxRuntime().createSessionFromAsset(modelAsset);
      return OnnxMuzzleDetectorService._(session);
    } on Exception catch (error) {
      throw ModelLoadFailure(modelAsset, error);
    }
  }

  Future<void> close() => _session.close();

  @override
  Future<MuzzleDetection?> detect(Uint8List imageBytes) async {
    OrtValue? inputTensor;
    Map<String, OrtValue>? outputs;

    try {
      final decoded = img.decodeImage(imageBytes);
      if (decoded == null) throw const ImageDecodeFailure();

      final original = img.bakeOrientation(decoded);

      final letterbox = preprocess(original);
      inputTensor = await OrtValue.fromList(letterbox.tensor, [
        1,
        3,
        _inputSize,
        _inputSize,
      ]);

      outputs = await _session.run({_session.inputNames.first: inputTensor});

      final rawOutput = await outputs[_session.outputNames.first]!.asList();

      final boundingBox = postprocess(rawOutput, letterbox);

      if (boundingBox == null) return null;

      final cropped = img.copyCrop(
        original,
        x: boundingBox.x.round(),
        y: boundingBox.y.round(),
        width: boundingBox.width.round(),
        height: boundingBox.height.round(),
      );

      return MuzzleDetection(
        boundingBox: boundingBox,
        fullImage: imageBytes,
        croppedImage: img.encodeJpg(cropped),
      );
    } finally {
      await inputTensor?.dispose();
      for (final output in outputs?.values ?? const <OrtValue>[]) {
        await output.dispose();
      }
    }
  }

  @visibleForTesting
  static Letterbox preprocess(img.Image original) {
    final scale = math.min(
      _inputSize / original.width,
      _inputSize / original.height,
    );
    final resizedWidth = (original.width * scale).round();
    final resizedHeight = (original.height * scale).round();
    final padX = ((_inputSize - resizedWidth) / 2).floorToDouble();
    final padY = ((_inputSize - resizedHeight) / 2).floorToDouble();

    final resized = img.copyResize(
      original,
      width: resizedWidth,
      height: resizedHeight,
      interpolation: img.Interpolation.linear,
    );

    final canvas = img.Image(width: _inputSize, height: _inputSize);
    img.fill(canvas, color: img.ColorRgb8(114, 114, 114));
    img.compositeImage(canvas, resized, dstX: padX.round(), dstY: padY.round());

    final rgbBytes = canvas.getBytes(order: img.ChannelOrder.rgb);
    final channelSize = _inputSize * _inputSize;
    final tensor = Float32List(3 * channelSize);
    for (var i = 0; i < channelSize; i++) {
      tensor[i] = rgbBytes[i * 3] / 255.0;
      tensor[channelSize + i] = rgbBytes[i * 3 + 1] / 255.0;
      tensor[2 * channelSize + i] = rgbBytes[i * 3 + 2] / 255.0;
    }

    return Letterbox(
      tensor: tensor,
      scale: scale,
      padX: padX,
      padY: padY,
      originalWidth: original.width,
      originalHeight: original.height,
    );
  }

  @visibleForTesting
  static BoundingBox? postprocess(
    List rawOutput,
    Letterbox letterbox,
  ) {
    final detections = rawOutput.first as List;

    List<double>? best;
    for (final detection in detections) {
      final values = (detection as List).cast<num>();
      final score = values[4].toDouble();
      if (best == null || score > best[4]) {
        best = values.map((value) => value.toDouble()).toList();
      }
    }

    if (best == null) return null;

    final maxX = letterbox.originalWidth.toDouble();
    final maxY = letterbox.originalHeight.toDouble();

    final x1 = ((best[0] - letterbox.padX) / letterbox.scale).clamp(0.0, maxX);
    final y1 = ((best[1] - letterbox.padY) / letterbox.scale).clamp(0.0, maxY);
    final x2 = ((best[2] - letterbox.padX) / letterbox.scale).clamp(0.0, maxX);
    final y2 = ((best[3] - letterbox.padY) / letterbox.scale).clamp(0.0, maxY);

    if (x2 <= x1 || y2 <= y1) return null;

    return BoundingBox(
      x: x1,
      y: y1,
      width: x2 - x1,
      height: y2 - y1,
      confidence: Percentage(best[4]),
    );
  }
}

class Letterbox {
  const Letterbox({
    required this.tensor,
    required this.scale,
    required this.padX,
    required this.padY,
    required this.originalWidth,
    required this.originalHeight,
  });

  final Float32List tensor;
  final double scale;
  final double padX;
  final double padY;
  final int originalWidth;
  final int originalHeight;
}
