// lib/models/carbon_usage.dart
class CarbonUsage {
  final int id;
  final int userId;
  final DateTime date;
  final String? fuelType;
  final int? fuelAmount;
  final int? electricity;
  final int? travel;
  final int totalCarbonEmitted;

  CarbonUsage({
    required this.id,
    required this.userId,
    required this.date,
    this.fuelType,
    this.fuelAmount,
    this.electricity,
    this.travel,
    required this.totalCarbonEmitted,
  });
}