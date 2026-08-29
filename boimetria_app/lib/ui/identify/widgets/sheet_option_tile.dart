import 'package:flutter/material.dart';

import '../../core/themes/app_colors.dart';

class SheetOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;

  static const double _iconSize = 40;

  const SheetOptionTile._({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor,
  });

  const SheetOptionTile.filled({
    Key? key,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) : this._(
         key: key,
         icon: icon,
         title: title,
         description: description,
         onTap: onTap,
         backgroundColor: AppColors.primary,
         foregroundColor: Colors.white,
       );

  const SheetOptionTile.outlined({
    Key? key,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) : this._(
         key: key,
         icon: icon,
         title: title,
         description: description,
         onTap: onTap,
         backgroundColor: Colors.white,
         foregroundColor: AppColors.text,
         borderColor: AppColors.text,
       );

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Material(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: borderColor ?? Colors.transparent,
          width: borderColor == null ? 0 : 2.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(26),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: foregroundColor, size: _iconSize),
              const SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: text.headlineSmall?.copyWith(color: foregroundColor),
                  ),
                  const SizedBox(width: 8),
                  Text(description,
                  style: text.bodyLarge?.copyWith(color: foregroundColor.withValues(alpha: 0.9)),)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
