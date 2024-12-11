import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DropoutDetectionDetailsPage extends StatelessWidget {
  final String studentName;
  final Map<String, dynamic> studentData;

  const DropoutDetectionDetailsPage({
    Key? key,
    required this.studentName,
    required this.studentData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dropout Risk Details',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 6.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                studentName,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontSize: 26, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 16),
              _buildRiskIndicator(),
              SizedBox(height: 24),
              _buildSectionTitle('Performance Breakdown'),
              _buildPerformanceBreakdown(),
              SizedBox(height: 24),
              _buildSectionTitle('Tips to Improve'),
              _buildTipsToImprove(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRiskIndicator() {
    double riskScore = _calculateOverallRisk();
    Color riskColor = _getRiskColor(riskScore);

    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Overall Dropout Risk',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            SizedBox(height: 16),
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0.0, end: riskScore),
              duration: Duration(seconds: 1),
              builder: (context, double value, child) {
                return CircularPercentIndicator(
                  radius: 130.0,
                  lineWidth: 15.0,
                  animation: true,
                  percent: value,
                  center: Text(
                    '${(value * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                        color: Colors.black87),
                  ),
                  footer: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      _getRiskLabel(value),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.black87),
                    ),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: riskColor,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _buildPerformanceBreakdown() {
    return Column(
      children: [
        _buildPerformanceItem('Attendance', 0.7, Color(0xFFBBDEFB)),
        _buildPerformanceItem('Grades', 0.8, Color(0xFF81C784)),
        _buildPerformanceItem('Participation', 0.2, Color(0xFFFFCC80)),
      ],
    );
  }

  Widget _buildPerformanceItem(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              double width = constraints.maxWidth - 32;
              return TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.0, end: value),
                duration: Duration(seconds: 2),
                builder: (context, double value, child) {
                  return LinearPercentIndicator(
                    width: width,
                    animation: true,
                    lineHeight: 20.0,
                    animationDuration: 2500,
                    percent: value,
                    center: Text('${(value * 100).toStringAsFixed(1)}%',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: color,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTipsToImprove() {
    List<Map<String, String>> tips = [
      {
        'title': 'Improve Attendance',
        'description':
            'Set a consistent sleep schedule and prepare for school the night before.',
      },
      {
        'title': 'Boost Grades',
        'description':
            'Create a study schedule and seek help from teachers or tutors when needed.',
      },
      {
        'title': 'Increase Participation',
        'description':
            'Set small goals to contribute in class discussions and join study groups.',
      },
      {
        'title': 'Stay Engaged',
        'description':
            'Regularly log in to the school portal and stay updated with assignments and announcements.',
      },
    ];

    return Column(
      children: tips
          .map((tip) => _buildTipCard(tip['title']!, tip['description']!))
          .toList(),
    );
  }

  Widget _buildTipCard(String title, String description) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: Duration(seconds: 1),
      child: Card(
        margin: EdgeInsets.only(bottom: 16),
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.lightbulb_outline,
                  color: Colors.yellow[700], size: 32),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    SizedBox(height: 8),
                    Text(description, style: TextStyle(color: Colors.black54)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateOverallRisk() {
    double attendanceWeight = 0.3;
    double gradesWeight = 0.4;
    double participationWeight = 0.2;
    double lastLoginWeight = 0.1;

    double attendanceRisk = 1 -
        (double.tryParse(studentData['attendance']?.toString() ?? '0.0') ??
            0.0);
    double gradesRisk = 1 -
        (double.tryParse(studentData['grades']?.toString() ?? '0.0') ?? 0.0);
    double participationRisk = 1 -
        (double.tryParse(studentData['participation']?.toString() ?? '0.0') ??
            0.0);

    DateTime lastLogin = studentData['lastLogin'] ?? DateTime.now();
    int daysSinceLastLogin = DateTime.now().difference(lastLogin).inDays;
    double lastLoginRisk =
        daysSinceLastLogin > 30 ? 1.0 : daysSinceLastLogin / 30;

    return (attendanceRisk * attendanceWeight) +
        (gradesRisk * gradesWeight) +
        (participationRisk * participationWeight) +
        (lastLoginRisk * lastLoginWeight);
  }

  Color _getRiskColor(double risk) {
    if (risk < 0.3) return Colors.green;
    if (risk < 0.6) return Colors.orangeAccent;
    return Colors.redAccent;
  }

  String _getRiskLabel(double risk) {
    if (risk < 0.3) return 'Low Risk';
    if (risk < 0.6) return 'Moderate Risk';
    return 'High Risk';
  }
}
