import 'dart:io';

import 'package:boimetria/config/assets.dart';
import 'package:boimetria/data/services/onnx_muzzle_detector_service.dart';
import 'package:boimetria/data/services/onnx_muzzle_embedder_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

const _dataset = 'C:/Users/murilo/Desktop/TCC/DataSet/CMPD300 _filtrado';
const _out =
    'C:/Users/murilo/AppData/Local/Temp/claude/'
    'C--Users-murilo-Desktop-Boimetria/'
    '4836f907-ec0e-480a-9e19-c75718fc674a/scratchpad/eval/out';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('sweep the dataset', (tester) async {
    final lines = File('$_out/manifest.csv').readAsLinesSync().skip(1);
    final rows = [
      for (final line in lines)
        if (line.trim().isNotEmpty) line.split(','),
    ];

    final detector = await OnnxMuzzleDetectorService.load(Assets.yolo);
    final embedder = await OnnxMuzzleEmbedderService.load(
      Assets.cattleMuzzleNet,
      Assets.cattleMuzzleNetVersion,
    );

    final vectors = Float32List(rows.length * 640);
    final meta = StringBuffer('index,detected,yolo_conf,x1,y1,x2,y2\n');
    final started = DateTime.now();

    for (var i = 0; i < rows.length; i++) {
      final bytes = File('$_dataset/${rows[i][2]}').readAsBytesSync();

      final detection = await detector.detect(bytes);
      if (detection == null) {
        meta.writeln('$i,0,0,0,0,0,0');
        continue;
      }

      final box = detection.boundingBox;
      final embedding = await embedder.embed(detection.croppedImage);
      vectors.setRange(i * 640, i * 640 + 640, embedding.values);

      meta.writeln(
        '$i,1,${box.confidence.value},'
        '${box.x.toStringAsFixed(2)},${box.y.toStringAsFixed(2)},'
        '${(box.x + box.width).toStringAsFixed(2)},'
        '${(box.y + box.height).toStringAsFixed(2)}',
      );

      if ((i + 1) % 200 == 0) {
        final ms = DateTime.now().difference(started).inMilliseconds / (i + 1);
        debugPrint('  ${i + 1}/${rows.length}  ${ms.toStringAsFixed(0)} ms/img');
      }
    }

    File('$_out/dart_embeddings.bin').writeAsBytesSync(
      vectors.buffer.asUint8List(),
    );
    File('$_out/dart_meta.csv').writeAsStringSync(meta.toString());

    final elapsed = DateTime.now().difference(started);
    debugPrint(
      'DART images=${rows.length} elapsed=${elapsed.inSeconds}s '
      '${(elapsed.inMilliseconds / rows.length).toStringAsFixed(0)} ms/img',
    );

    await detector.close();
    await embedder.close();
  }, timeout: const Timeout(Duration(hours: 2)));
}
