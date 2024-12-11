import 'package:flutter/material.dart';
import 'package:udaan_app/student/quiz_feature/quiz_screen.dart';

class MakeQuiz extends StatefulWidget {
  final String subject; // Subject passed via the constructor

  // Constructor to accept subject parameter
  const MakeQuiz({Key? key, required this.subject}) : super(key: key);

  @override
  _MakeQuizState createState() => _MakeQuizState();
}

class _MakeQuizState extends State<MakeQuiz> {
  final _formKey = GlobalKey<FormState>(); // Form key to validate the inputs

  // Controllers for the input fields
  final TextEditingController _chapterNameController = TextEditingController();
  final TextEditingController _timerController = TextEditingController();
  final TextEditingController _numQuestionsController = TextEditingController();

  // Default values for difficulty and subject
  String _difficultyLevel = 'Easy';
  String? _selectedSubject;

  @override
  void dispose() {
    _chapterNameController.dispose();
    _timerController.dispose();
    _numQuestionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Make Quiz - ${widget.subject}'), // Display the subject name
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create a new quiz for ${widget.subject}!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              // Subject (pre-filled as passed subject)
              TextFormField(
                initialValue: widget.subject,
                enabled: false, // Subject is pre-filled and not editable
                decoration: InputDecoration(
                  labelText: 'Subject',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              // Difficulty Level dropdown
              DropdownButtonFormField<String>(
                value: _difficultyLevel,
                onChanged: (String? newValue) {
                  setState(() {
                    _difficultyLevel = newValue!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Select Difficulty Level',
                  border: OutlineInputBorder(),
                ),
                items: ['Easy', 'Medium', 'Hard']
                    .map((difficulty) => DropdownMenuItem<String>(
                          value: difficulty,
                          child: Text(difficulty),
                        ))
                    .toList(),
              ),
              SizedBox(height: 10),
              // Chapter Name input field
              TextFormField(
                controller: _chapterNameController,
                decoration: InputDecoration(
                  labelText: 'Chapter Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a chapter name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              // Timer input field (in minutes)
              TextFormField(
                controller: _timerController,
                decoration: InputDecoration(
                  labelText: 'Timer (minutes)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the timer value';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              // Number of Questions input field
              TextFormField(
                controller: _numQuestionsController,
                decoration: InputDecoration(
                  labelText: 'Number of Questions',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of questions';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Submit button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Form is valid, handle quiz creation logic
                    _createQuiz();
                  }
                },
                child: Text('Start Quiz'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to handle quiz creation
  void _createQuiz() {
    if (_formKey.currentState!.validate()) {
      final chapterName = _chapterNameController.text;
      final timer = int.parse(_timerController.text);
      final numQuestions = int.parse(_numQuestionsController.text);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizScreen(
            subject: widget.subject,
            timer: timer,
            numQuestions: numQuestions,
          ),
        ),
      );
    }
  }
}
