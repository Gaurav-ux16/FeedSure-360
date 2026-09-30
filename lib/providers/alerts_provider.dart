import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/alert_model.dart';
import '../core/constants/demo_scenarios.dart';
import 'simulation_engine_provider.dart';

class AlertState {
  final List<FeedSureAlert> alerts;

  const AlertState({required this.alerts});

  int get unreadCount => alerts.where((a) => !a.isRead).length;

  AlertState copyWith({List<FeedSureAlert>? alerts}) {
    return AlertState(alerts: alerts ?? this.alerts);
  }
}

class AlertNotifier extends StateNotifier<AlertState> {
  final Ref ref;

  AlertNotifier(this.ref) : super(_initialAlerts()) {
    ref.listen(activeScenarioProvider, (prev, next) {
      _syncScenarioAlerts(next);
    });
  }

  static AlertState _initialAlerts() {
    return AlertState(
      alerts: [
        FeedSureAlert(
          id: "a1",
          title: "Storage Temperature Elevated",
          message: "Silage Pit 01 sensor reading reached 31.4°C. Check aeration.",
          severity: AlertSeverity.attention,
          category: "Storage",
          timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
          relatedBatchId: "FS-2026-00128",
          targetRoute: "/monitor",
        ),
        FeedSureAlert(
          id: "a2",
          title: "Ration Balancing Suggested",
          message: "Protein content in current basket is below lactating herd target.",
          severity: AlertSeverity.review,
          category: "Nutrition",
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          targetRoute: "/dairy",
        ),
        FeedSureAlert(
          id: "a3",
          title: "Feed Quality Test Complete",
          message: "Maize Silage Batch FS-2026-00128 verified with High Evidence.",
          severity: AlertSeverity.complete,
          category: "Testing",
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          relatedBatchId: "FS-2026-00128",
          targetRoute: "/test/result",
        ),
      ],
    );
  }

  void _syncScenarioAlerts(DemoScenario scenario) {
    if (scenario == DemoScenario.storageWarning) {
      final warningAlert = FeedSureAlert(
        id: "warn_${DateTime.now().millisecondsSinceEpoch}",
        title: "CRITICAL: Storage Temperature Spike",
        message: "Silage Pit 01 exceeds safe threshold (31.4°C). Spoilage risk rising.",
        severity: AlertSeverity.high,
        category: "Storage",
        timestamp: DateTime.now(),
        targetRoute: "/monitor",
      );
      state = state.copyWith(alerts: [warningAlert, ...state.alerts]);
    }
  }

  void markAsRead(String id) {
    final updated = state.alerts.map((a) => a.id == id ? a.copyWith(isRead: true) : a).toList();
    state = state.copyWith(alerts: updated);
  }

  void addAlert(FeedSureAlert alert) {
    state = state.copyWith(alerts: [alert, ...state.alerts]);
  }
}

final alertsProvider = StateNotifierProvider<AlertNotifier, AlertState>((ref) {
  return AlertNotifier(ref);
});
