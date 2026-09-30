import 'package:flutter/material.dart';

class AppColors {
  // Primary Agricultural Green Palette
  static const Color primaryGreen = Color(0xFF1E6B38);      // Deep rich forest/agri green
  static const Color primaryDark = Color(0xFF134A26);       // Deep green for headers & accents
  static const Color primaryLight = Color(0xFF2E8B57);      // Sea/Meadow green
  static const Color accentGreen = Color(0xFF4CAF50);       // Vibrant green for badges & checkmarks
  static const Color surfaceGreen = Color(0xFFF0F7F2);      // Very light soft green surface
  static const Color cardGreen = Color(0xFFE8F5E9);         // Soft green card background
  static const Color cardBorder = Color(0xFFC8E6C9);        // Subtle border
  
  // Neutrals
  static const Color background = Color(0xFFF8FAF8);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1B2A1E);
  static const Color textMedium = Color(0xFF4A5D4E);
  static const Color textLight = Color(0xFF7D8F81);
  static const Color divider = Color(0xFFE2EBE4);
  
  // Status & Warning Colors
  static const Color statusGood = Color(0xFF2E7D32);
  static const Color statusGoodBg = Color(0xFFE8F5E9);
  static const Color statusWarning = Color(0xFFE65100);
  static const Color statusWarningBg = Color(0xFFFFF3E0);
  static const Color statusAmber = Color(0xFFF57F17);
  static const Color statusAmberBg = Color(0xFFFFFDE7);
  static const Color statusError = Color(0xFFC62828);
  static const Color statusErrorBg = Color(0xFFFFEBEE);
  static const Color statusInfo = Color(0xFF0277BD);
  static const Color statusInfoBg = Color(0xFFE1F5FE);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1E6B38), Color(0xFF2E8B57)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardHeaderGradient = LinearGradient(
    colors: [Color(0xFFF1F8F4), Color(0xFFE8F5E9)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
