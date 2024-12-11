import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFF8F6FC), // Cream white
              const Color(0xFFE9E5FA), // Soft lavender
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                const SizedBox(height: 20),
                _buildOverallScoreCard(),
                const SizedBox(height: 20),
                _buildReportCard(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Progress Report',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A4A6A), // Dark muted purple
          ),
        ),
      ],
    );
  }

  Widget _buildOverallScoreCard() {
    return Card(
      elevation: 4,
      color: const Color(0xFFFFFFFF), // White for contrast
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Overall Score',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A4A6A)),
                ),
                SizedBox(height: 8),
                Text(
                  '4.14 / 5.0',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4CAF50), // Green for positive score
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.star_rounded,
              color: Color(0xFFFFD700), // Light purple
              size: 50,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(BuildContext context) {
    return Card(
      elevation: 4,
      color: const Color(0xFFFFFFFF), // White for contrast
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStudentInfo(),
            const Divider(
                color: Color(0xFFDDDDEA), height: 32), // Subtle divider
            _buildPerformanceBreakdown(),
            const SizedBox(height: 24),
            _buildPieChart(),
            const SizedBox(height: 24),
            _buildFeedback(),
            const SizedBox(height: 24),
            _buildNextQuestionButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentInfo() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage('assets/avatar.png'),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Ananya Sharma',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A4A6A),
              ),
            ),
            Text(
              'Class 6',
              style: TextStyle(
                  fontSize: 16, color: Color(0xFF888888)), // Muted grey
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPerformanceBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Performance Breakdown',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A4A6A)),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildPerformanceItem(
                  'Correctness', 80, const Color(0xFF4CAF50)), // Green
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildPerformanceItem(
                  'Confidence', 75, const Color(0xFF000080)), // Orange-red
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPerformanceItem(String label, int percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, color: Color(0xFF4A4A6A))),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: const Color(0xFFE0E0E0), // Light grey
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
        const SizedBox(height: 4),
        Text(
          '$percentage%',
          style: TextStyle(
              fontSize: 14, color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildPieChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Viva Concept Analysis',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A4A6A)),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 300, // Increased size for better readability
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: 40,
                  title: 'Semantic\n40%',
                  color: const Color(0xFF3E9F91),
                  radius: 80,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                PieChartSectionData(
                  value: 35,
                  title: '       Confidence\n35%',
                  color: const Color(0xFF000080),
                  radius: 80,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                PieChartSectionData(
                  value: 25,
                  title: 'Concept\n25%',
                  color: const Color(0xFF7B61FF),
                  radius: 80,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
              sectionsSpace: 8,
              centerSpaceRadius: 42, // Adjusted for label clarity
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeedback() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1), // Pale yellow
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: const Color(0xFFFFECB3)), // Subtle yellow border
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Feedback',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A4A6A)),
          ),
          SizedBox(height: 8),
          Text(
            'Good effort! Focus more on semantic accuracy and answer confidently. Revise concepts to deepen understanding.',
            style: TextStyle(fontSize: 16, color: Color(0xFF616161)),
          ),
        ],
      ),
    );
  }

  Widget _buildNextQuestionButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Logic for the next question
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
            vertical: 20, horizontal: 32), // Increased padding
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: const Color(0xFF7B61FF),
      ),
      child: const Text(
        'Go to Next Question',
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
