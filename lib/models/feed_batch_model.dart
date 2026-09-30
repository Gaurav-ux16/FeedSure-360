import 'nutrition_result_model.dart';
import 'evidence_model.dart';

class SamplePoint {
  final int index;
  final int row;
  final int col;
  final bool isCollected;
  final double? nirValue;

  const SamplePoint({
    required this.index,
    required this.row,
    required this.col,
    this.isCollected = false,
    this.nirValue,
  });

  SamplePoint copyWith({bool? isCollected, double? nirValue}) {
    return SamplePoint(
      index: index,
      row: row,
      col: col,
      isCollected: isCollected ?? this.isCollected,
      nirValue: nirValue ?? this.nirValue,
    );
  }
}

class FeedBatch {
  final String id;
  final String batchNumber; // e.g. FS-2026-00128
  final String feedType;    // Maize Silage, Dry Fodder, etc.
  final String source;      // Farm Produced, Purchased, Co-op
  final String storageLocation; // Silage Pit 01, Bunker A
  final String notes;
  final DateTime createdAt;
  final List<SamplePoint> samplePoints;
  final NutritionResult? nutritionResult;
  final EvidenceAssessment? evidenceAssessment;
  final String status; // Created, Sampling, Scanned, Analyzed, Completed
  final bool isSynced;

  const FeedBatch({
    required this.id,
    required this.batchNumber,
    required this.feedType,
    required this.source,
    required this.storageLocation,
    this.notes = '',
    required this.createdAt,
    this.samplePoints = const [],
    this.nutritionResult,
    this.evidenceAssessment,
    this.status = 'Created',
    this.isSynced = true,
  });

  FeedBatch copyWith({
    String? id,
    String? batchNumber,
    String? feedType,
    String? source,
    String? storageLocation,
    String? notes,
    DateTime? createdAt,
    List<SamplePoint>? samplePoints,
    NutritionResult? nutritionResult,
    EvidenceAssessment? evidenceAssessment,
    String? status,
    bool? isSynced,
  }) {
    return FeedBatch(
      id: id ?? this.id,
      batchNumber: batchNumber ?? this.batchNumber,
      feedType: feedType ?? this.feedType,
      source: source ?? this.source,
      storageLocation: storageLocation ?? this.storageLocation,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      samplePoints: samplePoints ?? this.samplePoints,
      nutritionResult: nutritionResult ?? this.nutritionResult,
      evidenceAssessment: evidenceAssessment ?? this.evidenceAssessment,
      status: status ?? this.status,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
