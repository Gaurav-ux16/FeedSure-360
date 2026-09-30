import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/monitoring_provider.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/status_badge.dart';

class StorageMonitoringScreen extends ConsumerWidget {
  const StorageMonitoringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monitoring = ref.watch(monitoringProvider);
    final activeZone = monitoring.activeTab == "Silage" ? monitoring.silageZone : monitoring.feedZone;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Storage Monitoring"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Segmented Tab: Silage vs Feed
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    _tabButton(ref, "Silage", monitoring.activeTab == "Silage"),
                    _tabButton(ref, "Feed", monitoring.activeTab == "Feed"),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Storage Condition Summary Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: activeZone.status.contains("Warning") ? const Color(0xFFFFF3E0) : AppColors.surfaceGreen,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: activeZone.status.contains("Warning") ? const Color(0xFFFFCC80) : AppColors.cardBorder,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activeZone.name,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                            ),
                            Text(
                              "Device ${activeZone.zoneId} • Real-time Stream",
                              style: const TextStyle(fontSize: 12, color: AppColors.textMedium),
                            ),
                          ],
                        ),
                        StatusBadge(
                          label: activeZone.status,
                          type: activeZone.status.contains("Warning") ? BadgeType.warning : BadgeType.success,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: AppColors.divider, height: 1),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _metricItem("pH Level", "${activeZone.phValue}", Icons.science_outlined, AppColors.primaryGreen),
                        _metricItem("Temperature", "${activeZone.temperature} °C", Icons.thermostat_outlined, Colors.orange.shade800),
                        _metricItem("Humidity", "${activeZone.humidity.toInt()} %", Icons.water_drop_outlined, Colors.blue.shade700),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Additional Risk Metrics
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    _infoRow("Mould Growth Risk", activeZone.spoilageRisk, activeZone.spoilageRisk == "Low" ? BadgeType.success : BadgeType.warning),
                    const Divider(height: 1, color: AppColors.divider),
                    _infoRow("Aerobic Exposure", "${activeZone.exposureDuration.inHours}h ${activeZone.exposureDuration.inMinutes % 60}m", BadgeType.neutral),
                    const Divider(height: 1, color: AppColors.divider),
                    _infoRow("Feed Remaining", "${activeZone.feedRemainingKg.toInt()} kg", BadgeType.info),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Live Temperature Trend Graph preview
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Continuous Sensor Trend", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        StatusBadge(label: "Live 2s Sync", type: BadgeType.success, fontSize: 10),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: monitoring.recentReadings.map((r) {
                          final heightRatio = ((r.temperature - 15.0) / 25.0).clamp(0.2, 1.0);
                          return Container(
                            width: 14,
                            height: 80 * heightRatio,
                            decoration: BoxDecoration(
                              color: r.temperature > 28.0 ? AppColors.statusWarning : AppColors.primaryGreen,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: () => context.push('/test/batch'),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text("Retest Silage Batch"),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
    );
  }

  Widget _tabButton(WidgetRef ref, String title, bool isActive) {
    return Expanded(
      child: GestureDetector(
        onTap: () => ref.read(monitoringProvider.notifier).setActiveTab(title),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4)] : null,
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive ? AppColors.primaryDark : AppColors.textMedium,
            ),
          ),
        ),
      ),
    );
  }

  Widget _metricItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 22, color: color),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMedium)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _infoRow(String label, String value, BadgeType type) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          StatusBadge(label: value, type: type, fontSize: 11),
        ],
      ),
    );
  }
}
