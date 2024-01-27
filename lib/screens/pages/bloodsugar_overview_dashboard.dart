import 'dart:async';

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../utilis/colors_utilis.dart';
import 'Services/DataAnalysisUtilities.dart';
import 'Services/GlucoseDataRetriever.dart';


class BloodsugarOverview extends StatefulWidget {
  @override
  _BloodsugarOverviewState createState() => _BloodsugarOverviewState();
}

class _BloodsugarOverviewState extends State<BloodsugarOverview> {
  late Timer _timer;
  final GlobalKey _dailyKey = GlobalKey();
  final GlobalKey _weeklyKey = GlobalKey();
  List<GlucoseData> weeklyChartData = [];
  List<GlucoseData> chartData = [];
  double bloodSugarValue = 0; // will be retrived from data base or from the user input,if pumpe is not available
  double minGlucoseValue = 0;
  double maxGlucoseValue = 0;

  double dailyInRangePercentage = 0;
  double weeklyInRangePercentage = 0;

  late String dailyRange = "0";
  late String weeklyRange = "0";

  @override
  void initState() {
    _loadGlyoseData();
    _timer = Timer.periodic(Duration(seconds: 57), (timer) {
      _loadGlyoseData();
    });
    super.initState();
  }

  Future<void> _loadGlyoseData() async {
    try {
      bloodSugarValue = await GlucoseDataRetriever.readLastGlucoseValue();
      weeklyChartData = await GlucoseDataRetriever.getGlucoseDataLast7Days();
      chartData = await GlucoseDataRetriever.getGlucoseDataForLastDay();
      var minMaxValues = DataAnalysisUtilities.findMinMaxGlucoseValues(chartData);
      minGlucoseValue = minMaxValues['min']!;
      maxGlucoseValue = minMaxValues['max']!;
      dailyInRangePercentage = DataAnalysisUtilities.calculateNormalRangePercentage(chartData);
      weeklyInRangePercentage = DataAnalysisUtilities.calculateNormalRangePercentage(weeklyChartData);
      dailyRange = (dailyInRangePercentage*100).toString();
      weeklyRange = (weeklyInRangePercentage*100).toString();
      setState(() {});
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showDailyOverlay(context) async {
    final box = _dailyKey.currentContext?.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero);
    final entry = OverlayEntry(
      builder: (_) => Positioned(
        top: offset.dy - 40,
        left: offset.dx - 120,
        child: _buildInfo(),
      ),
    );

    Overlay.of(context).insert(entry);
    await Future.delayed(Duration(seconds: 2));
    entry.remove();
  }

  void _showWeeklyOverlay(context) async {
    final box = _weeklyKey.currentContext?.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero);
    final entry = OverlayEntry(
      builder: (_) => Positioned(
        top: offset.dy - 30,
        left: offset.dx - 120,
        child: _buildInfo(),
      ),
    );

    Overlay.of(context)!.insert(entry);
    await Future.delayed(Duration(seconds: 2));
    entry.remove();
  }

  Widget _buildInfo() {
    return Material(
      child: Container(
        color: Colors.red[200],
        padding: const EdgeInsets.all(12),
        child: const Text("A representation of time spent within (green) \nand outside (red) of the normal blood sugar \nrange in percentage."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('Blutzucker Overview'),
      ),
      body: SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("#3158C3"),
              hexStringToColor("#3184C3"),
              hexStringToColor("#551CB4")
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Current blood sugar value: ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                alignment: Alignment.center,
                color: Colors.redAccent,
                child: Text(
                  '$bloodSugarValue',
                  style: TextStyle(
                    fontSize: 90.0,
                    color: Colors.white,
                  ),
                ),
              ),
              SfCartesianChart(
                primaryXAxis: DateTimeAxis(
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                primaryYAxis: NumericAxis(
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  minimum: 50,
                  maximum: 250,
                  plotBands: <PlotBand>[
                    PlotBand(
                      isVisible: true,
                      start: 120,
                      end: 55,
                      color: Colors.green.withOpacity(0.9),
                    ),
                  ],
                ),
                series: <CartesianSeries>[
                  LineSeries<GlucoseData, DateTime>(
                    dataSource: chartData,
                    xValueMapper: (GlucoseData bloodSugarValue, _) => bloodSugarValue.dateTime,
                    yValueMapper: (GlucoseData bloodSugarValue, _) => bloodSugarValue.glucoseLevel,
                    color: Colors.red,
                  )
                ],
              ),
              Text('MAX: $maxGlucoseValue   MIN: $minGlucoseValue',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                ),
              ),
              Row(
                children: [
                  const Text(
                    'Daily blood sugar range',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    key: _dailyKey,
                    icon: const Icon(Icons.info),
                    onPressed: () => _showDailyOverlay(context),
                  ),
                ],
              ),
              GFProgressBar(
                percentage: dailyInRangePercentage,
                lineHeight: 30,
                alignment: MainAxisAlignment.spaceBetween,
                leading  : const Icon( Icons.sentiment_dissatisfied, color: Colors.red),
                trailing: const Icon( Icons.sentiment_satisfied, color: Colors.green),
                backgroundColor: Colors.redAccent,
                progressBarColor: Colors.green,
                child:
                Text('$dailyRange %', textAlign: TextAlign.end,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              Row(
                children: [
                  const Text(
                    'Weekly blood sugar range',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    key: _weeklyKey,
                    icon: const Icon(Icons.info),
                    onPressed: () => _showWeeklyOverlay(context),
                  ),
                ],
              ),
              GFProgressBar(
                percentage: weeklyInRangePercentage,
                lineHeight: 30,
                alignment: MainAxisAlignment.spaceBetween,
                leading  : const Icon( Icons.sentiment_dissatisfied, color: Colors.red),
                trailing: const Icon( Icons.sentiment_satisfied, color: Colors.green),
                backgroundColor: Colors.redAccent,
                progressBarColor: Colors.green,
                child:
                Text('$weeklyRange %', textAlign: TextAlign.end,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
