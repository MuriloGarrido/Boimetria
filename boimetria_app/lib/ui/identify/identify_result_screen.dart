import 'package:flutter/material.dart';

import '../../domain/models/identify/identify_input.dart';
import '../core/widgets/app_header.dart';

class IdentifyResultScreen extends StatelessWidget {
  const IdentifyResultScreen({super.key, required this.input});

  final IdentifyInput input;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppHeader(),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
