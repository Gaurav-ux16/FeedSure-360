import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/testing_workflow_provider.dart';
import '../../widgets/status_badge.dart';

class FeedIdentificationScreen extends ConsumerStatefulWidget {
  const FeedIdentificationScreen({super.key});

  @override
  ConsumerState<FeedIdentificationScreen> createState() => _FeedIdentificationScreenState();
}

class _FeedIdentificationScreenState extends ConsumerState<FeedIdentificationScreen> {
  bool _isAnalyzing = false;
  bool _identificationDone = true;

  void _triggerCapture() async {
    setState(() => _isAnalyzing = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      ref.read(testingWorkflowProvider.notifier).setAIIdentifiedFeed("Maize Silage", 0.92);
      setState(() {
        _isAnalyzing = false;
        _identificationDone = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final workflow = ref.watch(testingWorkflowProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Identify Feed"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            children: [
              // Step Progress Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _stepDot(1, "Capture", isCompleted: true),
                  _stepLine(),
                  _stepDot(2, "Analyze", isCompleted: _identificationDone),
                  _stepLine(),
                  _stepDot(3, "Confirm", isCompleted: false),
                ],
              ),
              const SizedBox(height: 20),

              // Camera Frame Viewfinder
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C3E2D),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Silage texture background placeholder graphic
                            Container(
                              color: const Color(0xFF4A5D3E),
                              child: Center(
                                child: Icon(
                                  Icons.grass_rounded,
                                  size: 140,
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              ),
                            ),
                            // Guided Frame Overlay
                            Container(
                              margin: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white.withOpacity(0.8), width: 2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            if (_isAnalyzing)
                              Container(
                                color: Colors.black54,
                                child: const Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircularProgressIndicator(color: Colors.white),
                                      SizedBox(height: 16),
                                      Text(
                                        "Analyzing Feed Surface...",
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Keep the feed inside the frame",
                          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // AI Result Card
              if (_identificationDone) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceGreen,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.cardBorder, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.auto_awesome, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "AI Identification",
                              style: TextStyle(fontSize: 12, color: AppColors.textMedium, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              workflow.aiIdentifiedFeedType,
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textDark),
                            ),
                          ],
                        ),
                      ),
                      const StatusBadge(
                        label: "Confidence: 92%",
                        type: BadgeType.success,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _triggerCapture,
                        child: const Text("Retake"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          ref.read(testingWorkflowProvider.notifier).selectFeedType(workflow.aiIdentifiedFeedType);
                          context.push('/test/batch');
                        },
                        child: const Text("Use This"),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                ElevatedButton.icon(
                  onPressed: _triggerCapture,
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text("Capture Feed"),
                ),
              ],
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepDot(int step, String label, {required bool isCompleted}) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isCompleted ? AppColors.primaryGreen : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            "$step",
            style: TextStyle(
              color: isCompleted ? Colors.white : AppColors.textDark,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMedium)),
      ],
    );
  }

  Widget _stepLine() {
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.only(bottom: 14, left: 4, right: 4),
      color: Colors.grey.shade300,
    );
  }
}
