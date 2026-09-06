import 'package:boimetria/ui/core/formatters/decimal_input_formatter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  setUp(() => Intl.defaultLocale = 'pt_BR');

  const formatter = DecimalInputFormatter();

  /// Simula uma digitacao com o cursor no fim, que e' o caso normal.
  TextEditingValue typed(String text) => TextEditingValue(
    text: text,
    selection: TextSelection.collapsed(offset: text.length),
  );

  TextEditingValue apply(String older, String newer) =>
      formatter.formatEditUpdate(typed(older), typed(newer));

  test('aceita digitos', () {
    expect(apply('24', '248').text, '248');
  });

  test('troca o ponto do teclado pelo separador do locale', () {
    expect(apply('248', '248.').text, '248,');
    expect(apply('248.', '248.5').text, '248,5');
  });

  test('mantem o separador do locale', () {
    expect(apply('248', '248,').text, '248,');
  });

  test('rejeita letras e sinais', () {
    expect(apply('248', '248a').text, '248');
    expect(apply('248', '-248').text, '248');
  });

  test('rejeita o segundo separador', () {
    expect(apply('248,5', '248,5,').text, '248,5');
  });

  test('rejeita mais casas do que o permitido', () {
    expect(apply('248,5', '248,55').text, '248,5');
    expect(apply('1248', '12485').text, '1248');
  });

  test('aceita o campo vazio', () {
    expect(apply('2', '').text, '');
  });

  test('preserva o cursor: a troca nao muda o comprimento', () {
    // Cursor no meio, entre o 4 e o 8, e a pessoa digita o separador.
    const older = TextEditingValue(
      text: '2485',
      selection: TextSelection.collapsed(offset: 3),
    );
    const newer = TextEditingValue(
      text: '248.5',
      selection: TextSelection.collapsed(offset: 4),
    );

    final result = formatter.formatEditUpdate(older, newer);

    expect(result.text, '248,5');
    expect(result.selection.baseOffset, 4);
  });
}
