import 'package:flutter/material.dart';
import 'package:flutter_fullstack/data/models/post_model.dart';
import 'package:flutter_fullstack/core/theme/app_theme.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback? onJoin;
  final VoidCallback? onUserTap;

  const PostCard({
    Key? key,
    required this.post,
    required this.onLike,
    required this.onComment,
    this.onJoin,
    this.onUserTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM d');
    final timeFormat = DateFormat('h:mm a');
    final formattedDate = dateFormat.format(post.createdAt);
    final formattedTime = timeFormat.format(post.createdAt);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Profile picture
                GestureDetector(
                  onTap: onUserTap,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.15),
                      child: Text(
                        post.author.username.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Username, bio, and date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.author.username,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (post.author.bio != null)
                        Text(
                          post.author.bio!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        '$formattedDate at $formattedTime',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Join button
                if (!post.isJoined && onJoin != null)
                  ElevatedButton(
                    onPressed: onJoin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      foregroundColor: theme.colorScheme.primary,
                      elevation: 0,
                      textStyle: theme.textTheme.labelLarge,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Join'),
                  )
                else if (post.isJoined)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Joined',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          // Post content
          if (post.imageUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  post.imageUrl!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: theme.colorScheme.primary,
                          size: 48,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          // Post text content
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Post text content with hashtag highlighted
                if (post.content.isNotEmpty)
                  _buildRichTextContent(context, post.content, post.hashtag),
                const SizedBox(height: 20),
                // Actions row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Action buttons row
                    Row(
                      children: [
                        // Share button
                        _buildActionButton(
                          icon: Icons.send_outlined,
                          label: '',
                          onTap: () {},
                          theme: theme,
                        ),
                        const SizedBox(width: 20),
                        // Comment button
                        _buildActionButton(
                          icon: Icons.chat_bubble_outline_rounded,
                          label: post.comments.toString(),
                          onTap: onComment,
                          theme: theme,
                        ),
                        const SizedBox(width: 20),
                        // Like button
                        _buildActionButton(
                          icon: Icons.favorite_outline_rounded,
                          label: post.likes.toString(),
                          onTap: onLike,
                          theme: theme,
                        ),
                      ],
                    ),
                    // Coffee button
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.local_cafe_outlined,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        size: 22,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRichTextContent(BuildContext context, String content, String? hashtag) {
    if (hashtag == null || !content.contains('#$hashtag')) {
      return Text(
        content,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          height: 1.4,
          fontSize: 16,
        ),
      );
    }

    final theme = Theme.of(context);
    final parts = content.split('#$hashtag');
    
    return RichText(
      text: TextSpan(
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurface,
          height: 1.4,
          fontSize: 16,
        ),
        children: [
          TextSpan(text: parts[0]),
          TextSpan(
            text: '#$hashtag',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (parts.length > 1) TextSpan(text: parts[1]),
        ],
      ),
    );
  }
} 