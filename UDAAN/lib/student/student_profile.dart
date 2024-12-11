import 'package:flutter/material.dart';
import 'student_homepage.dart'; // Import the StudentHomePage screen

class StudentProfileForm extends StatefulWidget {
  @override
  _StudentProfileFormState createState() => _StudentProfileFormState();
}

class _StudentProfileFormState extends State<StudentProfileForm> {
  final _formKey = GlobalKey<FormState>();
  String? parentsName,
      city,
      address,
      className,
      section,
      teacherName,
      teacherId,
      school,
      studentSchoolId;
  TimeOfDay? scheduleStart, scheduleEnd;
  List<String> interests = [];
  List<String> availableInterests = [
    'Sports',
    'Music',
    'Art',
    'Science',
    'Literature',
    'Technology'
  ];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // TODO: Implement profile creation logic here
      print('Parents Name: $parentsName');
      print('City: $city');
      print('Address: $address');
      print('Class: $className');
      print('Section: $section');
      print('Teacher Name: $teacherName');
      print('Teacher ID: $teacherId');
      print('Interests: $interests');
      print(
          'Schedule: ${scheduleStart?.format(context)} - ${scheduleEnd?.format(context)}');
      print('School: $school');
      print('Student School ID: $studentSchoolId');

      // Navigate to the Student Homepage after form submission
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StudentHomepage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Profile'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildTextField('Parent\'s Name', (value) => parentsName = value,
                  'Please enter parent\'s name'),
              _buildTextField(
                  'City', (value) => city = value, 'Please enter your city'),
              _buildTextField(
                  'Address (Optional)', (value) => address = value, ''),
              _buildTextField('Class', (value) => className = value,
                  'Please enter your class'),
              _buildTextField('Section', (value) => section = value,
                  'Please enter your section'),
              _buildTextField('Teacher Name', (value) => teacherName = value,
                  'Please enter teacher\'s name'),
              _buildTextField(
                  'Teacher ID (if provided)', (value) => teacherId = value, ''),
              SizedBox(height: 20),
              Text('Interests', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 12),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: availableInterests.map((interest) {
                  final isSelected = interests.contains(interest);
                  return FilterChip(
                    label: Text(
                      interest,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.purple,
                        fontSize: 14,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          interests.add(interest);
                        } else {
                          interests.remove(interest);
                        }
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: Colors.purple,
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
              Text('Schedule', style: Theme.of(context).textTheme.titleLarge),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white),
                      child: Text(scheduleStart == null
                          ? 'Start Time'
                          : scheduleStart!.format(context)),
                      onPressed: () async {
                        TimeOfDay? time = await showTimePicker(
                            context: context, initialTime: TimeOfDay.now());
                        if (time != null) {
                          setState(() {
                            scheduleStart = time;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white),
                      child: Text(scheduleEnd == null
                          ? 'End Time'
                          : scheduleEnd!.format(context)),
                      onPressed: () async {
                        TimeOfDay? time = await showTimePicker(
                            context: context, initialTime: TimeOfDay.now());
                        if (time != null) {
                          setState(() {
                            scheduleEnd = time;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildTextField('School', (value) => school = value,
                  'Please enter your school'),
              _buildTextField(
                  'Student School ID',
                  (value) => studentSchoolId = value,
                  'Please enter your school ID'),
              SizedBox(height: 20),
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
