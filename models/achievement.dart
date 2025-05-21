// lib/models/achievement.dart
import 'package:flutter/material.dart';

class Achievement {
  final int id;
  final String name;
  final String description;
  final IconData icon;
  final int requiredValue;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.requiredValue,
  });
}