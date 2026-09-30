import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'routing/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: FeedSure360App(),
    ),
  );
}

class FeedSure360App extends StatelessWidget {
  const FeedSure360App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FeedSure 360',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
