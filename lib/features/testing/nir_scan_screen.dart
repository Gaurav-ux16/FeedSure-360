import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/simulation_engine_provider.dart';
import '../../providers/testing_workflow_provider.dart';
import '../../widgets/nir_chart_widget.dart';
import '../../widgets/status_badge.dart';

class NIRScanScreen extends ConsumerStatefulWidget {
  const NIRScanScreen({super.key});

  @override
  ConsumerState<NIRScanScreen> createState() => _NIRScanScreenState();
}

class _NIRScanScreenState extends ConsumerState<NIRScanScreen> {
  int _currentSample = 2;
  final int _totalSamples = 5;
  bool _isAutoScanning = false;
  Timer? _scanTimer;

  @override
  void initState() {
    super.initState();
    _startScanSimulation();
  }

  void _startScanSimulation() {
    setState(() => _isAutoScanning = true);
    _scanTimer = Timer.periodic(const Duration(milliseconds: 1400), (timer) {
      if (_currentSample < _totalSamples) {
        setState(() {
          _currentSample++;
          ref.read(testingWorkflowProvider.notifier).updateScanProgress(_currentSample);
        });
      } else {
        timer.cancel();
        setState(() => _isAutoScanning = false);
      }
    });
  }

  @override
  void dispose() {
    _scanTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workflow = ref.watch(testingWorkflowProvider);
    final engine = ref.watch(simulationEngineProvider);
    final spectrumPoints = engine.generateNIRSpectrum(sampleIndex: _currentSample);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Feed Analysis"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Scan Progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Scanning Sample $_currentSample / $_totalSamples",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  if (_isAutoScanning)
                    const StatusBadge(
                      label: "Scanning...",
                      type: BadgeType.info,
                      fontSize: 11,
                    )
                  else
                    const StatusBadge(
                      label: "Scan Ready ✓",
                      type: BadgeType.success,
                      fontSize: 11,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: _currentSample / _totalSamples,
                backgroundColor: AppColors.surfaceGreen,
                color: AppColors.primaryGreen,
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),

              const SizedBox(height: 18),

              // Sub-Tabs [NIR Scan | Sensors | Camera]
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    _subTabItem("NIR Scan", isActive: true),
                    _subTabItem("Sensors", isActive: false),
                    _subTabItem("Camera", isActive: false),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // NIR Spectrum Chart Card
              const Text(
                "NIR Spectrum (Absorbance vs Wavelength)",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              const SizedBox(height: 8),
              NIRChartWidget(spectrumPoints: spectrumPoints),

              const SizedBox(height: 16),

              // Signal Quality & Sensor Cards
              Row(
                children: [
                  Expanded(
                    child: _metricPill(
                      title: "Signal Quality",
                      value: "${workflow.scanSignalQuality.toInt()}%",
                      icon: Icons.network_check_rounded,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _metricPill(
                      title: "Temperature",
                      value: "${workflow.currentTemp} °C",
                      icon: Icons.thermostat_outlined,
                      color: Colors.orange.shade800,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _metricPill(
                      title: "Humidity",
                      value: "${workflow.currentHumidity.toInt()}%",
                      icon: Icons.water_drop_outlined,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Multi-point scanning consistency indication
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Multi-Point Sampling Consistency", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        Text("${engine.config.sampleConsistencyPercent.toInt()}%", style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(5, (i) {
                        final isDone = i < _currentSample;
                        return Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: isDone ? AppColors.primaryGreen : AppColors.surfaceGreen,
                              child: isDone
                                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                                  : Text("${i + 1}", style: const TextStyle(fontSize: 11, color: AppColors.textMedium)),
                            ),
                            if (i < 4) Container(width: 18, height: 2, color: isDone ? AppColors.primaryGreen : AppColors.divider),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () => context.push('/test/image'),
                child: const Text("Continue to Visual Inspection"),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _subTabItem(String title, {required bool isActive}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : null,
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? AppColors.primaryDark : AppColors.textMedium,
          ),
        ),
      ),
    );
  }

  Widget _metricPill({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontSize: 10, color: AppColors.textMedium)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
