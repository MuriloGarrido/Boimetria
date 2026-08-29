import 'package:boimetria/domain/models/animal/animal.dart';
import 'package:boimetria/ui/core/widgets/app_header.dart';
import 'package:boimetria/ui/core/widgets/field_button.dart';
import 'package:boimetria/ui/core/widgets/field_choice.dart';
import 'package:boimetria/ui/core/widgets/field_input.dart';
import 'package:flutter/material.dart';

class RegisterAnimalScreen extends StatelessWidget {
  const RegisterAnimalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const AppHeader(),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 72,
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          color: Colors.grey,
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
            const _Box(100),
            FieldInput(
              label: "IDENTIFICADOR",
              placeholder: "Digite o número",
              value: "BR-4822",
              suffix: "teste",
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
                label: "NASCIMENTO",
                placeholder: "dd/mm/aaaa",
                value: "14/03/2024",
                required: true,
                onTap: () {},
              ),
              FieldButton(
                label: "RAÇA",
                placeholder: "escolher",
                value: "Nelore",
                required: true,
                onTap: () {},
              ),
            ),
            _Pair(
              FieldInput(
                label: "PESO",
                placeholder: "Digite",
                value: "248",
                keyboardType: TextInputType.number,
                onChanged: (_) {},
                required: true,
              ),
              FieldButton(
                label: "PELAGEM",
                placeholder: "escolher",
                value: "Branca",
                onTap: () {},
                onClear: () {},
              ),
            ),
            _Pair(
              FieldButton(
                label: "PASTO",
                placeholder: "escolher",
                value: "Pasto 7",
                onTap: () {},
                onClear: () {},
              ),
              FieldButton(
                label: "MÃE",
                placeholder: "buscar",
                value: "BR-3110",
                onTap: () {},
                onClear: () {},
              ),
            ),
            _Pair(
              FieldButton(
                label: "PAI",
                placeholder: "buscar",
                value: "BR-2087",
                onTap: () {},
                onClear: () {},
              ),
              FieldButton(
                label: "ENTRADA",
                placeholder: "hoje",
                value: "Hoje",
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

  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
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

class _Box extends StatelessWidget {
  const _Box(this.height);

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(height: height, color: Colors.grey);
  }
}
