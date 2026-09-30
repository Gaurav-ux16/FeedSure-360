import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/batch_provider.dart';
import '../../widgets/status_badge.dart';

class TestHistoryScreen extends ConsumerWidget {
  const TestHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final batchState = ref.watch(batchProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Test History"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search & Filter Bar
              TextField(
                decoration: InputDecoration(
                  hintText: "Search batch ID, feed type...",
                  prefixIcon: const Icon(Icons.search),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "All Batches (${batchState.batches.length})",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  const Icon(Icons.filter_list_rounded, color: AppColors.primaryGreen),
                ],
              ),

              const SizedBox(height: 12),

              ...batchState.batches.map((batch) {
                final nutrition = batch.nutritionResult;
                final evidence = batch.evidenceAssessment;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.inventory_2_outlined, color: AppColors.primaryGreen),
                    ),
                    title: Text(
                      batch.feedType,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 2),
                        Text(
                          "Batch ${batch.batchNumber} • ${batch.storageLocation}",
                          style: const TextStyle(fontSize: 12, color: AppColors.textMedium),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              "CP: ${nutrition?.crudeProtein ?? 0.0}%  |  DM: ${nutrition?.dryMatter ?? 0.0}%",
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryDark),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        StatusBadge(
                          label: evidence?.nirEvidence == "HIGH" ? "HIGH Evidence" : "Review",
                          type: evidence?.nirEvidence == "HIGH" ? BadgeType.success : BadgeType.amber,
                          fontSize: 10,
                        ),
                        const SizedBox(height: 6),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textLight),
                      ],
                    ),
                    onTap: () {
                      ref.read(batchProvider.notifier).selectBatch(batch.id);
                      context.push('/test/result');
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
