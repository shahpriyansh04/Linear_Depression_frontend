import 'package:flutter/material.dart';
import 'package:udaan_app/student/viva_training/viva_training.dart';

class SubjectSelectionPage extends StatefulWidget {
  const SubjectSelectionPage({Key? key}) : super(key: key);

  @override
  _SubjectSelectionPageState createState() => _SubjectSelectionPageState();
}

class _SubjectSelectionPageState extends State<SubjectSelectionPage> {
  final List<Map<String, dynamic>> subjects = [
    {'name': 'Mathematics', 'isSelected': false, 'icon': Icons.calculate},
    {'name': 'Science', 'isSelected': false, 'icon': Icons.science},
    {'name': 'English', 'isSelected': false, 'icon': Icons.book},
    {'name': 'Hindi', 'isSelected': false, 'icon': Icons.language},
    {'name': 'Social Studies', 'isSelected': false, 'icon': Icons.public},
    {'name': 'Sanskrit', 'isSelected': false, 'icon': Icons.history_edu},
  ];

  final TextEditingController _topicController = TextEditingController();

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final selectedSubjects = subjects
        .where((subject) => subject['isSelected'])
        .map((subject) => subject['name'])
        .toList();
    final topic = _topicController.text;

    // TODO: Implement backend submission
    // Example API call:
    // await api.submitSelection({
    //   'subjects': selectedSubjects,
    //   'topic': topic,
    // });

    // Navigate to next page
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ModernRecordingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select your subjects',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Choose the subjects you want to focus on',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final subject = subjects[index];
                    return _buildSubjectCard(subject);
                  },
                  childCount: subjects.length,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'List down your strong topics',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _topicController,
                      decoration: InputDecoration(
                        hintText: 'Enter your topics',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                        ),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Center(
                        child: Text(
                          'Continue',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectCard(Map<String, dynamic> subject) {
    final isSelected = subject['isSelected'];
    return GestureDetector(
      onTap: () {
        setState(() {
          subject['isSelected'] = !isSelected;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    subject['icon'],
                    size: 36,
                    color: isSelected ? Theme.of(context).primaryColor : Colors.grey[600],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subject['name'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Theme.of(context).primaryColor : Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

