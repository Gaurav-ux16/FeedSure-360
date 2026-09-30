import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/testing_workflow_provider.dart';
import '../../widgets/app_bottom_nav.dart';

class TestFeedMenuScreen extends ConsumerWidget {
  const TestFeedMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workflow = ref.watch(testingWorkflowProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quick Test"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "What would you like to test?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Select a feed type to begin sampling and laboratory-grade evidence testing.",
                style: TextStyle(fontSize: 13, color: AppColors.textMedium),
              ),
              const SizedBox(height: 20),

              // Feed Options
              _feedOptionItem(
                title: "Maize Silage",
                subtitle: "High energy, common dairy forage",
                icon: Icons.grass_rounded,
                iconBg: const Color(0xFFE8F5E9),
                isSelected: workflow.selectedFeedType == "Maize Silage",
                onTap: () {
                  ref.read(testingWorkflowProvider.notifier).selectFeedType("Maize Silage");
                  context.push('/test/batch');
                },
              ),
              _feedOptionItem(
                title: "Dry Fodder",
                subtitle: "Fiber rich (wheat straw, hay, sorghum stover)",
                icon: Icons.grain_rounded,
                iconBg: const Color(0xFFFFF8E1),
                isSelected: workflow.selectedFeedType == "Dry Fodder",
                onTap: () {
                  ref.read(testingWorkflowProvider.notifier).selectFeedType("Dry Fodder");
                  context.push('/test/batch');
                },
              ),
              _feedOptionItem(
                title: "Concentrate Feed",
                subtitle: "Pellets, protein cakes, energy mixtures",
                icon: Icons.scatter_plot_rounded,
                iconBg: const Color(0xFFEFEBE9),
                isSelected: workflow.selectedFeedType == "Concentrate Feed",
                onTap: () {
                  ref.read(testingWorkflowProvider.notifier).selectFeedType("Concentrate Feed");
                  context.push('/test/batch');
                },
              ),
              _feedOptionItem(
                title: "Green Fodder",
                subtitle: "Napier, berseem, lucerne fresh forage",
                icon: Icons.eco_rounded,
                iconBg: const Color(0xFFE0F2F1),
                isSelected: workflow.selectedFeedType == "Green Fodder",
                onTap: () {
                  ref.read(testingWorkflowProvider.notifier).selectFeedType("Green Fodder");
                  context.push('/test/batch');
                },
              ),
              _feedOptionItem(
                title: "Other / Custom Feed",
                subtitle: "Mixed ration (TMR), bypass fat, custom blend",
                icon: Icons.cloud_queue_rounded,
                iconBg: const Color(0xFFEDE7F6),
                isSelected: workflow.selectedFeedType == "Other",
                onTap: () {
                  ref.read(testingWorkflowProvider.notifier).selectFeedType("Other");
                  context.push('/test/batch');
                },
              ),

              const SizedBox(height: 20),

              // AI Feed Identification Card
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceGreen,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder, width: 1.5),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.camera_enhance_rounded, color: Colors.white, size: 24),
                  ),
                  title: const Text(
                    "Not sure?",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                  ),
                  subtitle: const Text(
                    "Let AI identify the feed via camera",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.primaryGreen),
                  onTap: () => context.push('/test/identify'),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }

  Widget _feedOptionItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBg,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.primaryGreen : AppColors.divider,
          width: isSelected ? 1.8 : 1.0,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primaryDark, size: 26),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textDark),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: AppColors.textMedium),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.textLight),
        onTap: onTap,
      ),
    );
  }
}
