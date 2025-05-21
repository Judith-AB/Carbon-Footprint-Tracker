// lib/widgets/achievement_badge.dart
import 'package:flutter/material.dart';
import '../models/user_achievement.dart';

class AchievementBadge extends StatelessWidget {
  final UserAchievement achievement;

  const AchievementBadge({
    Key? key,
    required this.achievement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCompleted = achievement.isCompleted;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCompleted
              ? Theme.of(context).colorScheme.secondary
              : Colors.grey.shade300,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            achievement.achievement.icon,
            size: 18,
            color: isCompleted
                ? Theme.of(context).colorScheme.secondary
                : Colors.grey.shade400,
          ),
          const SizedBox(width: 8),
          Text(
            isCompleted
                ? achievement.achievement.name
                : '${achievement.achievement.name} (${achievement.progress}/${achievement.achievement.requiredValue})',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isCompleted
                  ? Colors.black87
                  : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}