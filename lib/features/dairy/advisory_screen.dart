import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/dairy_provider.dart';
import '../../providers/batch_provider.dart';
import '../../widgets/status_badge.dart';

class AdvisoryScreen extends ConsumerWidget {
  const AdvisoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dairyState = ref.watch(dairyProvider);
    final batchState = ref.watch(batchProvider);
    final advisory = dairyState.advisory;
    final currentBatch = batchState.selectedBatch ?? batchState.batches.first;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dairy Advisory"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Advisory Header Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surfaceGreen,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.cardBorder, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Dairy Advisory",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                        ),
                        StatusBadge(
                          label: advisory.status,
                          type: advisory.status == "Optimal Balance" ? BadgeType.success : BadgeType.warning,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      advisory.detailedAdvice,
                      style: const TextStyle(fontSize: 13, color: AppColors.textDark, height: 1.4),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      "Suggested Farmer Actions:",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                    ),
                    const SizedBox(height: 6),
                    ...advisory.suggestedActions.map((act) => Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.arrow_right, size: 20, color: AppColors.primaryGreen),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(act, style: const TextStyle(fontSize: 13, color: AppColors.textMedium)),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Feed Quality Passport Summary Card
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
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceGreen,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.qr_code_2_rounded, color: AppColors.primaryGreen, size: 32),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Feed Quality Passport",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Text(
                                "Batch ${currentBatch.batchNumber} • ${currentBatch.feedType}",
                                style: const TextStyle(fontSize: 12, color: AppColors.textMedium),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    OutlinedButton.icon(
                      onPressed: () => context.push('/passport'),
                      icon: const Icon(Icons.verified_outlined, size: 18),
                      label: const Text("View Digital Passport"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Batch Timeline Shortcut
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.divider),
                ),
                child: ListTile(
                  leading: const Icon(Icons.timeline_rounded, color: AppColors.primaryGreen),
                  title: const Text("Batch Lifecycle Timeline", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: const Text("Tracking from harvest to ration feeding", style: TextStyle(fontSize: 12, color: AppColors.textMedium)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  onTap: () => context.push('/passport/timeline'),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
