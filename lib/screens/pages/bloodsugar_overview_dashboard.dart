import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';



class GlucoseData {
  GlucoseData(this.year, this.bloodSugarValue);
  final DateTime year;
  final double bloodSugarValue;
}

class BloodsugarOverview extends StatefulWidget {

  @override
  _BloodsugarOverviewState createState() => _BloodsugarOverviewState();
}

class _BloodsugarOverviewState extends State<BloodsugarOverview> {
  final GlobalKey _dailyKey = GlobalKey();
  final GlobalKey _weeklyKey = GlobalKey();

  final List<GlucoseData> chartData = [
    GlucoseData(DateTime.parse('1969-07-20 20:18:04Z'), 35),
    GlucoseData(DateTime.parse('1969-07-20 20:23:04Z'), 28),
    GlucoseData(DateTime.parse('1969-07-20 20:28:04Z'), 34),
    GlucoseData(DateTime.parse('1969-07-20 20:33:04Z'), 32),
    GlucoseData(DateTime.parse('1969-07-20 20:38:04Z'), 31),
    GlucoseData(DateTime.parse('1969-07-20 20:43:04Z'), 29),
    GlucoseData(DateTime.parse('1969-07-20 20:48:04Z'), 33),
    GlucoseData(DateTime.parse('1969-07-20 20:53:04Z'), 36),
    GlucoseData(DateTime.parse('1969-07-20 20:58:04Z'), 38),
    GlucoseData(DateTime.parse('1969-07-20 21:03:04Z'), 46),
    GlucoseData(DateTime.parse('1969-07-20 21:08:04Z'), 50)
  ];

  double dailyOutOfRangePercentage = 0.7;
  late String dailyRange = (dailyOutOfRangePercentage*100).toString();
  double weeklyOutOfRangePercentage = 0.85;
  late String weeklyRange = (weeklyOutOfRangePercentage*100).toString();


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
        top: offset.dy - 40,
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
        child: const Text("A representation of time spent within (green) and outside (red) the normal blood sugar range in percentage."),
      ),
    );
  }
  //Source: https://stackoverflow.com/questions/64186397/create-info-popup-in-flutter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blutzucker Overview'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Current blood sugar value: ',
              style: TextStyle(
              color: Colors.indigo,
              fontSize: 22,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              alignment: Alignment.center,
              color: Colors.redAccent,
              child: Text(
              '67', // mock for blood sugar value
              style: TextStyle(
              fontSize: 90.0,
              color: Colors.white,
                  ),
                ),
              ),
            SfCartesianChart(
                primaryXAxis: DateTimeAxis(),
                primaryYAxis: NumericAxis(
                  plotBands: <PlotBand>[
                  PlotBand(
                    isVisible: true,
                    start: 20,
                    end: 40,
                    color: Colors.green.withOpacity(0.9),
                  ),
                ],),
              series: <CartesianSeries>[
                  LineSeries<GlucoseData, DateTime>(
                      dataSource: chartData,
                      xValueMapper: (GlucoseData bloodSugarValue, _) => bloodSugarValue.year,
                      yValueMapper: (GlucoseData bloodSugarValue, _) => bloodSugarValue.bloodSugarValue
                  )
                ],
            ),
            const Text('MAX ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 23,
              ),
            ),
            const Text('MIN ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 23,
              ),
            ),
            Row(
              children: [
                const Text(
              'Daily blood sugar range',
                  style: TextStyle(
                  color: Colors.black,
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
              percentage: dailyOutOfRangePercentage,
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
                    color: Colors.black,
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
              percentage: weeklyOutOfRangePercentage,
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
     );
   }
}
