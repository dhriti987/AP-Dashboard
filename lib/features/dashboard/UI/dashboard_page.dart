import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_data_dashboard/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:streaming_data_dashboard/models/plant_model.dart';
import 'package:streaming_data_dashboard/service_locator.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../../../models/unit_model.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({super.key, required this.plant});

  final Plant plant;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardBloc dashboardBloc = sl.get<DashboardBloc>();
  late final WebSocketChannel channel;

  @override
  void initState() {
    // TODO: implement initState
    connectSocket();
    super.initState();
  }

  Future<void> connectSocket() async {
    final SharedPreferences sharedPreferences = sl.get<SharedPreferences>();
    final token = sharedPreferences.getString("accessToken");
    final wsUrl = Uri.parse(
        'ws://127.0.0.1:8000/unit_data/?token=${token}&plant=${widget.plant.name}');
    channel = WebSocketChannel.connect(wsUrl);

    await channel.ready;
    channel.stream.listen((message) {
      print(message.toString());
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height / 3.7;
    // double width = ((size.width / 7) * 5) / 3.4;
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.plant.name} Dashboard"),
        centerTitle: true,
      ),
      // body: UnitDataWidget(
      //   onTap: () {},
      //   unit: units[0],
      // ),
      body: BlocConsumer<DashboardBloc, DashboardState>(
        bloc: dashboardBloc,
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          List<Unit> units = [];
          double frequency = 0;
          double totalValue = 0;
          double maxValue = 0;
          if (state is DashboardInitial) {
            dashboardBloc.add(FetchUnitDataEvent(plantName: widget.plant.name));
          } else if (state is DashboardLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is DashboardLoadingSuccessState) {
            units = state.units;
            frequency = state.frequency;
            totalValue = state.totalValue;
            maxValue = state.maxValue;
          }
          return Container(
            color: Color.fromARGB(255, 132, 200, 250),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        UnitData2Widget(
                          name: " Frequency ",
                          value: 50.1,
                          maxValue: 60,
                          valueWidget: Text.rich(TextSpan(
                              text: frequency.toString(),
                              children: [
                                TextSpan(
                                    text: "hz",
                                    style: TextStyle(fontSize: height / 50))
                              ])),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        UnitData2Widget(
                          name: ".    Total    .",
                          value: totalValue,
                          maxValue: maxValue,
                          valueWidget: Text(
                            totalValue.toString(),
                            style: TextStyle(
                                // fontSize: height / 5,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 5,
                    child: Wrap(
                      // spacing: 20,
                      runSpacing: 25,
                      alignment: WrapAlignment.spaceEvenly,
                      // runAlignment: WrapAlignment.spaceEvenly,
                      // crossAxisAlignment: WrapCrossAlignment.start,
                      children: units
                          .map<Widget>((unit) => UnitDataWidget(
                              unit: unit,
                              onTap: () {},
                              unitValue: unit.unitValue))
                          .toList()
                        ..add(const SizedBox(
                          height: 20,
                          width: double.maxFinite,
                        )),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class UnitDataWidget extends StatefulWidget {
  const UnitDataWidget(
      {super.key,
      required this.unit,
      required this.onTap,
      required this.unitValue});

  final Unit unit;
  final double unitValue;
  final void Function() onTap;

  @override
  State<UnitDataWidget> createState() => _UnitDataWidgetState();
}

class _UnitDataWidgetState extends State<UnitDataWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height / 3.7;
    double width = ((size.width / 7) * 5) / 3.4;
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 4.0,
            spreadRadius: 0.0,
            offset: Offset(7.0, 7.0), // shadow direction: bottom right
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: AnimatedRadialGauge(
                builder: (context, child, value) {
                  return FittedBox(
                    fit: BoxFit.fill,
                    child: Text(
                      "${(value / 3.30).toStringAsFixed(0)}%",
                      style: TextStyle(
                          // fontSize: height / 5,
                          fontWeight: FontWeight.w600),
                    ),
                  );
                },
                duration: Duration(seconds: 1),
                value: widget.unitValue,
                axis: GaugeAxis(
                    min: 0,
                    max: 330,
                    degrees: 330,
                    progressBar: GaugeProgressBar.rounded(
                        placement: GaugeProgressPlacement.inside,
                        gradient: GaugeAxisGradient(
                            colors: [Colors.red, Colors.orange, Colors.green],
                            colorStops: [0.01, 0.15, 0.65])),
                    segments: [
                      GaugeSegment(
                        from: 0,
                        to: 330 * 0.05,
                        cornerRadius: Radius.zero,
                      ),
                      GaugeSegment(
                        from: 330 * 0.05,
                        to: 330 * 0.45,
                      ),
                      GaugeSegment(from: 330 * 0.45, to: 330)
                    ],
                    style: GaugeAxisStyle(
                        thickness: width / 15, segmentSpacing: 4)),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Text(
                        widget.unitValue.toStringAsFixed(0),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Text(
                        widget.unit.unit,
                        style: TextStyle(),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class UnitData2Widget extends StatefulWidget {
  const UnitData2Widget(
      {super.key,
      required this.name,
      required this.value,
      required this.maxValue,
      required this.valueWidget});

  final String name;
  final double value;
  final double maxValue;
  final Widget valueWidget;

  @override
  State<UnitData2Widget> createState() => _UnitData2WidgetState();
}

class _UnitData2WidgetState extends State<UnitData2Widget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // double height = size.height / 3.7;
    double width = ((size.width / 7) * 5) / 3.4;
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 4.0,
              spreadRadius: 0.0,
              offset: Offset(7.0, 7.0), // shadow direction: bottom right
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: AnimatedRadialGauge(
                  builder: (context, child, value) {
                    return FittedBox(
                      fit: BoxFit.fill,
                      child: widget.valueWidget,
                    );
                  },
                  duration: Duration(seconds: 1),
                  value: widget.value,
                  axis: GaugeAxis(
                    min: 0,
                    max: widget.maxValue,
                    degrees: 240,
                    progressBar: GaugeProgressBar.rounded(
                        placement: GaugeProgressPlacement.inside,
                        gradient: GaugeAxisGradient(
                            colors: [Colors.red, Colors.orange, Colors.green],
                            colorStops: [0.01, 0.15, 0.65])),
                    segments: [
                      GaugeSegment(
                        from: 0,
                        to: widget.maxValue,
                        cornerRadius: Radius.zero,
                      )
                    ],
                    style: GaugeAxisStyle(
                        thickness: width / 13, segmentSpacing: 4),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    widget.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
