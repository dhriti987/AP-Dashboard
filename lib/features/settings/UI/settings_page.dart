import 'package:flutter/material.dart';
import 'package:streaming_data_dashboard/features/settings/UI/client_credentials_settings_widget.dart';
import 'package:streaming_data_dashboard/features/settings/UI/plants_settings_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List<Widget> settingWidgets = const [
    ClientCredentialSettings(),
    PlantsAndUnitSettings(),
  ];

  int currentSettings = 1;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: ListView(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (currentSettings == 0)
                        ? Colors.grey.shade400
                        : Colors.transparent,
                    elevation: 0,
                    foregroundColor: Colors.black,
                    fixedSize: Size.fromHeight(
                      size.height / 15,
                    ),
                    shadowColor: Colors.black12,
                    alignment: Alignment.centerLeft,
                  ),
                  child: Text(
                    "Client Credentials",
                    style: TextStyle(fontSize: size.height / 40),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (currentSettings == 1)
                        ? Colors.grey.shade400
                        : Colors.transparent,
                    elevation: 0,
                    foregroundColor: Colors.black,
                    fixedSize: Size.fromHeight(
                      size.height / 15,
                    ),
                    shadowColor: Colors.black12,
                    alignment: Alignment.centerLeft,
                  ),
                  child: Text(
                    "Plants",
                    style: TextStyle(fontSize: size.height / 40),
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(
            width: 20,
            thickness: 3,
            indent: 20,
            endIndent: 20,
            color: Colors.black12,
          ),
          Expanded(
            flex: 6,
            child: SizedBox(
              height: double.maxFinite,
              width: double.maxFinite,
              child: settingWidgets[currentSettings],
            ),
          )
        ],
      ),
    );
  }
}
