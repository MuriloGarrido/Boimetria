import 'package:boimetria/ui/core/themes/app_colors.dart';
import 'package:boimetria/ui/core/widgets/field_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FieldInput extends StatefulWidget {
  const FieldInput({
    super.key,
    required this.label,
    required this.placeholder,
    required this.onChanged,
    this.value,
    this.required = false,
    this.keyboardType,
    this.inputFormatters,
    this.suffix,
    this.emphasis = false,
  });

  final String label;
  final String? value;
  final String placeholder;
  final bool required;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;

  final List<TextInputFormatter>? inputFormatters;

  final String? suffix;
  final bool emphasis;

  @override
  State<FieldInput> createState() => _FieldInputState();
}

class _FieldInputState extends State<FieldInput> {
  late final _controller = TextEditingController(text: widget.value);

  @override
  void didUpdateWidget(FieldInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final valueStyle = FieldBox.valueStyle(context, widget.emphasis);

    return FieldBox(
      label: widget.label,
      required: widget.required,
      emphasis: widget.emphasis,
      trailing: widget.suffix == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                widget.suffix!,
                style: valueStyle?.copyWith(
                  fontSize: (valueStyle.fontSize ?? 16) + 3,
                ),
              ),
            ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        style: valueStyle,
        decoration: InputDecoration(
          hintText: widget.placeholder,
          hintStyle: valueStyle?.copyWith(color: AppColors.border),
          border: InputBorder.none,
          isDense: true,
          isCollapsed: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
