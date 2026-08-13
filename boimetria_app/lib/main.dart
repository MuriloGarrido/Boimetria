import 'package:boimetria/ui/home/widgets/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:boimetria/ui/core/themes/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boimetria',
      theme: AppTheme.light,
      home: const HomeScreen(),
    );
  }
}
