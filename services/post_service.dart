// lib/services/post_service.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/post.dart';
import '../models/user.dart';
import 'auth_service.dart';

class PostService extends ChangeNotifier {
  final AuthService _authService;
  final List<Post> _posts = [];

  File? _selectedImage;
  bool _isLoading = false;

  PostService(this._authService) {
    _loadInitialPosts();
  }

  List<Post> get posts => _posts;
  File? get selectedImage => _selectedImage;
  bool get isLoading => _isLoading;

  // Load initial sample posts
  Future<void> _loadInitialPosts() async {
    await Future.delayed(const Duration(seconds: 1));

    final sampleUsers = _getSampleUsers();

    final initialPosts = [
      Post(
        id: 1,
        user: sampleUsers.firstWhere((u) => u.id == 5),
        imageUrl: 'https://images.unsplash.com/photo-1541625602330-2277a4c46182',
        caption: "Starting my day with a bike ride to work instead of driving! 🚲 Already saved 4.2kg of CO2 this week with my new commuting habit. #SustainableCommute #GreenLife",
        impactType: 'Reduced car usage',
        likes: 124,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        comments: 2,
      ),
      Post(
        id: 2,
        user: sampleUsers.firstWhere((u) => u.id == 3),
        imageUrl: 'https://images.unsplash.com/photo-1560448205-4d9b3e6bb6db',
        caption: "Took the plunge and finally got my EV! No more gas stations for me. According to the app, I'll save about 2 tons of CO2 per year compared to my old car. #ElectricRevolution #ZeroEmissions",
        impactType: 'EV Adoption',
        likes: 256,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        comments: 2,
      ),
      Post(
        id: 3,
        user: sampleUsers.firstWhere((u) => u.id == 4),
        imageUrl: 'https://images.unsplash.com/photo-1625246333195-78d9c38ad449',
        caption: "Weekend well spent at our neighborhood community garden! Growing our own food reduces carbon footprint from food transportation and packaging. Plus, the community vibes are amazing! #LocalFood #CommunityGarden",
        impactType: 'Sustainable food choice',
        likes: 89,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        comments: 1,
      ),
    ];

    _posts.addAll(initialPosts);
    notifyListeners();
  }

  // Pick image from gallery
  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        _selectedImage = File(pickedImage.path);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  // Create a new post
  Future<bool> createPost(String caption, String impactType) async {
    if (_authService.currentUser == null || _selectedImage == null) {
      return false;
    }

    try {
      _isLoading = true;
      notifyListeners();

      // Simulate uploading image to server
      await Future.delayed(const Duration(seconds: 1));

      // In a real app, you would upload the image to storage and get a URL
      // For now, we'll use the file path as the "URL" for display purposes
      String imageUrl = _selectedImage!.path;

      // Create new post
      final newPost = Post(
        id: _posts.length + 1,
        user: User(
          id: _authService.currentUser!.id,
          username: _authService.currentUser!.username,
          displayName: _authService.currentUser!.displayName ?? _authService.currentUser!.username,
          avatarUrl: _authService.currentUser!.avatarUrl ?? 'https://images.unsplash.com/photo-1568602471122-7832951cc4c5',
          level: 1,
          carbonSaved: 0,
        ),
        imageUrl: imageUrl,
        caption: caption,
        impactType: impactType == 'Select impact type' ? null : impactType,
        likes: 0,
        createdAt: DateTime.now(),
        comments: 0,
      );

      // Add to beginning of posts list
      _posts.insert(0, newPost);

      // Reset selected image
      _selectedImage = null;
      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Like/unlike a post
  void toggleLike(int postId) {
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      _posts[index].isLiked = !_posts[index].isLiked;
      _posts[index].isLiked ? _posts[index].likes++ : _posts[index].likes--;
      notifyListeners();
    }
  }

  // Clear selected image
  void clearSelectedImage() {
    _selectedImage = null;
    notifyListeners();
  }

  // Helper method to get sample users
  List<User> _getSampleUsers() {
    return [
      User(
        id: 1,
        username: 'davidchen',
        displayName: 'David Chen',
        avatarUrl: 'https://images.unsplash.com/photo-1568602471122-7832951cc4c5',
        level: 8,
        carbonSaved: 4200,
      ),
      User(
        id: 2,
        username: 'sarah_peterson',
        displayName: 'Sarah Peterson',
        avatarUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
        level: 10,
        carbonSaved: 2100,
      ),
      User(
        id: 3,
        username: 'michael_rodriguez',
        displayName: 'Michael Rodriguez',
        avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
        level: 9,
        carbonSaved: 1800,
      ),
      User(
        id: 4,
        username: 'emily_jackson',
        displayName: 'Emily Jackson',
        avatarUrl: 'https://images.unsplash.com/photo-1544717305-2782549b5136',
        level: 7,
        carbonSaved: 1600,
      ),
      User(
        id: 5,
        username: 'jessica_martinez',
        displayName: 'Jessica Martinez',
        avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
        level: 6,
        carbonSaved: 1200,
      ),
    ];
  }
}