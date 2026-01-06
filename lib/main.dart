import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:skin_scan_ai/theme.dart';
import 'package:skin_scan_ai/state/scan_provider.dart';
import 'package:skin_scan_ai/features/splash/splash_screen.dart';
import 'package:skin_scan_ai/features/auth/authentication_screen.dart';
import 'package:skin_scan_ai/features/onboarding/onboarding_screen.dart';
import 'package:skin_scan_ai/features/quiz/skin_profile_screen.dart';
import 'package:skin_scan_ai/features/scan/smart_camera_screen.dart';
import 'package:skin_scan_ai/features/analysis/analysis_loading_screen.dart';
import 'package:skin_scan_ai/features/results/results_screen.dart';
import 'package:skin_scan_ai/features/routine/routine_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  final scanProvider = ScanProvider();
  await scanProvider.loadState();
  runApp(MyApp(scanProvider: scanProvider));
}

class MyApp extends StatelessWidget {
  final ScanProvider scanProvider;

  const MyApp({super.key, required this.scanProvider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ScanProvider>.value(
      value: scanProvider,
      child: MaterialApp.router(
        title: 'Skin Scan AI',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        routerConfig: _router,
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthenticationScreen(),
    ),
    GoRoute(
      path: '/quiz',
      builder: (context, state) => const SkinProfileScreen(),
    ),
    GoRoute(
      path: '/camera',
      builder: (context, state) => const SmartCameraScreen(),
    ),
    GoRoute(
      path: '/analysis',
      builder: (context, state) => AnalysisLoadingScreen(imagePath: state.extra as String?),
    ),
    GoRoute(
      path: '/results',
      builder: (context, state) => const ResultsScreen(),
    ),
    GoRoute(
      path: '/routine',
      builder: (context, state) => const RoutineScreen(),
    ),
  ],
);
