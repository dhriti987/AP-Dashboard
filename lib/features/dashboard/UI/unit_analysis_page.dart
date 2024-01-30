import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:streaming_data_dashboard/models/unit_model.dart';

class UnitAnalysisPage extends StatefulWidget {
  const UnitAnalysisPage({super.key, required this.unit});

  final Unit unit;

  @override
  State<UnitAnalysisPage> createState() => _UnitAnalysisPageState();
}

class _UnitAnalysisPageState extends State<UnitAnalysisPage> {
  List<List<double>> points = [
    [232.6, 2.7],
    [312.3, 3.3],
    [212.3, 6.7],
    [27.8, 8.34],
    [222.4, 22.5],
  ];

  List<Map<String, dynamic>> tempPoints = [
    {"point_value": 198.69, "sample_time": "12:08"},
    {"point_value": 198.52, "sample_time": "15:46"},
    {"point_value": 198.38, "sample_time": "17:19"},
    {"point_value": 197.54, "sample_time": "17:52"},
    {"point_value": 198.1, "sample_time": "18:04"}
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.unit.unit),
        ),
        body: MyLineChartWidget(points: tempPoints));
  }
}

class MyLineChartWidget extends StatelessWidget {
  const MyLineChartWidget({super.key, required this.points});

  final List<Map<String, dynamic>> points;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.black54, Colors.white54],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LineChart(LineChartData(
          minX: 0,
          maxX: 24,
          minY: 0,
          maxY: 360,
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.white10,
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
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

                  return LineTooltipItem(
                    'POWER ${flSpot.y} MW \n',
                    TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: "TIME " +
                            DateFormat("HH:mm").format(DateTime.now().copyWith(
                                hour: flSpot.x.floor(),
                                minute:
                                    (flSpot.x.remainder(1.0) * 60).floor())),
                        // "${flSpot.x.floor()}:${(flSpot.x.remainder(1.0) * 60).floor()}",
                        style: TextStyle(
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
                  gradient: LinearGradient(colors: [
                    Color(0x660b74b0),
                    Color(0x6675479c),
                    Color(0x66bd3861)
                  ]),
                ),
                gradient: LinearGradient(colors: [
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
          ],
          borderData: FlBorderData(
              border: const Border(bottom: BorderSide(), left: BorderSide())),
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(
              bottomTitles: AxisTitles(
                  axisNameWidget: Text(
                    "Time",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  axisNameSize: 50,
                  sideTitles: SideTitles(
                      getTitlesWidget: bottomTitleWidgets,
                      showTitles: true,
                      interval: 1,
                      reservedSize: 30)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                  axisNameSize: 50,
                  axisNameWidget: Text(
                    "Power (MW)",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  sideTitles: SideTitles(
                      getTitlesWidget: leftTitleWidgets,
                      showTitles: true,
                      reservedSize: 60))),
        )),
      ),
    );
  }
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
