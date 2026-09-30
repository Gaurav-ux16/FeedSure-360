import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/sensor_reading_model.dart';
import '../core/constants/demo_scenarios.dart';
import 'simulation_engine_provider.dart';

class MonitoringState {
  final StorageZone silageZone;
  final StorageZone feedZone;
  final List<SensorReading> recentReadings;
  final String activeTab; // "Silage" or "Feed"

  const MonitoringState({
    required this.silageZone,
    required this.feedZone,
    required this.recentReadings,
    this.activeTab = "Silage",
  });

  MonitoringState copyWith({
    StorageZone? silageZone,
    StorageZone? feedZone,
    List<SensorReading>? recentReadings,
    String? activeTab,
  }) {
    return MonitoringState(
      silageZone: silageZone ?? this.silageZone,
      feedZone: feedZone ?? this.feedZone,
      recentReadings: recentReadings ?? this.recentReadings,
      activeTab: activeTab ?? this.activeTab,
    );
  }
}

class MonitoringNotifier extends StateNotifier<MonitoringState> {
  final Ref ref;
  Timer? _ticker;

  MonitoringNotifier(this.ref) : super(_initialState()) {
    _startLiveSensorStream();
  }

  static MonitoringState _initialState() {
    const silage = StorageZone(
      zoneId: "FZ-001",
      name: "Silage Pit 01",
      type: "Silage",
      temperature: 18.2,
      humidity: 62.0,
      phValue: 4.2,
      feedRemainingKg: 1240.0,
      exposureDuration: Duration(hours: 7, minutes: 22),
      status: "Good",
      spoilageRisk: "Low",
    );

    const feed = StorageZone(
      zoneId: "FZ-002",
      name: "Dry Feed Shed A",
      type: "Feed",
      temperature: 24.5,
      humidity: 48.0,
      phValue: 6.8,
      feedRemainingKg: 680.0,
      exposureDuration: Duration(hours: 48, minutes: 0),
      status: "Stable",
      spoilageRisk: "Low",
    );

    final now = DateTime.now();
    final readings = List.generate(10, (i) {
      return SensorReading(
        deviceId: "FZ-001",
        timestamp: now.subtract(Duration(minutes: (9 - i) * 2)),
        temperature: 18.0 + (i * 0.05),
        humidity: 61.5 + (i * 0.1),
        weightKg: 1240.0 - (i * 0.5),
        phValue: 4.2,
      );
    });

    return MonitoringState(
      silageZone: silage,
      feedZone: feed,
      recentReadings: readings,
      activeTab: "Silage",
    );
  }

  void setActiveTab(String tab) {
    state = state.copyWith(activeTab: tab);
  }

  void _startLiveSensorStream() {
    _ticker = Timer.periodic(const Duration(seconds: 4), (timer) {
      final scenario = ref.read(activeScenarioProvider);
      final random = Random();
      
      double targetTemp = 18.2;
      double targetHumidity = 62.0;
      double targetPh = 4.2;
      String status = "Good";
      String spoilage = "Low";

      if (scenario == DemoScenario.storageWarning) {
        targetTemp = 31.4 + (random.nextDouble() * 0.4);
        targetHumidity = 78.0 + (random.nextDouble() * 1.2);
        targetPh = 5.2;
        status = "Warning (High Temp)";
        spoilage = "Elevated";
      } else {
        targetTemp = 18.0 + (random.nextDouble() * 0.4);
        targetHumidity = 61.5 + (random.nextDouble() * 0.8);
      }

      final updatedSilage = StorageZone(
        zoneId: "FZ-001",
        name: "Silage Pit 01",
        type: "Silage",
        temperature: double.parse(targetTemp.toStringAsFixed(1)),
        humidity: double.parse(targetHumidity.toStringAsFixed(1)),
        phValue: targetPh,
        feedRemainingKg: state.silageZone.feedRemainingKg,
        exposureDuration: state.silageZone.exposureDuration + const Duration(seconds: 4),
        status: status,
        spoilageRisk: spoilage,
      );

      final newReading = SensorReading(
        deviceId: "FZ-001",
        timestamp: DateTime.now(),
        temperature: updatedSilage.temperature,
        humidity: updatedSilage.humidity,
        phValue: updatedSilage.phValue,
        weightKg: updatedSilage.feedRemainingKg,
      );

      final readings = [...state.recentReadings.skip(1), newReading];

      state = state.copyWith(
        silageZone: updatedSilage,
        recentReadings: readings,
      );
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}

final monitoringProvider = StateNotifierProvider<MonitoringNotifier, MonitoringState>((ref) {
  return MonitoringNotifier(ref);
});
