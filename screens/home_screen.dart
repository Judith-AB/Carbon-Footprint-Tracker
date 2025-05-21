// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/post_card.dart';
import '../../models/post.dart';
import '../../models/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Post> posts;
  late List<User> stories;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // In a real app, fetch from an API
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      stories = getSampleUsers();
      posts = getSamplePosts();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // Stories section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: stories.map((user) => _buildStoryAvatar(user)).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Posts section
          ...posts.map((post) => PostCard(post: post)),
        ],
      ),
    );
  }

  Widget _buildStoryAvatar(User user) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: CircleAvatar(
              radius: 32,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(user.avatarUrl),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.displayName.split(' ')[0],
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  // Sample data generators
  List<User> getSampleUsers() {
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

  List<Post> getSamplePosts() {
    final users = getSampleUsers();

    return [
      Post(
        id: 1,
        user: users.firstWhere((u) => u.id == 5),
        imageUrl: 'https://images.unsplash.com/photo-1541625602330-2277a4c46182',
        caption: "Starting my day with a bike ride to work instead of driving! 🚲 Already saved 4.2kg of CO2 this week with my new commuting habit. #SustainableCommute #GreenLife",
        impactType: 'Reduced car usage',
        likes: 124,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        comments: 2,
      ),
      Post(
        id: 2,
        user: users.firstWhere((u) => u.id == 3),
        imageUrl: 'https://images.unsplash.com/photo-1560448205-4d9b3e6bb6db',
        caption: "Took the plunge and finally got my EV! No more gas stations for me. According to the app, I'll save about 2 tons of CO2 per year compared to my old car. #ElectricRevolution #ZeroEmissions",
        impactType: 'EV Adoption',
        likes: 256,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        comments: 2,
      ),
      Post(
        id: 3,
        user: users.firstWhere((u) => u.id == 4),
        imageUrl: 'https://images.unsplash.com/photo-1625246333195-78d9c38ad449',
        caption: "Weekend well spent at our neighborhood community garden! Growing our own food reduces carbon footprint from food transportation and packaging. Plus, the community vibes are amazing! #LocalFood #CommunityGarden",
        impactType: 'Sustainable food choice',
        likes: 89,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        comments: 1,
      ),
    ];
  }
}