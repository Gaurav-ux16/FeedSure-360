import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/theme/app_colors.dart';
import '../models/evidence_model.dart';

class NIRChartWidget extends StatelessWidget {
  final List<NIRSpectrumPoint> spectrumPoints;
  final bool isLive;

  const NIRChartWidget({
    super.key,
    required this.spectrumPoints,
    this.isLive = true,
  });

  @override
  Widget build(BuildContext context) {
    if (spectrumPoints.isEmpty) {
      return Container(
        height: 180,
        alignment: Alignment.center,
        child: const Text("No spectrum data available"),
      );
    }

    final spots = spectrumPoints.map((p) => FlSpot(p.wavelength, p.absorbance)).toList();

    return Container(
      height: 190,
      padding: const EdgeInsets.only(top: 16, right: 16, left: 4, bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 0.5,
            verticalInterval: 300,
            getDrawingHorizontalLine: (value) => const FlLine(
              color: Color(0xFFE8F5E9),
              strokeWidth: 1,
            ),
            getDrawingVerticalLine: (value) => const FlLine(
              color: Color(0xFFE8F5E9),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              axisNameWidget: const Text(
                'Wavelength (nm)',
                style: TextStyle(fontSize: 11, color: AppColors.textLight),
              ),
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                interval: 300,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 10, color: AppColors.textMedium),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              axisNameWidget: const Text(
                'Abs',
                style: TextStyle(fontSize: 10, color: AppColors.textLight),
              ),
              sideTitles: SideTitles(
                showTitles: true,
                interval: 0.5,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 10, color: AppColors.textMedium),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: AppColors.divider),
          ),
          minX: 1100,
          maxX: 2300,
          minY: 0.0,
          maxY: 1.8,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppColors.primaryGreen,
              barWidth: 2.5,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.primaryGreen.withOpacity(0.12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
