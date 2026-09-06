import 'package:boimetria/ui/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

const _radius = 16.0;

class AppSelectMenu<T> extends StatelessWidget {
  static const defaultWidth = 220.0;

  const AppSelectMenu({
    super.key,
    required this.options,
    required this.labelOf,
    required this.onSelected,
    required this.trigger,
    this.selected,
    this.leadingOf,
    this.width = defaultWidth,
    this.offset = Offset.zero,
  });

  final List<T> options;
  final T? selected;

  final String Function(T) labelOf;
  final Widget Function(T)? leadingOf;

  final ValueChanged<T> onSelected;

  final Widget trigger;

  final double width;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      onSelected: onSelected,
      position: PopupMenuPosition.under,
      tooltip: '',
      padding: EdgeInsets.zero,
      offset: offset,
      elevation: 3,
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      menuPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      constraints: BoxConstraints.tightFor(width: width),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radius),
      ),
      itemBuilder: (context) => [
        for (final option in options)
          PopupMenuItem<T>(
            value: option,
            padding: EdgeInsets.zero,
            height: 0,
            child: _Row(
              label: labelOf(option),
              leading: leadingOf?.call(option),
              selected: option == selected,
            ),
          ),
      ],
      child: trigger,
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.selected, this.leading});

  final String label;
  final Widget? leading;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final foreground = selected ? Colors.white : AppColors.text;

    return Container(
      color: selected ? AppColors.text : Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        spacing: 12,
        children: [
          if (leading case final leading?) leading,
          Expanded(
            child: Text(
              label,
              style: text.titleMedium?.copyWith(color: foreground),
            ),
          ),
          if (selected) Icon(Icons.check, color: foreground, size: 20),
        ],
      ),
    );
  }
}
