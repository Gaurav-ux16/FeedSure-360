class NutritionResult {
  final String batchId;
  final String overallQuality; // Good Quality, Fair Quality, Attention Needed
  final double crudeProtein;   // CP %
  final double dryMatter;      // DM %
  final double ndf;            // Neutral Detergent Fiber %
  final double adf;            // Acid Detergent Fiber %
  final double energyValue;    // Mcal/kg or MJ/kg
  final double calcium;        // %
  final double phosphorus;     // %
  final String ureaAdulteration; // Not Detected, Suspicious, Detected
  final List<double> pointMeasurements; // Multi-point 3x3 measurements
  final double averageMeasurement;
  final int? outlierIndex;
  final DateTime analyzedAt;

  const NutritionResult({
    required this.batchId,
    required this.overallQuality,
    required this.crudeProtein,
    required this.dryMatter,
    required this.ndf,
    required this.adf,
    required this.energyValue,
    this.calcium = 0.6,
    this.phosphorus = 0.4,
    this.ureaAdulteration = "Not Detected",
    required this.pointMeasurements,
    required this.averageMeasurement,
    this.outlierIndex,
    required this.analyzedAt,
  });
}
