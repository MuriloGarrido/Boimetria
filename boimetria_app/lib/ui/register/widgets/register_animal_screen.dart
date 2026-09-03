import 'package:boimetria/domain/models/animal/animal.dart';
import 'package:boimetria/domain/models/detection/muzzle_state.dart';
import 'package:boimetria/ui/core/widgets/app_button.dart';
import 'package:boimetria/ui/core/widgets/app_header.dart';
import 'package:boimetria/ui/core/widgets/field_button.dart';
import 'package:boimetria/ui/core/widgets/field_choice.dart';
import 'package:boimetria/ui/core/widgets/field_input.dart';
import 'package:boimetria/ui/register/widgets/muzzle_card.dart';
import 'package:flutter/material.dart';

class RegisterAnimalScreen extends StatelessWidget {
  const RegisterAnimalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const AppHeader(),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: AppButton.filled(label: "SALVAR", onPressed: () {}),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 10,
          children: [
            Text("Cadastrar animal", style: text.headlineLarge),
            Text(
              "Toque num campo para corrigir. Depois salve.",
              style: text.bodyLarge,
            ),
            MuzzleCard(state: const MuzzleMissing(), onRead: () {}),
            FieldInput(
              label: "IDENTIFICADOR",
              placeholder: "Digite o número",
              value: "BR-4822",
              required: true,
              emphasis: true,
              onChanged: (_) {},
            ),
            FieldChoice<Sex>(
              label: "SEXO",
              options: Sex.values,
              labelOf: (s) => switch (s) {
                Sex.male => "MACHO",
                Sex.female => "FÊMEA",
              },
              selected: Sex.male,
              required: true,
              onChanged: (_) {},
            ),
            _Pair(
              FieldButton(
                label: "ENTRADA",
                placeholder: "hoje",
                value: "Hoje",
                required: true,
                onTap: () {},
              ),
              FieldButton(
                label: "NASCIMENTO",
                placeholder: "dd/mm/aaaa",
                value: "14/03/2024",
                onTap: () {},
              ),
            ),
            _Pair(
              FieldInput(
                label: "PESO",
                placeholder: "Digite",
                value: "248",
                suffix: "kg",
                keyboardType: TextInputType.number,
                onChanged: (_) {},
              ),
              FieldButton(
                label: "RAÇA",
                placeholder: "escolher",
                value: "Nelore",
                onTap: () {},
              ),
            ),
            _Pair(
              FieldButton(
                label: "PELAGEM",
                placeholder: "escolher",
                value: "Branca",
                onTap: () {},
                onClear: () {},
              ),
              FieldButton(
                label: "PASTO",
                placeholder: "escolher",
                value: "Pasto 7",
                onTap: () {},
                onClear: () {},
              ),
            ),
            _Pair(
              FieldButton(
                label: "MÃE",
                placeholder: "buscar",
                value: "BR-3110",
                onTap: () {},
                onClear: () {},
              ),
              FieldButton(
                label: "PAI",
                placeholder: "buscar",
                value: "BR-2087",
                onTap: () {},
                onClear: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pair extends StatelessWidget {
  const _Pair(this.left, this.right);

  /// Acima disso os dois campos nao cabem lado a lado sem truncar o valor.
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
