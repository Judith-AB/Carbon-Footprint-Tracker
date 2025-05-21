// lib/models/user.dart
class User {
  final int id;
  final String username;
  final String displayName;
  final String avatarUrl;
  final int level;
  final int carbonSaved;

  User({
    required this.id,
    required this.username,
    required this.displayName,
    required this.avatarUrl,
    required this.level,
    required this.carbonSaved,
  });
}