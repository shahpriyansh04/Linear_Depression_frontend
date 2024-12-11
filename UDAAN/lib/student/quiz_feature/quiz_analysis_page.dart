import 'package:flutter/material.dart';

class QuizResult {
  final String quizTitle;
  final DateTime date;
  final int score;
  final int totalQuestions;
  final String subject;
  final List<Question> questions;

  QuizResult({
    required this.quizTitle,
    required this.date,
    required this.score,
    required this.totalQuestions,
    required this.subject,
    required this.questions,
  });
}

class Question {
  final String questionText;
  final String correctAnswer;
  final String userAnswer;

  Question({
    required this.questionText,
    required this.correctAnswer,
    required this.userAnswer,
  });

  bool get isCorrect => correctAnswer == userAnswer;
}

class QuizAnalysisPage extends StatelessWidget {
  final QuizResult quizResult;

  QuizAnalysisPage({required this.quizResult});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(quizResult.quizTitle),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quiz Subject: ${quizResult.subject}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildQuizDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizDetails() {
    return Expanded(
      child: ListView.builder(
        itemCount: quizResult.questions.length,
        itemBuilder: (context, index) {
          final question = quizResult.questions[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Text(
                question.questionText,
                style: TextStyle(fontSize: 16),
              ),
              subtitle: Text(
                'Your Answer: ${question.userAnswer}\nCorrect Answer: ${question.correctAnswer}',
                style: TextStyle(fontSize: 14),
              ),
              trailing: Icon(
                question.isCorrect ? Icons.check_circle : Icons.cancel,
                color: question.isCorrect ? Colors.green : Colors.red,
              ),
            ),
          );
        },
      ),
    );
  }
}
