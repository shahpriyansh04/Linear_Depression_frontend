import 'package:flutter/material.dart';
import 'package:udaan_app/parent/dropout_details.dart';
import 'package:udaan_app/parent/parent_homepage.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _showDropoutAlert = false;
  final Map<String, Map<String, dynamic>> _studentData = {
    'John Doe': {
      'attendance': 0.75,
      'grades': 0.65,
      'participation': 0.50,
      'lastLogin': DateTime.now().subtract(Duration(days: 5)),
    },
  };

  // Sample notifications with added reminder and dropout alert notification
  final List<Map<String, dynamic>> notifications = [
    {
      'id': '1',
      'section': 'Today',
      'subject': 'Basic Mathematics',
      'message': 'You got A+ today.',
      'reminder': 'Complete Chapter 4 homework by tomorrow.',
      'icon': Icons.calculate,
      'color': Colors.blue[50],
    },
    {
      'id': '2',
      'section': 'Today',
      'subject': 'English Grammar',
      'message': 'You have unfinished homework.',
      'reminder': 'Finish writing your essay before the weekend.',
      'icon': Icons.book,
      'color': Colors.green[50],
    },
    {
      'id': '3',
      'section': 'Today',
      'subject': 'World History',
      'message': 'Congrats! You got A+ yesterday.',
      'reminder': 'Review notes on World War II.',
      'icon': Icons.public,
      'color': Colors.pink[50],
    },
    {
      'id': '4',
      'section': 'Yesterday',
      'subject': 'Science',
      'message': 'You got D+ today.',
      'reminder': 'Focus on chapters 3 and 4.',
      'icon': Icons.science,
      'color': Colors.yellow[50],
      'detail': {
        'grade': 'D+',
        'message': 'Sad, but you need to improve your knowledge.',
        'teacher': 'Eleanor Pena',
        'time': 'Today, 1:15pm'
      }
    },
    {
      'id': '5',
      'section': 'Yesterday',
      'subject': 'World History',
      'message': 'You have unfinished homework.',
      'reminder': 'Submit your essay on historical figures.',
      'icon': Icons.public,
      'color': Colors.pink[50],
    },
    {
      'id': '6',
      'section': 'Yesterday',
      'subject': 'Basic Mathematics',
      'message': 'You got A+ today.',
      'reminder': 'Keep up the good work in Math!',
      'icon': Icons.calculate,
      'color': Colors.blue[50],
    },
    // Dropout alert notification
    {
      'id': '7',
      'section': 'Alert',
      'subject': 'Dropout Risk Alert',
      'message': 'Student John Doe has a high risk of dropping out.',
      'reminder': 'Please review the attendance and performance.',
      'icon': Icons.warning_amber_rounded,
      'color': Colors.red[50],
      'detail': {
        'risk': 'High',
        'message': 'John has missed several classes and has poor grades.',
        'teacher': 'Mr. Smith',
        'time': 'Nov 30, 2024'
      }
    }
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
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              // Navigate to the home screen if there's no route to pop to
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ParentHomepage()),
              );
            }
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
          _buildSection('Alert'), // Section for dropout alert
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
        if (notification['id'] == '7') {
          _showDropoutRiskAlert(notification);
        } else {
          _showNotificationDetail(notification);
        }
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
                  if (notification['reminder'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Reminder: ${notification['reminder']}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDropoutRiskAlert(Map<String, dynamic> notification) {
    String studentName = 'John Doe';
    String dropoutRisk = notification['detail']['risk'] ?? 'Unknown';
    String riskMessage =
        notification['detail']['message'] ?? 'No further details available';
    String teacherName = notification['detail']['teacher'] ?? 'Unknown';
    String alertTime = notification['detail']['time'] ?? 'Unknown';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 40),
                decoration: BoxDecoration(
                  color: Colors.yellow[700],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: 64,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Warning',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '$studentName has a high risk of dropping out. $riskMessage',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _showDropoutAlert = false;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DropoutDetectionDetailsPage(
                              studentName: studentName,
                              studentData: _studentData[studentName] ?? {},
                            ),
                          ),
                        );
                      },
                      child: Text('Check Details'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showNotificationDetail(Map<String, dynamic> notification) {
    // Handle other notification details if needed
  }
}
