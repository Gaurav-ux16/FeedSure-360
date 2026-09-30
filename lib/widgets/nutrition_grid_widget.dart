import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class NutritionGridWidget extends StatelessWidget {
  final List<double> values; // 9 values
  final int? outlierIndex;
  final ValueChanged<int>? onPointSelected;

  const NutritionGridWidget({
    super.key,
    required this.values,
    this.outlierIndex,
    this.onPointSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.35,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              final val = index < values.length ? values[index] : 0.0;
              final isOutlier = outlierIndex == index;

              final bgColor = isOutlier
                  ? const Color(0xFFFFF3E0)
                  : const Color(0xFFE8F5E9);
              final textColor = isOutlier
                  ? const Color(0xFFE65100)
                  : const Color(0xFF2E7D32);
              final borderColor = isOutlier
                  ? const Color(0xFFFFB74D)
                  : const Color(0xFFA5D6A7);

              return InkWell(
                onTap: () => onPointSelected?.call(index),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderColor, width: 1.2),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    val.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendItem("Normal", const Color(0xFF2E7D32), const Color(0xFFE8F5E9)),
              const SizedBox(width: 20),
              _legendItem("Varying", const Color(0xFFE65100), const Color(0xFFFFF3E0)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color dotColor, Color pillBg) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
