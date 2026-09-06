import 'package:boimetria/l10n/app_locale.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localeProvider = NotifierProvider<LocaleController, Locale>(
  LocaleController.new,
);

class LocaleController extends Notifier<Locale> {
  @override
  Locale build() => AppLocale.options.first.locale;

  void select(Locale locale) => state = locale;
}
