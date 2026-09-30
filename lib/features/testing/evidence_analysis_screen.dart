import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/simulation_engine_provider.dart';
import '../../providers/testing_workflow_provider.dart';
import '../../widgets/evidence_gauge.dart';
import '../../widgets/status_badge.dart';

class EvidenceAnalysisScreen extends ConsumerWidget {
  const EvidenceAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final engine = ref.watch(simulationEngineProvider);
    final workflow = ref.watch(testingWorkflowProvider);
    final batchId = workflow.currentBatch?.batchNumber ?? "FS-2026-00128";
    final evidence = workflow.evidenceAssessment ?? engine.evaluateEvidence(batchId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Evidence Analysis"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circular Sufficiency Gauge
              const SizedBox(height: 8),
              CircularEvidenceGauge(
                score: evidence.sufficiencyScore,
                label: evidence.sufficiencyScore >= 0.75 ? "HIGH" : (evidence.sufficiencyScore >= 0.5 ? "MODERATE" : "LOW"),
                size: 140,
              ),
              const SizedBox(height: 8),
              const Text(
                "Evidence Sufficiency",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              const SizedBox(height: 4),
              Text(
                evidence.isTrusted
                    ? "Sufficient multi-source evidence to provide reliable nutritional values."
                    : "Evidence is below the validation threshold. Result cannot be trusted.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: AppColors.textMedium),
              ),

              const SizedBox(height: 24),

              // Evidence Dimension Breakdown
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Multi-Evidence Verification",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
                ),
              ),
              const SizedBox(height: 10),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    _evidenceRow(
                      "NIR Evidence",
                      evidence.nirEvidence,
                      evidence.nirEvidence == "HIGH" ? BadgeType.success : BadgeType.amber,
                      Icons.graphic_eq,
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    _evidenceRow(
                      "Image Evidence",
                      evidence.imageEvidence,
                      evidence.imageEvidence == "GOOD" ? BadgeType.success : BadgeType.warning,
                      Icons.camera_alt_outlined,
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    _evidenceRow(
                      "Sampling Consistency",
                      evidence.samplingConsistency,
                      evidence.samplingConsistency == "HIGH" ? BadgeType.success : BadgeType.amber,
                      Icons.grid_view_rounded,
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    _evidenceRow(
                      "Calibration Applicability",
                      evidence.calibrationApplicability,
                      evidence.calibrationApplicability == "VALID" ? BadgeType.success : BadgeType.error,
                      Icons.verified_outlined,
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    _evidenceRow(
                      "Prediction Uncertainty",
                      evidence.predictionUncertainty,
                      evidence.predictionUncertainty == "LOW" ? BadgeType.success : BadgeType.warning,
                      Icons.shield_outlined,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Trust Decision Continue Button
              ElevatedButton(
                onPressed: () {
                  if (evidence.isTrusted) {
                    context.push('/test/result');
                  } else {
                    context.push('/test/insufficient');
                  }
                },
                child: Text(evidence.isTrusted ? "View Feed Quality Result" : "Review Insufficient Evidence"),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _evidenceRow(String label, String value, BadgeType type, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primaryGreen),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark)),
          const Spacer(),
          StatusBadge(label: value, type: type, fontSize: 12),
        ],
      ),
    );
  }
}
