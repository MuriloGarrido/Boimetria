import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

class ActionCard extends StatelessWidget {
  const ActionCard._({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    required this.backgroundColor,
    required this.foregroundColor,
    this.iconPadding = EdgeInsets.zero,
    this.borderColor,
    this.iconBackgroundColor,
  });

  const ActionCard.filled({
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

  const ActionCard.outlined({
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

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color foregroundColor;
  final EdgeInsetsGeometry iconPadding;

  static const double _iconSize = 40;
  final Color? borderColor;
  final Color? iconBackgroundColor;

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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: iconPadding,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: foregroundColor, size: _iconSize),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: text.headlineMedium?.copyWith(color: foregroundColor),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: text.bodyLarge?.copyWith(
                  color: foregroundColor.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
