import 'package:boimetria/ui/core/themes/app_colors.dart';
import 'package:boimetria/ui/core/widgets/field_box.dart';
import 'package:flutter/material.dart';

class PickerField extends StatelessWidget {
  const PickerField({
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
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final valueStyle = FieldBox.valueStyle(context, emphasis);
    final filled = value != null;
    final clearable = filled && onClear != null;

    return FieldBox(
      label: label,
      required: required,
      emphasis: emphasis,
      onTap: onTap,
      trailing: clearable
          ? InkWell(
              onTap: onClear,
              customBorder: const CircleBorder(),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.close, size: 20, color: AppColors.text),
              ),
            )
          : const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.keyboard_arrow_down,
                size: 22,
                color: AppColors.text,
              ),
            ),
      child: Text(
        value ?? placeholder,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: valueStyle?.copyWith(color: filled ? null : AppColors.border),
      ),
    );
  }
}
