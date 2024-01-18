import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PlantsAndUnitSettings extends StatelessWidget {
  const PlantsAndUnitSettings({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          height: size.height / 10,
          width: double.maxFinite,
          color: Colors.amber,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // SizedBox(
              //   width: 20,
              // ),
              Text(
                "Adani Thermal Power Plants",
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
                        shape: StadiumBorder(),
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 20)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_location_alt_rounded),
                        Text(
                          "Add Plant",
                          style: TextStyle(
                              fontSize: size.height / 40,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
