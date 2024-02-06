import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_data_dashboard/features/settings/UI/client_credentials_settings_widget.dart';
import 'package:streaming_data_dashboard/features/settings/UI/plants_settings_widget.dart';
import 'package:streaming_data_dashboard/features/settings/UI/users_settings_widget.dart';
import 'package:streaming_data_dashboard/features/settings/bloc/settings_bloc.dart';
import 'package:streaming_data_dashboard/service_locator.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List<Widget> settingWidgets = [
    const ClientCredentialSettings(),
    PlantsAndUnitSettings(),
    UsersSettings(),
  ];

  final SettingsBloc settingsBloc = sl.get<SettingsBloc>();

  int currentSettings = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<SettingsBloc, SettingsState>(
      bloc: settingsBloc,
      listenWhen: (previous, current) => current is SettingsActionState,
      buildWhen: (previous, current) => current is! SettingsActionState,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is TabChangeState) {
          currentSettings = state.index;
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text("Settings"),
            centerTitle: true,
          ),
          body: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ListView(
                      shrinkWrap: true,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            settingsBloc.add(TabChangeEvent(index: 0));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: (currentSettings == 0)
                                ? Colors.grey.shade400
                                : Colors.transparent,
                            elevation: 0,
                            foregroundColor: Colors.black,
                            fixedSize: Size.fromHeight(
                              size.height / 20,
                            ),
                            shadowColor: Colors.black12,
                            alignment: Alignment.centerLeft,
                          ),
                          child: Text(
                            "Client Credentials",
                            style: TextStyle(fontSize: size.height / 50),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            settingsBloc.add(TabChangeEvent(index: 1));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: (currentSettings == 1)
                                ? Colors.grey.shade400
                                : Colors.transparent,
                            elevation: 0,
                            foregroundColor: Colors.black,
                            fixedSize: Size.fromHeight(
                              size.height / 20,
                            ),
                            shadowColor: Colors.black12,
                            alignment: Alignment.centerLeft,
                          ),
                          child: Text(
                            "Plants",
                            style: TextStyle(fontSize: size.height / 50),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            settingsBloc.add(TabChangeEvent(index: 2));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: (currentSettings == 2)
                                ? Colors.grey.shade400
                                : Colors.transparent,
                            elevation: 0,
                            foregroundColor: Colors.black,
                            fixedSize: Size.fromHeight(
                              size.height / 20,
                            ),
                            shadowColor: Colors.black12,
                            alignment: Alignment.centerLeft,
                          ),
                          child: Text(
                            "Users",
                            style: TextStyle(fontSize: size.height / 50),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: ElevatedButton(
                          onPressed: () {}, child: const Text("Logout")),
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
                flex: 10,
                child: SizedBox(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  child: settingWidgets[currentSettings],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
