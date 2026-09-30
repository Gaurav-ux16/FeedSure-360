import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/feed_batch_model.dart';
import '../models/nutrition_result_model.dart';
import '../models/evidence_model.dart';

class BatchState {
  final List<FeedBatch> batches;
  final FeedBatch? selectedBatch;

  const BatchState({
    required this.batches,
    this.selectedBatch,
  });

  BatchState copyWith({
    List<FeedBatch>? batches,
    FeedBatch? selectedBatch,
  }) {
    return BatchState(
      batches: batches ?? this.batches,
      selectedBatch: selectedBatch ?? this.selectedBatch,
    );
  }
}

class BatchNotifier extends StateNotifier<BatchState> {
  BatchNotifier() : super(_initialBatches());

  static BatchState _initialBatches() {
    final batch1 = FeedBatch(
      id: "b1",
      batchNumber: "FS-2026-00128",
      feedType: "Maize Silage",
      source: "Farm Produced",
      storageLocation: "Silage Pit 01",
      notes: "Harvested at 35% DM, 120 days fermentation",
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      status: "Completed",
      nutritionResult: NutritionResult(
        batchId: "FS-2026-00128",
        overallQuality: "Good Quality",
        crudeProtein: 15.8,
        dryMatter: 36.2,
        ndf: 42.0,
        adf: 28.5,
        energyValue: 2.6,
        calcium: 0.6,
        phosphorus: 0.4,
        ureaAdulteration: "Not Detected",
        pointMeasurements: [17.2, 17.5, 17.0, 16.9, 12.8, 17.1, 17.0, 16.8, 17.3],
        averageMeasurement: 16.7,
        outlierIndex: 4,
        analyzedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      evidenceAssessment: const EvidenceAssessment(
        batchId: "FS-2026-00128",
        isTrusted: true,
        sufficiencyScore: 0.86,
        nirEvidence: "HIGH",
        imageEvidence: "GOOD",
        samplingConsistency: "HIGH",
        calibrationApplicability: "VALID",
        predictionUncertainty: "LOW",
        sampleConsistencyPercent: 92.0,
        visualForeignMaterial: "Not Detected",
        visualSurfaceAnomaly: "Possible",
        visualMouldRisk: "Low Risk",
      ),
    );

    final batch2 = FeedBatch(
      id: "b2",
      batchNumber: "FS-2026-00124",
      feedType: "Dry Fodder",
      source: "Purchased (Local Mandi)",
      storageLocation: "Shed Bay 2",
      notes: "Wheat straw batch with urea treatment",
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      status: "Completed",
      nutritionResult: NutritionResult(
        batchId: "FS-2026-00124",
        overallQuality: "Fair Quality",
        crudeProtein: 6.8,
        dryMatter: 88.5,
        ndf: 65.2,
        adf: 44.0,
        energyValue: 1.8,
        pointMeasurements: [6.8, 6.7, 6.9, 6.8, 6.8, 6.9, 6.7, 6.8, 6.8],
        averageMeasurement: 6.8,
        analyzedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      evidenceAssessment: const EvidenceAssessment(
        batchId: "FS-2026-00124",
        isTrusted: true,
        sufficiencyScore: 0.82,
        nirEvidence: "HIGH",
        imageEvidence: "GOOD",
        samplingConsistency: "HIGH",
        calibrationApplicability: "VALID",
        predictionUncertainty: "LOW",
        sampleConsistencyPercent: 90.0,
      ),
    );

    final batch3 = FeedBatch(
      id: "b3",
      batchNumber: "FS-2026-00118",
      feedType: "Concentrate Feed",
      source: "Kisan Cattle Feed Mills",
      storageLocation: "Feed Store Room",
      notes: "Pelleted cattle feed 20% CP blend",
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      status: "Completed",
      nutritionResult: NutritionResult(
        batchId: "FS-2026-00118",
        overallQuality: "Good Quality",
        crudeProtein: 18.4,
        dryMatter: 90.2,
        ndf: 28.1,
        adf: 14.5,
        energyValue: 3.1,
        pointMeasurements: [18.4, 18.5, 18.3, 18.4, 18.6, 18.4, 18.3, 18.5, 18.4],
        averageMeasurement: 18.4,
        analyzedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      evidenceAssessment: const EvidenceAssessment(
        batchId: "FS-2026-00118",
        isTrusted: true,
        sufficiencyScore: 0.91,
        nirEvidence: "HIGH",
        imageEvidence: "GOOD",
        samplingConsistency: "HIGH",
        calibrationApplicability: "VALID",
        predictionUncertainty: "LOW",
        sampleConsistencyPercent: 96.0,
      ),
    );

    return BatchState(
      batches: [batch1, batch2, batch3],
      selectedBatch: batch1,
    );
  }

  void addBatch(FeedBatch batch) {
    state = state.copyWith(
      batches: [batch, ...state.batches],
      selectedBatch: batch,
    );
  }

  void updateBatch(FeedBatch updated) {
    final list = state.batches.map((b) => b.id == updated.id ? updated : b).toList();
    state = state.copyWith(
      batches: list,
      selectedBatch: updated.id == state.selectedBatch?.id ? updated : state.selectedBatch,
    );
  }

  void selectBatch(String id) {
    final found = state.batches.firstWhere((b) => b.id == id || b.batchNumber == id, orElse: () => state.batches.first);
    state = state.copyWith(selectedBatch: found);
  }
}

final batchProvider = StateNotifierProvider<BatchNotifier, BatchState>((ref) {
  return BatchNotifier();
});
