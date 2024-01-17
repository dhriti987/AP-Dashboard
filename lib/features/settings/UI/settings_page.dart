import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.amber,
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }
}
