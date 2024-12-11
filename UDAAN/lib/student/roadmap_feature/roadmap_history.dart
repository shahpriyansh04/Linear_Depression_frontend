import 'package:flutter/material.dart';
import 'package:udaan_app/student/roadmap_feature/roadmap.dart';
import 'package:udaan_app/student/roadmap_feature/roadmap_generator.dart';
import 'package:udaan_app/student/student_homepage.dart';

class RoadmapHistory extends StatefulWidget {
  const RoadmapHistory({Key? key}) : super(key: key);

  @override
  _RoadmapHistoryState createState() => _RoadmapHistoryState();
}

class _RoadmapHistoryState extends State<RoadmapHistory> {
  List<Map<String, String>> roadmaps = [];

  // Method to add new roadmap to the list
  void addRoadmap(Map<String, String> roadmap) {
    setState(() {
      roadmaps.add(roadmap);
    });
  }

  // Method to delete a roadmap from the list
  void deleteRoadmap(int index) {
    setState(() {
      roadmaps.removeAt(index);
    });
  }

  bool isScreenBlank() {
    // Example check: If the list of roadmaps is empty, consider the screen blank
    return roadmaps.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F7FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog or current screen

            // Check if the screen is blank or empty and navigate to the homepage
            if (isScreenBlank()) {
              // Replace this with the condition you need
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) =>
                        StudentHomepage()), // Navigate to homepage
              );
            }
          },
        ),
        title: const Text(
          'Your Roadmaps',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: _buildCreateButton(context),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            if (roadmaps.isEmpty)
              const Center(
                child: Text('No roadmaps created yet'),
              )
            else
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: List.generate(roadmaps.length, (index) {
                  final roadmap = roadmaps[index];
                  return _buildSubjectCard(
                    roadmap['title']!,
                    roadmap['duration']!,
                    roadmap['progress']!,
                    roadmap['progressText']!,
                    roadmap['description']!,
                    index,
                  );
                }),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Navigate to RoadmapGeneratorPage and wait for the result
        final Map<String, String>? newRoadmap = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RoadmapGeneratorPage(),
          ),
        );

        if (newRoadmap != null) {
          // Add the new roadmap to the list
          addRoadmap(newRoadmap);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFE1F7E3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.add,
              size: 18,
              color: Color(0xFF1E7B28),
            ),
            Text(
              'Create',
              style: TextStyle(
                color: Color(0xFF1E7B28),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectCard(
    String subject,
    String duration,
    String progress,
    String progressText,
    String description,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        _showRoadmapDetailsDialog(
            context, subject, duration, progress, progressText, description);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.book_outlined,
                  color: Color(0xFF4339F2),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    subject,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    deleteRoadmap(index); // Delete the roadmap at this index
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              duration,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: double.tryParse(progress) ?? 0.0,
              backgroundColor: Colors.grey[200],
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF4339F2)),
            ),
            const SizedBox(height: 8),
            Text(
              progressText,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to show roadmap details in a dialog
  void _showRoadmapDetailsDialog(
      BuildContext context,
      String subject,
      String duration,
      String progress,
      String progressText,
      String description) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Title: $subject',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  'Duration: $duration',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Text(
                  'Progress: $progress',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Text(
                  'Progress Text: $progressText',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Text(
                  'Description: $description',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Close Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                      },
                      child: const Text('Close'),
                    ),
                    const SizedBox(width: 10), // Add some space between buttons

                    // Check Button
                    ElevatedButton(
                      onPressed: () async {
                        // Close the dialog
                        Navigator.pop(context);

                        // Check if the screen is blank or empty, then navigate
                        if (isScreenBlank()) {
                          // Navigate to the StudentHomepage after dialog closes
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => StudentHomepage(),
                            ),
                            (Route<dynamic> route) =>
                                false, // Removes all previous routes
                          );
                        } else {
                          // Navigate to another page (e.g., RoadmapApp or any other page)
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RoadmapPage(),
                            ),
                          );
                        }
                      },
                      child: const Text('Check'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.green, // Custom color for the "Check" button
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
