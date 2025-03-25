import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_fullstack/data/models/post_model.dart';
import 'package:flutter_fullstack/presentation/providers/post_provider.dart';
import 'package:flutter_fullstack/presentation/providers/auth_provider.dart';
import 'package:flutter_fullstack/core/theme/app_theme.dart';
import 'package:uuid/uuid.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _contentController = TextEditingController();
  final _hashtagController = TextEditingController();
  String? _imageUrl;
  bool _isLoading = false;

  @override
  void dispose() {
    _contentController.dispose();
    _hashtagController.dispose();
    super.dispose();
  }

  void _submitPost() async {
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter some content')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final hashtag = _hashtagController.text.trim().isEmpty
        ? null
        : _hashtagController.text.trim();

    try {
      final user = ref.read(userProvider);
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final post = Post(
        id: const Uuid().v4(),
        content: content,
        hashtag: hashtag,
        imageUrl: _imageUrl,
        author: User(
          id: user.id,
          username: user.name,
          bio: null,
        ),
        createdAt: DateTime.now(),
        likes: 0,
        comments: 0,
      );

      await ref.read(postProvider.notifier).addPost(post);

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating post: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Post',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _isLoading
                ? Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  )
                : TextButton(
                    onPressed: _submitPost,
                    style: TextButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Post'),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author info
            Consumer(
              builder: (context, ref, child) {
                final user = ref.watch(userProvider);
                if (user == null) return const SizedBox.shrink();

                return Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                      child: Text(
                        user.name[0].toUpperCase(),
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            // Content field
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                hintText: 'What\'s on your mind?',
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
                border: InputBorder.none,
              ),
              style: theme.textTheme.bodyLarge,
              maxLines: 8,
              minLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            // Hashtag field
            TextField(
              controller: _hashtagController,
              decoration: InputDecoration(
                hintText: 'Add hashtag (optional)',
                prefixText: '#',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.5),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.5),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Image URL field (simplified, in a real app would use an image picker)
            TextField(
              decoration: InputDecoration(
                hintText: 'Image URL (optional)',
                prefixIcon: const Icon(Icons.image_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.5),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.5),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _imageUrl = value.trim().isEmpty ? null : value.trim();
                });
              },
            ),
            const SizedBox(height: 24),
            if (_imageUrl != null && _imageUrl!.isNotEmpty)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    _imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: theme.colorScheme.error,
                              size: 48,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Invalid Image URL',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.error,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 