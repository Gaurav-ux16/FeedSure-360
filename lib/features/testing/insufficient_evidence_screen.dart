import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

class InsufficientEvidenceScreen extends StatelessWidget {
  const InsufficientEvidenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("More Evidence Required"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Warning Header Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFFCC80)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFE0B2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFE65100), size: 24),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Result Not Trusted",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFBF360C),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "We found significant variation in the sample measurements. FeedSure 360 will not fabricate nutritional values without verified scientific confidence.",
                            style: TextStyle(fontSize: 13, color: Color(0xFF5D4037), height: 1.3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Root Cause Diagnostics
              const Text(
                "Why was evidence insufficient?",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              const SizedBox(height: 10),
              _diagnosticItem(Icons.grid_off_rounded, "Sample variability detected across testing points"),
              _diagnosticItem(Icons.sensors_off_outlined, "NIR spectral confidence is below calibration envelope"),
              _diagnosticItem(Icons.hide_image_outlined, "Visual surface evidence requires higher resolution"),

              const SizedBox(height: 24),

              // Recommended Next Steps
              const Text(
                "Recommended Next Steps",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              const SizedBox(height: 12),

              _actionTile(
                context,
                title: "Collect More Samples",
                subtitle: "Take 5 additional points from the center of the pit",
                icon: Icons.grid_view_rounded,
                onTap: () => context.push('/test/sample'),
              ),
              _actionTile(
                context,
                title: "Additional High-Res Image",
                subtitle: "Re-capture under even natural daylight",
                icon: Icons.camera_enhance_outlined,
                onTap: () => context.push('/test/image'),
              ),
              _actionTile(
                context,
                title: "Rapid Urea Strip Test",
                subtitle: "Screen for non-protein nitrogen adulteration",
                icon: Icons.colorize_outlined,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Urea Test Strip guide opened")),
                  );
                },
              ),
              _actionTile(
                context,
                title: "Confirmatory Wet-Lab Analysis",
                subtitle: "Send sample to accredited regional forage lab",
                icon: Icons.local_shipping_outlined,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Lab sample dispatch request created")),
                  );
                },
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () => context.go('/home'),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryDark),
                child: const Text("Return to Dashboard"),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _diagnosticItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFFE65100)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: AppColors.textMedium),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.surfaceGreen,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primaryGreen, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textMedium)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textLight),
        onTap: onTap,
      ),
    );
  }
}
