import 'package:boimetria/domain/exceptions/muzzle_detection_failure.dart';
import 'package:boimetria/domain/interfaces/services/muzzle_embedder.dart';
import 'package:boimetria/domain/shared/result.dart';
import 'package:boimetria/domain/value_objects/muzzle_embedding.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_onnxruntime/flutter_onnxruntime.dart';
import 'package:image/image.dart' as img;

const _inputSize = 128;

class OnnxMuzzleEmbedderService implements MuzzleEmbedderService {
  OnnxMuzzleEmbedderService._(this._session, this._modelVersion);

  final OrtSession _session;
  final String _modelVersion;

  static Future<OnnxMuzzleEmbedderService> load(
    String modelAsset,
    String modelVersion,
  ) async {
    try {
      final session = await OnnxRuntime().createSessionFromAsset(modelAsset);
      return OnnxMuzzleEmbedderService._(session, modelVersion);
    } on Exception catch (error) {
      throw ModelLoadFailure(modelAsset, error);
    }
  }

  Future<void> close() => _session.close();

  @override
  Future<Result<MuzzleEmbedding>> embed(Uint8List muzzleImage) async {
    OrtValue? inputTensor;
    Map<String, OrtValue>? outputs;

    try {
      final decoded = img.decodeImage(muzzleImage);
      if (decoded == null) return Result.error(const ImageDecodeFailure());

      inputTensor = await OrtValue.fromList(preprocess(decoded), [
        1,
        3,
        _inputSize,
        _inputSize,
      ]);

      outputs = await _session.run({_session.inputNames.first: inputTensor});

      final rawOutput = await outputs[_session.outputNames.first]!.asList();

      return Result.ok(MuzzleEmbedding(postprocess(rawOutput), _modelVersion));
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      await inputTensor?.dispose();
      for (final output in outputs?.values ?? const <OrtValue>[]) {
        await output.dispose();
      }
    }
  }

  @visibleForTesting
  static Float32List preprocess(img.Image muzzle) {
    // O treino e o eval usam PIL BILINEAR, que aplica antialias ao reduzir; o
    // pacote image nao tem equivalente. Medido em 40 recortes reais: os
    // embeddings se afastam 0.011, mas as distancias — que e' o que o limiar
    // enxerga — mudam menos de 0.001 (mesmo animal 0.2739 no PIL contra 0.2730
    // aqui). A perturbacao cai nos dois vetores comparados e se cancela.
    // Interpolation.average chegaria a 0.0066, se um dia isso importar.
    final resized = img.copyResize(
      muzzle,
      width: _inputSize,
      height: _inputSize,
      interpolation: img.Interpolation.linear,
    );

    final rgbBytes = resized.getBytes(order: img.ChannelOrder.rgb);
    final channelSize = _inputSize * _inputSize;
    final tensor = Float32List(3 * channelSize);

    for (var i = 0; i < channelSize; i++) {
      tensor[i] = rgbBytes[i * 3].toDouble();
      tensor[channelSize + i] = rgbBytes[i * 3 + 1].toDouble();
      tensor[2 * channelSize + i] = rgbBytes[i * 3 + 2].toDouble();
    }

    return tensor;
  }

  @visibleForTesting
  static Float32List postprocess(List rawOutput) {
    final values = (rawOutput.first as List).cast<num>();
    final vector = Float32List(values.length);

    for (var i = 0; i < values.length; i++) {
      vector[i] = values[i].toDouble();
    }

    return vector;
  }
}
