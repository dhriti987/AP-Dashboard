import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: IconButton(onPressed: (){}, icon: const Icon(Icons.settings_suggest_outlined, size: 40,)),
      )]),
    );
  }
}