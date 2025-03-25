import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_fullstack/data/models/post_model.dart';
import 'package:flutter_fullstack/presentation/providers/post_provider.dart';
import 'package:flutter_fullstack/presentation/widgets/post_card.dart';
import 'package:flutter_fullstack/presentation/providers/theme_provider.dart';
import 'package:flutter_fullstack/presentation/widgets/spill_logo.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postState = ref.watch(postProvider);
    final isDarkMode = ref.watch(isDarkModeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? const RadialGradient(
                  center: Alignment(0.7, -1.25),
                  radius: 2,
                  colors: [
                    Color(0xff976658),
                    Color(0xff2f2768),
                    Color(0xff14161d),
                  ],
                  stops: [0.0, 0.3, 0.45],
                )
              : const RadialGradient(
                  center: Alignment(0.7, -1.5),
                  radius: 2,
                  colors: [
                    Color(0xffFFA07A), // Light salmon
                    // Color(0xff6495ED), // Cornflower blue
                    Color(0xffE6E6FA), // Lavender
                  ],
                  stops: [0.0, 0.45],
                ),
        ),
        child: Column(
          children: [
            PreferredSize(
              preferredSize: const Size.fromHeight(120),
              child: AppBar(
                toolbarHeight: 120,
                titleSpacing: 20,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: SpillLogo(
                    width: 88,
                    height: 24,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                centerTitle: false,
                actions: [
                  // Theme toggle button
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, top: 20.0),
                    child: IconButton(
                      icon: Icon(
                        isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      onPressed: () => ref.read(themeModeProvider.notifier).toggleTheme(),
                      style: IconButton.styleFrom(
                        backgroundColor: (isDarkMode ? Colors.white : Colors.black).withOpacity(0.1),
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                  ),
                  // Search button
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0, top: 20.0),
                    child: IconButton(
                      icon: Icon(Icons.search_rounded, color: isDarkMode ? Colors.white : Colors.black),
                      onPressed: () {
                        // Handle search action
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: (isDarkMode ? Colors.white : Colors.black).withOpacity(0.1),
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _buildBody(context, ref, postState),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, PostState postState) {
    final theme = Theme.of(context);
    
    if (postState.isLoading && postState.posts.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.primary,
        ),
      );
    }

    if (postState.errorMessage != null && postState.posts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 60,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Oops! Something went wrong',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                postState.errorMessage!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => ref.read(postProvider.notifier).fetchPosts(),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(postProvider.notifier).fetchPosts(),
      color: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.surface,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        itemCount: postState.posts.length,
        itemBuilder: (context, index) {
          final post = postState.posts[index];
          return PostCard(
            post: post,
            onLike: () => ref.read(postProvider.notifier).likePost(post.id),
            onComment: () {
              // Handle comment action
            },
            onJoin: post.isJoined
                ? null
                : () => ref.read(postProvider.notifier).joinUser(post.author.id),
            onUserTap: () {
              // Handle user profile navigation
            },
          );
        },
      ),
    );
  }
} 