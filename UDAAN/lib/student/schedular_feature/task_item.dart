import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Task {
  final String title;
  final bool isCompleted;
  final String? project;
  final List<String>? collaborators;
  final DateTime timeSlot;

  Task({
    required this.title,
    required this.isCompleted,
    this.project,
    this.collaborators,
    required this.timeSlot,
  });
}

extension DateTimeExtension on DateTime {
  String format() {
    return DateFormat('HH:mm').format(this);
  }
}

class TaskItem extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?> onCompletionChanged;
  final VoidCallback onDelete;

  const TaskItem({
    Key? key,
    required this.task,
    required this.onCompletionChanged,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: onCompletionChanged,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.project != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  task.project!,
                  style: TextStyle(
                      color: Colors.blue[700], fontWeight: FontWeight.w500),
                ),
              ),
            if (task.collaborators != null && task.collaborators!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: task.collaborators!.map((avatar) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: CircleAvatar(
                        radius: 12,
                        backgroundImage: AssetImage(avatar),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              task.timeSlot.format(),
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              onPressed: () {
                _showTaskMenu(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showTaskMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete Task'),
            onTap: () {
              onDelete();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
