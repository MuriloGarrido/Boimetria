import 'dart:math' as math;
import 'dart:typed_data';

import 'package:boimetria/domain/value_objects/muzzle_embedding.dart';
import 'package:flutter_test/flutter_test.dart';

Float32List _values(List<double> values) => Float32List.fromList(values);

double _norm(Float32List values) {
  var sum = 0.0;
  for (final value in values) {
    sum += value * value;
  }
  return math.sqrt(sum);
}

void main() {
  test('normaliza no construtor', () {
    final embedding = MuzzleEmbedding(_values([3, 4]));

    expect(_norm(embedding.values), closeTo(1.0, 1e-6));
    expect(embedding.values[0], closeTo(0.6, 1e-6));
    expect(embedding.values[1], closeTo(0.8, 1e-6));
  });

  test('normalizar de novo nao muda nada', () {
    final once = MuzzleEmbedding(_values([3, 4]));
    final twice = MuzzleEmbedding(once.values);

    expect(twice.values, once.values);
  });

  test('vetor de zeros nao divide por zero', () {
    final embedding = MuzzleEmbedding(_values([0, 0, 0]));

    expect(embedding.values.every((value) => value == 0), isTrue);
  });

  test('distancia entre vetores iguais e zero', () {
    final a = MuzzleEmbedding(_values([1, 2, 3]));
    final b = MuzzleEmbedding(_values([1, 2, 3]));

    expect(a.distanceTo(b).value, closeTo(0.0, 1e-6));
  });

  test('vetores opostos ficam a distancia 2 na esfera unitaria', () {
    final a = MuzzleEmbedding(_values([1, 0]));
    final b = MuzzleEmbedding(_values([-1, 0]));

    expect(a.distanceTo(b).value, closeTo(2.0, 1e-6));
  });

  test('a escala do vetor original nao afeta a distancia', () {
    final small = MuzzleEmbedding(_values([1, 1]));
    final large = MuzzleEmbedding(_values([100, 100]));
    final other = MuzzleEmbedding(_values([1, 0]));

    expect(
      small.distanceTo(other).value,
      closeTo(large.distanceTo(other).value, 1e-6),
    );
  });

  test('sobrevive a ida e volta por bytes', () {
    final original = MuzzleEmbedding(_values([0.1, -0.2, 0.3, 0.4]));
    final restored = MuzzleEmbedding.fromBytes(original.toBytes());

    expect(restored.values, original.values);
  });

  test('le bytes desalinhados vindos do banco', () {
    final original = MuzzleEmbedding(_values([0.1, -0.2, 0.3, 0.4]));

    final padded = Uint8List(original.toBytes().length + 1)
      ..setRange(1, original.toBytes().length + 1, original.toBytes());
    final unaligned = Uint8List.sublistView(padded, 1);

    final restored = MuzzleEmbedding.fromBytes(unaligned);

    expect(restored.values, original.values);
  });
}
