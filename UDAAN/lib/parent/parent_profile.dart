import 'package:flutter/material.dart';
import 'parent_homepage.dart'; // Assuming you have the ParentHomepage screen

class ParentProfileForm extends StatefulWidget {
  @override
  _ParentProfileFormState createState() => _ParentProfileFormState();
}

class _ParentProfileFormState extends State<ParentProfileForm> {
  final _formKey = GlobalKey<FormState>();

  // Fields for Parent Profile
  String? parentName, city, address, teacherName, whatsappNumber, occupation;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // TODO: Implement profile creation logic here
      print('Parent\'s Name: $parentName');
      print('City: $city');
      print('Address: $address');
      print('Teacher Name: $teacherName');
      print('WhatsApp Number: $whatsappNumber');
      print('Occupation: $occupation');

      //Navigate to ParentHomepage after form submission
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ParentHomepage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parent Profile'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Parent's Name field
              _buildTextField('Parent\'s Name', (value) => parentName = value,
                  'Please enter parent\'s name'),

              // City is optional
              _buildTextField('City (Optional)', (value) => city = value, ''),

              // Address is optional
              _buildTextField(
                  'Address (Optional)', (value) => address = value, ''),

              // Teacher's Name (Field for the student’s teacher)
              _buildTextField(
                  'Student\'s Teacher Name',
                  (value) => teacherName = value,
                  'Please enter teacher\'s name'),

              // WhatsApp Contact Number field
              _buildTextField(
                  'WhatsApp Contact No.',
                  (value) => whatsappNumber = value,
                  'Please enter WhatsApp contact number'),

              // Occupation is optional
              _buildTextField(
                  'Occupation (Optional)', (value) => occupation = value, ''),

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
