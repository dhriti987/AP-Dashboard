import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_data_dashboard/core/utilities/user_dialog.dart';
import 'package:streaming_data_dashboard/features/settings/bloc/settings_bloc.dart';
import 'package:streaming_data_dashboard/models/user_model.dart';
import 'package:streaming_data_dashboard/service_locator.dart';

class UsersSettings extends StatelessWidget {
  const UsersSettings({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SettingsBloc settingsBloc = sl.get<SettingsBloc>();
    List<UserModel> users = [];
    return Column(
      children: [
        SizedBox(
          height: size.height / 10,
          width: double.maxFinite,
          // color: Colors.amber,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "   Manage Users",
                style: TextStyle(
                  fontSize: size.height / 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    onPressed: () {
                      settingsBloc.add(ButtonAddUserClickedEvent());
                    },
                    style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.person_add_alt_1_sharp,
                          size: size.height / 35,
                        ),
                        Text(
                          "Add User",
                          style: TextStyle(
                            fontSize: size.height / 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        BlocConsumer<SettingsBloc, SettingsState>(
          bloc: settingsBloc,
          listenWhen: (previous, current) => current is SettingsActionState,
          buildWhen: (previous, current) => current is! SettingsActionState,
          listener: (context, state) {
            if (state is OpenAddUserDialogState) {
              showDialog(
                context: context,
                builder: (context) {
                  return UserDialog(
                    settingsBloc: settingsBloc,
                  );
                },
              );
            } else if (state is OpenEditUserDialogState) {
              showDialog(
                context: context,
                builder: (context) {
                  return UserDialog(
                    isEditUserDialog: true,
                    user: state.user,
                    settingsBloc: settingsBloc,
                  );
                },
              );
            }
          },
          builder: (context, state) {
            if (state is SettingsInitial) {
              settingsBloc.add(UserDataFetchEvent());
            } else if (state is UsersLoadingState) {
              return Expanded(
                  child: Center(child: CircularProgressIndicator()));
            } else if (state is UsersLoadingFailedState) {
              return Center(
                  child: Text(
                "${state.apiException.error.first} \n ${state.apiException.error.last}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ));
            } else if (state is UsersLoadingSuccessState) {
              users = state.users;
            }
            if (state is AddUserSuccessState) {
              print("AddUserSuccessState");
              users.add(state.user);
            }
            return Card(
              child: DataTable(
                columns: [
                  DataColumn(label: Text("Employee ID")),
                  DataColumn(label: Text("User")),
                  DataColumn(label: Text("Contact")),
                  DataColumn(label: Text("Role")),
                  DataColumn(label: Text("Action")),
                ],
                rows: users
                    .map((user) => DataRow(cells: [
                          DataCell(Text(user.employeeId)),
                          DataCell(Column(
                            children: [
                              Text.rich(TextSpan(
                                  text: "${user.firstName} ${user.lastName}",
                                  children: [
                                    TextSpan(text: "(${user.username})")
                                  ])),
                              Text(user.email),
                            ],
                          )),
                          DataCell(Text(user.contact)),
                          DataCell(Text(user.isAdmin ? "Admin" : "Standard")),
                          DataCell(Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    print("here");
                                    settingsBloc.add(
                                        ButtonEditUserClickedEvent(user: user));
                                  },
                                  icon: const Icon(Icons.edit_rounded)),
                              IconButton(
                                  onPressed: () {
                                    settingsBloc
                                        .add(DeleteUserEvent(user: user));
                                  },
                                  icon: const Icon(Icons.delete_rounded))
                            ],
                          )),
                        ]))
                    .toList(),
                headingTextStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
              ),
            );
          },
        )
      ],
    );
  }
}
