import 'package:boimetria/ui/core/themes/app_colors.dart';
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
    final text = Theme.of(context).textTheme;
    final valueStyle = widget.emphasis ? text.headlineSmall : text.titleMedium;

    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: widget.emphasis ? AppColors.text : AppColors.border,
          width: widget.emphasis ? 2.5 : 1.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
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
                      text: widget.label,
                      style: text.labelMedium,
                      children: [
                        if (widget.required)
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
                  TextField(
                    controller: _controller,
                    onChanged: widget.onChanged,
                    keyboardType: widget.keyboardType,
                    inputFormatters: widget.inputFormatters,
                    style: valueStyle,
                    decoration: InputDecoration.collapsed(
                      hintText: widget.placeholder,
                      hintStyle: valueStyle?.copyWith(color: AppColors.border),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.suffix != null) ...[
              const SizedBox(width: 10),
              Text(
                widget.suffix!,
                style: valueStyle?.copyWith(
                  fontSize: (valueStyle.fontSize ?? 16) + 3,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
