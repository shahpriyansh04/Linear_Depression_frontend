import 'package:flutter/material.dart';

class Task {
  final String title;
  final TimeSlot timeSlot;
  final String icon;
  final List<String>? collaborators;
  final String? project;
  bool isCompleted;

  Task({
    required this.title,
    required this.timeSlot,
    required this.icon,
    this.collaborators,
    this.project,
    this.isCompleted = false,
  });
}

class TimeSlot {
  final TimeOfDay start;
  final TimeOfDay end;

  const TimeSlot({required this.start, required this.end});

  String format() {
    String formatTimeOfDay(TimeOfDay time) {
      final hour = time.hour.toString().padLeft(2, '0');
      final minute = time.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }

    return '${formatTimeOfDay(start)} - ${formatTimeOfDay(end)}';
  }
}
