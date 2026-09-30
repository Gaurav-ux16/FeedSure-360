import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/simulation_engine_provider.dart';
import '../../providers/testing_workflow_provider.dart';
import '../../widgets/nutrition_grid_widget.dart';

class NutritionMapScreen extends ConsumerStatefulWidget {
  const NutritionMapScreen({super.key});

  @override
  ConsumerState<NutritionMapScreen> createState() => _NutritionMapScreenState();
}

class _NutritionMapScreenState extends ConsumerState<NutritionMapScreen> {
  int _selectedPointIndex = -1;
  @override
  Widget build(BuildContext context) {
    final engine = ref.watch(simulationEngineProvider);
    final workflow = ref.watch(testingWorkflowProvider);
    final batchId = workflow.currentBatch?.batchNumber ?? "FS-2026-00128";
    final nutrition = workflow.nutritionResult ?? engine.generateNutritionResult(batchId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Nutrition Map"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "CP Across Sample Points (%)",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Spatial distribution of Crude Protein across the 3x3 sampling grid.",
                style: TextStyle(fontSize: 13, color: AppColors.textMedium),
              ),
              const SizedBox(height: 18),

              // 3x3 Nutrition Grid Component
              NutritionGridWidget(
                values: nutrition.pointMeasurements,
                outlierIndex: nutrition.outlierIndex,
                onPointSelected: (idx) {
                  setState(() => _selectedPointIndex = idx);
                },
              ),

              const SizedBox(height: 18),

              // Summary Stats Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Average Crude Protein", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        Text(
                          "${nutrition.averageMeasurement}%",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
                        ),
                      ],
                    ),
                    if (nutrition.outlierIndex != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFFFCC80)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded, size: 18, color: Color(0xFFE65100)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "One area varies significantly (${nutrition.pointMeasurements[nutrition.outlierIndex!]}% at center).",
                                style: const TextStyle(fontSize: 12, color: Color(0xFFBF360C), fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () => context.go('/dairy'),
                child: const Text("Continue to Dairy Assessment"),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
