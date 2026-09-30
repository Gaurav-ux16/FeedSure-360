class SensorReading {
  final String deviceId;
  final DateTime timestamp;
  final double temperature; // °C
  final double humidity;    // %
  final double? weightKg;
  final double? phValue;
  final String source;      // "simulation" or "hardware"

  const SensorReading({
    required this.deviceId,
    required this.timestamp,
    required this.temperature,
    required this.humidity,
    this.weightKg,
    this.phValue,
    this.source = "simulation",
  });
}

class StorageZone {
  final String zoneId; // FZ-001
  final String name;   // Silage Pit 01
  final String type;   // Silage / Dry Feed
  final double temperature;
  final double humidity;
  final double phValue;
  final double feedRemainingKg;
  final Duration exposureDuration;
  final String status; // "Stable", "Warning", "Critical"
  final String spoilageRisk; // "Low", "Moderate", "High"

  const StorageZone({
    required this.zoneId,
    required this.name,
    required this.type,
    required this.temperature,
    required this.humidity,
    required this.phValue,
    required this.feedRemainingKg,
    required this.exposureDuration,
    required this.status,
    required this.spoilageRisk,
  });
}
