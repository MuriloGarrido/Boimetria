import 'dart:typed_data';

import 'package:boimetria/data/services/onnx_muzzle_detector_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

const _inputSize = 640;
const _plane = _inputSize * _inputSize;

/// Cinza 114 normalizado — a cor com que o Ultralytics preenche o padding.
const _padValue = 114 / 255.0;

/// Imagem de cor sólida, para conferir canal e normalização sem que a
/// interpolação entre na conta.
img.Image _solid(int width, int height, int r, int g, int b) {
  final image = img.Image(width: width, height: height);
  img.fill(image, color: img.ColorRgb8(r, g, b));
  return image;
}

/// Valor do canal [c] no pixel ([x], [y]) do tensor NCHW.
double _at(Float32List tensor, int c, int x, int y) =>
    tensor[c * _plane + y * _inputSize + x];

/// Uma detecção crua do YOLO: `[x1, y1, x2, y2, score, classId]`, em pixels
/// do espaço 640 letterboxado.
List<double> _detection(
  double x1,
  double y1,
  double x2,
  double y2,
  double score,
) => [x1, y1, x2, y2, score, 0.0];

/// A saída do modelo tem shape `[1, 300, 6]`, então o `asList()` devolve uma
/// lista de um elemento contendo a lista de detecções.
List _output(List<List<double>> detections) => [detections];

/// Letterbox de uma foto em pé de 500x1000: cabe em 320x640, sobrando 160px
/// de padding cinza de cada lado na horizontal.
Letterbox _portraitLetterbox() => Letterbox(
  tensor: Float32List(0),
  scale: 0.64,
  padX: 160,
  padY: 0,
  originalWidth: 500,
  originalHeight: 1000,
);

void main() {
  group('preprocess', () {
    test('imagem deitada: padding só na vertical', () {
      final letterbox = OnnxMuzzleDetectorService.preprocess(
        _solid(1000, 500, 10, 20, 30),
      );

      // 640/1000 = 0.64 é menor que 640/500 = 1.28, então a largura manda:
      // 1000x500 vira 640x320 e sobram 320px de padding divididos em dois.
      expect(letterbox.scale, closeTo(0.64, 1e-9));
      expect(letterbox.padX, 0.0);
      expect(letterbox.padY, 160.0);
      expect(letterbox.originalWidth, 1000);
      expect(letterbox.originalHeight, 500);
    });

    test('imagem em pé: padding só na horizontal', () {
      final letterbox = OnnxMuzzleDetectorService.preprocess(
        _solid(500, 1000, 10, 20, 30),
      );

      expect(letterbox.scale, closeTo(0.64, 1e-9));
      expect(letterbox.padX, 160.0);
      expect(letterbox.padY, 0.0);
    });

    test('imagem quadrada: sem padding nenhum', () {
      final letterbox = OnnxMuzzleDetectorService.preprocess(
        _solid(777, 777, 10, 20, 30),
      );

      expect(letterbox.scale, closeTo(640 / 777, 1e-9));
      expect(letterbox.padX, 0.0);
      expect(letterbox.padY, 0.0);
    });

    test('tensor tem o tamanho de [1, 3, 640, 640]', () {
      final letterbox = OnnxMuzzleDetectorService.preprocess(
        _solid(1000, 500, 10, 20, 30),
      );

      expect(letterbox.tensor.length, 3 * _plane);
    });

    test('preenche o padding com cinza 114 nos três canais', () {
      final letterbox = OnnxMuzzleDetectorService.preprocess(
        _solid(500, 1000, 200, 100, 50),
      );

      // padX = 160: as 160 primeiras colunas são padding puro.
      for (final x in [0, 80, 159]) {
        for (var c = 0; c < 3; c++) {
          expect(_at(letterbox.tensor, c, x, 320), closeTo(_padValue, 1e-6),
              reason: 'coluna $x, canal $c');
        }
      }

      // A coluna 160 já é imagem, não padding.
      expect(_at(letterbox.tensor, 0, 160, 320), closeTo(200 / 255.0, 1e-6));
    });

    test('separa os canais em RGB e normaliza em [0, 1]', () {
      // 640x640 não passa por resize, então o valor chega intacto e o teste
      // isola canal e normalização da interpolação.
      final letterbox = OnnxMuzzleDetectorService.preprocess(
        _solid(_inputSize, _inputSize, 255, 128, 0),
      );

      expect(_at(letterbox.tensor, 0, 300, 300), closeTo(1.0, 1e-6));
      expect(_at(letterbox.tensor, 1, 300, 300), closeTo(128 / 255.0, 1e-6));
      expect(_at(letterbox.tensor, 2, 300, 300), closeTo(0.0, 1e-6));
    });

    test('preserva a posição dos pixels no layout NCHW', () {
      // Metade esquerda vermelha, metade direita azul: se as linhas e colunas
      // estiverem trocadas, os dois lados saem iguais.
      final image = _solid(_inputSize, _inputSize, 255, 0, 0);
      img.fillRect(image,
          x1: _inputSize ~/ 2, y1: 0, x2: _inputSize - 1, y2: _inputSize - 1,
          color: img.ColorRgb8(0, 0, 255));

      final tensor = OnnxMuzzleDetectorService.preprocess(image).tensor;

      expect(_at(tensor, 0, 100, 300), closeTo(1.0, 1e-6));
      expect(_at(tensor, 2, 100, 300), closeTo(0.0, 1e-6));
      expect(_at(tensor, 0, 500, 300), closeTo(0.0, 1e-6));
      expect(_at(tensor, 2, 500, 300), closeTo(1.0, 1e-6));
    });

    test('reduz com interpolação bilinear, não nearest-neighbor', () {
      // Listras verticais de 1px. Ao reduzir 1000 -> 640 (escala 0.64), as
      // posições amostradas caem entre pixels: o bilinear mistura os vizinhos
      // e produz tons intermediários, enquanto o nearest escolhe um dos dois
      // e devolve só preto ou branco puro.
      //
      // O default do copyResize é nearest, e usá-lo aqui causa aliasing: a
      // textura fina da mufla vira ruído em vez de padrão. Medido: com
      // linear 93.75% dos pixels saem misturados, com nearest 0%.
      final image = img.Image(width: 1000, height: 1000);
      for (var y = 0; y < 1000; y++) {
        for (var x = 0; x < 1000; x++) {
          final value = x.isEven ? 0 : 255;
          image.setPixelRgb(x, y, value, value, value);
        }
      }

      final tensor = OnnxMuzzleDetectorService.preprocess(image).tensor;

      var mixed = 0;
      for (var i = 0; i < _plane; i++) {
        if (tensor[i] > 0.01 && tensor[i] < 0.99) mixed++;
      }

      expect(
        mixed,
        greaterThan(_plane ~/ 2),
        reason: 'quase nenhum pixel misturado — o copyResize provavelmente '
            'voltou ao Interpolation.nearest',
      );
    });
  });

  group('postprocess', () {
    test('converte do espaço 640 letterboxado para a imagem original', () {
      final box = OnnxMuzzleDetectorService.postprocess(
        _output([_detection(200, 100, 300, 200, 0.9)]),
        _portraitLetterbox(),
      );

      // x: (200 - 160) / 0.64 = 62.5   |  y: (100 - 0) / 0.64 = 156.25
      expect(box, isNotNull);
      expect(box!.x, closeTo(62.5, 1e-9));
      expect(box.y, closeTo(156.25, 1e-9));
      expect(box.width, closeTo(156.25, 1e-9));
      expect(box.height, closeTo(156.25, 1e-9));
    });

    test('ignora detecção abaixo do limiar de confiança', () {
      final box = OnnxMuzzleDetectorService.postprocess(
        _output([_detection(200, 100, 300, 200, 0.49)]),
        _portraitLetterbox(),
      );

      expect(box, isNull);
    });

    test('devolve null quando não há detecção nenhuma', () {
      final box = OnnxMuzzleDetectorService.postprocess(
        _output([]),
        _portraitLetterbox(),
      );

      expect(box, isNull);
    });

    test('escolhe a detecção de maior score, não a primeira', () {
      final box = OnnxMuzzleDetectorService.postprocess(
        _output([
          _detection(200, 100, 300, 200, 0.6),
          _detection(360, 100, 460, 200, 0.95),
          _detection(200, 300, 300, 400, 0.7),
        ]),
        _portraitLetterbox(),
      );

      // A de score 0.95 começa em x = (360 - 160) / 0.64 = 312.5
      expect(box, isNotNull);
      expect(box!.x, closeTo(312.5, 1e-9));
    });

    test('clampa a caixa que passa da borda da imagem', () {
      // x1 = (0 - 160) / 0.64 = -250, fora da foto: tem que virar 0.
      final box = OnnxMuzzleDetectorService.postprocess(
        _output([_detection(0, 0, 300, 200, 0.9)]),
        _portraitLetterbox(),
      );

      expect(box, isNotNull);
      expect(box!.x, 0.0);
      expect(box.y, 0.0);
      expect(box.width, closeTo(218.75, 1e-9));
    });

    test('devolve null quando a caixa fica inteiramente fora da imagem', () {
      // x1 e x2 negativos: depois do clamp os dois viram 0 e a caixa não
      // tem área — recortar isso estouraria no copyCrop.
      final box = OnnxMuzzleDetectorService.postprocess(
        _output([_detection(0, 0, 100, 200, 0.9)]),
        _portraitLetterbox(),
      );

      expect(box, isNull);
    });

    test('aceita score exatamente no limiar', () {
      final box = OnnxMuzzleDetectorService.postprocess(
        _output([_detection(200, 100, 300, 200, 0.5)]),
        _portraitLetterbox(),
      );

      expect(box, isNotNull);
    });
  });
}
