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

  //TODO: make a function that receives a list of a type List<GlucoseData>
// and calculates percentage of being in normal range and outside of a normal range
}