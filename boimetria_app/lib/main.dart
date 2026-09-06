import 'package:boimetria/l10n/app_locale.dart';
import 'package:boimetria/l10n/generated/app_localizations.dart';
import 'package:boimetria/ui/core/state/locale_controller.dart';
import 'package:boimetria/ui/core/themes/app_theme.dart';
import 'package:boimetria/routing/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Boimetria',
      theme: AppTheme.light,
      routerConfig: router,
      locale: ref.watch(localeProvider),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocale.supported,
      builder: (context, child) {
        Intl.defaultLocale = Localizations.localeOf(context).toString();
        return child!;
      },
    );
  }
}
