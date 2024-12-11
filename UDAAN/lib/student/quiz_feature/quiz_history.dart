import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:udaan_app/student/quiz_feature/quiz_analysis_page.dart';

class QuizHistoryPage extends StatelessWidget {
  final List<QuizResult> quizResults = [
    QuizResult(
      quizTitle: 'Math Quiz',
      date: DateTime.now().subtract(Duration(days: 5)),
      score: 8,
      totalQuestions: 10,
      subject: 'Math',
      questions: [
        Question(
            questionText: 'What is 2+2?', correctAnswer: '4', userAnswer: '4'),
        Question(
            questionText: 'What is 3+5?', correctAnswer: '8', userAnswer: '7'),
        // Add more questions as needed
      ],
    ),
    QuizResult(
      quizTitle: 'Science Quiz',
      date: DateTime.now().subtract(Duration(days: 3)),
      score: 7,
      totalQuestions: 10,
      subject: 'Science',
      questions: [
        Question(
            questionText: 'What is H2O?',
            correctAnswer: 'Water',
            userAnswer: 'Water'),
        Question(
            questionText: 'What is the symbol for Oxygen?',
            correctAnswer: 'O',
            userAnswer: 'O'),
        // Add more questions as needed
      ],
    ),
    QuizResult(
      quizTitle: 'History Quiz',
      date: DateTime.now().subtract(Duration(days: 1)),
      score: 9,
      totalQuestions: 10,
      subject: 'History',
      questions: [
        Question(
            questionText: 'Who was the first president of the USA?',
            correctAnswer: 'George Washington',
            userAnswer: 'George Washington'),
        Question(
            questionText: 'When was the Battle of Gettysburg?',
            correctAnswer: '1863',
            userAnswer: '1863'),
        // Add more questions as needed
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz History'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildQuizHistory(context),
              SizedBox(height: 24),
              _buildQuizAnalysis(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizHistory(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quiz History',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: quizResults.length,
              itemBuilder: (context, index) {
                final result = quizResults[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title:
                        Text(result.quizTitle, style: TextStyle(fontSize: 16)),
                    subtitle: Text(
                      'Date: ${result.date.toString().split(' ')[0]}',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: Text(
                      'Score: ${result.score}/${result.totalQuestions}',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                    onTap: () {
                      // Pass the selected quiz result to the QuizAnalysisPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizAnalysisPage(
                            quizResult: result, // Pass the specific quiz result
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizAnalysis() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quiz Analysis',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              height: 250,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey, width: 0.5),
                  ),
                  minX: 0,
                  maxX: quizResults.length.toDouble() - 1,
                  minY: 0,
                  maxY: 10,
                  lineBarsData: [
                    LineChartBarData(
                      spots: quizResults.asMap().entries.map((entry) {
                        return FlSpot(
                          entry.key.toDouble(),
                          entry.value.score.toDouble(),
                        );
                      }).toList(),
                      isCurved: true,
                      color: Colors.blue,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Average Score: ${_calculateAverageScore().toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Text(
              'Total Quizzes Taken: ${quizResults.length}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateAverageScore() {
    if (quizResults.isEmpty) return 0;
    double totalScore =
        quizResults.fold(0, (sum, result) => sum + result.score);
    return totalScore / quizResults.length;
  }
}
