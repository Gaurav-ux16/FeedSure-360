enum DemoScenario {
  goodFeed,
  variableSample,
  insufficientEvidence,
  storageWarning,
  nutritionImbalance,
  visualAnomaly,
}

class DemoScenarioConfig {
  final DemoScenario scenario;
  final String title;
  final String description;
  final bool evidenceTrusted;
  final double evidenceSufficiency; // e.g. 0.86
  final String nirEvidenceLevel;     // HIGH, MEDIUM, LOW
  final String imageEvidenceLevel;   // GOOD, SUSPICIOUS, POOR
  final String samplingConsistency;  // HIGH, MEDIUM, LOW
  final String calibrationStatus;    // VALID, OUT_OF_BOUNDS
  final String uncertaintyLevel;     // LOW, MODERATE, HIGH
  final double sampleConsistencyPercent; // e.g. 92%
  final String overallQuality;       // Good, Fair, Needs Review, Poor
  final double crudeProtein;         // e.g. 15.8%
  final double dryMatter;            // e.g. 36.2%
  final double ndf;                  // e.g. 42.0%
  final double adf;                  // e.g. 28.5%
  final double energyValue;          // e.g. 2.6 Mcal/kg
  final String visualMouldRisk;      // Not Detected, Low Risk, Requires Inspection
  final String visualForeignMat;     // Not Detected, Detected
  final String visualSurfaceAnomaly; // Not Detected, Possible, Detected
  final bool hasStorageWarning;
  final double storageTemp;
  final double storageHumidity;
  final double storagePh;
  final String dairyAdvisoryStatus;  // Optimal, Needs Improvement, Critical Alert

  const DemoScenarioConfig({
    required this.scenario,
    required this.title,
    required this.description,
    required this.evidenceTrusted,
    required this.evidenceSufficiency,
    required this.nirEvidenceLevel,
    required this.imageEvidenceLevel,
    required this.samplingConsistency,
    required this.calibrationStatus,
    required this.uncertaintyLevel,
    required this.sampleConsistencyPercent,
    required this.overallQuality,
    required this.crudeProtein,
    required this.dryMatter,
    required this.ndf,
    required this.adf,
    required this.energyValue,
    required this.visualMouldRisk,
    required this.visualForeignMat,
    required this.visualSurfaceAnomaly,
    required this.hasStorageWarning,
    required this.storageTemp,
    required this.storageHumidity,
    required this.storagePh,
    required this.dairyAdvisoryStatus,
  });

  static DemoScenarioConfig getConfig(DemoScenario scenario) {
    switch (scenario) {
      case DemoScenario.goodFeed:
        return const DemoScenarioConfig(
          scenario: DemoScenario.goodFeed,
          title: "Scenario 1: GOOD FEED",
          description: "High evidence sufficiency, optimal nutritional composition, trusted result.",
          evidenceTrusted: true,
          evidenceSufficiency: 0.86,
          nirEvidenceLevel: "HIGH",
          imageEvidenceLevel: "GOOD",
          samplingConsistency: "HIGH",
          calibrationStatus: "VALID",
          uncertaintyLevel: "LOW",
          sampleConsistencyPercent: 94.0,
          overallQuality: "Good Quality",
          crudeProtein: 15.8,
          dryMatter: 36.2,
          ndf: 42.0,
          adf: 28.5,
          energyValue: 2.6,
          visualMouldRisk: "Not Detected",
          visualForeignMat: "Not Detected",
          visualSurfaceAnomaly: "Not Detected",
          hasStorageWarning: false,
          storageTemp: 18.4,
          storageHumidity: 62.0,
          storagePh: 4.2,
          dairyAdvisoryStatus: "Optimal Balance",
        );

      case DemoScenario.variableSample:
        return const DemoScenarioConfig(
          scenario: DemoScenario.variableSample,
          title: "Scenario 2: VARIABLE SAMPLE",
          description: "Sample points show spatial variation; highlighted in nutrition map.",
          evidenceTrusted: true,
          evidenceSufficiency: 0.74,
          nirEvidenceLevel: "HIGH",
          imageEvidenceLevel: "GOOD",
          samplingConsistency: "MEDIUM",
          calibrationStatus: "VALID",
          uncertaintyLevel: "MODERATE",
          sampleConsistencyPercent: 78.0,
          overallQuality: "Fair Quality",
          crudeProtein: 14.2,
          dryMatter: 34.0,
          ndf: 44.5,
          adf: 30.1,
          energyValue: 2.4,
          visualMouldRisk: "Low Risk",
          visualForeignMat: "Not Detected",
          visualSurfaceAnomaly: "Possible",
          hasStorageWarning: false,
          storageTemp: 22.1,
          storageHumidity: 65.0,
          storagePh: 4.4,
          dairyAdvisoryStatus: "Needs Improvement",
        );

      case DemoScenario.insufficientEvidence:
        return const DemoScenarioConfig(
          scenario: DemoScenario.insufficientEvidence,
          title: "Scenario 3: INSUFFICIENT EVIDENCE",
          description: "Low confidence / Out of bounds; guides farmer to Path B (More Evidence Required).",
          evidenceTrusted: false,
          evidenceSufficiency: 0.48,
          nirEvidenceLevel: "LOW",
          imageEvidenceLevel: "INCONCLUSIVE",
          samplingConsistency: "LOW",
          calibrationStatus: "OUT_OF_BOUNDS",
          uncertaintyLevel: "HIGH",
          sampleConsistencyPercent: 52.0,
          overallQuality: "Result Not Trusted",
          crudeProtein: 0.0,
          dryMatter: 0.0,
          ndf: 0.0,
          adf: 0.0,
          energyValue: 0.0,
          visualMouldRisk: "Requires Inspection",
          visualForeignMat: "Possible",
          visualSurfaceAnomaly: "Detected",
          hasStorageWarning: false,
          storageTemp: 24.5,
          storageHumidity: 70.0,
          storagePh: 4.9,
          dairyAdvisoryStatus: "Re-test Required",
        );

      case DemoScenario.storageWarning:
        return const DemoScenarioConfig(
          scenario: DemoScenario.storageWarning,
          title: "Scenario 4: STORAGE WARNING",
          description: "Elevated temperature/humidity detected in storage pit; trigger retest advisory.",
          evidenceTrusted: true,
          evidenceSufficiency: 0.82,
          nirEvidenceLevel: "HIGH",
          imageEvidenceLevel: "GOOD",
          samplingConsistency: "HIGH",
          calibrationStatus: "VALID",
          uncertaintyLevel: "LOW",
          sampleConsistencyPercent: 88.0,
          overallQuality: "Attention Needed",
          crudeProtein: 13.9,
          dryMatter: 33.1,
          ndf: 46.0,
          adf: 31.8,
          energyValue: 2.3,
          visualMouldRisk: "Low Risk",
          visualForeignMat: "Not Detected",
          visualSurfaceAnomaly: "Possible",
          hasStorageWarning: true,
          storageTemp: 31.4,
          storageHumidity: 78.5,
          storagePh: 5.2,
          dairyAdvisoryStatus: "Storage Risk Alert",
        );

      case DemoScenario.nutritionImbalance:
        return const DemoScenarioConfig(
          scenario: DemoScenario.nutritionImbalance,
          title: "Scenario 5: NUTRITION IMBALANCE",
          description: "Low protein / high fibre ration triggering specific protein enrichment advice.",
          evidenceTrusted: true,
          evidenceSufficiency: 0.85,
          nirEvidenceLevel: "HIGH",
          imageEvidenceLevel: "GOOD",
          samplingConsistency: "HIGH",
          calibrationStatus: "VALID",
          uncertaintyLevel: "LOW",
          sampleConsistencyPercent: 91.0,
          overallQuality: "Good (Low Protein)",
          crudeProtein: 8.7,
          dryMatter: 34.2,
          ndf: 48.2,
          adf: 33.4,
          energyValue: 2.1,
          visualMouldRisk: "Not Detected",
          visualForeignMat: "Not Detected",
          visualSurfaceAnomaly: "Not Detected",
          hasStorageWarning: false,
          storageTemp: 19.0,
          storageHumidity: 60.0,
          storagePh: 4.1,
          dairyAdvisoryStatus: "Needs Improvement",
        );

      case DemoScenario.visualAnomaly:
        return const DemoScenarioConfig(
          scenario: DemoScenario.visualAnomaly,
          title: "Scenario 6: VISUAL ANOMALY",
          description: "Guided camera flags mould-like surface anomaly on image analysis overlay.",
          evidenceTrusted: true,
          evidenceSufficiency: 0.79,
          nirEvidenceLevel: "HIGH",
          imageEvidenceLevel: "SUSPICIOUS",
          samplingConsistency: "HIGH",
          calibrationStatus: "VALID",
          uncertaintyLevel: "LOW",
          sampleConsistencyPercent: 85.0,
          overallQuality: "Requires Visual Inspection",
          crudeProtein: 14.8,
          dryMatter: 35.0,
          ndf: 43.1,
          adf: 29.0,
          energyValue: 2.5,
          visualMouldRisk: "Requires Inspection",
          visualForeignMat: "Not Detected",
          visualSurfaceAnomaly: "Detected",
          hasStorageWarning: false,
          storageTemp: 21.0,
          storageHumidity: 66.0,
          storagePh: 4.3,
          dairyAdvisoryStatus: "Inspect Pit Surface",
        );
    }
  }
}
