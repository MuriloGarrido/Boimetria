import 'dart:typed_data';

import 'package:boimetria/data/services/onnx_muzzle_embedder_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

const _inputSize = 128;
const _plane = _inputSize * _inputSize;

img.Image _solid(int width, int height, int r, int g, int b) {
  final image = img.Image(width: width, height: height);
  img.fill(image, color: img.ColorRgb8(r, g, b));
  return image;
}

double _at(Float32List tensor, int c, int x, int y) =>
    tensor[c * _plane + y * _inputSize + x];

void main() {
  group('preprocess', () {
    test('tensor tem o tamanho de [1, 3, 128, 128]', () {
      final tensor = OnnxMuzzleEmbedderService.preprocess(
        _solid(300, 200, 10, 20, 30),
      );

      expect(tensor.length, 3 * _plane);
    });

    test('mantem a escala 0-255: a normalizacao esta no grafo', () {
      final tensor = OnnxMuzzleEmbedderService.preprocess(
        _solid(_inputSize, _inputSize, 255, 128, 0),
      );

      expect(_at(tensor, 0, 60, 60), closeTo(255.0, 1e-6));
      expect(_at(tensor, 1, 60, 60), closeTo(128.0, 1e-6));
      expect(_at(tensor, 2, 60, 60), closeTo(0.0, 1e-6));
    });

    test('estica a imagem sem letterbox: nao ha padding cinza', () {
      final tensor = OnnxMuzzleEmbedderService.preprocess(
        _solid(400, 100, 200, 100, 50),
      );

      for (final x in [0, 64, 127]) {
        expect(_at(tensor, 0, x, 64), closeTo(200.0, 1e-6), reason: 'coluna $x');
      }
    });

    test('preserva a posicao dos pixels no layout NCHW', () {
      final image = _solid(_inputSize, _inputSize, 255, 0, 0);
      img.fillRect(
        image,
        x1: _inputSize ~/ 2,
        y1: 0,
        x2: _inputSize - 1,
        y2: _inputSize - 1,
        color: img.ColorRgb8(0, 0, 255),
      );

      final tensor = OnnxMuzzleEmbedderService.preprocess(image);

      expect(_at(tensor, 0, 20, 60), closeTo(255.0, 1e-6));
      expect(_at(tensor, 2, 20, 60), closeTo(0.0, 1e-6));
      expect(_at(tensor, 0, 100, 60), closeTo(0.0, 1e-6));
      expect(_at(tensor, 2, 100, 60), closeTo(255.0, 1e-6));
    });
  });

  group('postprocess', () {
    test('achata a saida [1, N] num vetor de N floats', () {
      final vector = OnnxMuzzleEmbedderService.postprocess([
        [0.1, -0.2, 0.3],
      ]);

      expect(vector.length, 3);
      expect(vector[0], closeTo(0.1, 1e-6));
      expect(vector[1], closeTo(-0.2, 1e-6));
      expect(vector[2], closeTo(0.3, 1e-6));
    });
  });
}
