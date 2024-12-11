import 'package:flutter/material.dart';
import 'package:udaan_app/student/student_notes_revision/music_vinyl_player/ui/my_library/my_library_page.dart';

class StudyContentScreen extends StatelessWidget {
  const StudyContentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F0),
      appBar: AppBar(
        title: const Text(
          'Educational Content',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 80,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double cardWidth =
              (constraints.maxWidth - 48) / 2; // Account for padding and gap
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * 0.02),
                  SizedBox(
                    width: constraints.maxWidth,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: cardWidth,
                          child: _buildCard(
                            title: 'Notes',
                            description:
                                'Access your study materials and important notes',
                            color: const Color(0xFFE57373),
                            rating: 4.1,
                            progress: 12,
                            icon: Icons.note_alt_outlined,
                            height: constraints.maxHeight * 0.35,
                            context: context,
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: cardWidth,
                          child: _buildCard(
                            title: 'Revise',
                            description:
                                'Review and practice your learning materials',
                            color: const Color(0xFF66BB6A),
                            rating: 4.5,
                            progress: 32,
                            icon: Icons.refresh_rounded,
                            height: constraints.maxHeight * 0.35,
                            context: context,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  _buildLargeCard(
                    title: 'Video Content',
                    description:
                        'Watch educational videos and tutorials for better understanding',
                    color: const Color(0xFFBA68C8),
                    rating: 4.6,
                    progress: 100,
                    icon: Icons.play_circle_outline,
                    height: constraints.maxHeight * 0.5,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String description,
    required Color color,
    required double rating,
    required int progress,
    required IconData icon,
    required double height,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        if (title == 'Notes') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyLibraryPage()),
          );
        }
      },
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      size: 20,
                      color: color,
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 1),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                flex: 2,
                child: Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    rating.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$progress%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLargeCard({
    required String title,
    required String description,
    required Color color,
    required double rating,
    required int progress,
    required IconData icon,
    required double height,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    size: 24,
                    color: color,
                  ),
                ),
              ],
            ),
            const Spacer(flex: 1),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              flex: 2,
              child: Text(
                description,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.2,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  rating.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$progress%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
