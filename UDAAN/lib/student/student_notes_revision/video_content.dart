import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoContentScreen extends StatefulWidget {
  const VideoContentScreen({Key? key}) : super(key: key);

  @override
  _VideoContentScreenState createState() => _VideoContentScreenState();
}

class _VideoContentScreenState extends State<VideoContentScreen> {
  String selectedSubject = 'Mathematics';
  String selectedTopic = 'Calculus';

  final List<String> subjects = [
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
  ];

  final List<String> topics = [
    'Calculus',
    'Algebra',
    'Geometry',
    'Statistics',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5),
      appBar: AppBar(
        title: const Text('Video Content',
            style: TextStyle(
              color: Colors.white,
            )),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 10,
              itemBuilder: (context, index) {
                return _VideoCard(
                  title: 'Introduction to ${selectedTopic} - Part ${index + 1}',
                  description: 'Learn the fundamentals of ${selectedTopic} with detailed explanations and examples.',
                  channel: 'NPTEL',
                  duration: '12:34',
                  views: '${(index + 1) * 10}K',
                  videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _FilterDropdown(
              value: selectedSubject,
              items: subjects,
              onChanged: (value) {
                setState(() {
                  selectedSubject = value!;
                });
              },
              hint: 'Select Subject',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _FilterDropdown(
              value: selectedTopic,
              items: topics,
              onChanged: (value) {
                setState(() {
                  selectedTopic = value!;
                });
              },
              hint: 'Select Topic',
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final void Function(String?) onChanged;
  final String hint;

  const _FilterDropdown({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButton<String>(
        value: value,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        hint: Text(hint),
        isExpanded: true,
        underline: const SizedBox(),
        icon: const Icon(Icons.arrow_drop_down),
      ),
    );
  }
}

class _VideoCard extends StatelessWidget {
  final String title;
  final String description;
  final String channel;
  final String duration;
  final String views;
  final String videoUrl;

  const _VideoCard({
    Key? key,
    required this.title,
    required this.description,
    required this.channel,
    required this.duration,
    required this.views,
    required this.videoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: InkWell(
        onTap: () => _launchYouTubeVideo(videoUrl),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildThumbnail(),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle(),
                    const SizedBox(height: 4),
                    _buildDescription(),
                    const SizedBox(height: 8),
                    _buildMetadata(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return Container(
      width: 120,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.play_circle_fill,
            size: 40,
            color: Colors.deepPurple.shade400,
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                duration,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription() {
    return Text(
      description,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey.shade600,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildMetadata() {
    return Row(
      children: [
        Text(
          channel,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$views views',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  void _launchYouTubeVideo(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

