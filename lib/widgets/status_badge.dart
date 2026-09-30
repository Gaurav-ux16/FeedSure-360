import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

enum BadgeType { success, warning, amber, error, info, neutral }

class StatusBadge extends StatelessWidget {
  final String label;
  final BadgeType type;
  final IconData? icon;
  final double fontSize;

  const StatusBadge({
    super.key,
    required this.label,
    this.type = BadgeType.success,
    this.icon,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    IconData defaultIcon;

    switch (type) {
      case BadgeType.success:
        bg = AppColors.statusGoodBg;
        fg = AppColors.statusGood;
        defaultIcon = Icons.check_circle;
        break;
      case BadgeType.warning:
        bg = AppColors.statusWarningBg;
        fg = AppColors.statusWarning;
        defaultIcon = Icons.warning_amber_rounded;
        break;
      case BadgeType.amber:
        bg = AppColors.statusAmberBg;
        fg = AppColors.statusAmber;
        defaultIcon = Icons.info_outline;
        break;
      case BadgeType.error:
        bg = AppColors.statusErrorBg;
        fg = AppColors.statusError;
        defaultIcon = Icons.error_outline;
        break;
      case BadgeType.info:
        bg = AppColors.statusInfoBg;
        fg = AppColors.statusInfo;
        defaultIcon = Icons.info_outline;
        break;
      case BadgeType.neutral:
        bg = AppColors.divider;
        fg = AppColors.textMedium;
        defaultIcon = Icons.circle;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withOpacity(0.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon ?? defaultIcon, size: fontSize + 2, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontWeight: FontWeight.w600,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
