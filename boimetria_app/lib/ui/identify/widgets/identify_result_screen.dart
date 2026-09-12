import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:boimetria/domain/value_objects/bounding_box.dart';
import 'package:boimetria/l10n/generated/app_localizations.dart';
import 'package:boimetria/ui/core/widgets/app_header.dart';
import 'package:boimetria/ui/identify/view_models/identify_state.dart';
import 'package:boimetria/ui/identify/view_models/identify_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IdentifyResultScreen extends ConsumerStatefulWidget {
  const IdentifyResultScreen({super.key, required this.photo});

  final Uint8List photo;

  @override
  ConsumerState<IdentifyResultScreen> createState() =>
      _IdentifyResultScreenState();
}

class _IdentifyResultScreenState extends ConsumerState<IdentifyResultScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(identifyProvider.notifier).identify(widget.photo),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(identifyProvider);

    return Scaffold(
      appBar: const AppHeader(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 12,
          children: switch (state) {
            IdentifyRunning() => const [
              SizedBox(height: 120),
              Center(child: CircularProgressIndicator()),
            ],
            IdentifyFailed(:final reason) => [
              _Title(l10n.identifyFailedTitle),
              Text(reason),
            ],
            IdentifyNoMuzzle() => [
              _Title(l10n.identifyNoMuzzleTitle),
              _Photo(widget.photo, null),
            ],
            IdentifyUnknown(:final detection, :final nearest) => [
              _Title(l10n.identifyUnknownTitle),
              _Photo(widget.photo, detection.boundingBox),
              _Row(
                l10n.identifyDetectionLabel,
                _percent(detection.confidence.value),
              ),
              if (nearest != null)
                _Row(
                  l10n.identifySimilarityLabel,
                  '${_percent(nearest.similarity.value)}  ($nearest)',
                )
              else
                Text(l10n.identifyNoneEnrolled),
            ],
            IdentifyMatched(:final detection, :final bovine, :final distance) =>
              [
                _Title(l10n.identifyMatchedTitle),
                _Photo(widget.photo, detection.boundingBox),
                _Row(l10n.identifyAnimalLabel, bovine.tag),
                _Row(
                  l10n.identifyDetectionLabel,
                  _percent(detection.confidence.value),
                ),
                _Row(
                  l10n.identifySimilarityLabel,
                  '${_percent(distance.similarity.value)}  ($distance)',
                ),
              ],
          },
        ),
      ),
    );
  }

  static String _percent(double value) =>
      '${(value * 100).toStringAsFixed(1)}%';
}

class _Title extends StatelessWidget {
  const _Title(this.text);

  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: Theme.of(context).textTheme.headlineSmall);
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: text.labelLarge),
        Text(value, style: text.bodyLarge),
      ],
    );
  }
}

class _Photo extends StatelessWidget {
  const _Photo(this.bytes, this.box);

  final Uint8List bytes;
  final BoundingBox? box;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image>(
      future: decodeImageFromList(bytes),
      builder: (context, snapshot) {
        final image = snapshot.data;
        if (image == null) {
          return const AspectRatio(aspectRatio: 1, child: SizedBox());
        }

        return AspectRatio(
          aspectRatio: image.width / image.height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.memory(bytes, fit: BoxFit.fill),
              if (box != null)
                CustomPaint(
                  painter: _BoxPainter(
                    box!,
                    Size(image.width.toDouble(), image.height.toDouble()),
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _BoxPainter extends CustomPainter {
  const _BoxPainter(this.box, this.imageSize, this.color);

  final BoundingBox box;
  final Size imageSize;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / imageSize.width;
    final scaleY = size.height / imageSize.height;

    canvas.drawRect(
      Rect.fromLTWH(
        box.x * scaleX,
        box.y * scaleY,
        box.width * scaleX,
        box.height * scaleY,
      ),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(_BoxPainter old) =>
      old.box != box || old.imageSize != imageSize || old.color != color;
}
