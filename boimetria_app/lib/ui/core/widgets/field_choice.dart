import 'package:boimetria/ui/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

/// Escolha única entre poucas opções, todas visíveis ao mesmo tempo.
///
/// Genérico em vez de preso a `Enum`: amarrar a enum não dispensaria o
/// [labelOf] e fecharia a porta para opções que não são enum. Pensado para
/// 2-3 opções.
class FieldChoice<T> extends StatelessWidget {
  const FieldChoice({
    super.key,
    required this.label,
    required this.options,
    required this.labelOf,
    required this.onChanged,
    this.selected,
    this.required = false,
    this.emphasis = false,
  });

  final String label;
  final List<T> options;

  /// O texto de cada opção. Fica fora do domínio de propósito: `Sex.male` não
  /// sabe que se chama "MACHO" na tela.
  final String Function(T) labelOf;

  final T? selected;
  final ValueChanged<T> onChanged;
  final bool required;

  /// Borda grossa e escura, opções maiores — o campo âncora da tela.
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final optionStyle = emphasis ? text.headlineSmall : text.titleMedium;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: emphasis ? AppColors.text : AppColors.border,
          width: emphasis ? 2.5 : 1.5,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
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
          const SizedBox(height: 8),
          Row(
            spacing: 10,
            children: [
              for (final option in options)
                Expanded(
                  child: _Option(
                    label: labelOf(option),
                    selected: option == selected,
                    style: optionStyle,
                    onTap: () => onChanged(option),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.label,
    required this.selected,
    required this.style,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final TextStyle? style;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.text : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: selected ? AppColors.text : AppColors.border,
          width: 1.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style?.copyWith(
              color: selected ? Colors.white : AppColors.text,
            ),
          ),
        ),
      ),
    );
  }
}
