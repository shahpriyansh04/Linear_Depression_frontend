import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:udaan_app/teacher/models/student.dart';

class StudentDetailScreen extends StatelessWidget {
  final Student student;

  const StudentDetailScreen({Key? key, required this.student})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(student.name),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[100],
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOverviewSection(),
                SizedBox(height: 24),
                _buildSubjectPerformanceChart(),
                SizedBox(height: 24),
                _buildDropoutRiskSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildOverviewItem(
                    'Average Score', '${student.averageScore}%', Colors.blue),
                _buildOverviewItem('Dropout Risk', '${student.dropoutScore}%',
                    _getDropoutRiskColor(student.dropoutScore)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildSubjectPerformanceChart() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Subject Performance',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 100,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            String text;
                            switch (value.toInt()) {
                              case 0:
                                text = 'Math';
                                break;
                              case 1:
                                text = 'Science';
                                break;
                              case 2:
                                text = 'English';
                                break;
                              case 3:
                                text = 'History';
                                break;
                              default:
                                text = '';
                            }
                            return Text(
                              text,
                              style: const TextStyle(
                                color: Color(0xff7589a2),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            );
                          },
                          reservedSize: 20,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                            // Configure left titles similarly
                            ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      _buildBarGroup(0, student.subjects['Math'] ?? 0),
                      _buildBarGroup(1, student.subjects['Science'] ?? 0),
                      _buildBarGroup(2, student.subjects['English'] ?? 0),
                      _buildBarGroup(3, student.subjects['History'] ?? 0),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  BarChartGroupData _buildBarGroup(int x, int y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y.toDouble(),
          color: _getBarColor(y),
          width: 22,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Color _getBarColor(int score) {
    if (score >= 90) return Colors.green;
    if (score >= 80) return Colors.blue;
    if (score >= 70) return Colors.orange;
    return Colors.red;
  }

  Widget _buildDropoutRiskSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dropout Risk Analysis',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getDropoutRiskColor(student.dropoutScore),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _getDropoutRiskLevel(student.dropoutScore),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Current Risk: ${student.dropoutScore}%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              _getDropoutRiskDescription(student.dropoutScore),
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  String _getDropoutRiskLevel(int score) {
    if (score < 20) return 'Low Risk';
    if (score < 50) return 'Medium Risk';
    return 'High Risk';
  }

  String _getDropoutRiskDescription(int score) {
    if (score < 20) {
      return 'The student is performing well and has a low risk of dropping out. Continue to monitor and support their progress.';
    } else if (score < 50) {
      return 'The student may be at risk of dropping out. Consider implementing additional support measures and closely monitor their performance.';
    } else {
      return 'The student is at high risk of dropping out. Immediate intervention and support are recommended. Consider scheduling a meeting with the student and their guardians.';
    }
  }

  Color _getDropoutRiskColor(int score) {
    if (score < 20) return Colors.green;
    if (score < 50) return Colors.orange;
    return Colors.red;
  }
}
