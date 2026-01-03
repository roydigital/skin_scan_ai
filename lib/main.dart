import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skin_scan_ai/theme.dart';
import 'package:skin_scan_ai/features/auth/authentication_screen.dart';
import 'package:skin_scan_ai/features/onboarding/onboarding_screen.dart';
import 'package:skin_scan_ai/features/quiz/skin_profile_screen.dart';
import 'package:skin_scan_ai/features/scan/smart_camera_screen.dart';
import 'package:skin_scan_ai/features/analysis/analysis_loading_screen.dart';
import 'package:skin_scan_ai/features/results/results_screen.dart';
import 'package:skin_scan_ai/features/routine/routine_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Skin Scan AI',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: _router,
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
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
      builder: (context, state) => const AnalysisLoadingScreen(),
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
