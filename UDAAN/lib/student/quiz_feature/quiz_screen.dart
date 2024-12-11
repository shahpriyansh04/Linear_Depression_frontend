import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  final String subject;
  final int timer; // Timer in minutes
  final int numQuestions; // Number of questions to display

  const QuizScreen({
    Key? key,
    required this.subject,
    required this.timer,
    required this.numQuestions,
  }) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestion = 0;
  List<Map<String, dynamic>> questions = [
    {
      'question': 'What is the capital of France?',
      'options': ['London', 'Berlin', 'Paris', 'Madrid'],
      'correctAnswer': 2,
      'explanation': 'Paris is the capital and most populous city of France.',
      'hint': 'It\'s also known for the Eiffel Tower.',
      'userAnswer': -1,
    },
    {
      'question': 'What is 2 + 2?',
      'options': ['3', '4', '5', '6'],
      'correctAnswer': 1,
      'explanation': '2 + 2 = 4 is a basic arithmetic equation.',
      'hint': 'It\'s a basic math operation.',
      'userAnswer': -1,
    },
    // Add more questions here
  ];

  int remainingTime = 60;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    // Timer to countdown from 60 seconds
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        timer.cancel();
        _showResults();
      }
    });
  }

  // Handle answer selection
  void _answerQuestion(int answerIndex) {
    setState(() {
      questions[currentQuestion]['userAnswer'] = answerIndex;
    });

    // Check if the answer is correct or not
    if (questions[currentQuestion]['userAnswer'] !=
        questions[currentQuestion]['correctAnswer']) {
      // Incorrect answer, show a hint and let the user try again
      _showHint();
    } else {
      // Correct answer, move to the next question
      _nextQuestion();
    }
  }

  // Move to the next question or show results if it's the last question
  void _nextQuestion() {
    setState(() {
      if (currentQuestion < questions.length - 1) {
        currentQuestion++;
      } else {
        _showResults(); // Navigate to results if it's the last question
      }
    });
  }

  // Show hint if answer is incorrect and shuffle the question order
  void _showHint() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hint'),
        content: Text(questions[currentQuestion]['hint']),
        actions: [
          TextButton(
            onPressed: () {
              // Reset the user's answer to -1 (unanswered) for the current question
              setState(() {
                questions[currentQuestion]['userAnswer'] = -1;
              });

              // Shuffle the questions to repeat the current question randomly
              _shuffleQuestions();

              // Close the hint dialog
              Navigator.of(context).pop();
            },
            child: Text('Try Again'),
          ),
        ],
      ),
    );
  }

  // Shuffle questions to pick one randomly and repeat the question
  void _shuffleQuestions() {
    var rng = Random();
    currentQuestion = rng.nextInt(questions.length);
  }

  // Show results screen
  void _showResults() {
    timer.cancel(); // Stop the timer
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(questions: questions),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text('${widget.subject} Quiz'),
        backgroundColor: Colors.teal[600],
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Time: ${remainingTime}s',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal[600],
              ),
              child: Text(
                'Quiz Progress',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ...List.generate(
              questions.length,
              (index) => ListTile(
                title: Text('Question ${index + 1}'),
                trailing: Icon(
                  questions[index]['userAnswer'] != -1
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: questions[index]['userAnswer'] != -1
                      ? Colors.green
                      : Colors.red,
                ),
                onTap: () {
                  setState(() {
                    currentQuestion = index;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Question ${currentQuestion + 1} of ${questions.length}',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[600]),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _buildQuestionOrAnswerCard(),
            ),
          ],
        ),
      ),
    );
  }

  // Widget that builds the card for the current question or answers
  Widget _buildQuestionOrAnswerCard() {
    return Card(
      elevation: 8,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              questions[currentQuestion]['question'],
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ...List.generate(
              4,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: AnimatedButton(
                  onPressed: () => _answerQuestion(index),
                  text: questions[currentQuestion]['options'][index],
                  backgroundColor: Colors.blue[400] ?? Colors.blue,
                ),
              ),
            ),
            // Next button
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                onPressed: _nextQuestion,
                child: Text(currentQuestion == questions.length - 1
                    ? 'Finish'
                    : 'Next Question'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(120, 50),
                  backgroundColor: Colors.orange[400],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  textStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Animated button widget to provide a scaling effect
class AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final Color backgroundColor;

  const AnimatedButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      required this.backgroundColor})
      : super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _scale = 1.1;
        });
        widget.onPressed();
        Future.delayed(Duration(milliseconds: 100), () {
          setState(() {
            _scale = 1.0;
          });
        });
      },
      child: Transform.scale(
        scale: _scale,
        child: ElevatedButton(
          onPressed: widget.onPressed,
          child: Text(
            widget.text,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.backgroundColor,
            minimumSize: Size(double.infinity, 50),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ),
    );
  }
}

// Results Screen that displays the final results
class ResultsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> questions;

  const ResultsScreen({Key? key, required this.questions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Results'),
        backgroundColor: Colors.teal[600],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                var question = questions[index];
                bool isCorrect =
                    question['userAnswer'] == question['correctAnswer'];
                return Card(
                  elevation: 8,
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Q${index + 1}: ${question['question']}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Your answer: ${question['userAnswer'] != -1 ? question['options'][question['userAnswer']] : "Not answered"}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Correct answer: ${question['options'][question['correctAnswer']]}',
                          style: TextStyle(
                              fontSize: 16,
                              color: isCorrect ? Colors.green : Colors.red),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Explanation: ${question['explanation']}',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Go to Home'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.orange[400],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
