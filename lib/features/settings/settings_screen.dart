import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/offline_sync_provider.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/scenario_selector_sheet.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    final offlineSync = ref.watch(offlineSyncProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile & Settings"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Header Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.primaryGreen.withOpacity(0.15),
                      child: const Icon(Icons.person, size: 36, color: AppColors.primaryGreen),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.farmerName,
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textDark),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user.farmName,
                            style: const TextStyle(fontSize: 13, color: AppColors.textMedium),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user.location,
                            style: const TextStyle(fontSize: 12, color: AppColors.textLight),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Demo Scenario Switcher
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceGreen,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: const Icon(Icons.science_outlined, color: AppColors.primaryGreen),
                  title: const Text(
                    "Demo Scenario Switcher",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  subtitle: const Text("Toggle between 6 test scenarios", style: TextStyle(fontSize: 12)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.primaryGreen),
                  onTap: () => ScenarioSelectorSheet.show(context),
                ),
              ),

              const SizedBox(height: 16),

              // Offline Sync Control
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              offlineSync.isOnline ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
                              color: offlineSync.isOnline ? AppColors.primaryGreen : AppColors.statusWarning,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Network & Offline Sync", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                Text(
                                  offlineSync.isOnline ? "Online (All records synced)" : "Offline (${offlineSync.pendingSyncCount} pending records)",
                                  style: const TextStyle(fontSize: 12, color: AppColors.textMedium),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Switch(
                          value: offlineSync.isOnline,
                          activeColor: AppColors.primaryGreen,
                          onChanged: (val) {
                            ref.read(offlineSyncProvider.notifier).toggleNetwork(val);
                          },
                        ),
                      ],
                    ),
                    if (!offlineSync.isOnline) ...[
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => ref.read(offlineSyncProvider.notifier).triggerSync(),
                        child: Text(offlineSync.isSyncing ? "Synchronizing..." : "Force Sync Queue"),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Settings List
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    _settingsTile(
                      "Language",
                      user.language == 'en' ? "English" : (user.language == 'hi' ? "हिन्दी" : "मराठी"),
                      Icons.language_rounded,
                      onTap: () {
                        _showLanguageDialog(context, ref);
                      },
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    _settingsTile(
                      "Hardware Devices",
                      user.isHardwareMode ? "Connected (FS-NIR-001)" : "Simulation Mode Active",
                      Icons.devices_rounded,
                      onTap: () => context.push('/test/device'),
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    _settingsTile(
                      "Farm & Dairy Profile",
                      "18 Animals (12 Lactating)",
                      Icons.grass_rounded,
                      onTap: () => context.go('/dairy'),
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    _settingsTile(
                      "About FeedSure 360",
                      "v1.0.0 (Smart Agri Tech)",
                      Icons.info_outline_rounded,
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Logout Button
              OutlinedButton.icon(
                onPressed: () {
                  ref.read(authProvider.notifier).logout();
                  context.go('/login');
                },
                icon: const Icon(Icons.logout, size: 18, color: AppColors.statusError),
                label: const Text("Logout", style: TextStyle(color: AppColors.statusError)),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.statusError)),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 4),
    );
  }

  static void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Select Language"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("English"),
              onTap: () {
                ref.read(authProvider.notifier).setLanguage('en');
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text("हिन्दी (Hindi)"),
              onTap: () {
                ref.read(authProvider.notifier).setLanguage('hi');
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text("मराठी (Marathi)"),
              onTap: () {
                ref.read(authProvider.notifier).setLanguage('mr');
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsTile(String title, String subtitle, IconData icon, {required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryGreen),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textMedium)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textLight),
      onTap: onTap,
    );
  }
}
