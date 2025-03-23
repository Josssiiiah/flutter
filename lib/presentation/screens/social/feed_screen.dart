import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_fullstack/data/models/post_model.dart';
import 'package:flutter_fullstack/presentation/providers/post_provider.dart';
import 'package:flutter_fullstack/presentation/widgets/post_card.dart';
import 'package:flutter_fullstack/presentation/providers/theme_provider.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postState = ref.watch(postProvider);
    final isDarkMode = ref.watch(isDarkModeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        titleSpacing: 20,
        title: Text(
          'SPILL',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: false,
        actions: [
          // Theme toggle button
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(
                isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                color: isDarkMode ? Colors.amber.shade300 : Colors.blueGrey.shade800,
              ),
              onPressed: () => ref.read(themeModeProvider.notifier).toggleTheme(),
              style: IconButton.styleFrom(
                backgroundColor: isDarkMode 
                    ? Colors.amber.shade200.withOpacity(0.2) 
                    : Colors.blueGrey.shade100.withOpacity(0.3),
                padding: const EdgeInsets.all(12),
              ),
            ),
          ),
          // Search button
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () {
                // Handle search action
              },
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                padding: const EdgeInsets.all(12),
              ),
            ),
          ),
        ],
      ),
      body: _buildBody(context, ref, postState),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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