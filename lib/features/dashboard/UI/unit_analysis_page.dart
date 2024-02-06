import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:streaming_data_dashboard/features/dashboard/UI/dashboard_page.dart';
import 'package:streaming_data_dashboard/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:streaming_data_dashboard/models/unit_model.dart';

class UnitAnalysisPage extends StatefulWidget {
  const UnitAnalysisPage({super.key, required this.unit, required this.bloc});

  final Unit unit;
  final DashboardBloc bloc;

  @override
  State<UnitAnalysisPage> createState() => _UnitAnalysisPageState();
}

class _UnitAnalysisPageState extends State<UnitAnalysisPage> {
  late Unit unit;
  double total = 0;
  double max_value = 0;
  double min_value = 0;

  List<Map<String, dynamic>> dataPoints = [];
  List<Map<String, dynamic>> freqPoints = [];

  @override
  void initState() {
    unit = widget.unit;
    Future.delayed(const Duration(seconds: 2), () {
      widget.bloc.add(FetchDatapointsEvent(unitId: widget.unit.id));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.unit.unit),
        ),
        body: BlocBuilder<DashboardBloc, DashboardState>(
          bloc: widget.bloc,
          builder: (context, state) {
            if (state is UnitAnalysisLodingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UnitAnalysisLodingFailedState) {
              return const Center(child: Text("Error"));
            } else if (state is UnitAnalysisLodingSuccessState) {
              dataPoints = state.dataPoints;
              freqPoints = state.frequencyPoints;
              total = state.total;
              max_value = state.max_value;
              min_value = state.min_value;
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      BlocBuilder<DashboardBloc, DashboardState>(
                        bloc: widget.bloc,
                        builder: (context, state) {
                          if (state is DashboardLoadingSuccessState) {
                            unit = state.units.singleWhere(
                                (element) => element.id == widget.unit.id);
                            dataPoints.add({
                              "point_value": unit.unitValue,
                              "sample_time":
                                  "${DateTime.now().hour}:${DateTime.now().minute}"
                            });
                            total += unit.unitValue;
                            max_value = max(max_value, unit.unitValue);
                            min_value = min(min_value, unit.unitValue);
                          }
                          return Expanded(
                            flex: 1,
                            child: UnitDataWidget(
                                unit: widget.unit,
                                onTap: () {},
                                unitValue: unit.unitValue),
                          );
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: UnitDataWidget(
                          unit: widget.unit,
                          onTap: () {},
                          unitValue: (total / dataPoints.length),
                          isUnit: false,
                          bgColor: Colors.red[200],
                          title: "AVG",
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: UnitDataWidget(
                          unit: widget.unit,
                          onTap: () {},
                          unitValue: max_value,
                          isUnit: false,
                          bgColor: Colors.blue[200],
                          title: "MAX",
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: UnitDataWidget(
                          unit: widget.unit,
                          onTap: () {},
                          unitValue: min_value,
                          isUnit: false,
                          bgColor: Colors.indigo[200],
                          title: "MIN",
                        ),
                      ),
                    ],
                  )),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      flex: 6,
                      child: MyLineChartWidget(
                        points: dataPoints,
                        freqPoints: freqPoints,
                        unit: unit,
                      )),
                ],
              ),
            );
          },
        ));
  }
}

class MyLineChartWidget extends StatelessWidget {
  const MyLineChartWidget(
      {super.key,
      required this.points,
      required this.freqPoints,
      required this.unit});

  final List<Map<String, dynamic>> points;
  final List<Map<String, dynamic>> freqPoints;
  final Unit unit;
  final int minFrequency = 47;
  final int maxFrequency = 55;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.black54, Colors.white54],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: 24,
            minY: 0,
            maxY: unit.maxVoltage.toDouble(),
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: Colors.white10,
                getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                  touchedBarSpots
                      .sort((a, b) => a.barIndex.compareTo(b.barIndex));
                  return touchedBarSpots.map((barSpot) {
                    final flSpot = barSpot;
                    if (flSpot.x == 0 || flSpot.x == 24) {
                      return null;
                    }

                    TextAlign textAlign;
                    switch (flSpot.x.toInt()) {
                      case 1:
                        textAlign = TextAlign.left;
                        break;
                      case 5:
                        textAlign = TextAlign.right;
                        break;
                      default:
                        textAlign = TextAlign.center;
                    }

                    double multiplier = (flSpot.y / unit.maxVoltage) *
                        (maxFrequency - minFrequency);

                    return LineTooltipItem(
                      flSpot.barIndex == 0
                          ? 'POWER ${flSpot.y.toStringAsFixed(2)} MW'
                          : 'Frequency ${(multiplier + minFrequency).toStringAsFixed(2)} hz \n',
                      const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      children: flSpot.barIndex == 0
                          ? []
                          : [
                              TextSpan(
                                text: "TIME " +
                                    DateFormat("HH:mm").format(DateTime.now()
                                        .copyWith(
                                            hour: flSpot.x.floor(),
                                            minute:
                                                (flSpot.x.remainder(1.0) * 60)
                                                    .floor())),
                                // "${flSpot.x.floor()}:${(flSpot.x.remainder(1.0) * 60).floor()}",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                ),
                              )
                            ],
                      textAlign: textAlign,
                    );
                  }).toList();
                },
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                  dotData: const FlDotData(
                    show: false,
                  ),
                  barWidth: 7,
                  isStrokeCapRound: true,
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: const LinearGradient(colors: [
                      Color(0x660b74b0),
                      Color(0x6675479c),
                      Color(0x66bd3861)
                    ]),
                  ),
                  gradient: const LinearGradient(colors: [
                    Color(0xff0b74b0),
                    Color(0xff75479c),
                    Color(0xffbd3861)
                  ]),
                  spots: points.map((point) {
                    var time = DateFormat("HH:mm").parse(point["sample_time"]);
                    return FlSpot(
                        time.hour + (time.minute / 60), point["point_value"]);
                  }).toList(),
                  isCurved: true),
              LineChartBarData(
                dotData: const FlDotData(
                  show: false,
                ),
                barWidth: 7,
                isStrokeCapRound: true,
                isCurved: true,
                spots: freqPoints.map((freqPoint) {
                  var time =
                      DateFormat("HH:mm").parse(freqPoint["sample_time"]);
                  double multiplier =
                      (freqPoint["point_value"] - minFrequency) /
                          (maxFrequency - minFrequency);
                  return FlSpot(time.hour + (time.minute / 60),
                      unit.maxVoltage * multiplier);
                }).toList(),
              )
            ],
            borderData: FlBorderData(
                border: const Border(bottom: BorderSide(), left: BorderSide())),
            gridData: const FlGridData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                  axisNameWidget: const Text(
                    "Time",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  axisNameSize: 50,
                  sideTitles: SideTitles(
                      getTitlesWidget: bottomTitleWidgets,
                      showTitles: true,
                      interval: 1,
                      reservedSize: 30)),
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                axisNameSize: 50,
                axisNameWidget: const Text(
                  "Frequency",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                sideTitles: SideTitles(
                  getTitlesWidget: rightTitleWidgets,
                  showTitles: true,
                  reservedSize: 60,
                ),
              ),
              leftTitles: AxisTitles(
                axisNameSize: 50,
                axisNameWidget: const Text(
                  "Power (MW)",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                sideTitles: SideTitles(
                    getTitlesWidget: leftTitleWidgets,
                    showTitles: true,
                    reservedSize: 60),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    if (value.toInt() % 3 == 0) {
      text = Text('${value.toInt()}:00', style: style);
    } else {
      text = const Text('', style: style);
    }

    return SideTitleWidget(axisSide: meta.axisSide, child: text);
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    if (value.toInt() % 20 == 0) {
      text = Text('${value}', style: style);
    } else {
      text = const Text('', style: style);
    }

    return SideTitleWidget(axisSide: meta.axisSide, child: text);
  }

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    double divider = unit.maxVoltage / (maxFrequency - minFrequency);
    Widget text;
    if (value.toInt() % 20 == 0) {
      text = Text((value / divider + minFrequency).toStringAsFixed(0),
          style: style);
    } else {
      text = const Text('', style: style);
    }

    return SideTitleWidget(axisSide: meta.axisSide, child: text);
  }
}
