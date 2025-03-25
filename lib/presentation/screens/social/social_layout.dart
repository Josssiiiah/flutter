import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_fullstack/presentation/screens/social/feed_screen.dart';
import 'package:flutter_fullstack/presentation/providers/auth_provider.dart';
import 'package:flutter_fullstack/core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_fullstack/presentation/screens/social/create_post_screen.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui';  // For BackdropFilter
import 'package:flutter_svg/flutter_svg.dart';

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
      body: Stack(
        children: [
          // Main content
          _buildBody(currentTab),
          
          // Custom bottom navigation bar with frosted glass effect
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                child: Container(
                  height: kBottomNavigationBarHeight + 2, // Add 1px for border
                  decoration: BoxDecoration(
                    color: isDark 
                        ? Colors.black.withOpacity(0.00) 
                        : Colors.white.withOpacity(0.00),
                    border: Border(
                      top: BorderSide(
                        color: isDark
                            ? Colors.white.withOpacity(0.00)
                            : Colors.black.withOpacity(0.00),
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: Colors.transparent,
                    ),
                    child: BottomNavigationBar(
                      currentIndex: () {
                        switch (currentTab) {
                          case SocialTab.feed:
                            return 0;
                          case SocialTab.search:
                            return 1;
                          case SocialTab.notifications:
                            return 3;
                          case SocialTab.profile:
                            return 4;
                        }
                      }(),
                      onTap: (index) {
                        if (index == 2) return; // ignore taps on the dummy space
                        final adjustedIndex = index > 2 ? index - 1 : index;
                        ref.read(currentTabProvider.notifier).state = SocialTab.values[adjustedIndex];
                      },
                      type: BottomNavigationBarType.fixed,
                      backgroundColor: Colors.transparent,
                      selectedItemColor: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      unselectedItemColor: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      elevation: 0,
                      showSelectedLabels: false,
                      showUnselectedLabels: false,
                      selectedFontSize: 0,
                      unselectedFontSize: 0,
                      items: [
                        BottomNavigationBarItem(
                          icon: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: SvgPicture.string(
                                  '''
                                  <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                  <path fill-rule="evenodd" clip-rule="evenodd" d="M9.62824 0.738616C11.0581 -0.246205 12.9419 -0.246205 14.3718 0.738616L22.1719 6.11181C23.316 6.90012 24 8.20604 24 9.60144V19.7713C24 22.1068 22.1196 24 19.7998 24H4.20015C1.88042 24 0 22.1068 0 19.7713V9.60144C0 8.20548 0.683995 6.89956 1.82811 6.11181L9.62824 0.738616ZM8.99993 18.5634C8.66862 18.5634 8.39975 18.8341 8.39975 19.1676C8.39975 19.5012 8.66862 19.7719 8.99993 19.7719H15.0001C15.3314 19.7719 15.6003 19.5012 15.6003 19.1676C15.6003 18.8341 15.3314 18.5634 15.0001 18.5634H8.99993Z" fill="currentColor"/>
                                  </svg>
                                  ''',
                                  width: 24,
                                  height: 24,
                                  colorFilter: ColorFilter.mode(
                                    isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              if (currentTab == SocialTab.feed)
                                SvgPicture.string(
                                  '''
                                  <svg width="6" height="6" viewBox="0 0 6 6" fill="none" xmlns="http://www.w3.org/2000/svg">
                                  <circle cx="3" cy="3" r="3" fill="currentColor"/>
                                  </svg>
                                  ''',
                                  colorFilter: ColorFilter.mode(
                                    isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                    BlendMode.srcIn,
                                  ),
                                ),
                            ],
                          ),
                          label: '',
                        ),
                        BottomNavigationBarItem(
                          icon: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: SvgPicture.string(
                                  '''
                                  <svg width="26" height="18" viewBox="0 0 26 18" fill="none" xmlns="http://www.w3.org/2000/svg">
                                  <path d="M25.7129 16.8752C25.7129 17.4964 25.2093 18 24.5881 18H11.0879C10.4667 18 9.96309 17.4964 9.96309 16.8752C9.96309 13.1473 12.9853 10.1251 16.7132 10.1251H18.9634C22.6912 10.1251 25.7134 13.1473 25.7134 16.8752H25.7129ZM17.838 0C15.3526 0 13.3381 2.015 13.3381 4.49987C13.3381 6.98474 15.3531 8.99974 17.838 8.99974C20.3229 8.99974 22.3379 6.98474 22.3379 4.49987C22.3379 2.015 20.3234 0 17.838 0ZM7.7129 0C5.2275 0 3.21303 2.015 3.21303 4.49987C3.21303 6.98474 5.22803 8.99974 7.7129 8.99974C10.1978 8.99974 12.2128 6.98474 12.2128 4.49987C12.2128 2.015 10.1983 0 7.7129 0ZM7.7129 16.8752C7.70973 14.4884 8.6616 12.1992 10.3565 10.519C9.66989 10.2596 8.94162 10.1262 8.20755 10.1251H7.21772C3.76569 10.1314 0.969158 12.928 0.96283 16.38V16.8752C0.96283 17.4964 1.46645 18 2.08766 18H7.9154C7.78462 17.6393 7.71606 17.2585 7.7129 16.8752Z" fill="currentColor"/>
                                  </svg>
                                  ''',
                                  width: 26,
                                  height: 18,
                                  colorFilter: ColorFilter.mode(
                                    isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              if (currentTab == SocialTab.search)
                                SvgPicture.string(
                                  '''
                                  <svg width="6" height="6" viewBox="0 0 6 6" fill="none" xmlns="http://www.w3.org/2000/svg">
                                  <circle cx="3" cy="3" r="3" fill="currentColor"/>
                                  </svg>
                                  ''',
                                  colorFilter: ColorFilter.mode(
                                    isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                    BlendMode.srcIn,
                                  ),
                                ),
                            ],
                          ),
                          label: '',
                        ),
                        const BottomNavigationBarItem(
                          icon: SizedBox(height: 30),
                          label: '',
                        ),
                        BottomNavigationBarItem(
                          icon: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: SvgPicture.string(
                                  '''
                                  <svg width="22" height="24" viewBox="0 0 22 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                  <path fill-rule="evenodd" clip-rule="evenodd" d="M3.30532 19.1999H17.1696C19.3638 19.1999 20.6159 16.9933 19.2997 15.4465C18.717 14.762 18.3581 13.9498 18.2614 13.0982L18.0645 11.3636C17.8587 11.3872 17.6494 11.3996 17.4374 11.3996C14.4552 11.3996 12.0377 8.98207 12.0377 5.99986C12.0377 4.83499 12.4066 3.75617 13.0344 2.87366C13.0102 2.86522 12.986 2.85678 12.9618 2.84834V2.72404C12.9618 1.22 11.7424 0 10.2383 0C8.73427 0 7.51428 1.21943 7.51428 2.72404V2.84834C4.9438 3.72861 3.0404 5.82043 2.75129 8.3701L2.2147 13.0977C2.11795 13.9492 1.7591 14.7609 1.17638 15.446C-0.139801 16.9922 1.11226 19.1993 3.30645 19.1993L3.30532 19.1999ZM21.0372 6.00042C21.0372 7.98875 19.4257 9.60023 17.4374 9.60023C15.449 9.60023 13.8376 7.98875 13.8376 6.00042C13.8376 4.01209 15.449 2.40062 17.4374 2.40062C19.4257 2.40062 21.0372 4.01209 21.0372 6.00042ZM10.2378 24C11.8655 24 13.2554 23.0393 13.8038 21.686C13.8269 21.6298 13.8376 21.569 13.8376 21.5083C13.8376 21.2276 13.6103 21.0004 13.3296 21.0004H7.14643C6.86575 21.0004 6.63852 21.2276 6.63852 21.5083C6.63852 21.569 6.6492 21.6298 6.67226 21.686C7.22123 23.0393 8.61109 24 10.2383 24H10.2378Z" fill="currentColor"/>
                                  </svg>
                                  ''',
                                  width: 24,
                                  height: 26,
                                  colorFilter: ColorFilter.mode(
                                    isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              if (currentTab == SocialTab.notifications)
                                SvgPicture.string(
                                  '''
                                  <svg width="6" height="6" viewBox="0 0 6 6" fill="none" xmlns="http://www.w3.org/2000/svg">
                                  <circle cx="3" cy="3" r="3" fill="currentColor"/>
                                  </svg>
                                  ''',
                                  colorFilter: ColorFilter.mode(
                                    isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                    BlendMode.srcIn,
                                  ),
                                ),
                            ],
                          ),
                          label: '',
                        ),
                        BottomNavigationBarItem(
                          icon: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey.shade200,
                                    image: const DecorationImage(
                                      image: AssetImage('assets/images/profile.jpeg'),
                                      fit: BoxFit.cover,
                                    
                                    ),
                                  ),
                                ),
                              ),
                              if (currentTab == SocialTab.profile)
                                SvgPicture.string(
                                  '''
                                  <svg width="6" height="6" viewBox="0 0 6 6" fill="none" xmlns="http://www.w3.org/2000/svg">
                                  <circle cx="3" cy="3" r="3" fill="currentColor"/>
                                  </svg>
                                  ''',
                                  colorFilter: ColorFilter.mode(
                                    isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                    BlendMode.srcIn,
                                  ),
                                ),
                            ],
                          ),
                          label: '',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Floating action button
          Positioned(
            bottom: kBottomNavigationBarHeight - 24,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                height: 40, // Reduced height for a more compact button
                child: FloatingActionButton(
                  onPressed: () async {
                    // Navigate to create post screen
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreatePostScreen(),
                      ),
                    );
                    
                    // If post was created successfully, refresh the feed
                    if (result == true) {
                      ref.read(currentTabProvider.notifier).state = SocialTab.feed;
                    }
                  },
                  backgroundColor: const Color(0xFF6C3BFB),
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(Icons.add_rounded, size: 28),
                ),
              ),
            ),
          ),
        ],
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