// lib/services/auth_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_user.dart';

class AuthService extends ChangeNotifier {
  AuthUser? _currentUser;
  bool _keepSignedIn = false;
  bool _isLoading = false;

  AuthUser? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get keepSignedIn => _keepSignedIn;
  bool get isLoading => _isLoading;

  AuthService() {
    // Check for saved user on init
    _loadSavedUser();
  }

  // Sign in method
  Future<bool> signIn(String username, String password, bool keepSignedIn) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulate API request
      await Future.delayed(const Duration(seconds: 1));

      // In a real app, you would make an API call here
      // For demo purposes, we'll accept any non-empty credentials
      if (username.isNotEmpty && password.isNotEmpty) {
        // Create a mock user
        final user = AuthUser(
          id: 1,
          username: username,
          email: '$username@example.com',
          displayName: 'David Chen',
          avatarUrl: 'https://images.unsplash.com/photo-1568602471122-7832951cc4c5',
        );

        _currentUser = user;
        _keepSignedIn = keepSignedIn;

        // Save if "keep me signed in" is selected
        if (keepSignedIn) {
          await _saveUserToPrefs(user);
        }

        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign up method
  Future<bool> signUp(String username, String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulate API request
      await Future.delayed(const Duration(seconds: 1));

      // In a real app, you would make an API call to create a user
      // For demo purposes, we'll accept any valid input
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          email.contains('@') &&
          password.isNotEmpty &&
          password.length >= 6) {

        // Create a new user
        final user = AuthUser(
          id: 1,
          username: username,
          email: email,
          displayName: username,
        );

        _currentUser = user;

        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Change password method
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulate API request
      await Future.delayed(const Duration(seconds: 1));

      // In a real app, you would validate current password and update to new password
      if (currentPassword.isNotEmpty &&
          newPassword.isNotEmpty &&
          newPassword.length >= 6) {

        // Password change successful
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign out method
  Future<void> signOut() async {
    _currentUser = null;

    // Clear saved user data
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    await prefs.remove('keepSignedIn');

    notifyListeners();
  }

  // Load saved user on app start
  Future<void> _loadSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final keepSignedIn = prefs.getBool('keepSignedIn') ?? false;

    if (keepSignedIn) {
      final userData = prefs.getString('user');
      if (userData != null) {
        final userMap = jsonDecode(userData);
        _currentUser = AuthUser.fromJson(userMap);
        _keepSignedIn = true;
        notifyListeners();
      }
    }
  }

  // Save user to shared preferences
  Future<void> _saveUserToPrefs(AuthUser user) async {
    final prefs = await SharedPreferences.getInstance();

    // Convert user to JSON
    final userJson = {
      'id': user.id,
      'username': user.username,
      'email': user.email,
      'displayName': user.displayName,
      'avatarUrl': user.avatarUrl,
    };

    await prefs.setString('user', jsonEncode(userJson));
    await prefs.setBool('keepSignedIn', true);
  }
}