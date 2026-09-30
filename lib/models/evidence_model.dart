class EvidenceAssessment {
  final String batchId;
  final bool isTrusted;
  final double sufficiencyScore; // 0.0 to 1.0 (e.g. 0.86)
  final String nirEvidence;       // HIGH, MEDIUM, LOW
  final String imageEvidence;     // GOOD, SUSPICIOUS, INCONCLUSIVE
  final String samplingConsistency; // HIGH, MEDIUM, LOW
  final String calibrationApplicability; // VALID, EXPIRED, OUT_OF_BOUNDS
  final String predictionUncertainty;    // LOW, MODERATE, HIGH
  final double sampleConsistencyPercent; // e.g. 92.0
  final String? visualForeignMaterial;
  final String? visualSurfaceAnomaly;
  final String? visualMouldRisk;
  final List<String> recommendedNextSteps;

  const EvidenceAssessment({
    required this.batchId,
    required this.isTrusted,
    required this.sufficiencyScore,
    required this.nirEvidence,
    required this.imageEvidence,
    required this.samplingConsistency,
    required this.calibrationApplicability,
    required this.predictionUncertainty,
    required this.sampleConsistencyPercent,
    this.visualForeignMaterial = "Not Detected",
    this.visualSurfaceAnomaly = "Not Detected",
    this.visualMouldRisk = "Not Detected",
    this.recommendedNextSteps = const [],
  });
}

class NIRSpectrumPoint {
  final double wavelength; // nm (e.g. 900 to 1700)
  final double absorbance; // absorbance/intensity

  const NIRSpectrumPoint(this.wavelength, this.absorbance);
}
