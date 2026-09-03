import 'package:boimetria/ui/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

/// A casca comum dos campos: moldura, padding e o label com a marca de
/// obrigatorio.
///
/// [emphasis] aqui decide so' a borda. O tamanho do texto do valor e' decidido
/// por quem monta o [child], que e' quem sabe o que esta' desenhando.
class FieldBox extends StatelessWidget {
  const FieldBox({
    super.key,
    required this.label,
    required this.child,
    this.required = false,
    this.emphasis = false,
    this.onTap,
    this.trailing,
  });

  final String label;

  /// O conteudo abaixo do label: campo de texto, valor, opcoes.
  final Widget child;

  final bool required;
  final bool emphasis;

  /// Nulo = caixa nao clicavel.
  final VoidCallback? onTap;

  /// Widget colado a direita, alinhado ao centro da caixa: sufixo, chevron, X.
  final Widget? trailing;

  /// O estilo do valor. Fica aqui junto da regra da borda: as duas sao o que
  /// [emphasis] significa.
  static TextStyle? valueStyle(BuildContext context, bool emphasis) {
    final text = Theme.of(context).textTheme;
    return emphasis ? text.headlineSmall : text.titleMedium;
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

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
                    child,
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
