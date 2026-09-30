import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/demo_scenarios.dart';
import '../core/theme/app_colors.dart';
import '../providers/simulation_engine_provider.dart';

class ScenarioSelectorSheet extends ConsumerWidget {
  const ScenarioSelectorSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const ScenarioSelectorSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentScenario = ref.watch(activeScenarioProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.science_outlined, color: AppColors.primaryGreen, size: 24),
              const SizedBox(width: 8),
              const Text(
                "Demo Simulation Scenarios",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            "Select a scenario to dynamically update evidence calculations, NIR spectra, nutrition maps, alerts, and advisories across all 18 screens.",
            style: TextStyle(fontSize: 13, color: AppColors.textMedium),
          ),
          const SizedBox(height: 16),
          ...DemoScenario.values.map((sc) {
            final config = DemoScenarioConfig.getConfig(sc);
            final isSelected = currentScenario == sc;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.surfaceGreen : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.primaryGreen : AppColors.divider,
                  width: isSelected ? 1.8 : 1.0,
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                title: Text(
                  config.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? AppColors.primaryDark : AppColors.textDark,
                  ),
                ),
                subtitle: Text(
                  config.description,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_circle, color: AppColors.primaryGreen)
                    : null,
                onTap: () {
                  ref.read(activeScenarioProvider.notifier).state = sc;
                  Navigator.of(context).pop();
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
