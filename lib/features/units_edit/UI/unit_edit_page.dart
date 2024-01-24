import 'package:flutter/material.dart';
import 'package:streaming_data_dashboard/models/plant_model.dart';
import 'package:streaming_data_dashboard/models/unit_model.dart';

class UnitEditPage extends StatefulWidget {
  final Plant plant;

  const UnitEditPage({super.key, required this.plant});

  @override
  State<UnitEditPage> createState() => _UnitEditPageState();
}

class _UnitEditPageState extends State<UnitEditPage> {
  List<Unit> units = [
    Unit(
      id: 1,
      pointId: "pointIdpointIdpointId",
      systemGuid: "systemGuidsystemGuidsystemGuidsystemGuid",
      plant: "plant",
      unit: "unit",
      code: "code",
      maxVoltage: 0,
    ),
    Unit(
        id: 2,
        pointId: "pointIdpointIdpointId",
        systemGuid: "systemGuidsystemGuidsystemGuidsystemGuid",
        plant: "plant",
        unit: "unit",
        code: "code",
        maxVoltage: 0),
    Unit(
        id: 3,
        pointId: "pointIdpointIdpointId",
        systemGuid: "systemGuidsystemGuidsystemGuidsystemGuid",
        plant: "plant",
        unit: "unit",
        code: "code",
        maxVoltage: 0),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plant.name),
        centerTitle: true,
        actions: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add_location_alt_rounded),
                Text(
                  "Add Unit",
                  style: TextStyle(
                    fontSize: size.height / 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 10,
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              border: TableBorder(),
              columns: const [
                DataColumn(
                  label: Flexible(
                    child: Text(
                      "Sr No.",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                DataColumn(
                  label: Flexible(
                    child: Text(
                      "Point Id",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "System GUID",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Unit",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Unit Code",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Actions",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
              rows: units
                  .asMap()
                  .entries
                  .map<DataRow>(
                    (data) => DataRow(
                      cells: [
                        DataCell(Text((data.key + 1).toString())),
                        DataCell(Text(data.value.pointId)),
                        DataCell(Text(data.value.systemGuid)),
                        DataCell(Text(data.value.unit)),
                        DataCell(Text(data.value.code)),
                        DataCell(Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.edit_rounded)),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.delete_rounded))
                          ],
                        ))
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

// Text(
//                   "Sr No.",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//                 ),
//                 Text(
//                   "Point ID",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//                 ),
//                 Text(
//                   "SystemGUID",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//                 ),
//                 Text(
//                   "Unit",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//                 ),
//                 Text(
//                   "Unit Code",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//                 ),
//                 Text(
//                   "Actions",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//                 ),