import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/testing_workflow_provider.dart';

class RepresentativeSamplingScreen extends ConsumerWidget {
  const RepresentativeSamplingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workflow = ref.watch(testingWorkflowProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Collect Representative Sample"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Take samples from different positions of the feed batch.",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 16),

              // Interactive 3x3 Grid Canvas
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceGreen,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 3x3 Grid with lines
                      SizedBox(
                        width: 260,
                        height: 260,
                        child: Stack(
                          children: [
                            // Connecting Grid Lines
                            CustomPaint(
                              size: const Size(260, 260),
                              painter: _GridLinesPainter(),
                            ),
                            // 9 Sample Points
                            ...List.generate(9, (index) {
                              final row = index ~/ 3;
                              final col = index % 3;
                              final point = workflow.samplePoints.isNotEmpty && index < workflow.samplePoints.length
                                  ? workflow.samplePoints[index]
                                  : null;
                              final isCollected = point?.isCollected ?? false;

                              final left = col * 95.0 + 10.0;
                              final top = row * 95.0 + 10.0;

                              return Positioned(
                                left: left,
                                top: top,
                                child: GestureDetector(
                                  onTap: () {
                                    ref.read(testingWorkflowProvider.notifier).toggleSamplePoint(index);
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: isCollected ? AppColors.primaryGreen : Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isCollected ? AppColors.primaryDark : AppColors.primaryLight,
                                        width: 2.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: isCollected
                                              ? AppColors.primaryGreen.withOpacity(0.35)
                                              : Colors.black.withOpacity(0.06),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: isCollected
                                          ? const Icon(Icons.check, color: Colors.white, size: 26)
                                          : Text(
                                              "${index + 1}",
                                              style: const TextStyle(
                                                color: AppColors.primaryDark,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Legend
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _legendItem("Sample points", Colors.white, AppColors.primaryLight),
                          const SizedBox(width: 24),
                          _legendItem("Collected", AppColors.primaryGreen, AppColors.primaryDark),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Progress & Advisory Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${workflow.collectedSampleCount} / 9 collected",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        Text(
                          workflow.collectedSampleCount >= 4 ? "Good sample coverage ✓" : "Collect more points",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: workflow.collectedSampleCount >= 4 ? AppColors.statusGood : AppColors.statusWarning,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: workflow.collectedSampleCount / 9.0,
                      backgroundColor: AppColors.surfaceGreen,
                      color: AppColors.primaryGreen,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Icon(Icons.tips_and_updates_outlined, size: 16, color: AppColors.statusAmber),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            "Take another sample from the center for optimal calibration.",
                            style: TextStyle(fontSize: 12, color: AppColors.textMedium),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () => context.push('/test/device'),
                child: const Text("Start Scan"),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _legendItem(String label, Color fill, Color border) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: fill,
            shape: BoxShape.circle,
            border: Border.all(color: border, width: 2),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMedium, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _GridLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryGreen.withOpacity(0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const p0 = 35.0;
    const p1 = 130.0;
    const p2 = 225.0;

    // Horizontal Lines
    canvas.drawLine(const Offset(p0, p0), const Offset(p2, p0), paint);
    canvas.drawLine(const Offset(p0, p1), const Offset(p2, p1), paint);
    canvas.drawLine(const Offset(p0, p2), const Offset(p2, p2), paint);

    // Vertical Lines
    canvas.drawLine(const Offset(p0, p0), const Offset(p0, p2), paint);
    canvas.drawLine(const Offset(p1, p0), const Offset(p1, p2), paint);
    canvas.drawLine(const Offset(p2, p0), const Offset(p2, p2), paint);

    // Diagonals for spatial depth
    canvas.drawLine(const Offset(p0, p0), const Offset(p2, p2), paint);
    canvas.drawLine(const Offset(p2, p0), const Offset(p0, p2), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
