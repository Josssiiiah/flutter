import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_fullstack/core/config/router.dart';
import 'package:flutter_fullstack/core/theme/app_theme.dart';
import 'package:flutter_fullstack/presentation/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // No need to initialize Firebase for now
  // We're using mock data for development
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    
    return MaterialApp.router(
      title: 'SPILL',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
