import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/batch_provider.dart';
import '../../providers/alerts_provider.dart';
import '../../providers/dairy_provider.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/scenario_selector_sheet.dart';

class HomeDashboardScreen extends ConsumerWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    final batchState = ref.watch(batchProvider);
    final alertsState = ref.watch(alertsProvider);
    final dairyState = ref.watch(dairyProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFA),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. HERO HEADER SECTION
                _buildHeroHeader(context, user, dairyState, alertsState),

                // BODY CONTENT SECTION
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 18),

                      // 2. FARM STATUS SECTION
                      _buildFarmStatusSection(context),

                      const SizedBox(height: 22),

                      // 3. QUICK ACTIONS GRID
                      _buildQuickActionsSection(context),

                      const SizedBox(height: 22),

                      // 4. ALERTS BANNER (If Any)
                      _buildAlertsBanner(context, alertsState),

                      const SizedBox(height: 22),

                      // 5. RECENT FEED BATCHES
                      _buildRecentBatchesSection(context, ref, batchState),

                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }

  // 1. HERO HEADER
  Widget _buildHeroHeader(
    BuildContext context,
    dynamic user,
    dynamic dairyState,
    dynamic alertsState,
  ) {
    return Stack(
      children: [
        // Background Farm Image
        Container(
          height: 230,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFF2E3D2A),
          ),
          child: Image.asset(
            'assets/images/hero_dairy_farm.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: const Color(0xFF2E3D2A),
              child: const Center(
                child: Icon(Icons.landscape, size: 80, color: Colors.white24),
              ),
            ),
          ),
        ),

        // Gradient Overlay for Text Readability
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.55),
                  Colors.black.withOpacity(0.20),
                  Colors.black.withOpacity(0.60),
                ],
                stops: const [0.0, 0.45, 1.0],
              ),
            ),
          ),
        ),

        // User Profile & Status Bar Header Content
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar + Greeting
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2F0E5),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.85), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.18),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: Color(0xFF1B4D2E),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Good Morning, ${user.farmerName.split(' ').first}!",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: -0.2,
                                shadows: [
                                  Shadow(
                                    color: Colors.black45,
                                    blurRadius: 4,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "${user.farmName} • ${dairyState.profile.lactatingAnimals} Lactating • ${dairyState.profile.dryAnimals} Dry",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.92),
                                fontWeight: FontWeight.w500,
                                shadows: const [
                                  Shadow(
                                    color: Colors.black45,
                                    blurRadius: 3,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Action Icons (Demo Switcher & Notifications)
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.25),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white30, width: 1),
                      ),
                      child: IconButton(
                        onPressed: () => ScenarioSelectorSheet.show(context),
                        icon: const Icon(Icons.science_outlined, color: Colors.white, size: 20),
                        tooltip: "Switch Demo Scenario",
                        constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.25),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white30, width: 1),
                          ),
                          child: IconButton(
                            onPressed: () => context.push('/alerts'),
                            icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 20),
                            constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                        if (alertsState.unreadCount > 0)
                          Positioned(
                            right: 2,
                            top: 2,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFFE65100),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                "${alertsState.unreadCount}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 2. FARM STATUS SECTION
  Widget _buildFarmStatusSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Farm Status",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B2A1E),
                letterSpacing: -0.3,
              ),
            ),
            InkWell(
              onTap: () => context.go('/monitor'),
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Row(
                  children: [
                    Text(
                      "View Details",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    SizedBox(width: 3),
                    Icon(Icons.arrow_forward, size: 14, color: AppColors.primaryGreen),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Card 1: Feed Quality
            Expanded(
              child: _buildStatusPill(
                title: "Feed Quality",
                value: "Good",
                icon: Icons.check_circle_rounded,
                iconColor: const Color(0xFF1E7E34),
                watermarkIcon: Icons.eco_rounded,
                gradientColors: const [Color(0xFFEBF7EE), Color(0xFFD8EFE0)],
                borderColor: const Color(0xFFC7E6D0),
                valueColor: const Color(0xFF1B4D2E),
                onTap: () => context.push('/test/result'),
              ),
            ),
            const SizedBox(width: 8),

            // Card 2: Storage
            Expanded(
              child: _buildStatusPill(
                title: "Storage",
                value: "Attention",
                icon: Icons.warning_rounded,
                iconColor: const Color(0xFFE65100),
                watermarkIcon: Icons.inventory_2_rounded,
                gradientColors: const [Color(0xFFFFF6EE), Color(0xFFFDECE0)],
                borderColor: const Color(0xFFF8D8C0),
                valueColor: const Color(0xFFB71C1C),
                onTap: () => context.go('/monitor'),
              ),
            ),
            const SizedBox(width: 8),

            // Card 3: Dairy Profile
            Expanded(
              child: _buildStatusPill(
                title: "Dairy Profile",
                value: "Ready",
                icon: Icons.check_circle_rounded,
                iconColor: const Color(0xFF1E7E34),
                watermarkIcon: Icons.pets_rounded,
                gradientColors: const [Color(0xFFEBF7EE), Color(0xFFD8EFE0)],
                borderColor: const Color(0xFFC7E6D0),
                valueColor: const Color(0xFF1B4D2E),
                onTap: () => context.go('/dairy'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusPill({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required IconData watermarkIcon,
    required List<Color> gradientColors,
    required Color borderColor,
    required Color valueColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 84,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Decorative Translucent Watermark on Right
              Positioned(
                right: -4,
                bottom: -4,
                child: Icon(
                  watermarkIcon,
                  size: 46,
                  color: iconColor.withOpacity(0.16),
                ),
              ),

              // Content Layout
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(icon, size: 20, color: iconColor),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 10.5,
                            color: Color(0xFF556557),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 1),
                        Text(
                          value,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: valueColor,
                            letterSpacing: -0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 3. QUICK ACTIONS 2X2 GRID
  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quick Actions",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B2A1E),
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 1.18,
          children: [
            _buildQuickActionImageCard(
              title: "Test Feed",
              subtitle: "Analyze feed quality",
              imagePath: "assets/images/card_test_feed.jpg",
              badgeIcon: Icons.science_rounded,
              onTap: () => context.go('/test'),
            ),
            _buildQuickActionImageCard(
              title: "Monitor",
              subtitle: "Feed Zone & Silage",
              imagePath: "assets/images/card_monitor_cows.jpg",
              badgeIcon: Icons.sensors_rounded,
              onTap: () => context.go('/monitor'),
            ),
            _buildQuickActionImageCard(
              title: "Manage Farm",
              subtitle: "Herd, Feed & Resources",
              imagePath: "assets/images/card_manage_farm.jpg",
              badgeIcon: Icons.spa_rounded,
              onTap: () => context.go('/dairy'),
            ),
            _buildQuickActionImageCard(
              title: "History & Reports",
              subtitle: "Track progress over time",
              imagePath: "assets/images/card_history_reports.jpg",
              badgeIcon: Icons.history_rounded,
              onTap: () => context.push('/history'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionImageCard({
    required String title,
    required String subtitle,
    required String imagePath,
    required IconData badgeIcon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Photographic Background
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFF2C3B2B),
                  child: Center(
                    child: Icon(badgeIcon, size: 48, color: Colors.white24),
                  ),
                ),
              ),

              // 2. Contrast Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.20),
                      Colors.black.withOpacity(0.15),
                      Colors.black.withOpacity(0.78),
                    ],
                    stops: const [0.0, 0.45, 1.0],
                  ),
                ),
              ),

              // 3. Top-Left Badge Icon
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBF7EE).withOpacity(0.92),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withOpacity(0.8), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    badgeIcon,
                    color: const Color(0xFF1B4D2E),
                    size: 20,
                  ),
                ),
              ),

              // 4. Bottom Information & Circular Chevron Button
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: -0.2,
                              shadows: [
                                Shadow(
                                  color: Colors.black54,
                                  blurRadius: 3,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withOpacity(0.85),
                              fontWeight: FontWeight.w400,
                              shadows: const [
                                Shadow(
                                  color: Colors.black54,
                                  blurRadius: 2,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.35),
                        border: Border.all(color: Colors.white.withOpacity(0.85), width: 1.2),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 4. ALERTS BANNER
  Widget _buildAlertsBanner(BuildContext context, dynamic alertsState) {
    return InkWell(
      onTap: () => context.push('/alerts'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF7ED),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFFD8A8)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFFFE8CC),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFD9480F), size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${alertsState.unreadCount} actions need attention",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD9480F),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    "Storage temperature & ration balance alerts",
                    style: TextStyle(fontSize: 12, color: Color(0xFF862E9C)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFFD9480F)),
          ],
        ),
      ),
    );
  }

  // 5. RECENT BATCHES
  Widget _buildRecentBatchesSection(
    BuildContext context,
    WidgetRef ref,
    dynamic batchState,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Recent Feed Batches",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B2A1E),
                letterSpacing: -0.3,
              ),
            ),
            TextButton(
              onPressed: () => context.push('/history'),
              child: const Text(
                "View All",
                style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ...batchState.batches.take(2).map((batch) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE9EFEA)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF5EE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.inventory_2_outlined, color: AppColors.primaryGreen),
              ),
              title: Text(
                batch.feedType,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
              ),
              subtitle: Text(
                "${batch.batchNumber} • ${batch.storageLocation}",
                style: const TextStyle(fontSize: 12, color: AppColors.textMedium),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  StatusBadge(
                    label: batch.evidenceAssessment?.nirEvidence == "HIGH" ? "Evidence HIGH" : "Review",
                    type: batch.evidenceAssessment?.nirEvidence == "HIGH" ? BadgeType.success : BadgeType.amber,
                    fontSize: 10,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "CP: ${batch.nutritionResult?.crudeProtein ?? 0.0}%",
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textDark),
                  ),
                ],
              ),
              onTap: () {
                ref.read(batchProvider.notifier).selectBatch(batch.id);
                context.push('/test/result');
              },
            ),
          );
        }),
      ],
    );
  }
}

