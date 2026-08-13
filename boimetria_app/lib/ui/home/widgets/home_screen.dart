
import 'package:boimetria/ui/core/widgets/action_card.dart';
import 'package:boimetria/ui/core/widgets/app_header.dart';
import 'package:boimetria/ui/core/widgets/header_icon_button.dart';
import 'package:boimetria/ui/home/widgets/greeting_header.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        actions: [
          HeaderIconButton(icon: Icons.person_outline, onTap: () {}),
          const SizedBox(width: 10),
          HeaderIconButton(icon: Icons.notifications_outlined, onTap: () {}),
          const SizedBox(width: 20),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const GreetingHeader(
                username: "Seu Antônio",
                farmName: "Fazenda Santa Rita",
                animalCount: 1284,
              ),
              ActionCard.filled(
                icon: Icons.camera_alt_outlined,
                title: "Quem é esse boi?",
                description:
                    "Aponte a câmera no focinho — o app diz o brinco na hora",
                onTap: () {},
              ),
              ActionCard.outlined(
                icon: Icons.add,
                title: "Cadastrar um animal",
                description:
                    "Bezerro novo ou animal comprado que ainda não está no rebanho",
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
