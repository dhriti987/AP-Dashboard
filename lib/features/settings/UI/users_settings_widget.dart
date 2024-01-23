import 'package:flutter/material.dart';
import 'package:streaming_data_dashboard/models/user_model.dart';

class UsersSettings extends StatelessWidget {
  const UsersSettings({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<UserModel> users = [
      UserModel(
          employeeId: "2222222",
          username: "username",
          firstName: "firstName",
          lastName: "lastName",
          email: "intern.dhritiman@adani.com",
          contact: "s901008989",
          isAdmin: true)
    ];
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
                    onPressed: () {},
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
        Card(
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
                      DataCell(IconButton(
                        icon: Icon(Icons.abc),
                        onPressed: () {},
                      )),
                    ]))
                .toList(),
            headingTextStyle: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black),
          ),
        )
      ],
    );
  }
}
