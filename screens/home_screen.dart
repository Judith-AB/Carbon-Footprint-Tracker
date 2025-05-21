// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/post_service.dart';
import '../services/auth_service.dart';
import '../models/user.dart';
import '../widgets/post_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<User> stories;
  bool isLoadingStories = true;

  @override
  void initState() {
    super.initState();
    _loadStories();
  }

  Future<void> _loadStories() async {
    // In a real app, fetch from an API
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      stories = getSampleUsers();
      isLoadingStories = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final postService = Provider.of<PostService>(context);

    return RefreshIndicator(
      onRefresh: () async {
        // Refresh posts logic would go here
      },
      child: CustomScrollView(
        slivers: [
          // Stories section
          SliverToBoxAdapter(
            child: isLoadingStories
                ? const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            )
                : Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: stories.length,
                  itemBuilder: (context, index) => _buildStoryAvatar(stories[index]),
                ),
              ),
            ),
          ),

          // Posts section
          postService.posts.isEmpty
              ? const SliverFillRemaining(
            child: Center(
              child: Text('No posts yet. Create your first post!'),
            ),
          )
              : SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: PostCard(post: postService.posts[index]),
                );
              },
              childCount: postService.posts.length,
            ),
          ),
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
}