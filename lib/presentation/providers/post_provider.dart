import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_fullstack/data/models/post_model.dart';
import 'package:flutter_fullstack/data/repositories/post_repository.dart';

// Provider for the PostRepository
final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository();
});

// State for the post provider
class PostState {
  final List<Post> posts;
  final bool isLoading;
  final String? errorMessage;

  PostState({
    this.posts = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  PostState copyWith({
    List<Post>? posts,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PostState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

// Notifier for managing post state
class PostNotifier extends StateNotifier<PostState> {
  final PostRepository _repository;

  PostNotifier(this._repository) : super(PostState()) {
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final posts = await _repository.getPosts();
      state = state.copyWith(posts: posts, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load posts: $e',
      );
    }
  }

  Future<void> addPost(Post post) async {
    try {
      await _repository.addPost(post);
      await fetchPosts();
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to create post: $e',
      );
      throw e;
    }
  }

  Future<void> likePost(String postId) async {
    try {
      await _repository.likePost(postId);
      
      // Update UI immediately (optimistic update)
      final updatedPosts = state.posts.map((post) {
        if (post.id == postId) {
          return post.copyWith(likes: post.likes + 1);
        }
        return post;
      }).toList();
      
      state = state.copyWith(posts: updatedPosts);
    } catch (e) {
      // In case of error, refresh the posts
      fetchPosts();
    }
  }

  Future<void> joinUser(String userId) async {
    try {
      await _repository.joinUser(userId);
      
      // Update UI immediately (optimistic update)
      final updatedPosts = state.posts.map((post) {
        if (post.author.id == userId) {
          return post.copyWith(isJoined: true);
        }
        return post;
      }).toList();
      
      state = state.copyWith(posts: updatedPosts);
    } catch (e) {
      // In case of error, refresh the posts
      fetchPosts();
    }
  }
}

// Provider for posts
final postProvider = StateNotifierProvider<PostNotifier, PostState>((ref) {
  final repository = ref.watch(postRepositoryProvider);
  return PostNotifier(repository);
}); 