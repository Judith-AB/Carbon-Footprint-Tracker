// lib/models/auth_user.dart
class AuthUser {
  final int id;
  final String username;
  final String email;
  final String? displayName;
  final String? avatarUrl;

  AuthUser({
    required this.id,
    required this.username,
    required this.email,
    this.displayName,
    this.avatarUrl,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      displayName: json['displayName'] ?? json['username'],
      avatarUrl: json['avatarUrl'],
    );
  }
}