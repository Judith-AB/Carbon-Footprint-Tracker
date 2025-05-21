// lib/models/post.dart
import 'user.dart';

class Post {
  final int id;
  final User user;
  final String imageUrl;
  final String caption;
  final String? impactType;
  final int likes;
  final DateTime createdAt;
  final int comments;
  final bool isLiked;

  Post({
    required this.id,
    required this.user,
    required this.imageUrl,
    required this.caption,
    this.impactType,
    required this.likes,
    required this.createdAt,
    required this.comments,
    this.isLiked = false,
  });
}