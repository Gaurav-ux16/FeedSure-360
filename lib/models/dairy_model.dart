class DairyProfile {
  final int totalAnimals;
  final int lactatingAnimals;
  final int dryAnimals;
  final int calves;
  final String milkYieldRange; // e.g. "8 - 12 L/day"

  const DairyProfile({
    this.totalAnimals = 18,
    this.lactatingAnimals = 12,
    this.dryAnimals = 6,
    this.calves = 4,
    this.milkYieldRange = "8 - 12 L/day",
  });

  DairyProfile copyWith({
    int? totalAnimals,
    int? lactatingAnimals,
    int? dryAnimals,
    int? calves,
    String? milkYieldRange,
  }) {
    return DairyProfile(
      totalAnimals: totalAnimals ?? this.totalAnimals,
      lactatingAnimals: lactatingAnimals ?? this.lactatingAnimals,
      dryAnimals: dryAnimals ?? this.dryAnimals,
      calves: calves ?? this.calves,
      milkYieldRange: milkYieldRange ?? this.milkYieldRange,
    );
  }
}

class FeedBasketItem {
  final String id;
  final String name;
  final double quantityKg;
  final double? crudeProtein;
  final bool isTested;

  const FeedBasketItem({
    required this.id,
    required this.name,
    required this.quantityKg,
    this.crudeProtein,
    this.isTested = false,
  });

  FeedBasketItem copyWith({
    String? id,
    String? name,
    double? quantityKg,
    double? crudeProtein,
    bool? isTested,
  }) {
    return FeedBasketItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantityKg: quantityKg ?? this.quantityKg,
      crudeProtein: crudeProtein ?? this.crudeProtein,
      isTested: isTested ?? this.isTested,
    );
  }
}

class DairyAdvisory {
  final String status; // "Optimal", "Needs Improvement", "Attention Required"
  final String headline;
  final String detailedAdvice;
  final List<String> suggestedActions;
  final DateTime generatedAt;

  const DairyAdvisory({
    required this.status,
    required this.headline,
    required this.detailedAdvice,
    required this.suggestedActions,
    required this.generatedAt,
  });
}
