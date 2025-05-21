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
    // In a real app, fetch from an API
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
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Profile header
        _buildProfileHeader(),

        const SizedBox(height: 24),

        // Achievements section
        _buildAchievementsSection(),

        const SizedBox(height: 24),

        // Carbon tracker card
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Carbon Footprint Tracker',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Carbon chart
                const CarbonChart(),

                const Divider(height: 32),

                // Carbon usage form
                const CarbonUsageForm(),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Leaderboard
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
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Eco Enthusiast | Level ${currentUser.level}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.eco, size: 16, color: Theme.of(context).colorScheme.secondary),
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
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: achievements.map((achievement) =>
              AchievementBadge(achievement: achievement)
          ).toList(),
        ),
      ],
    );
  }

  // Sample data generators
  User getSampleCurrentUser() {
    return User(
      id: 1,
      username: 'davidchen',
      displayName: 'David Chen',
      avatarUrl: 'https://images.unsplash.com/photo-1568602471122-7832951cc4c5',
      level: 8,
      carbonSaved: 4200,
    );
  }

  List<UserAchievement> getSampleAchievements() {
    return [
      UserAchievement(
        id: 1,
        userId: 1,
        achievement: Achievement(
          id: 1,
          name: 'EV Adopter',
          description: 'Switch to an electric vehicle',
          icon: Icons.electric_car,
          requiredValue: 1,
        ),
        progress: 1,
        isCompleted: true,
        completedAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      UserAchievement(
        id: 2,
        userId: 1,
        achievement: Achievement(
          id: 2,
          name: 'Cycle Commuter',
          description: 'Commute by bicycle 5 times',
          icon: Icons.directions_bike,
          requiredValue: 5,
        ),
        progress: 5,
        isCompleted: true,
        completedAt: DateTime.now().subtract(const Duration(days: 14)),
      ),
      UserAchievement(
        id: 3,
        userId: 1,
        achievement: Achievement(
          id: 3,
          name: '7-Day Streak',
          description: 'Log carbon usage for 7 consecutive days',
          icon: Icons.verified,
          requiredValue: 7,
        ),
        progress: 7,
        isCompleted: true,
        completedAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      UserAchievement(
        id: 4,
        userId: 1,
        achievement: Achievement(
          id: 4,
          name: 'Plant 10 Trees',
          description: 'Plant or donate to plant 10 trees',
          icon: Icons.spa,
          requiredValue: 10,
        ),
        progress: 1,
        isCompleted: false,
      ),
    ];
  }
}