import 'package:boimetria/domain/entities/animal.dart';
import 'package:boimetria/ui/core/formatters/decimal_input_formatter.dart';
import 'package:boimetria/ui/core/widgets/app_button.dart';
import 'package:boimetria/ui/core/widgets/app_header.dart';
import 'package:boimetria/ui/core/widgets/choice_field.dart';
import 'package:boimetria/ui/core/widgets/date_field.dart';
import 'package:boimetria/ui/core/widgets/image_source_sheet.dart';
import 'package:boimetria/ui/core/widgets/input_field.dart';
import 'package:boimetria/ui/register/view_models/register_animal_view_model.dart';
import 'package:boimetria/ui/register/widgets/muzzle_card.dart';
import 'package:boimetria/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class RegisterAnimalScreen extends ConsumerWidget {
  const RegisterAnimalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(registerAnimalProvider);
    final vm = ref.read(registerAnimalProvider.notifier);

    return Scaffold(
      appBar: const AppHeader(),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: AppButton.filled(
            label: l10n.registerSave,
            onPressed: state.canSave ? () {} : null,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 10,
          children: [
            Text(l10n.registerTitle, style: text.headlineLarge),
            Text(
              l10n.registerSubtitle,
              style: text.bodyLarge,
            ),
            MuzzleCard(state: state.muzzle, onRead: () => _onRead(context, vm)),
            InputField(
              label: l10n.registerTagLabel,
              placeholder: l10n.registerTagPlaceholder,
              value: state.tag,
              required: true,
              emphasis: true,
              onChanged: vm.setTag,
            ),
            ChoiceField<Sex>(
              label: l10n.registerSexLabel,
              options: Sex.values,
              labelOf: (s) => switch (s) {
                Sex.male => l10n.registerSexMale,
                Sex.female => l10n.registerSexFemale,
              },
              selected: state.sex,
              required: true,
              onChanged: vm.setSex,
            ),
            _Pair(
              DateField(
                label: l10n.registerEntryDateLabel,
                value: state.entryDate,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                required: true,
                onChanged: vm.setEntryDate,
              ),
              DateField(
                label: l10n.registerBirthDateLabel,
                value: state.birthDate,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                onChanged: vm.setBirthDate,
              ),
            ),
            _Pair(
              InputField(
                label: l10n.registerWeightLabel,
                placeholder: l10n.registerWeightPlaceholder,
                value: state.weightText,
                suffix: l10n.unitKilogram,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: const [DecimalInputFormatter()],
                onChanged: vm.setWeight,
              ),
              const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onRead(
    BuildContext context,
    RegisterAnimalViewModel vm,
  ) async {
    final source = await ImageSourceSheet.show(context);
    if (source == null) return;

    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;

    vm.readMuzzle(await image.readAsBytes());
  }
}

class _Pair extends StatelessWidget {
  const _Pair(this.left, this.right);

  static const _limiteDeEscala = 1.3;

  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    final escala = MediaQuery.textScalerOf(context).scale(1);

    if (escala > _limiteDeEscala) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 10,
        children: [left, right],
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 10,
        children: [
          Expanded(child: left),
          Expanded(child: right),
        ],
      ),
    );
  }
}
