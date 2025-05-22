import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/post_service.dart';
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
        // Refresh posts logic
      },
      child: CustomScrollView(
        slivers: [
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
                        itemBuilder: (context, index) =>
                            _buildStoryAvatar(stories[index]),
                      ),
                    ),
                  ),
          ),
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

  List<User> getSampleUsers() {
    return [
      User(
        id: 1,
        username: 'aditi_s',
        displayName: 'Aditi S',
        avatarUrl: 'https://cdn-icons-png.flaticon.com/512/921/921085.png',
        level: 8,
        carbonSaved: 4200,
      ),
      User(
        id: 2,
        username: 'varshenee_r',
        displayName: 'Varshenee',
        avatarUrl: 'https://cdn-icons-png.flaticon.com/512/921/921086.png',
        level: 10,
        carbonSaved: 2100,
      ),
      User(
        id: 3,
        username: 'ridu_v',
        displayName: 'Riduvarshini',
        avatarUrl: 'https://cdn-icons-png.flaticon.com/512/921/921087.png',
        level: 9,
        carbonSaved: 1800,
      ),
      User(
        id: 4,
        username: 'judith_m',
        displayName: 'Judith',
        avatarUrl: 'https://cdn-icons-png.flaticon.com/512/921/921088.png',
        level: 7,
        carbonSaved: 1600,
      ),
      User(
        id: 5,
        username: 'meghana_k',
        displayName: 'Meghana',
        avatarUrl: 'https://cdn-icons-png.flaticon.com/512/921/921089.png',
        level: 6,
        carbonSaved: 1200,
      ),
    ];
  }
}
