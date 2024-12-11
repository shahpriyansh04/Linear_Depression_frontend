import 'package:flutter/material.dart';
import 'package:udaan_app/teacher/teacher_homepage.dart';

class TeacherProfileForm extends StatefulWidget {
  @override
  _TeacherProfileFormState createState() => _TeacherProfileFormState();
}

class _TeacherProfileFormState extends State<TeacherProfileForm> {
  final _formKey = GlobalKey<FormState>();

  // Fields for Teacher Profile
  String? teacherId, city, address, className, section;
  List<Map<String, String>> studentsEmails = [];
  List<String> subjectsTaught = [];
  List<String> availableSubjects = [
    'Math',
    'Science',
    'English',
    'History',
    'Geography'
  ];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Print or save form data as needed
      print('Teacher ID: $teacherId');
      print('City: $city');
      print('Address: $address');
      print('Class: $className');
      print('Section: $section');
      print('Subjects Taught: $subjectsTaught');
      studentsEmails.forEach((student) {
        print(
            'Student SAP ID: ${student["sapId"]}, Email: ${student["email"]}');
      });
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TeacherHomepage()),
    );
  }

  // Add student email along with their SAP ID
  void _addStudentEmail() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController emailController = TextEditingController();
        TextEditingController sapIdController = TextEditingController();

        return AlertDialog(
          title: Text('Add Student Email and SAP ID'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Student Email'),
              ),
              TextField(
                controller: sapIdController,
                decoration: InputDecoration(labelText: 'Student SAP ID'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (emailController.text.isNotEmpty &&
                    sapIdController.text.isNotEmpty) {
                  setState(() {
                    studentsEmails.add({
                      'email': emailController.text,
                      'sapId': sapIdController.text,
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Profile'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Teacher ID (optional)
              _buildTextField(
                  'Teacher ID (Optional)', (value) => teacherId = value, ''),

              // City field
              _buildTextField(
                  'City', (value) => city = value, 'Please enter city'),

              // Address (Optional)
              _buildTextField(
                  'Address (Optional)', (value) => address = value, ''),

              // Class
              _buildTextField('Class', (value) => className = value,
                  'Please enter the class'),

              // Section (Optional)
              _buildTextField(
                  'Section (Optional)', (value) => section = value, ''),

              // Subjects Taught (Multiple selection)
              Text('Subjects Taught',
                  style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 12),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: availableSubjects.map((subject) {
                  final isSelected = subjectsTaught.contains(subject);
                  return FilterChip(
                    label: Text(
                      subject,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.purple,
                        fontSize: 14,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          subjectsTaught.add(subject);
                        } else {
                          subjectsTaught.remove(subject);
                        }
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: Colors.deepPurple,
                    checkmarkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color:
                            isSelected ? Colors.transparent : Colors.grey[300]!,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  );
                }).toList(),
              ),

              SizedBox(height: 20),

              // List of students' email and SAP ID
              Text('Students Email and SAP ID',
                  style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 12),
              ...studentsEmails.map((student) {
                return Card(
                  child: ListTile(
                    title: Text(student['email']!),
                    subtitle: Text('SAP ID: ${student['sapId']}'),
                  ),
                );
              }).toList(),

              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                child: Text('Add Student Email'),
                onPressed: _addStudentEmail,
              ),
              SizedBox(height: 20),

              // Submit button
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                child: Text('Create Profile'),
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build text fields with validation and save
  Widget _buildTextField(
      String label, Function(String?) onSaved, String validatorMessage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding:
              EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        ),
        validator: (value) => value!.isEmpty && validatorMessage.isNotEmpty
            ? validatorMessage
            : null,
        onSaved: onSaved,
      ),
    );
  }
}
