import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeSlot implements Comparable<TimeSlot> {
  final TimeOfDay start;
  final TimeOfDay end;

  const TimeSlot({required this.start, required this.end});

  @override
  int compareTo(TimeSlot other) {
    final startComparison = start.hour * 60 + start.minute;
    final otherStartComparison = other.start.hour * 60 + other.start.minute;
    return startComparison.compareTo(otherStartComparison);
  }
}

class Task {
  final String title;
  final TimeSlot timeSlot;
  final String icon;
  final String? project;
  final List<String>? collaborators;

  const Task({
    required this.title,
    required this.timeSlot,
    required this.icon,
    this.project,
    this.collaborators,
  });
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<Task> tasks = [];
  String description = '';
  final TextEditingController _descriptionController = TextEditingController();

  void _generateTasks() {
    // Generate tasks based on the description
    TimeSlot generatedTimeSlot = TimeSlot(
      start: TimeOfDay(hour: 9, minute: 0), // Default time slot
      end: TimeOfDay(hour: 10, minute: 0),
    );

    if (description.toLowerCase().contains('morning')) {
      generatedTimeSlot = TimeSlot(
        start: TimeOfDay(hour: 8, minute: 0),
        end: TimeOfDay(hour: 10, minute: 0),
      );
    } else if (description.toLowerCase().contains('afternoon')) {
      generatedTimeSlot = TimeSlot(
        start: TimeOfDay(hour: 13, minute: 0),
        end: TimeOfDay(hour: 15, minute: 0),
      );
    }

    setState(() {
      tasks.clear(); // Clear existing tasks (if any)
      tasks.add(Task(
        title: 'Generated Task', // Placeholder task title
        timeSlot: generatedTimeSlot,
        icon: '📝', // Default icon
      ));
      tasks.add(Task(
        title: 'Generated Task', // Placeholder task title
        timeSlot: generatedTimeSlot,
        icon: '📝', // Default icon
      ));
      tasks.add(Task(
        title: 'Generated Task', // Placeholder task title
        timeSlot: generatedTimeSlot,
        icon: '📝', // Default icon
      ));
      tasks.add(Task(
        title: 'Generated Task', // Placeholder task title
        timeSlot: generatedTimeSlot,
        icon: '📝', // Default icon
      ));
    });
  }

  Widget _buildHeader() {
    final now = DateTime.now();
    final dateFormat = DateFormat('E d MMMM yyyy');

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Good Morning, Sullivan! 👋',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Row(
                children: [
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      // TODO: Implement menu
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            dateFormat.format(now),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _descriptionController,
        decoration: const InputDecoration(
          labelText: 'Enter Task Description',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          setState(() {
            description = value;
          });
        },
      ),
    );
  }

  Widget _buildGenerateButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: _generateTasks,
        child: const Text('Generate Task(s)'),
      ),
    );
  }

  Widget _buildTaskList() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return TaskItem(
            task: tasks[index],
            onDelete: () => _deleteTask(index),
            onCut: () => _cutTaskItem(index),
          );
        },
      ),
    );
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void _cutTaskItem(int index) {
    // Implement cut functionality if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
            'AI Schedule Planner'), // You can customize the title here
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
                context); // This pops the current screen from the stack
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildDescriptionField(), // Add description field here
            _buildGenerateButton(), // Add Generate button
            _buildTaskList(), // Display generated tasks
          ],
        ),
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;
  final VoidCallback onCut;

  const TaskItem({
    Key? key,
    required this.task,
    required this.onDelete,
    required this.onCut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(task.icon, style: TextStyle(fontSize: 24)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${task.timeSlot.start.format(context)} - ${task.timeSlot.end.format(context)}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
