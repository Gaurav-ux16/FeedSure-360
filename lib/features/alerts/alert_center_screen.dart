import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../models/alert_model.dart';
import '../../providers/alerts_provider.dart';
import '../../widgets/status_badge.dart';

class AlertCenterScreen extends ConsumerWidget {
  const AlertCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertState = ref.watch(alertsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Alert Center"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Active Alerts (${alertState.alerts.length})",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              const SizedBox(height: 6),
              const Text(
                "Real-time notifications regarding storage conditions, adulteration alerts, and feed ration reviews.",
                style: TextStyle(fontSize: 13, color: AppColors.textMedium),
              ),
              const SizedBox(height: 18),

              ...alertState.alerts.map((alert) {
                BadgeType badgeType;
                IconData alertIcon;

                switch (alert.severity) {
                  case AlertSeverity.high:
                    badgeType = BadgeType.error;
                    alertIcon = Icons.error_outline;
                    break;
                  case AlertSeverity.attention:
                    badgeType = BadgeType.warning;
                    alertIcon = Icons.warning_amber_rounded;
                    break;
                  case AlertSeverity.review:
                    badgeType = BadgeType.amber;
                    alertIcon = Icons.info_outline;
                    break;
                  case AlertSeverity.complete:
                    badgeType = BadgeType.success;
                    alertIcon = Icons.check_circle_outline;
                    break;
                }

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: alert.severity == AlertSeverity.high
                            ? AppColors.statusErrorBg
                            : (alert.severity == AlertSeverity.attention ? AppColors.statusWarningBg : AppColors.surfaceGreen),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        alertIcon,
                        color: alert.severity == AlertSeverity.high
                            ? AppColors.statusError
                            : (alert.severity == AlertSeverity.attention ? AppColors.statusWarning : AppColors.primaryGreen),
                        size: 22,
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            alert.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                        StatusBadge(label: alert.category, type: badgeType, fontSize: 10),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(alert.message, style: const TextStyle(fontSize: 12, color: AppColors.textMedium)),
                        const SizedBox(height: 6),
                        const Text(
                          "Tap to inspect >",
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
                        ),
                      ],
                    ),
                    onTap: () {
                      ref.read(alertsProvider.notifier).markAsRead(alert.id);
                      if (alert.targetRoute != null) {
                        context.push(alert.targetRoute!);
                      }
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
