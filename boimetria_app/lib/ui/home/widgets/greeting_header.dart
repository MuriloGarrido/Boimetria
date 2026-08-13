import 'package:flutter/material.dart';

class GreetingHeader extends StatelessWidget {
  const GreetingHeader({
    super.key,
    required this.username,
    required this.farmName,
    required this.animalCount
  });

  final String username;
  final String farmName;
  final int animalCount;



  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Text("Bom dia, \n$username", style: text.headlineLarge,),
      Text("$farmName . $animalCount animais", style: text.bodyLarge,)
      ]
     
      
    );
  }
}
