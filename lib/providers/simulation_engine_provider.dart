import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/demo_scenarios.dart';
import '../models/evidence_model.dart';
import '../models/nutrition_result_model.dart';

final activeScenarioProvider = StateProvider<DemoScenario>((ref) {
  return DemoScenario.goodFeed;
});

final simulationEngineProvider = Provider<SimulationEngine>((ref) {
  final scenario = ref.watch(activeScenarioProvider);
  return SimulationEngine(scenario: scenario);
});

class SimulationEngine {
  final DemoScenario scenario;
  final DemoScenarioConfig config;

  SimulationEngine({required this.scenario})
      : config = DemoScenarioConfig.getConfig(scenario);

  // Generates 40-point realistic NIR spectra curve (1100nm to 2400nm)
  List<NIRSpectrumPoint> generateNIRSpectrum({int sampleIndex = 1}) {
    final List<NIRSpectrumPoint> points = [];
    final random = Random(42 + sampleIndex);
    
    // Baseline shape for forage/silage NIR spectrum with characteristic absorption bands:
    // Water (1450nm, 1940nm), Protein (1510nm, 2180nm), Fiber/Cellulose (2100-2300nm)
    for (int wl = 1100; wl <= 2400; wl += 30) {
      double baseAbsorbance = 0.45;
      
      // Moisture peak around 1450nm
      baseAbsorbance += 0.35 * exp(-pow((wl - 1450) / 90.0, 2));
      // Protein/CH peak around 1720nm
      baseAbsorbance += 0.22 * exp(-pow((wl - 1720) / 70.0, 2));
      // Water absorption peak around 1940nm
      baseAbsorbance += 0.55 * exp(-pow((wl - 1940) / 110.0, 2));
      // Fiber/Lignin band around 2270nm
      baseAbsorbance += 0.40 * exp(-pow((wl - 2270) / 80.0, 2));
      
      // Scenario specific adjustments
      if (scenario == DemoScenario.insufficientEvidence) {
        // Flat or noisy erroneous spectrum
        baseAbsorbance += (random.nextDouble() - 0.5) * 0.25;
      } else if (scenario == DemoScenario.variableSample) {
        baseAbsorbance += (random.nextDouble() - 0.5) * 0.08 * sampleIndex;
      } else {
        baseAbsorbance += (random.nextDouble() - 0.5) * 0.02;
      }

      points.add(NIRSpectrumPoint(wl.toDouble(), baseAbsorbance.clamp(0.1, 1.8)));
    }
    return points;
  }

  // Generates 3x3 nutrition grid points
  List<double> generateNutritionMapPoints() {
    if (scenario == DemoScenario.variableSample) {
      // Outlier in middle center
      return [17.2, 17.5, 17.0, 16.9, 12.8, 17.1, 17.0, 16.8, 17.3];
    } else if (scenario == DemoScenario.nutritionImbalance) {
      return [8.8, 8.6, 8.9, 8.5, 8.7, 8.6, 8.8, 8.7, 8.6];
    } else {
      // Good Feed homogenous
      return [15.7, 15.9, 15.8, 15.6, 15.8, 16.0, 15.7, 15.8, 15.9];
    }
  }

  EvidenceAssessment evaluateEvidence(String batchId) {
    List<String> nextSteps = [];
    if (!config.evidenceTrusted) {
      nextSteps = [
        "Collect More Samples (3x3 grid)",
        "Additional High-Resolution Image",
        "Urea Test Strip Confirmation",
        "Send Sample to Confirmatory Lab"
      ];
    }

    return EvidenceAssessment(
      batchId: batchId,
      isTrusted: config.evidenceTrusted,
      sufficiencyScore: config.evidenceSufficiency,
      nirEvidence: config.nirEvidenceLevel,
      imageEvidence: config.imageEvidenceLevel,
      samplingConsistency: config.samplingConsistency,
      calibrationApplicability: config.calibrationStatus,
      predictionUncertainty: config.uncertaintyLevel,
      sampleConsistencyPercent: config.sampleConsistencyPercent,
      visualForeignMaterial: config.visualForeignMat,
      visualSurfaceAnomaly: config.visualSurfaceAnomaly,
      visualMouldRisk: config.visualMouldRisk,
      recommendedNextSteps: nextSteps,
    );
  }

  NutritionResult generateNutritionResult(String batchId) {
    final points = generateNutritionMapPoints();
    final avg = points.reduce((a, b) => a + b) / points.length;
    
    return NutritionResult(
      batchId: batchId,
      overallQuality: config.overallQuality,
      crudeProtein: config.crudeProtein,
      dryMatter: config.dryMatter,
      ndf: config.ndf,
      adf: config.adf,
      energyValue: config.energyValue,
      calcium: 0.6,
      phosphorus: 0.4,
      ureaAdulteration: "Not Detected",
      pointMeasurements: points,
      averageMeasurement: double.parse(avg.toStringAsFixed(1)),
      outlierIndex: scenario == DemoScenario.variableSample ? 4 : null,
      analyzedAt: DateTime.now(),
    );
  }
}
