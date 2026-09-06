import 'package:flutter/widgets.dart';

class LanguageOption {
  const LanguageOption({
    required this.locale,
    required this.name,
    required this.flag,
  });

  final Locale locale;
  final String name;
  final String flag;
}

abstract class AppLocale {
  static const options = [
    LanguageOption(
      locale: Locale('pt', 'BR'),
      name: 'Português',
      flag: '\u{1F1E7}\u{1F1F7}',
    ),
    LanguageOption(
      locale: Locale('en', 'US'),
      name: 'English',
      flag: '\u{1F1FA}\u{1F1F8}',
    ),
  ];

  static Iterable<Locale> get supported => options.map((o) => o.locale);
}
