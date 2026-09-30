import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/feed_batch_model.dart';
import '../models/nutrition_result_model.dart';
import '../models/evidence_model.dart';
import 'simulation_engine_provider.dart';
import 'batch_provider.dart';

class TestingWorkflowState {
  final String selectedFeedType;
  final String aiIdentifiedFeedType;
  final double aiConfidence;
  final FeedBatch? currentBatch;
  final List<SamplePoint> samplePoints;
  final int collectedSampleCount;
  final bool isDeviceConnected;
  final String connectedDeviceId;
  final int deviceBattery;
  final int currentScanPoint;
  final int totalScanPoints;
  final double scanSignalQuality;
  final double currentTemp;
  final double currentHumidity;
  final double currentWeight;
  final bool isScanning;
  // Camera Quality Checks
  final bool lightingOk;
  final bool focusOk;
  final bool coverageOk;
  final bool imageCaptured;
  final String capturedImagePath;
  final Uint8List? imageBytes;
  // Evidence & Result
  final EvidenceAssessment? evidenceAssessment;
  final NutritionResult? nutritionResult;
  final bool isAnalysisComplete;

  const TestingWorkflowState({
    this.selectedFeedType = "Maize Silage",
    this.aiIdentifiedFeedType = "Maize Silage",
    this.aiConfidence = 0.92,
    this.currentBatch,
    this.samplePoints = const [],
    this.collectedSampleCount = 4,
    this.isDeviceConnected = true,
    this.connectedDeviceId = "FS-NIR-001",
    this.deviceBattery = 82,
    this.currentScanPoint = 2,
    this.totalScanPoints = 5,
    this.scanSignalQuality = 92.0,
    this.currentTemp = 30.8,
    this.currentHumidity = 69.0,
    this.currentWeight = 8.4,
    this.isScanning = false,
    this.lightingOk = true,
    this.focusOk = true,
    this.coverageOk = true,
    this.imageCaptured = false,
    this.capturedImagePath = "",
    this.imageBytes,
    this.evidenceAssessment,
    this.nutritionResult,
    this.isAnalysisComplete = false,
  });

  TestingWorkflowState copyWith({
    String? selectedFeedType,
    String? aiIdentifiedFeedType,
    double? aiConfidence,
    FeedBatch? currentBatch,
    List<SamplePoint>? samplePoints,
    int? collectedSampleCount,
    bool? isDeviceConnected,
    String? connectedDeviceId,
    int? deviceBattery,
    int? currentScanPoint,
    int? totalScanPoints,
    double? scanSignalQuality,
    double? currentTemp,
    double? currentHumidity,
    double? currentWeight,
    bool? isScanning,
    bool? lightingOk,
    bool? focusOk,
    bool? coverageOk,
    bool? imageCaptured,
    String? capturedImagePath,
    Uint8List? imageBytes,
    EvidenceAssessment? evidenceAssessment,
    NutritionResult? nutritionResult,
    bool? isAnalysisComplete,
  }) {
    return TestingWorkflowState(
      selectedFeedType: selectedFeedType ?? this.selectedFeedType,
      aiIdentifiedFeedType: aiIdentifiedFeedType ?? this.aiIdentifiedFeedType,
      aiConfidence: aiConfidence ?? this.aiConfidence,
      currentBatch: currentBatch ?? this.currentBatch,
      samplePoints: samplePoints ?? this.samplePoints,
      collectedSampleCount: collectedSampleCount ?? this.collectedSampleCount,
      isDeviceConnected: isDeviceConnected ?? this.isDeviceConnected,
      connectedDeviceId: connectedDeviceId ?? this.connectedDeviceId,
      deviceBattery: deviceBattery ?? this.deviceBattery,
      currentScanPoint: currentScanPoint ?? this.currentScanPoint,
      totalScanPoints: totalScanPoints ?? this.totalScanPoints,
      scanSignalQuality: scanSignalQuality ?? this.scanSignalQuality,
      currentTemp: currentTemp ?? this.currentTemp,
      currentHumidity: currentHumidity ?? this.currentHumidity,
      currentWeight: currentWeight ?? this.currentWeight,
      isScanning: isScanning ?? this.isScanning,
      lightingOk: lightingOk ?? this.lightingOk,
      focusOk: focusOk ?? this.focusOk,
      coverageOk: coverageOk ?? this.coverageOk,
      imageCaptured: imageCaptured ?? this.imageCaptured,
      capturedImagePath: capturedImagePath ?? this.capturedImagePath,
      imageBytes: imageBytes ?? this.imageBytes,
      evidenceAssessment: evidenceAssessment ?? this.evidenceAssessment,
      nutritionResult: nutritionResult ?? this.nutritionResult,
      isAnalysisComplete: isAnalysisComplete ?? this.isAnalysisComplete,
    );
  }
}

class TestingWorkflowNotifier extends StateNotifier<TestingWorkflowState> {
  final Ref ref;

  TestingWorkflowNotifier(this.ref) : super(const TestingWorkflowState()) {
    _initializeSamplingGrid();
  }

  void _initializeSamplingGrid() {
    final points = <SamplePoint>[];
    int idx = 0;
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 3; c++) {
        // Preset 4 points collected for visual demo match
        bool isCollected = (r == 0 && c == 0) || (r == 0 && c == 2) || (r == 1 && c == 1) || (r == 2 && c == 1);
        points.add(SamplePoint(index: idx, row: r, col: c, isCollected: isCollected));
        idx++;
      }
    }
    state = state.copyWith(
      samplePoints: points,
      collectedSampleCount: points.where((p) => p.isCollected).length,
    );
  }

  void selectFeedType(String type) {
    state = state.copyWith(selectedFeedType: type);
  }

  void setAIIdentifiedFeed(String feedType, double confidence) {
    state = state.copyWith(
      aiIdentifiedFeedType: feedType,
      selectedFeedType: feedType,
      aiConfidence: confidence,
    );
  }

  void createBatch({
    required String feedType,
    required String batchNumber,
    required String source,
    required String storageLocation,
    String notes = '',
  }) {
    final newBatch = FeedBatch(
      id: const Uuid().v4(),
      batchNumber: batchNumber,
      feedType: feedType,
      source: source,
      storageLocation: storageLocation,
      notes: notes,
      createdAt: DateTime.now(),
      samplePoints: state.samplePoints,
      status: 'Sampling',
    );
    state = state.copyWith(currentBatch: newBatch);
    ref.read(batchProvider.notifier).addBatch(newBatch);
  }

  void toggleSamplePoint(int index) {
    final updated = List<SamplePoint>.from(state.samplePoints);
    if (index >= 0 && index < updated.length) {
      final current = updated[index];
      updated[index] = current.copyWith(isCollected: !current.isCollected);
      state = state.copyWith(
        samplePoints: updated,
        collectedSampleCount: updated.where((p) => p.isCollected).length,
      );
    }
  }

  void setDeviceConnected(bool connected) {
    state = state.copyWith(isDeviceConnected: connected);
  }

  void updateScanProgress(int point) {
    state = state.copyWith(
      currentScanPoint: point,
      scanSignalQuality: 92.0 + (point % 3) * 1.5,
      currentTemp: 30.5 + (point * 0.1),
      currentHumidity: 68.5 + (point * 0.2),
    );
  }

  void updateCameraChecks({bool? lighting, bool? focus, bool? coverage}) {
    state = state.copyWith(
      lightingOk: lighting ?? state.lightingOk,
      focusOk: focus ?? state.focusOk,
      coverageOk: coverage ?? state.coverageOk,
    );
  }

  // Set captured image information (for upload or camera)
  void setCapturedImage({Uint8List? bytes, String? path}) {
    state = state.copyWith(
      imageCaptured: true,
      imageBytes: bytes ?? state.imageBytes,
      capturedImagePath: path ?? state.capturedImagePath,
    );
  }

  void clearCapturedImage() {
    state = state.copyWith(
      imageCaptured: false,
      imageBytes: null,
      capturedImagePath: '',
    );
  }

  void runFullAnalysis() {
    final engine = ref.read(simulationEngineProvider);
    final batchId = state.currentBatch?.batchNumber ?? "FS-2026-00128";
    
    final evidence = engine.evaluateEvidence(batchId);
    final nutrition = engine.generateNutritionResult(batchId);

    state = state.copyWith(
      evidenceAssessment: evidence,
      nutritionResult: nutrition,
      isAnalysisComplete: true,
    );

    if (state.currentBatch != null) {
      final updated = state.currentBatch!.copyWith(
        status: evidence.isTrusted ? "Completed" : "Requires Evidence",
        evidenceAssessment: evidence,
        nutritionResult: nutrition,
      );
      ref.read(batchProvider.notifier).updateBatch(updated);
      state = state.copyWith(currentBatch: updated);
    }
  }
}

final testingWorkflowProvider = StateNotifierProvider<TestingWorkflowNotifier, TestingWorkflowState>((ref) {
  return TestingWorkflowNotifier(ref);
});
