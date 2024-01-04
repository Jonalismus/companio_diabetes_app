class InsulinCalculator {
  late double totalUnits;
  late double basalPercentage;
  late double bolusPercentage;
  late int mealsPerDay;
  late double afterMealTargetBodyGlucose;

  InsulinCalculator(this.totalUnits, this.basalPercentage, this.bolusPercentage,
      this.mealsPerDay, this.afterMealTargetBodyGlucose);

  double getBasalUnits() {
    return totalUnits * basalPercentage;
  }

  double calculateInsulinUnitsPerMeal() {
    double bolusUnits = totalUnits * bolusPercentage;
    double bolusPerMeal = (bolusUnits / mealsPerDay).roundToDouble();
    return bolusPerMeal;
  }

  static double getCorrectionFactor(
      double totalUnits, bool rapidInsulin, bool usualInsulin) {
    if (rapidInsulin && !usualInsulin) {
      return 1500 / totalUnits;
    } else if (usualInsulin && !rapidInsulin) {
      return 1800 / totalUnits;
    } else {
      throw ArgumentError("Invalid insulin type or several types chosen");
    }
  }

  double getPremealCorrectionUnits(
      double currentBodyGlucose, String insulinType, double corrFactor) {
    if (afterMealTargetBodyGlucose > currentBodyGlucose) {
      return (-1 *
          (currentBodyGlucose - afterMealTargetBodyGlucose).abs() /
          corrFactor)
          .roundToDouble();
    } else {
      return ((currentBodyGlucose - afterMealTargetBodyGlucose) / corrFactor)
          .roundToDouble();
    }
  }

  double getAfterMealInsulin(double carbsInGrams, double correctionUnits) {
    double carbsToInsulinRatio = (500 / totalUnits).roundToDouble();
    return (carbsInGrams / carbsToInsulinRatio + correctionUnits)
        .roundToDouble();
  }
}


void main() {
  double totalUnitsVal = 40;
  double basalPercentageVal = 0.4;
  double bolusPercentageVal = 0.6;
  int mealsPerDayVal = 3;
  double afterMealTargetGlucoseVal = 90;

  InsulinCalculator insulinCalc = InsulinCalculator(
      totalUnitsVal,
      basalPercentageVal,
      bolusPercentageVal,
      mealsPerDayVal,
      afterMealTargetGlucoseVal);

  double currentGlucose = 160;
  double corrFactor = InsulinCalculator.getCorrectionFactor(
      totalUnitsVal, true, false);
  double premealCorrUnits = insulinCalc.getPremealCorrectionUnits(
      currentGlucose, "rapid", corrFactor);
  print("Premeal correction units: $premealCorrUnits");

  double carbsIntake = 77; // in gram
  double afterMealInsulin = insulinCalc.getAfterMealInsulin(carbsIntake, premealCorrUnits);
  print("After meal insulin needed for 60g carbs: $afterMealInsulin units");
}