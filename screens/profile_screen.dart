// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/carbon_chart.dart';
import '../../widgets/carbon_usage_form.dart';
import '../../widgets/achievement_badge.dart';
import '../../widgets/leaderboard_card.dart';
import '../../models/user.dart';
import '../../models/achievement.dart';
import '../../models/user_achievement.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User currentUser;
  late List<UserAchievement> achievements;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      currentUser = getSampleCurrentUser();
      achievements = getSampleAchievements();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildProfileHeader(),
        const SizedBox(height: 24),
        _buildAchievementsSection(),
        const SizedBox(height: 24),
        _buildCarbonTrackerCard(),
        const SizedBox(height: 24),
        const LeaderboardCard(),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(currentUser.avatarUrl),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentUser.displayName,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                'Eco Enthusiast | Level ${currentUser.level}',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.eco,
                      size: 16, color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(width: 4),
                  Text(
                    '${(currentUser.carbonSaved / 1000).toStringAsFixed(1)} tons CO₂ saved this year',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Achievements',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: achievements
              .map((ua) => AchievementBadge(achievement: ua))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildCarbonTrackerCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Carbon Footprint Tracker',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            CarbonChart(),
            Divider(height: 32),
            CarbonUsageForm(),
          ],
        ),
      ),
    );
  }

  // Sample Data ---------------------------------------

  User getSampleCurrentUser() {
    List<User> sampleUsers = [
      User(
        id: 1,
        username: 'Aditi',
        displayName: 'Aditi ',
        avatarUrl:
            'https://www.freepik.com/free-vector/young-woman-with-braided-hair_370755283.htm#fromView=keyword&page=1&position=8&uuid=7abfd9a5-e0da-4d95-8719-5bb92dbef70d&query=Young+Girl+Avatar',
        level: 8,
        carbonSaved: 4200,
      ),
      User(
        id: 2,
        username: 'Varshenee',
        displayName: 'Varshenee ',
        avatarUrl:
            'https://cdn-icons-png.flaticon.com/512/921/921087.png',

        level: 10,
        carbonSaved: 5600,
      ),
      User(
        id: 3,
        username: 'Riduvarshini',
        displayName: 'Riduvarshini ',
        avatarUrl:
            'https://cdn-icons-png.flaticon.com/512/921/921087.png',
        level: 6,
        carbonSaved: 3100,
      ),
      User(
        id: 4,
        username: 'Judith',
        displayName: 'Judith ',
        avatarUrl:
            'https://cdn-icons-png.flaticon.com/512/921/921087.png',
        level: 9,
        carbonSaved: 4800,
      ),
    ];

    sampleUsers.shuffle(); // Pick a random user
    return sampleUsers.first;
  }

  List<UserAchievement> getSampleAchievements() {
    List<Achievement> baseAchievements = [
      Achievement(
        id: 1,
        name: 'First Step',
        description: 'Logged your first carbon footprint!',
        icon: Icons.directions_walk,
        requiredValue: 1,
      ),
      Achievement(
        id: 2,
        name: 'Eco Warrior',
        description: 'Saved over 1 ton of CO₂!',
        icon: Icons.eco,
        requiredValue: 1000,
      ),
      Achievement(
        id: 3,
        name: 'Leaderboard Star',
        description: 'Reached top 10 in the leaderboard!',
        icon: Icons.emoji_events,
        requiredValue: 10,
      ),
    ];

    return [
      UserAchievement(
        id: 1,
        userId: 1,
        achievement: baseAchievements[0],
        progress: 1,
        isCompleted: true,
        completedAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      UserAchievement(
        id: 2,
        userId: 1,
        achievement: baseAchievements[1],
        progress: 1500,
        isCompleted: true,
        completedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      UserAchievement(
        id: 3,
        userId: 1,
        achievement: baseAchievements[2],
        progress: 6,
        isCompleted: false,
        completedAt: null,
      ),
    ];
  }
}
