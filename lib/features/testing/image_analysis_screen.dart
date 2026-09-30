import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/simulation_engine_provider.dart';
import '../../providers/testing_workflow_provider.dart';
import '../../widgets/status_badge.dart';

class ImageAnalysisScreen extends ConsumerWidget {
  const ImageAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final engine = ref.watch(simulationEngineProvider);
    final workflow = ref.watch(testingWorkflowProvider);
    final config = engine.config;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Analysis"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Captured Feed Image with Anomaly Overlay
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E281F),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Actual input image from user (Upload / Camera) or clean placeholder
                      if (workflow.imageBytes != null && workflow.imageBytes!.isNotEmpty)
                        Image.memory(
                          workflow.imageBytes!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(),
                        )
                      else
                        _buildImagePlaceholder(),

                      // Subtle Dark Gradient on Top/Bottom for contrast
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.4),
                                Colors.transparent,
                                Colors.black.withOpacity(0.3),
                              ],
                              stops: const [0.0, 0.4, 1.0],
                            ),
                          ),
                        ),
                      ),

                      // Anomaly Highlight Overlay Bounding Box
                      if (config.visualSurfaceAnomaly != "Not Detected")
                        Positioned(
                          top: 55,
                          right: 45,
                          child: Container(
                            width: 110,
                            height: 75,
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.25),
                              border: Border.all(color: Colors.redAccent, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                color: Colors.redAccent,
                                child: const Text(
                                  "1 Anomaly Detected",
                                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.65),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white24, width: 0.5),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.remove_red_eye_outlined, size: 14, color: Colors.white),
                              SizedBox(width: 5),
                              Text("Visual Screening Overlay", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Visual Screening Results Header
              const Text(
                "Visual Screening Results",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              const SizedBox(height: 10),

              // Results Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    _screeningRow(
                      "Feed Type",
                      workflow.selectedFeedType,
                      BadgeType.success,
                      Icons.check_circle_outline,
                    ),
                    const Divider(color: AppColors.divider, height: 1),
                    _screeningRow(
                      "Foreign Material",
                      config.visualForeignMat,
                      config.visualForeignMat == "Not Detected" ? BadgeType.success : BadgeType.warning,
                      config.visualForeignMat == "Not Detected" ? Icons.check_circle_outline : Icons.warning_amber_rounded,
                    ),
                    const Divider(color: AppColors.divider, height: 1),
                    _screeningRow(
                      "Surface Anomaly",
                      config.visualSurfaceAnomaly,
                      config.visualSurfaceAnomaly == "Not Detected" ? BadgeType.success : BadgeType.amber,
                      config.visualSurfaceAnomaly == "Not Detected" ? Icons.check_circle_outline : Icons.info_outline,
                    ),
                    const Divider(color: AppColors.divider, height: 1),
                    _screeningRow(
                      "Mould-like Region",
                      config.visualMouldRisk,
                      config.visualMouldRisk == "Not Detected" ? BadgeType.success : BadgeType.warning,
                      config.visualMouldRisk == "Not Detected" ? Icons.check_circle_outline : Icons.warning_amber_rounded,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Scientific Disclaimer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceGreen,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.gavel_rounded, size: 18, color: AppColors.primaryGreen),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "This is a visual screening indication, not chemical confirmation.",
                        style: TextStyle(fontSize: 12, color: AppColors.primaryDark, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  ref.read(testingWorkflowProvider.notifier).runFullAnalysis();
                  context.push('/test/evidence');
                },
                child: const Text("Continue to Evidence Check"),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _screeningRow(String label, String value, BadgeType type, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark)),
          StatusBadge(label: value, type: type, icon: icon, fontSize: 12),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: const Color(0xFF334233),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.grain_rounded, size: 80, color: Colors.white.withOpacity(0.3)),
            const SizedBox(height: 8),
            Text(
              "Sample Feed Image",
              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
