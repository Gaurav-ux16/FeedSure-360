import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/dairy_provider.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/status_badge.dart';

class DairyProfileScreen extends ConsumerWidget {
  const DairyProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dairyState = ref.watch(dairyProvider);
    final profile = dairyState.profile;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dairy & Feed Basket"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Animals Profile Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surfaceGreen,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Dairy Herd Setup",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
                        ),
                        Text(
                          "Yield: ${profile.milkYieldRange}",
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryGreen),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _animalPill("Total", "${profile.totalAnimals}", Colors.blueGrey),
                        _animalPill("Lactating", "${profile.lactatingAnimals}", AppColors.primaryGreen),
                        _animalPill("Dry", "${profile.dryAnimals}", Colors.orange.shade700),
                        _animalPill("Young", "${profile.calves}", Colors.teal),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Feed Basket Inventory
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Feed Basket Inventory",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  const StatusBadge(label: "7 Ingredients", type: BadgeType.neutral, fontSize: 11),
                ],
              ),
              const SizedBox(height: 10),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: dairyState.basket.map((item) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: item.isTested ? AppColors.statusGood : Colors.grey.shade400,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  item.name,
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                ),
                              ),
                              if (item.crudeProtein != null)
                                Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: Text(
                                    "CP ${item.crudeProtein}%",
                                    style: const TextStyle(fontSize: 12, color: AppColors.primaryGreen, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              Text(
                                "${item.quantityKg.toInt()} kg",
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark),
                              ),
                            ],
                          ),
                        ),
                        if (item != dairyState.basket.last)
                          const Divider(height: 1, color: AppColors.divider),
                      ],
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 22),

              // Batch Ration Assessment Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFFE082)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.analytics_outlined, color: Color(0xFFE65100), size: 28),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Batch Assessment",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFFBF360C)),
                          ),
                          Text(
                            "Current ration protein balance is under review.",
                            style: TextStyle(fontSize: 12, color: Color(0xFF795548)),
                          ),
                        ],
                      ),
                    ),
                    const StatusBadge(label: "Needs Review", type: BadgeType.amber, fontSize: 11),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () => context.push('/dairy/advisory'),
                child: const Text("View Tailored Advisory"),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
    );
  }

  Widget _animalPill(String title, String count, Color color) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 11, color: AppColors.textMedium)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            count,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
          ),
        ),
      ],
    );
  }
}
