import 'dart:typed_data';

import 'package:boimetria/domain/models/detection/muzzle_detection.dart';
import 'package:boimetria/domain/models/detection/muzzle_state.dart';
import 'package:boimetria/domain/thresholds.dart';
import 'package:boimetria/ui/core/themes/app_colors.dart';
import 'package:boimetria/ui/core/widgets/app_button.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

const _radius = 16.0;
const _side = 122.0;
const _innerRadius = 12.0;

class MuzzleCard extends StatelessWidget {
  const MuzzleCard({super.key, required this.state, required this.onRead});

  final MuzzleState state;
  final VoidCallback onRead;

  @override
  Widget build(BuildContext context) => switch (state) {
    MuzzleMissing() => _Missing(onTap: onRead),
    MuzzleDetecting() => _Detecting(onTap: onRead),
    MuzzleCaptured(:final detection) => _Ok(detection, onTap: onRead),
    MuzzleLowConfidence(:final detection) => _Weak(detection, onTap: onRead),
    MuzzleFailed(:final reason) => _Failed(reason, onTap: onRead),
  };
}

class _Missing extends StatelessWidget {
  const _Missing({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Dashed(
      color: AppColors.warning,
      child: _Body(
        surface: AppColors.warningSurface,
        onTap: onTap,
        leading: const _EmptyBox(dashed: true),
        title: "BIOMETRIA FALTANDO",
        color: AppColors.warning,
        description: "Sem a foto do focinho não dá pra salvar",
        action: const _Action(label: "LER FOCINHO"),
      ),
    );
  }
}

class _Detecting extends StatelessWidget {
  const _Detecting({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Solid(
      color: AppColors.border,
      child: _Body(
        surface: AppColors.surface,
        onTap: onTap,
        centered: true,
        leading: const _SpinnerBox(),
        title: "LENDO O FOCINHO",
        color: AppColors.text,
        description: "Aguarde um instante",
      ),
    );
  }
}

class _Ok extends StatelessWidget {
  const _Ok(this.detection, {required this.onTap});

  final MuzzleDetected detection;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Solid(
      color: AppColors.primary,
      child: _Body(
        surface: AppColors.primarySurface,
        onTap: onTap,
        leading: _PhotoBox(detection.croppedImage),
        title: "BIOMETRIA ${detection.confidence.percent}%",
        color: AppColors.primary,
        description:
            "Mínimo é ${Thresholds.muzzleConfidence.percent}% — pode salvar",
        bar: _ConfidenceBar(
          value: detection.confidence.value,
          color: AppColors.primary,
        ),
        action: const _Action(label: "REFAZER FOTO", outlined: true),
      ),
    );
  }
}

class _Weak extends StatelessWidget {
  const _Weak(this.detection, {required this.onTap});

  final MuzzleDetected detection;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Solid(
      color: AppColors.error,
      child: _Body(
        surface: AppColors.errorSurface,
        onTap: onTap,
        leading: _PhotoBox(detection.croppedImage),
        title: "BIOMETRIA ${detection.confidence.percent}%",
        color: AppColors.error,
        description:
            "Mínimo é ${Thresholds.muzzleConfidence.percent}% — refaça a foto",
        bar: _ConfidenceBar(
          value: detection.confidence.value,
          color: AppColors.error,
        ),
        action: const _Action(label: "REFAZER FOTO"),
      ),
    );
  }
}

class _Failed extends StatelessWidget {
  const _Failed(this.reason, {required this.onTap});

  final String reason;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Solid(
      color: AppColors.error,
      child: _Body(
        surface: AppColors.errorSurface,
        onTap: onTap,
        leading: const _EmptyBox(),
        title: "NÃO DEU PRA LER",
        color: AppColors.error,
        description: reason,
        action: const _Action(label: "TENTAR DE NOVO"),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.surface,
    required this.onTap,
    required this.leading,
    required this.title,
    required this.color,
    required this.description,
    this.bar,
    this.action,
    this.centered = false,
  });

  final Color surface;
  final VoidCallback onTap;
  final Widget leading;
  final String title;
  final Color color;
  final String description;
  final Widget? bar;
  final Widget? action;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Material(
      color: surface,
      borderRadius: BorderRadius.circular(_radius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: centered
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            spacing: 14,
            children: [
              leading,
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text(title, style: text.titleMedium?.copyWith(color: color)),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodyMedium,
                    ),
                    if (bar case final bar?) ...[
                      const SizedBox(height: 6),
                      bar,
                    ],
                    if (action case final action?) ...[
                      const SizedBox(height: 4),
                      action,
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Solid extends StatelessWidget {
  const _Solid({required this.color, required this.child});

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(_radius),
      ),
      child: child,
    );
  }
}

class _Dashed extends StatelessWidget {
  const _Dashed({required this.color, required this.child});

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        radius: const Radius.circular(_radius),
        color: color,
        strokeWidth: 2,
        dashPattern: const [6, 4],
        padding: EdgeInsets.zero,
      ),
      child: child,
    );
  }
}

class _PhotoBox extends StatelessWidget {
  const _PhotoBox(this.bytes);

  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _side,
      height: _side,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_innerRadius),
        child: Image.memory(bytes, fit: BoxFit.cover),
      ),
    );
  }
}

class _EmptyBox extends StatelessWidget {
  const _EmptyBox({this.dashed = false});

  final bool dashed;

  @override
  Widget build(BuildContext context) {
    final box = ClipRRect(
      borderRadius: BorderRadius.circular(_innerRadius),
      child: const ColoredBox(
        color: AppColors.surface,
        child: Center(
          child: Icon(
            Icons.photo_camera_outlined,
            color: AppColors.border,
            size: 28,
          ),
        ),
      ),
    );

    return SizedBox(
      width: _side,
      height: _side,
      child: dashed
          ? DottedBorder(
              options: RoundedRectDottedBorderOptions(
                radius: const Radius.circular(_innerRadius),
                color: AppColors.border,
                strokeWidth: 1.5,
                dashPattern: const [5, 3],
                padding: EdgeInsets.zero,
              ),
              child: box,
            )
          : box,
    );
  }
}

class _SpinnerBox extends StatelessWidget {
  const _SpinnerBox();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _side,
      height: _side,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_innerRadius),
        child: const ColoredBox(
          color: AppColors.surface,
          child: Center(
            child: SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColors.text,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({required this.label, this.outlined = false});

  final String label;
  final bool outlined;

  static const _padding = EdgeInsets.symmetric(vertical: 10);

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleMedium;

    return SizedBox(
      width: double.infinity,
      child: IgnorePointer(
        child: outlined
            ? AppButton.outlined(
                label: label,
                onPressed: () {},
                padding: _padding,
                radius: _innerRadius,
                textStyle: style,
              )
            : AppButton.filled(
                label: label,
                onPressed: () {},
                padding: _padding,
                radius: _innerRadius,
                textStyle: style,
              ),
      ),
    );
  }
}

class _ConfidenceBar extends StatelessWidget {
  const _ConfidenceBar({required this.value, required this.color});

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: value,
      minHeight: 8,
      borderRadius: BorderRadius.circular(4),
      backgroundColor: AppColors.surface,
      valueColor: AlwaysStoppedAnimation(color),
    );
  }
}
