import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/quiz_flow_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/routine/screens/routine_screen.dart';
import '../../features/scan/screens/scan_screen.dart';
import '../../features/progress/screens/progress_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/product/screens/product_detail_screen.dart';
import '../../shared/widgets/main_scaffold.dart';
import '../constants/app_routes.dart';
// MODEL IMPORTU EKLENDİ (Hata almamak için şart)
import '../../models/user_profile_model.dart'; 

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.login, 
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    // GÜNCELLENEN KISIM: Quiz rotası artık dışarıdan gelen UserProfileModel'i kabul ediyor
    GoRoute(
      path: '/quiz',
      name: 'quiz',
      builder: (context, state) {
        // state.extra üzerinden gelen modeli yakalıyoruz
        final userProfile = state.extra as UserProfileModel; 
        return QuizFlowScreen(userProfile: userProfile);
      },
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.routine,
          builder: (context, state) => const RoutineScreen(),
        ),
        GoRoute(
          path: AppRoutes.scan,
          builder: (context, state) => const ScanScreen(),
        ),
        GoRoute(
          path: AppRoutes.progress,
          builder: (context, state) => const ProgressScreen(),
        ),
        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/product/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final productId = state.pathParameters['id']!;
        return ProductDetailScreen(productId: productId);
      },
    ),
    GoRoute(
      path: AppRoutes.ingredientConflict,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return IngredientConflictSheet(data: extra);
      },
    ),
  ],
);

class IngredientConflictSheet extends StatelessWidget {
  final Map<String, dynamic>? data;
  const IngredientConflictSheet({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Icon(Icons.warning_amber_rounded,
                color: Color(0xFFE05252), size: 48),
              const SizedBox(height: 12),
              const Text('İçerik Çakışması Tespit Edildi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(
                data?['message'] ?? 'Bu ürünler aynı anda kullanılmamalıdır.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF7A7291)),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => context.pop(),
                  child: const Text('Anladım'),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}