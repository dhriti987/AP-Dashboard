import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_data_dashboard/core/utilities/unit_dialog.dart';
import 'package:streaming_data_dashboard/features/units_edit/bloc/units_edit_bloc.dart';
import 'package:streaming_data_dashboard/models/plant_model.dart';
import 'package:streaming_data_dashboard/models/unit_model.dart';
import 'package:streaming_data_dashboard/service_locator.dart';

class UnitEditPage extends StatefulWidget {
  final Plant plant;

  const UnitEditPage({super.key, required this.plant});

  @override
  State<UnitEditPage> createState() => _UnitEditPageState();
}

class _UnitEditPageState extends State<UnitEditPage> {
  final UnitsEditBloc unitsEditBloc = sl.get<UnitsEditBloc>();

  List<Unit> units = [
    // Unit(
    //   id: 1,
    //   pointId: "pointIdpointIdpointId",
    //   systemGuid: "systemGuidsystemGuidsystemGuidsystemGuid",
    //   plant: "plant",
    //   unit: "unit",
    //   code: "code",
    //   maxVoltage: 0,
    // ),
    // Unit(
    //     id: 2,
    //     pointId: "pointIdpointIdpointId",
    //     systemGuid: "systemGuidsystemGuidsystemGuidsystemGuid",
    //     plant: "plant",
    //     unit: "unit",
    //     code: "code",
    //     maxVoltage: 0),
    // Unit(
    //     id: 3,
    //     pointId: "pointIdpointIdpointId",
    //     systemGuid: "systemGuidsystemGuidsystemGuidsystemGuid",
    //     plant: "plant",
    //     unit: "unit",
    //     code: "code",
    //     maxVoltage: 0),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plant.name),
        centerTitle: true,
        actions: [
          ElevatedButton(
            onPressed: () {
              unitsEditBloc.add(ClickAddUnitEvent(plant: widget.plant));
            },
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
      body: BlocConsumer<UnitsEditBloc, UnitsEditState>(
        bloc: unitsEditBloc,
        listenWhen: (previous, current) => current is UnitEditActionState,
        buildWhen: (previous, current) => current is! UnitEditActionState,
        listener: (context, state) {
          print(state.runtimeType);
          // TODO: implement listener

          if (state is EditUnitButtonClickedState) {
            showDialog(
              context: context,
              builder: (context) {
                return UnitDialog(
                  plant: widget.plant,
                  isEditUnitDialog: true,
                  unit: state.unit,
                  unitsEditBloc: unitsEditBloc,
                );
              },
            );
          }
          if (state is AddUnitButtonClickedState) {
            showDialog(
              context: context,
              builder: (context) {
                return UnitDialog(
                  plant: widget.plant,
                  unitsEditBloc: unitsEditBloc,
                );
              },
            );
          }
          if (state is UnitEditErrorState) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                      state.apiException.error.first,
                      style:
                          const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      state.apiException.error.last,
                      style: const TextStyle(fontSize: 20),
                    )
                  ]),
                );
              },
            );
          }
        },
        builder: (context, state) {
          print(state.runtimeType);
          if (state is UnitsEditInitial) {
            unitsEditBloc.add(FetchUnitDataEvent(plantName: widget.plant.name));
          } else if (state is UnitEditLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UnitEditLoadingSuccessState) {
            units = state.units;
          } else if (state is UnitEditLoadingFailedState) {
            return const Center(child: Text("Error"));
          } else if (state is UnitAddedState) {
            units.add(state.unit);
          } else if (state is UnitDeleteSuccessState) {
            units.remove(state.unit);
          } else if (state is UnitEditSuccessState) {
            print("UnitEditSuccessState----------------------------------");
            var index =
                units.indexWhere((element) => element.id == state.unit.id);
            units[index] = state.unit;
          }
          return Align(
            alignment: Alignment.topCenter,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 10,
              margin: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  border: const TableBorder(),
                  columns: const [
                    DataColumn(
                      label: Flexible(
                        child: Text(
                          "Sr No.",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Flexible(
                        child: Text(
                          "Point Id",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "System GUID",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Unit",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Unit Code",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Actions",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
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
                            DataCell(SelectableText(data.value.pointId)),
                            DataCell(SelectableText(data.value.systemGuid)),
                            DataCell(SelectableText(data.value.unit)),
                            DataCell(SelectableText(data.value.code)),
                            DataCell(Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      unitsEditBloc.add(
                                          ClickEditUnitEvent(unit: data.value));
                                    },
                                    icon: const Icon(Icons.edit_rounded)),
                                IconButton(
                                    onPressed: () {
                                      unitsEditBloc.add(
                                          DeleteUnitEvent(unit: data.value));
                                    },
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
          );
        },
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