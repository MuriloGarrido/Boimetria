import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../core/widgets/app_header.dart';

class IdentifyResultScreen extends StatelessWidget {
  const IdentifyResultScreen({super.key, required this.photo});

  final Uint8List photo;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppHeader(),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
