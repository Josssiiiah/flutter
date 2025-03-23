import 'package:flutter_fullstack/data/models/post_model.dart';

class PostRepository {
  // Mock data for posts
  List<Post> getMockPosts() {
    return [
      Post(
        id: '1',
        content: "Me: 'I'm going to bed #earlytonight.' Also me at 3 AM: watching a raccoon wash grapes in slow motion",
        hashtag: 'earlytonight',
        imageUrl: 'https://picsum.photos/id/237/500/500',
        author: User(
          id: '1',
          username: 'wanderlust_gypsy',
          bio: 'All we do is skaaaate',
        ),
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        likes: 16,
        comments: 0,
        isJoined: true,
      ),
      Post(
        id: '2',
        content: "Sometimes it just makes more sense to just rest.",
        author: User(
          id: '1',
          username: 'wanderlust_gypsy',
          bio: 'All we do is skaaaate',
        ),
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        likes: 16,
        comments: 0,
        isJoined: false,
      ),
      Post(
        id: '3',
        content: "Just learned a new trick on my board!",
        hashtag: 'skateboarding',
        imageUrl: 'https://picsum.photos/id/1025/500/500',
        author: User(
          id: '3',
          username: 'artistic_incline',
          bio: 'Not Today Baby',
        ),
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        likes: 42,
        comments: 7,
        isJoined: false,
      ),
    ];
  }

  Future<List<Post>> getPosts() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    return getMockPosts();
  }

  Future<void> likePost(String postId) async {
    // In a real app, this would call an API
    await Future.delayed(const Duration(milliseconds: 300));
    return;
  }

  Future<void> joinUser(String userId) async {
    // In a real app, this would call an API
    await Future.delayed(const Duration(milliseconds: 300));
    return;
  }
} 