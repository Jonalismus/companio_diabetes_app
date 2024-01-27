import 'GlucoseDataRetriever.dart';

class DataAnalysisUtilities {

  static Map<String, double> findMinMaxGlucoseValues(
      List<GlucoseData> glucoseDataList) {
    if (glucoseDataList.isEmpty) {
      throw Exception('Empty glucose data list');
    }

    double minGlucose = double.infinity;
    double maxGlucose = double.negativeInfinity;

    for (var glucoseData in glucoseDataList) {
      if (glucoseData.glucoseLevel < minGlucose) {
        minGlucose = glucoseData.glucoseLevel;
      }
      if (glucoseData.glucoseLevel > maxGlucose) {
        maxGlucose = glucoseData.glucoseLevel;
      }
    }
    return {'min': minGlucose, 'max': maxGlucose};
  }


// and calculates percentage of being in normal range
  static double calculateNormalRangePercentage(List<GlucoseData> glucoseDataList) {
    int normalRangeCount = 0;

    for (GlucoseData data in glucoseDataList) {
      if (data.glucoseLevel >= 45 && data.glucoseLevel <= 120) {
        normalRangeCount++;
      }
    }

    double percentage = normalRangeCount / glucoseDataList.length;
    var result = double.parse(percentage.toStringAsFixed(3));
    return result;
  }
}