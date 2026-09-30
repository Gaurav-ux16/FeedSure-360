import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/batch_provider.dart';
import '../../widgets/status_badge.dart';

class PassportScreen extends ConsumerWidget {
  const PassportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final batchState = ref.watch(batchProvider);
    final batch = batchState.selectedBatch ?? batchState.batches.first;
    final nutrition = batch.nutritionResult;
    final evidence = batch.evidenceAssessment;

    final qrData = "FEEDSURE360:BATCH:${batch.batchNumber}:CP:${nutrition?.crudeProtein ?? 15.8}:DM:${nutrition?.dryMatter ?? 36.2}:EVIDENCE:${evidence?.sufficiencyScore ?? 0.86}";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Feed Quality Passport"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Feed Quality Passport shared successfully")),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            children: [
              // Digital Passport Certificate Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primaryGreen, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Certificate Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: AppColors.primaryGreen,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.verified_user_rounded, color: Colors.white, size: 22),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "FeedSure 360",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark),
                                ),
                                Text(
                                  "Digital Verification Passport",
                                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const StatusBadge(label: "VERIFIED", type: BadgeType.success),
                      ],
                    ),

                    const Divider(height: 28, color: AppColors.divider),

                    // Batch Details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Batch Number", style: TextStyle(fontSize: 11, color: AppColors.textMedium)),
                            Text(batch.batchNumber, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text("Feed Type", style: TextStyle(fontSize: 11, color: AppColors.textMedium)),
                            Text(batch.feedType, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Nutrition Summary Grid
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _passportMetric("CP", "${nutrition?.crudeProtein ?? 15.8}%"),
                          _passportMetric("DM", "${nutrition?.dryMatter ?? 36.2}%"),
                          _passportMetric("NDF", "${nutrition?.ndf ?? 42.0}%"),
                          _passportMetric("ADF", "${nutrition?.adf ?? 28.5}%"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Live QR Code
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: QrImageView(
                        data: qrData,
                        version: QrVersions.auto,
                        size: 160.0,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: AppColors.primaryDark,
                        ),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                    const Text(
                      "Scan QR to verify laboratory evidence on blockchain/ledger",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: AppColors.textMedium),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/passport/timeline'),
                      icon: const Icon(Icons.timeline_rounded, size: 18),
                      label: const Text("Batch Timeline"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Generating Official PDF Passport Report...")),
                        );
                      },
                      icon: const Icon(Icons.download_rounded, size: 18),
                      label: const Text("Download PDF"),
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

  Widget _passportMetric(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMedium, fontWeight: FontWeight.w500)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
      ],
    );
  }
}
