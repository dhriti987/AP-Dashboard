import 'package:flutter/material.dart';
import 'package:streaming_data_dashboard/core/utilities/gradient_text.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
              decoration: BoxDecoration(color: Colors.grey),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: GradientText(
                    "adani",
                    gradient: LinearGradient(colors: [
                      Color(0xff0B74B0),
                      Color(0xff75479C),
                      Color(0xffBD3861),
                    ]),
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ))),
          ListTile(
            title: const Text(
              ' Mundra ',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {},
          )
        ],
      ),
    );
  }
}
