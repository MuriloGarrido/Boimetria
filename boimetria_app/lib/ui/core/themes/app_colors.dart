import 'package:flutter/material.dart';

abstract class AppColors {
  static const background = Colors.white; // fundo das telas
  static const appbar = Colors.white; // fundo das telas
  static const text = Color(0xFF1A1A1A); // texto principal
  static const primary = Color(0xFF15803D); // verde Boimetria / match
  static const error = Color(0xFFC81E1E); // sem match / erro
  static const warning = Color(0xFFC05600); // aviso / re-scan
  static const border = Color(0xFFCFC9BF); // bordas / desabilitado

  static const surface = Color(0xFFF2F0ED); // fundo neutro / placeholder

  // superficies claras, para o fundo de cards que acompanham as cores acima
  static const primarySurface = Color(0xFFF3F9F5); // fundo de sucesso
  static const warningSurface = Color(0xFFFEFAF6); // fundo de aviso
  static const errorSurface = Color(0xFFFDF6F5); // fundo de erro
}
