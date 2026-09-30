import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dairy_model.dart';
import '../core/constants/demo_scenarios.dart';
import 'simulation_engine_provider.dart';

class DairyState {
  final DairyProfile profile;
  final List<FeedBasketItem> basket;
  final String selectedGroup; // "Lactating", "Dry", "Calves"
  final DairyAdvisory advisory;

  const DairyState({
    required this.profile,
    required this.basket,
    this.selectedGroup = "Lactating",
    required this.advisory,
  });

  DairyState copyWith({
    DairyProfile? profile,
    List<FeedBasketItem>? basket,
    String? selectedGroup,
    DairyAdvisory? advisory,
  }) {
    return DairyState(
      profile: profile ?? this.profile,
      basket: basket ?? this.basket,
      selectedGroup: selectedGroup ?? this.selectedGroup,
      advisory: advisory ?? this.advisory,
    );
  }
}

class DairyNotifier extends StateNotifier<DairyState> {
  final Ref ref;

  DairyNotifier(this.ref) : super(_initialState()) {
    // Listen to scenario change to update advisory
    ref.listen(activeScenarioProvider, (prev, next) {
      _recalculateAdvisory(next);
    });
  }

  static DairyState _initialState() {
    const profile = DairyProfile(
      totalAnimals: 18,
      lactatingAnimals: 12,
      dryAnimals: 6,
      calves: 4,
      milkYieldRange: "8 - 12 L/day",
    );

    final basket = [
      const FeedBasketItem(id: "1", name: "Green Fodder", quantityKg: 120, isTested: false),
      const FeedBasketItem(id: "2", name: "Dry Fodder", quantityKg: 80, crudeProtein: 6.8, isTested: true),
      const FeedBasketItem(id: "3", name: "Silage", quantityKg: 200, crudeProtein: 15.8, isTested: true),
      const FeedBasketItem(id: "4", name: "Concentrate", quantityKg: 50, crudeProtein: 18.4, isTested: true),
      const FeedBasketItem(id: "5", name: "Oil Cake", quantityKg: 30, crudeProtein: 32.0, isTested: true),
      const FeedBasketItem(id: "6", name: "Bran", quantityKg: 40, crudeProtein: 12.5, isTested: true),
      const FeedBasketItem(id: "7", name: "Mineral Mixture", quantityKg: 5, isTested: true),
    ];

    final advisory = DairyAdvisory(
      status: "Needs Improvement",
      headline: "Ration Status: Needs Improvement",
      detailedAdvice: "Your current feed profile is low in protein for the selected lactating group based on recent milk yield requirements.",
      suggestedActions: [
        "Add protein-rich feed (e.g., oil cake, soybean meal).",
        "Balance roughage to concentrate ratio to maintain healthy rumen pH.",
        "Ensure adequate mineral supplementation (50g/animal/day)."
      ],
      generatedAt: DateTime.now(),
    );

    return DairyState(
      profile: profile,
      basket: basket,
      selectedGroup: "Lactating",
      advisory: advisory,
    );
  }

  void updateProfile(DairyProfile newProfile) {
    state = state.copyWith(profile: newProfile);
  }

  void selectGroup(String group) {
    state = state.copyWith(selectedGroup: group);
  }

  void updateBasketItemQuantity(String id, double newQty) {
    final updated = state.basket.map((item) {
      return item.id == id ? item.copyWith(quantityKg: newQty) : item;
    }).toList();
    state = state.copyWith(basket: updated);
  }

  void _recalculateAdvisory(DemoScenario scenario) {
    final config = DemoScenarioConfig.getConfig(scenario);
    if (scenario == DemoScenario.goodFeed) {
      state = state.copyWith(
        advisory: DairyAdvisory(
          status: "Optimal Balance",
          headline: "Ration Status: Well Balanced",
          detailedAdvice: "Your current feed basket provides optimal crude protein (15.8% CP) and fiber digestibility for lactating cows.",
          suggestedActions: [
            "Maintain current feeding schedule (silage 20kg + green fodder 10kg).",
            "Monitor storage temperature of silage pit 01.",
            "Continue regular mineral mixture addition."
          ],
          generatedAt: DateTime.now(),
        ),
      );
    } else {
      state = state.copyWith(
        advisory: DairyAdvisory(
          status: config.dairyAdvisoryStatus,
          headline: "Ration Status: ${config.dairyAdvisoryStatus}",
          detailedAdvice: "The feed profile shows potential imbalance in protein or fiber. Supplement with locally available high-protein ingredients.",
          suggestedActions: [
            "Add protein-rich feed (e.g., mustard/cottonseed oil cake).",
            "Balance roughage to concentrate ratio.",
            "Ensure adequate fresh water and mineral supplementation."
          ],
          generatedAt: DateTime.now(),
        ),
      );
    }
  }
}

final dairyProvider = StateNotifierProvider<DairyNotifier, DairyState>((ref) {
  return DairyNotifier(ref);
});
