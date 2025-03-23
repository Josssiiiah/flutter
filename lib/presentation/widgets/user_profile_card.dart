import 'package:flutter/material.dart';
import 'package:flutter_fullstack/data/models/post_model.dart';

class UserProfileCard extends StatelessWidget {
  final User user;
  final bool isFollowing;
  final VoidCallback? onFollowTap;
  final VoidCallback? onUserTap;

  const UserProfileCard({
    Key? key,
    required this.user,
    this.isFollowing = false,
    this.onFollowTap,
    this.onUserTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Profile picture
            GestureDetector(
              onTap: onUserTap,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                child: Text(
                  user.username.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Username and bio
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.username,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (user.bio != null)
                    Text(
                      user.bio!,
                      style: theme.textTheme.bodySmall,
                    ),
                ],
              ),
            ),
            // Follow button
            if (!isFollowing && onFollowTap != null)
              ElevatedButton(
                onPressed: onFollowTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  elevation: 0,
                  textStyle: theme.textTheme.labelLarge,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                child: const Text('Following'),
              )
            else if (isFollowing)
              OutlinedButton(
                onPressed: onFollowTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  side: BorderSide(color: theme.colorScheme.primary),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                child: const Text('Following'),
              ),
          ],
        ),
      ),
    );
  }
} 