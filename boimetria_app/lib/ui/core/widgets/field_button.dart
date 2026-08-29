import 'package:boimetria/ui/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class FieldButton extends StatelessWidget {
  const FieldButton({
    super.key,
    required this.label,
    required this.placeholder,
    required this.onTap,
    this.value,
    this.required = false,
    this.emphasis = false,
    this.onClear,
  });

  final String label;

  final String? value;

  final String placeholder;
  final bool required;
  final VoidCallback onTap;

  final bool emphasis;

  /// Nulo = campo nao limpavel. Obrigatorio nao passa.
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final valueStyle = emphasis ? text.headlineSmall : text.titleMedium;
    final filled = value != null;
    final clearable = filled && onClear != null;

    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: emphasis ? AppColors.text : AppColors.border,
          width: emphasis ? 2.5 : 1.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: label,
                        style: text.labelMedium,
                        children: [
                          if (required)
                            const WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Text(
                      value ?? placeholder,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: valueStyle?.copyWith(
                        color: filled ? null : AppColors.border,
                      ),
                    ),
                  ],
                ),
              ),
              if (clearable)
                InkWell(
                  onTap: onClear,
                  customBorder: const CircleBorder(),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.close, size: 20, color: AppColors.text),
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 22,
                    color: AppColors.text,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
