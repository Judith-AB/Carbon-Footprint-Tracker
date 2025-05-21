// lib/models/user_achievement.dart
import 'achievement.dart';

class UserAchievement {
  final int id;
  final int userId;
  final Achievement achievement;
  final int progress;
  final bool isCompleted;
  final DateTime? completedAt;

  UserAchievement({
    required this.id,
    required this.userId,
    required this.achievement,
    required this.progress,
    required this.isCompleted,
    this.completedAt,
  });
}