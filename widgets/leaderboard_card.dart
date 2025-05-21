// lib/widgets/leaderboard_card.dart
import 'package:flutter/material.dart';
import '../models/user.dart';

class LeaderboardCard extends StatelessWidget {
  const LeaderboardCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample data - in a real app, this would come from API
    final leaderboardUsers = [
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
    ];

    // Current user (assume user 1)
    const currentUserId = 1;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Carbon Leaderboard',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...leaderboardUsers.asMap().entries.map((entry) {
              final index = entry.key;
              final user = entry.value;
              final isCurrentUser = user.id == currentUserId;

              return Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: index < leaderboardUsers.length - 1
                      ? Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade200,
                    ),
                  )
                      : null,
                  color: isCurrentUser ? Colors.green.shade50 : null,
                  borderRadius: isCurrentUser ? BorderRadius.circular(8) : null,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 12),
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.avatarUrl),
                      radius: 20,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.displayName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${(user.carbonSaved / 1000).toStringAsFixed(1)} tons CO₂ saved',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Icon(
                      index == 0 ? Icons.emoji_events : Icons.person,
                      color: index == 0 ? Colors.amber : Colors.grey.shade400,
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}