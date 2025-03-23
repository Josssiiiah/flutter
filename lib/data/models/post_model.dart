import 'package:flutter/material.dart';

class Post {
  final String id;
  final String content;
  final String? hashtag;
  final String? imageUrl;
  final User author;
  final DateTime createdAt;
  final int likes;
  final int comments;
  final bool isJoined;

  Post({
    required this.id,
    required this.content, 
    this.hashtag,
    this.imageUrl,
    required this.author,
    required this.createdAt,
    required this.likes,
    required this.comments,
    this.isJoined = false,
  });

  Post copyWith({
    String? id,
    String? content,
    String? hashtag,
    String? imageUrl,
    User? author,
    DateTime? createdAt,
    int? likes,
    int? comments,
    bool? isJoined,
  }) {
    return Post(
      id: id ?? this.id,
      content: content ?? this.content,
      hashtag: hashtag ?? this.hashtag,
      imageUrl: imageUrl ?? this.imageUrl,
      author: author ?? this.author,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      isJoined: isJoined ?? this.isJoined,
    );
  }
}

class User {
  final String id;
  final String username;
  final String? avatarUrl;
  final String? bio;
  
  User({
    required this.id,
    required this.username,
    this.avatarUrl,
    this.bio,
  });
} 