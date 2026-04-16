import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/tasks/presentation/screens/tasks_screen.dart';
import '../../features/tasks/presentation/screens/focus_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import 'scaffold_with_nav_bar.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/tasks',
    redirect: (context, state) {
      // Check auth status
      final isAuthenticated = authState.valueOrNull != null;
      final isLoggingIn = state.uri.toString() == '/login' || state.uri.toString() == '/register';

      // If waiting for async loading, don't redirect yet
      if (authState.isLoading) return null;

      if (!isAuthenticated && !isLoggingIn) {
        return '/login'; // Redirect to login if unauthenticated
      }

      if (isAuthenticated && isLoggingIn) {
        return '/tasks'; // Redirect authenticated users away from auth screens
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return ScaffoldWithNavBar(child: child);
        },
        routes: [
          GoRoute(
            path: '/tasks',
            builder: (context, state) => const TasksScreen(),
          ),
          GoRoute(
            path: '/focus',
            builder: (context, state) => const FocusScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
});
