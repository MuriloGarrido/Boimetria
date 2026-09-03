import 'package:boimetria/ui/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;

  final EdgeInsetsGeometry? padding;
  final double? radius;
  final TextStyle? textStyle;

  static const _padding = EdgeInsets.symmetric(vertical: 18);
  static const _radius = 20.0;

  const AppButton._({
    super.key,
    required this.label,
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor,
    this.padding,
    this.radius,
    this.textStyle,
  });

  const AppButton.filled({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    EdgeInsetsGeometry? padding,
    double? radius,
    TextStyle? textStyle,
  }) : this._(
         key: key,
         label: label,
         onPressed: onPressed,
         backgroundColor: AppColors.primary,
         foregroundColor: Colors.white,
         padding: padding,
         radius: radius,
         textStyle: textStyle,
       );

  const AppButton.outlined({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    EdgeInsetsGeometry? padding,
    double? radius,
    TextStyle? textStyle,
  }) : this._(
         key: key,
         label: label,
         onPressed: onPressed,
         backgroundColor: Colors.white,
         foregroundColor: AppColors.text,
         borderColor: AppColors.border,
         padding: padding,
         radius: radius,
         textStyle: textStyle,
       );

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final enabled = onPressed != null;

    final foreground = enabled
        ? foregroundColor
        : foregroundColor.withValues(alpha: 0.4);

    final style = (textStyle ?? text.headlineSmall)?.copyWith(
      color: foreground,
    );

    return Material(
      color: enabled
          ? backgroundColor
          : Color.alphaBlend(
              Colors.white.withValues(alpha: 0.6),
              backgroundColor,
            ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius ?? _radius),
        side: BorderSide(
          color: borderColor ?? Colors.transparent,
          width: borderColor == null ? 0 : 2.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: padding ?? _padding,
          child: Text(label, textAlign: TextAlign.center, style: style),
        ),
      ),
    );
  }
}
