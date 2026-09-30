import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/simulation_engine_provider.dart';
import '../../providers/testing_workflow_provider.dart';
import '../../widgets/status_badge.dart';

class FeedQualityResultScreen extends ConsumerWidget {
  const FeedQualityResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final engine = ref.watch(simulationEngineProvider);
    final workflow = ref.watch(testingWorkflowProvider);
    final batchId = workflow.currentBatch?.batchNumber ?? "FS-2026-00128";
    final nutrition = workflow.nutritionResult ?? engine.generateNutritionResult(batchId);
    final evidence = workflow.evidenceAssessment ?? engine.evaluateEvidence(batchId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Feed Analysis Results"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overall Rating Header Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surfaceGreen,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.cardBorder, width: 1.5),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.verified_rounded, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nutrition.overallQuality,
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                              Text(
                                "${workflow.selectedFeedType} • Batch $batchId",
                                style: const TextStyle(fontSize: 12, color: AppColors.textMedium),
                              ),
                            ],
                          ),
                        ),
                        const StatusBadge(label: "Overall: Good", type: BadgeType.success),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Divider(color: AppColors.cardBorder, height: 1),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _summaryMetric("Evidence", evidence.nirEvidence, AppColors.primaryGreen),
                        _summaryMetric("Calibration", evidence.calibrationApplicability, AppColors.primaryGreen),
                        _summaryMetric("Sample Quality", "Good", AppColors.primaryGreen),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Nutritional Composition Grid
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Nutritional Composition",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  TextButton.icon(
                    onPressed: () => context.push('/test/nutrition-map'),
                    icon: const Icon(Icons.grid_view_rounded, size: 16, color: AppColors.primaryGreen),
                    label: const Text("Nutrition Map", style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    _nutrientRow("Crude Protein (CP)", "${nutrition.crudeProtein}%", isHighlight: true),
                    const Divider(height: 1, color: AppColors.divider),
                    _nutrientRow("Dry Matter (DM)", "${nutrition.dryMatter}%"),
                    const Divider(height: 1, color: AppColors.divider),
                    _nutrientRow("Neutral Detergent Fiber (NDF)", "${nutrition.ndf}%"),
                    const Divider(height: 1, color: AppColors.divider),
                    _nutrientRow("Acid Detergent Fiber (ADF)", "${nutrition.adf}%"),
                    const Divider(height: 1, color: AppColors.divider),
                    _nutrientRow("Energy Value", "${nutrition.energyValue} Mcal/kg"),
                    const Divider(height: 1, color: AppColors.divider),
                    _nutrientRow("Minerals (Calcium / Phosphorus)", "${nutrition.calcium}% / ${nutrition.phosphorus}%"),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Contaminant / Urea Adulteration Screening
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F8E9),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFC8E6C9)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.shield_outlined, color: AppColors.primaryGreen, size: 24),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Adulteration Screening",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primaryDark),
                          ),
                          Text(
                            "No synthetic urea or chemical adulterants detected.",
                            style: TextStyle(fontSize: 12, color: AppColors.textMedium),
                          ),
                        ],
                      ),
                    ),
                    StatusBadge(label: nutrition.ureaAdulteration, type: BadgeType.success, fontSize: 11),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/passport'),
                      icon: const Icon(Icons.card_membership_outlined, size: 18),
                      label: const Text("View Passport"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => context.go('/dairy'),
                      icon: const Icon(Icons.arrow_forward, size: 18),
                      label: const Text("Get Advisory"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryMetric(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMedium)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _nutrientRow(String name, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
              color: isHighlight ? AppColors.primaryDark : AppColors.textDark,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isHighlight ? AppColors.primaryGreen : AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
