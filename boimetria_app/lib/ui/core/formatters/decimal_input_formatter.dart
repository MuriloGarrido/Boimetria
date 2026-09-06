import 'package:boimetria/utils/decimals.dart';
import 'package:flutter/services.dart';

/// Deixa passar so' o que forma um numero decimal: digitos e no maximo um
/// separador.
///
/// Normaliza antes de validar. O teclado numerico entrega '.' ou ',' conforme
/// o IME do aparelho, nao conforme o locale do app — rejeitar o separador
/// "errado" faria a tecla parecer quebrada. Depois daqui, so' o separador do
/// locale circula pelo app.
class DecimalInputFormatter extends TextInputFormatter {
  const DecimalInputFormatter({this.integerDigits = 4, this.decimalDigits = 1});

  /// Quatro inteiros cobrem qualquer peso de bovino.
  final int integerDigits;
  final int decimalDigits;

  static final _separators = RegExp(r'[.,]');

  /// Getter pelo mesmo motivo do [Decimals.separator]: preso num `static
  /// final` ficaria com o separador do primeiro locale lido, para sempre.
  RegExp get _pattern {
    final separator = RegExp.escape(Decimals.separator);
    return RegExp(
      '^\\d{0,$integerDigits}($separator\\d{0,$decimalDigits})?' r'$',
    );
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue older,
    TextEditingValue newer,
  ) {
    final normalized = newer.text.replaceAll(
      _separators,
      Decimals.separator,
    );

    if (!_pattern.hasMatch(normalized)) return older;

    // Troca de um caractere por outro: o comprimento nao muda, entao os
    // offsets de `newer.selection` continuam apontando para o mesmo lugar.
    return newer.copyWith(text: normalized);
  }
}
