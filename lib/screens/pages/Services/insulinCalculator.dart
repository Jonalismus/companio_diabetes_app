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
