import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<Map<String, dynamic>> notifications = [
    {
      'id': '1',
      'section': 'Today',
      'subject': 'Basic mathematic',
      'message': 'You got A+ today.',
      'icon': Icons.calculate,
      'color': Colors.blue[50],
    },
    {
      'id': '2',
      'section': 'Today',
      'subject': 'English grammar',
      'message': 'You have unfinished homework.',
      'icon': Icons.book,
      'color': Colors.green[50],
    },
    {
      'id': '3',
      'section': 'Today',
      'subject': 'World history',
      'message': 'Congrats! You got A+ yesterday.',
      'icon': Icons.public,
      'color': Colors.pink[50],
    },
    {
      'id': '4',
      'section': 'Yesterday',
      'subject': 'Science',
      'message': 'You got D+ today.',
      'icon': Icons.science,
      'color': Colors.yellow[50],
      'detail': {
        'grade': 'D+',
        'message': 'Sad, but you need to improve your knowledge',
        'teacher': 'Eleanor Pena',
        'time': 'Today, 1:15pm'
      }
    },
    {
      'id': '5',
      'section': 'Yesterday',
      'subject': 'World history',
      'message': 'You have unfinished homework.',
      'icon': Icons.public,
      'color': Colors.pink[50],
    },
    {
      'id': '6',
      'section': 'Yesterday',
      'subject': 'Basic mathematic',
      'message': 'You got A+ today.',
      'icon': Icons.calculate,
      'color': Colors.blue[50],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(
                context); // This will navigate back to the previous screen
          },
        ),
        title: Text(
          'Notifications',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              '12', // Number of notifications
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildSection('Today'),
          _buildSection('Yesterday'),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
        ...notifications
            .where((notification) => notification['section'] == title)
            .map((notification) => _buildNotificationCard(notification))
            .toList(),
      ],
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    return GestureDetector(
      onTap: () {
        _showNotificationDetail(notification);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification['color'],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(notification['icon'], size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification['subject'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    notification['message'],
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationDetail(Map<String, dynamic> notification) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.2,
          maxChildSize: 0.75,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.yellow[50],
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: ListView(
                controller: controller,
                padding: EdgeInsets.all(16),
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  if (notification['detail'] != null) ...[
                    Text(
                      notification['detail']['grade'],
                      style:
                          TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      notification['detail']['message'],
                      style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                    ),
                    SizedBox(height: 24),
                    Text(
                      notification['subject'],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      notification['detail']['time'],
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: AssetImage('assets/placeholder.png'),
                        ),
                        SizedBox(width: 8),
                        Text(notification['detail']['teacher'],
                            style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Lessons materials'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        minimumSize: Size(double.infinity, 48),
                      ),
                    ),
                  ] else ...[
                    Text(
                      'No detailed information available',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }
}
