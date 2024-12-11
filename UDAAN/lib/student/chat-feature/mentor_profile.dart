import 'package:flutter/material.dart';

class MentorProfileScreen extends StatelessWidget {
  const MentorProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mentor Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildInfoSection('About',
                'Experienced software engineer with a passion for mentoring and helping others grow in their careers.'),
            _buildInfoSection(
                'Expertise', 'Flutter, Dart, Mobile Development, UI/UX Design'),
            _buildInfoSection('Experience',
                '10+ years in software development\n5+ years in mentoring'),
            _buildInfoSection('Education',
                'M.S. in Computer Science, XYZ University\nB.S. in Software Engineering, ABC University'),
            _buildInfoSection(
                'Languages', 'English (Native), Spanish (Fluent)'),
            _buildInfoSection('Availability',
                'Weekdays: 6 PM - 9 PM\nWeekends: 10 AM - 4 PM'),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage:
                NetworkImage('/placeholder.svg?height=100&width=100'),
          ),
          const SizedBox(height: 16),
          const Text(
            'Mentor Sarah',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text(
            'sarah@mentorapp.com',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
