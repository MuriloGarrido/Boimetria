import 'package:boimetria/ui/core/widgets/action_card.dart';
import 'package:boimetria/ui/core/widgets/app_header.dart';
import 'package:boimetria/ui/core/widgets/header_icon_button.dart';
import 'package:boimetria/ui/core/widgets/app_select_menu.dart';
import 'package:boimetria/domain/entities/identify_input.dart';
import 'package:boimetria/ui/core/widgets/image_source_sheet.dart';
import 'package:boimetria/l10n/app_locale.dart';
import 'package:boimetria/l10n/generated/app_localizations.dart';
import 'package:boimetria/ui/core/state/locale_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

const _flagSize = 24.0;
const _triggerWidth = 52.0;
const _menuGap = 6.0;

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppHeader(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: AppSelectMenu<LanguageOption>(
              options: AppLocale.options,
              selected: AppLocale.options
                  .where((o) => o.locale == ref.watch(localeProvider))
                  .firstOrNull,
              labelOf: (option) => option.name,
              leadingOf: (option) => Text(
                option.flag,
                style: const TextStyle(fontSize: _flagSize),
              ),
              onSelected: (option) =>
                  ref.read(localeProvider.notifier).select(option.locale),
              offset: const Offset(
                _triggerWidth - AppSelectMenu.defaultWidth,
                _menuGap,
              ),
              trigger: const HeaderIconButton(
                icon: Icons.language,
                onTap: null,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.homeQuestion,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              ActionCard.filled(
                icon: Icons.camera_alt_outlined,
                title: l10n.homeIdentifyTitle,
                description: l10n.homeIdentifyDescription,
                onTap: () => _onIdentifyTap(context),
              ),
              ActionCard.outlined(
                icon: Icons.add,
                title: l10n.homeRegisterTitle,
                description: l10n.homeRegisterDescription,
                onTap: () => context.push('/register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onIdentifyTap(BuildContext context) async {
    final source = await ImageSourceSheet.show(context);
    if (source == null) return;

    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;

    final bytes = await image.readAsBytes();
    if (!context.mounted) return;

    context.push(
      '/identify',
      extra: IdentifyInput(bytes: bytes, kind: ImageKind.raw),
    );
  }
}
