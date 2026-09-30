import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/testing_workflow_provider.dart';
import '../../widgets/status_badge.dart';

class DeviceConnectionScreen extends ConsumerStatefulWidget {
  const DeviceConnectionScreen({super.key});

  @override
  ConsumerState<DeviceConnectionScreen> createState() => _DeviceConnectionScreenState();
}

class _DeviceConnectionScreenState extends ConsumerState<DeviceConnectionScreen> {
  bool _isConnecting = false;

  void _handleConnect() async {
    setState(() => _isConnecting = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      ref.read(testingWorkflowProvider.notifier).setDeviceConnected(true);
      setState(() => _isConnecting = false);
      context.push('/test/scan');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);
    final workflow = ref.watch(testingWorkflowProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Feed Analyzer"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Segmented Hardware vs Simulation Toggle
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => ref.read(authProvider.notifier).toggleHardwareMode(true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: user.isHardwareMode ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: user.isHardwareMode
                                ? [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4)]
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Connected Hardware",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: user.isHardwareMode ? FontWeight.bold : FontWeight.w500,
                              color: user.isHardwareMode ? AppColors.primaryDark : AppColors.textMedium,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => ref.read(authProvider.notifier).toggleHardwareMode(false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: !user.isHardwareMode ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: !user.isHardwareMode
                                ? [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4)]
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Simulation Mode",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: !user.isHardwareMode ? FontWeight.bold : FontWeight.w500,
                                  color: !user.isHardwareMode ? AppColors.primaryGreen : AppColors.textMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Device Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.divider),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceGreen,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.sensors_rounded, color: AppColors.primaryGreen, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    workflow.connectedDeviceId,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const StatusBadge(label: "Simulation", type: BadgeType.info, fontSize: 10),
                                ],
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                "NIR Portable Feed Analyzer",
                                style: TextStyle(fontSize: 13, color: AppColors.textMedium),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 28, color: AppColors.divider),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _deviceMetric(Icons.battery_charging_full_rounded, "Battery", "${workflow.deviceBattery}%", Colors.green),
                        _deviceMetric(Icons.bluetooth_connected_rounded, "Connection", "Strong", AppColors.primaryGreen),
                        _deviceMetric(Icons.check_circle_outline, "Status", "Ready", AppColors.statusGood),
                      ],
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: _isConnecting ? null : _handleConnect,
                      child: _isConnecting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text("Connect & Start Analysis"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Demo Sensor Telemetry Summary
              const Text(
                "Live Telemetry Stream",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    _telemetryRow("NIR Spectrum", "Simulated Spectral Sweep (1100-2400nm)", Icons.graphic_eq),
                    const Divider(color: AppColors.divider, height: 20),
                    _telemetryRow("Temperature", "${workflow.currentTemp} °C", Icons.thermostat),
                    const Divider(color: AppColors.divider, height: 20),
                    _telemetryRow("Humidity", "${workflow.currentHumidity} %", Icons.water_drop_outlined),
                    const Divider(color: AppColors.divider, height: 20),
                    _telemetryRow("Feed Weight", "${workflow.currentWeight} kg", Icons.scale_outlined),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Simulation Banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.statusGoodBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, size: 18, color: AppColors.primaryGreen),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Simulation mode is active. Generates realistic laboratory grade spectra and environmental sensor data.",
                        style: TextStyle(fontSize: 12, color: AppColors.primaryDark, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _deviceMetric(IconData icon, String title, String value, Color color) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 11, color: AppColors.textMedium)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _telemetryRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primaryGreen),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textDark, fontWeight: FontWeight.w500)),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 13, color: AppColors.textMedium, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
