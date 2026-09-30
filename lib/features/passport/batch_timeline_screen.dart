import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/batch_provider.dart';

class BatchTimelineScreen extends ConsumerWidget {
  const BatchTimelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final batchState = ref.watch(batchProvider);
    final batch = batchState.selectedBatch ?? batchState.batches.first;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Batch Lifecycle Timeline"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                "Lifecycle: ${batch.batchNumber}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              const SizedBox(height: 4),
              Text(
                "Complete provenance and chronological audit trace",
                style: const TextStyle(fontSize: 13, color: AppColors.textMedium),
              ),
              const SizedBox(height: 24),

              // Timeline Items
              _timelineStep(
                title: "Feed Received & Created",
                time: "Today, 08:30 AM",
                description: "Batch ${batch.batchNumber} created from ${batch.source}.",
                icon: Icons.inventory_2_outlined,
                isCompleted: true,
                isFirst: true,
              ),
              _timelineStep(
                title: "Representative 9-Point Sampling",
                time: "Today, 09:15 AM",
                description: "Collected multi-point spatial core samples across pit.",
                icon: Icons.grid_view_rounded,
                isCompleted: true,
              ),
              _timelineStep(
                title: "NIR Spectral Sweep & Sensor Telemetry",
                time: "Today, 09:22 AM",
                description: "5-point continuous absorbance scanning completed via FS-NIR-001.",
                icon: Icons.graphic_eq,
                isCompleted: true,
              ),
              _timelineStep(
                title: "Multi-Source Evidence Verification",
                time: "Today, 09:25 AM",
                description: "Calculated 86% sufficiency score with valid calibration envelope.",
                icon: Icons.verified_outlined,
                isCompleted: true,
              ),
              _timelineStep(
                title: "Digital Quality Passport Generated",
                time: "Today, 09:30 AM",
                description: "Nutritional matrix established (CP: 15.8%, DM: 36.2%).",
                icon: Icons.card_membership_outlined,
                isCompleted: true,
              ),
              _timelineStep(
                title: "Storage Pit Telemetry Active",
                time: "Ongoing",
                description: "Smart sensor FZ-001 streaming temperature and pH.",
                icon: Icons.sensors_outlined,
                isCompleted: true,
                isLast: true,
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _timelineStep({
    required String title,
    required String time,
    required String description,
    required IconData icon,
    required bool isCompleted,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stepper Bar & Icon
        Column(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.primaryGreen : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            if (!isLast)
              Container(
                width: 2.5,
                height: 54,
                color: isCompleted ? AppColors.primaryGreen.withOpacity(0.5) : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 14),
        // Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark)),
                    Text(time, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(fontSize: 12, color: AppColors.textMedium, height: 1.3)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
