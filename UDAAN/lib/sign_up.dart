import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:udaan_app/login_screen.dart';
import 'package:udaan_app/student/student_profile.dart'; // Assume the StudentProfileForm exists
import 'package:udaan_app/parent/parent_profile.dart'; // Placeholder for ParentProfileForm
import 'package:udaan_app/teacher/teacher_profile.dart'; // Placeholder for TeacherProfileForm

// Enum for Role
enum Role { student, parent, teacher }

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String? name, lastName, email, password, parentEmail, studentId;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final parentEmailController = TextEditingController();
  final studentIdController = TextEditingController();
  Role? _role = Role.student;

  StateMachineController? controller;
  SMIInput<bool>? isChecking;

  void _onRiveInit(Artboard artboard) {
    controller = StateMachineController.fromArtboard(
      artboard,
      'Login Machine',
    );
    if (controller != null) {
      artboard.addController(controller!);
      isChecking = controller?.findInput('isChecking');
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Navigate based on role selection
      switch (_role) {
        case Role.student:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  StudentProfileForm(), // Navigate to student profile form
            ),
          );
          break;
        case Role.parent:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ParentProfileForm(), // Navigate to parent profile form
            ),
          );
          break;
        case Role.teacher:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TeacherProfileForm(), // Navigate to teacher profile form
            ),
          );
          break;
        default:
          break;
      }
      // Debug information (you can remove this when done)
      print('Role: $_role');
      print('Name: $name');
      print('Last Name: $lastName');
      print('Email: $email');
      print('Password: $password');
      if (_role == Role.student) {
        print('Parent Email: $parentEmail');
      }
      if (_role == Role.parent) {
        print('Student ID: $studentId');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(216, 228, 236, 1.0),
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Rive animation section
                SizedBox(
                  height: 400,
                  width: 400,
                  child: RiveAnimation.asset(
                    "assets/login-teddy.riv",
                    fit: BoxFit.contain,
                    onInit: _onRiveInit,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'UDAAN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2C4D),
                  ),
                ),
                const SizedBox(height: 32),
                // Dropdown for role selection
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Role>(
                      isExpanded: true,
                      value: _role,
                      items: Role.values.map((Role role) {
                        return DropdownMenuItem<Role>(
                          value: role,
                          child: Text(
                            role.toString().split('.').last.capitalize(),
                            style: TextStyle(
                              color: Color(0xFF1E2C4D),
                              fontSize: 16,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (Role? newValue) {
                        setState(() {
                          _role = newValue;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Sign-in form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Name',
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter your name' : null,
                        onSaved: (value) => name = value,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Last Name',
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) => value!.isEmpty
                            ? 'Please enter your last name'
                            : null,
                        onSaved: (value) => lastName = value,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) => !value!.contains('@')
                            ? 'Please enter a valid email'
                            : null,
                        onSaved: (value) => email = value,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) => value!.length < 6
                            ? 'Password must be at least 6 characters'
                            : null,
                        onSaved: (value) => password = value,
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),
                      // Conditionally show Parent's Email Field (For Student)
                      if (_role == Role.student) ...[
                        TextFormField(
                          controller: parentEmailController,
                          decoration: InputDecoration(
                            hintText: 'Parent\'s Email',
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) => !value!.contains('@')
                              ? 'Please enter a valid email'
                              : null,
                          onSaved: (value) => parentEmail = value,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                      ],
                      // Conditionally show Student ID Field (For Parent)
                      if (_role == Role.parent) ...[
                        TextFormField(
                          controller: studentIdController,
                          decoration: InputDecoration(
                            hintText: 'Student ID',
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) => value!.isEmpty
                              ? 'Please enter the student\'s ID'
                              : null,
                          onSaved: (value) => studentId = value,
                        ),
                        const SizedBox(height: 16),
                      ],
                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF1E2C4D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Already have an account? Login
                TextButton(
                  onPressed: () {
                    debugPrint('Navigating to Login Screen...');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LoginScreen()), // Check this constructor
                    );
                  },
                  child: const Text(
                    'Already have an account? Login',
                    style: TextStyle(
                      color: Color(0xFF1E2C4D),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension StringCapitalization on String {
  String capitalize() {
    return this[0].toUpperCase() + this.substring(1);
  }
}
