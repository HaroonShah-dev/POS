import 'package:flutter/material.dart';

enum ReportPeriod { daily, weekly, monthly, yearly }

extension ReportPeriodX on ReportPeriod {
  String get label {
    switch (this) {
      case ReportPeriod.daily:
        return 'Daily';
      case ReportPeriod.weekly:
        return 'Weekly';
      case ReportPeriod.monthly:
        return 'Monthly';
      case ReportPeriod.yearly:
        return 'Yearly';
    }
  }
}

class ReportSummary {
  final String title;
  final String value;
  final String change;
  final bool isPositive;
  final IconData icon;

  const ReportSummary({
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.icon,
  });
}

class ChartPoint {
  final String label;
  final double value;
  const ChartPoint(this.label, this.value);
}

class TopProduct {
  final String name;
  final int quantity;
  final double amount;
  const TopProduct(this.name, this.quantity, this.amount);
}

String formatNumber(num value) {
  return value
      .toStringAsFixed(0)
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
}

String formatCompact(double value) {
  if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}k';
  return value.toStringAsFixed(0);
}
