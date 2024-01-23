import 'package:flutter/material.dart';
import 'package:streaming_data_dashboard/models/plant_model.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.plant});

  final Plant plant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${plant.name} Dashboard"),
        centerTitle: true,
      ),
    );
  }
}
