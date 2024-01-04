import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../utilis/dao/loadData.dart';
import 'fooddairy.dart';

class SugarIntakeData {
  late DateTime date;
  late double totalSugarIntake;

  SugarIntakeData({required this.date, this.totalSugarIntake = 0.0});

  void addSugar(double sugar) {
    totalSugarIntake += sugar;
  }
}

class SugarIntakeOverview extends StatefulWidget {
  @override
  _SugarIntakeOverviewState createState() => _SugarIntakeOverviewState();
}

class _SugarIntakeOverviewState extends State<SugarIntakeOverview> {
  late List<SugarIntakeData> chartData;
  late DateTime selectedDate;
  late List<MealEntry> mealEntries;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  }

  List<SugarIntakeData> _generateChartData(DateTime centerDate) {
    Map<DateTime, SugarIntakeData> sugarIntakeMap = {};

    for (var mealEntry in mealEntries) {
      DateTime date = DateTime(mealEntry.dateTime.year, mealEntry.dateTime.month, mealEntry.dateTime.day);

      sugarIntakeMap.putIfAbsent(date, () => SugarIntakeData(date: date));

      for (var item in mealEntry.foodItems) {
        double sugar = item.carbohydrate_100g * item.quantity / 100;
        sugarIntakeMap[date]?.addSugar(sugar);
      }
    }

    List<SugarIntakeData> chartData = [];
    for (int i = -3; i <= 3; i++) {
      DateTime currentDate = centerDate.add(Duration(days: i));
      chartData.add(sugarIntakeMap[currentDate] ?? SugarIntakeData(date: currentDate));
    }

    return chartData;
  }


  void _changeDate(bool increment) {
    setState(() {
      selectedDate = increment
          ? selectedDate.add(Duration(days: 1))
          : selectedDate.subtract(Duration(days: 1));
      chartData = _generateChartData(selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    DataProvider dataProvider =
    Provider.of<DataProvider>(context, listen: true);
    if (!dataProvider.isLoaded) {
      return const Center(child: CircularProgressIndicator());
    }
    mealEntries = dataProvider.mealEntries;

    chartData = _generateChartData(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Zuckeraufnahmenübersicht'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => _changeDate(false),
                  child: Icon(Icons.arrow_back),
                ),
                Text(
                  DateFormat('yyyy-MM-dd').format(selectedDate),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () => _changeDate(true),
                  child: Icon(Icons.arrow_forward),
                ),
              ],
            ),
            SizedBox(height: 20),
            SfCartesianChart(
              primaryXAxis: DateTimeAxis(
                interval: 1,
                labelRotation: -45,
                intervalType: DateTimeIntervalType.days,
                dateFormat: DateFormat.Md(),
              ),
              primaryYAxis: NumericAxis(
                title: AxisTitle(text: 'Zuckeraufnahme (g)'),
                plotBands: <PlotBand>[
                  PlotBand(
                    isVisible: true,
                    start: 15,
                    end: 15,
                    color: Colors.red,
                    borderWidth: 2,
                    borderColor: Colors.red,
                  ),
                ],
              ),
              series: <CartesianSeries>[
                ColumnSeries<SugarIntakeData, DateTime>(
                  dataSource: chartData,
                  xValueMapper: (SugarIntakeData data, _) => data.date,
                  yValueMapper: (SugarIntakeData data, _) => data.totalSugarIntake,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                "Diese Tabelle zeigt Ihre tägliche Zuckeraufnahme. Die rote Linie stellt die empfohlene Obergrenze der täglichen Zuckeraufnahme für Sie dar.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
            // Other widgets...
          ],
        ),
      ),
    );
  }
}