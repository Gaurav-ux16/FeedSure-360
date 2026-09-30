import 'package:go_router/go_router.dart';
import '../features/splash/splash_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/signup_screen.dart';
import '../features/home/home_dashboard_screen.dart';
import '../features/testing/test_feed_menu_screen.dart';
import '../features/testing/feed_identification_screen.dart';
import '../features/testing/create_batch_screen.dart';
import '../features/testing/representative_sampling_screen.dart';
import '../features/testing/device_connection_screen.dart';
import '../features/testing/nir_scan_screen.dart';
import '../features/testing/guided_camera_screen.dart';
import '../features/testing/image_analysis_screen.dart';
import '../features/testing/evidence_analysis_screen.dart';
import '../features/testing/insufficient_evidence_screen.dart';
import '../features/testing/feed_quality_result_screen.dart';
import '../features/testing/nutrition_map_screen.dart';
import '../features/monitoring/storage_monitoring_screen.dart';
import '../features/dairy/dairy_profile_screen.dart';
import '../features/dairy/advisory_screen.dart';
import '../features/passport/passport_screen.dart';
import '../features/passport/batch_timeline_screen.dart';
import '../features/history/test_history_screen.dart';
import '../features/alerts/alert_center_screen.dart';
import '../features/more/more_screen.dart';
import '../features/settings/settings_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeDashboardScreen(),
    ),
    GoRoute(
      path: '/test',
      builder: (context, state) => const TestFeedMenuScreen(),
      routes: [
        GoRoute(
          path: 'identify',
          builder: (context, state) => const FeedIdentificationScreen(),
        ),
        GoRoute(
          path: 'batch',
          builder: (context, state) => const CreateBatchScreen(),
        ),
        GoRoute(
          path: 'sample',
          builder: (context, state) => const RepresentativeSamplingScreen(),
        ),
        GoRoute(
          path: 'device',
          builder: (context, state) => const DeviceConnectionScreen(),
        ),
        GoRoute(
          path: 'scan',
          builder: (context, state) => const NIRScanScreen(),
        ),
        GoRoute(
          path: 'image',
          builder: (context, state) => const GuidedCameraScreen(),
        ),
        GoRoute(
          path: 'analysis',
          builder: (context, state) => const ImageAnalysisScreen(),
        ),
        GoRoute(
          path: 'evidence',
          builder: (context, state) => const EvidenceAnalysisScreen(),
        ),
        GoRoute(
          path: 'insufficient',
          builder: (context, state) => const InsufficientEvidenceScreen(),
        ),
        GoRoute(
          path: 'result',
          builder: (context, state) => const FeedQualityResultScreen(),
        ),
        GoRoute(
          path: 'nutrition-map',
          builder: (context, state) => const NutritionMapScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/monitor',
      builder: (context, state) => const StorageMonitoringScreen(),
    ),
    GoRoute(
      path: '/dairy',
      builder: (context, state) => const DairyProfileScreen(),
      routes: [
        GoRoute(
          path: 'advisory',
          builder: (context, state) => const AdvisoryScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/passport',
      builder: (context, state) => const PassportScreen(),
      routes: [
        GoRoute(
          path: 'timeline',
          builder: (context, state) => const BatchTimelineScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const TestHistoryScreen(),
    ),
    GoRoute(
      path: '/alerts',
      builder: (context, state) => const AlertCenterScreen(),
    ),
    GoRoute(
      path: '/more',
      builder: (context, state) => const MoreScreen(),
      routes: [
        GoRoute(
          path: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: 'history',
          builder: (context, state) => const TestHistoryScreen(),
        ),
        GoRoute(
          path: 'alerts',
          builder: (context, state) => const AlertCenterScreen(),
        ),
        GoRoute(
          path: 'passport',
          builder: (context, state) => const PassportScreen(),
        ),
      ],
    ),
  ],
);
