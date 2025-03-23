import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_fullstack/presentation/providers/auth_provider.dart';
import 'package:flutter_fullstack/presentation/screens/home_screen.dart';
import 'package:flutter_fullstack/presentation/screens/auth/login_screen.dart';
import 'package:flutter_fullstack/presentation/screens/auth/register_screen.dart';
import 'package:flutter_fullstack/presentation/screens/splash_screen.dart';
import 'package:flutter_fullstack/presentation/screens/tasks/task_detail_screen.dart';
import 'package:flutter_fullstack/presentation/screens/tasks/task_form_screen.dart';
import 'package:flutter_fullstack/presentation/screens/social/feed_screen.dart';
import 'package:flutter_fullstack/presentation/screens/social/social_layout.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, GoRouterState state) {
      // Check if the user is on the splash screen
      if (state.uri.path == '/') {
        return null;
      }
      
      // Check auth state
      final isLoggedIn = authState == AuthState.authenticated;
      final isLoggingIn = state.uri.path == '/login' || state.uri.path == '/register';
      
      // If not logged in and not on login page, redirect to login
      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }
      
      // If logged in and on login page, redirect to feed
      if (isLoggedIn && isLoggingIn) {
        return '/social';
      }
      
      return null;
    },
    routes: [
      // Splash screen
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Auth routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Home route (old)
      GoRoute(
        path: '/home',
        builder: (context, state) => const SocialLayout(),
      ),
      
      // Social routes
      GoRoute(
        path: '/social',
        builder: (context, state) => const SocialLayout(),
      ),
      
      // Feed route (direct access to feed)
      GoRoute(
        path: '/feed',
        builder: (context, state) => const FeedScreen(),
      ),
      
      // Task routes
      GoRoute(
        path: '/tasks/create',
        builder: (context, state) => const TaskFormScreen(isEditing: false),
      ),
      GoRoute(
        path: '/tasks/:id',
        builder: (context, state) {
          final taskId = state.pathParameters['id']!;
          return TaskDetailScreen(taskId: taskId);
        },
      ),
      GoRoute(
        path: '/tasks/:id/edit',
        builder: (context, state) {
          final taskId = state.pathParameters['id']!;
          return TaskFormScreen(isEditing: true, taskId: taskId);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );
}); 