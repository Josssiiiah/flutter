import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_fullstack/presentation/providers/auth_provider.dart';
import 'package:flutter_fullstack/core/theme/app_theme.dart';
import 'package:flutter_fullstack/presentation/widgets/spill_logo.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    // Simulate initial loading
    await Future.delayed(const Duration(seconds: 2));
    
    // Check if we're still mounted before navigating
    if (!mounted) return;
    
    // Check authentication state
    final authState = ref.read(authStateProvider);
    
    if (authState == AuthState.authenticated) {
      // Navigate to social layout if authenticated
      if (context.mounted) {
        context.go('/social');
      }
    } else {
      // Navigate to login screen if not authenticated
      if (context.mounted) {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    const Color(0xFF21222C),
                    const Color(0xFF181922),
                  ]
                : [
                    const Color(0xFFF8F9FF),
                    const Color(0xFFEEF1FF),
                  ],
          ),
        ),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Center(
              child: FadeTransition(
                opacity: _fadeInAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo container with shadow
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withOpacity(0.1)
                              : Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.2),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: SpillLogo(
                          width: 56,
                          height: 56 * (24/88), // Maintain aspect ratio
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 40),
                      // App name
                      Text(
                        'SPILL',
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF21222C),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Tagline
                      Text(
                        'Share your thoughts, connect with others',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: isDark
                              ? Colors.white.withOpacity(0.7)
                              : const Color(0xFF333333).withOpacity(0.7),
                        ),
                      ),
                      SizedBox(height: size.height * 0.08),
                      // Loading indicator
                      SizedBox(
                        width: 36,
                        height: 36,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
} 