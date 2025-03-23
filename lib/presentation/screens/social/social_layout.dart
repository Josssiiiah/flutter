import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_fullstack/presentation/screens/social/feed_screen.dart';
import 'package:flutter_fullstack/presentation/providers/auth_provider.dart';
import 'package:flutter_fullstack/core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';

enum SocialTab { feed, search, notifications, profile }

final currentTabProvider = StateProvider<SocialTab>((ref) => SocialTab.feed);

class SocialLayout extends ConsumerWidget {
  const SocialLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(currentTabProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: _buildBody(currentTab),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentTab.index,
          onTap: (index) {
            ref.read(currentTabProvider.notifier).state = SocialTab.values[index];
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          elevation: 0,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
          items: [
            _buildNavItem(
              icon: Icons.home_outlined, 
              activeIcon: Icons.home_rounded,
              label: 'Home',
            ),
            _buildNavItem(
              icon: Icons.search_outlined, 
              activeIcon: Icons.search_rounded,
              label: 'Search',
            ),
            _buildNavItem(
              icon: Icons.notifications_outlined, 
              activeIcon: Icons.notifications_rounded,
              label: 'Activity',
            ),
            _buildNavItem(
              icon: Icons.person_outline_rounded, 
              activeIcon: Icons.person_rounded,
              label: 'Profile',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle new post action
        },
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required IconData icon, 
    required IconData activeIcon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(icon, size: 24),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(activeIcon, size: 24),
      ),
      label: label,
    );
  }

  Widget _buildBody(SocialTab tab) {
    switch (tab) {
      case SocialTab.feed:
        return const FeedScreen();
      case SocialTab.search:
        return _buildPlaceholderScreen(
          icon: Icons.search_rounded,
          title: 'Search',
          message: 'Search for posts, users, and hashtags',
        );
      case SocialTab.notifications:
        return _buildPlaceholderScreen(
          icon: Icons.notifications_rounded,
          title: 'Activity',
          message: 'See your latest notifications and activity',
        );
      case SocialTab.profile:
        return _buildPlaceholderScreen(
          icon: Icons.person_rounded,
          title: 'Profile',
          message: 'View and edit your profile',
        );
    }
  }

  Widget _buildPlaceholderScreen({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark 
                        ? AppTheme.primaryColor.withOpacity(0.2) 
                        : AppTheme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 60,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    // Handle placeholder button press
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Coming Soon',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 