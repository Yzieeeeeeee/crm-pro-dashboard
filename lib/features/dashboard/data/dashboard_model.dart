import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Represents a single KPI metric displayed on the dashboard.
class KpiMetric extends Equatable {
  final String title;
  final String value;
  final IconData icon;
  final double trend;
  final Color color;
  final List<Color> gradientColors;

  const KpiMetric({
    required this.title,
    required this.value,
    required this.icon,
    required this.trend,
    required this.color,
    required this.gradientColors,
  });

  @override
  List<Object?> get props => [title, value, icon, trend, color, gradientColors];
}

/// Activity type for the recent-activity timeline.
enum ActivityType { deal, meeting, email, task }

/// A single activity entry in the timeline.
class Activity extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final ActivityType type;
  final String userName;

  const Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
    required this.userName,
  });

  @override
  List<Object?> get props =>
      [id, title, description, timestamp, type, userName];
}

/// An upcoming meeting card entry.
class Meeting extends Equatable {
  final String id;
  final String title;
  final String contactName;
  final DateTime time;
  final String type;
  final String avatarInitials;

  const Meeting({
    required this.id,
    required this.title,
    required this.contactName,
    required this.time,
    required this.type,
    required this.avatarInitials,
  });

  @override
  List<Object?> get props =>
      [id, title, contactName, time, type, avatarInitials];
}

/// A single data-point for the revenue bar chart.
class ChartDataPoint extends Equatable {
  final String label;
  final double value;

  const ChartDataPoint({required this.label, required this.value});

  @override
  List<Object?> get props => [label, value];
}
