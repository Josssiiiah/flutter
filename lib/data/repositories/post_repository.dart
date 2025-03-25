import 'package:flutter_fullstack/data/models/post_model.dart';

class PostRepository {
  // Mock data for posts
  List<Post> getMockPosts() {
    return [
      Post(
        id: '1',
        content: "Me: 'I'm going to bed #earlytonight.' Also me at 3 AM: watching a raccoon wash grapes in slow motion",
        hashtag: 'earlytonight',
        imageUrl: 'image1',
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
        content: "Design inspiration strikes at midnight #figmadesign",
        imageUrl: 'figma2',
        hashtag: 'figmadesign',
        author: User(
          id: '2',
          username: 'design_ninja',
          bio: 'Creating pixels of joy',
        ),
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        likes: 24,
        comments: 3,
        isJoined: false,
      ),
      Post(
        id: '3',
        content: "Just wrapped up another beautiful interface #uidesign",
        imageUrl: 'figma3',
        hashtag: 'uidesign',
        author: User(
          id: '3',
          username: 'ui_wizard',
          bio: 'Making the web beautiful',
        ),
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        likes: 31,
        comments: 5,
        isJoined: false,
      ),
      Post(
        id: '4',
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
        id: '5',
        content: "Every time I drink water, I'm like, wow, I'm really out here keeping myself alive. Incredible.",
        hashtag: 'skateboarding',
        imageUrl: 'figma1',
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
      Post(
        id: '6',
        content: "Throwing up on the haters",
        hashtag: 'skateboarding',
        imageUrl: 'image2',
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

  // In-memory storage for posts
  final List<Post> _posts = [];

  Future<List<Post>> getPosts() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    if (_posts.isEmpty) {
      _posts.addAll(getMockPosts());
    }
    return _posts;
  }

  Future<void> addPost(Post post) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    _posts.insert(0, post);
  }

  Future<void> likePost(String postId) async {
    // In a real app, this would call an API
    await Future.delayed(const Duration(milliseconds: 300));
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final post = _posts[postIndex];
      _posts[postIndex] = post.copyWith(likes: post.likes + 1);
    }
  }

  Future<void> joinUser(String userId) async {
    // In a real app, this would call an API
    await Future.delayed(const Duration(milliseconds: 300));
    for (var i = 0; i < _posts.length; i++) {
      if (_posts[i].author.id == userId) {
        _posts[i] = _posts[i].copyWith(isJoined: true);
      }
    }
  }
} 