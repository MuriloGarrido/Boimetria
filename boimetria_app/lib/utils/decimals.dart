import 'package:intl/intl.dart';

abstract class Decimals {
  /// Getter e nao `static final`: um campo estatico guardaria o formato lido na
  /// primeira chamada para o resto da execucao — e quem chama primeiro decide
  /// o locale. Sem argumento, usa o Intl.defaultLocale definido no main.
  static NumberFormat get _format => NumberFormat.decimalPattern();

  /// A virgula no pt_BR, o ponto em locales que usam ponto. E' o separador que
  /// o [tryParse] entende, e o unico que deve chegar ate' aqui.
  static String get separator => _format.symbols.DECIMAL_SEP;

  /// Aceita "248,5" e "1.248,5". Devolve nulo se estiver vazio ou invalido.
  static double? tryParse(String value) {
    if (value.trim().isEmpty) return null;
    try {
      return _format.parse(value).toDouble();
    } on FormatException {
      return null;
    }
  }

  static String format(double value) => _format.format(value);
}
