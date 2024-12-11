import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:udaan_app/parent/parent_homepage.dart';
import 'package:udaan_app/sign_up.dart';
import 'package:udaan_app/student/student_homepage.dart';

enum Role { student, parent, teacher }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers for the text fields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Controllers for Rive animation
  StateMachineController? controller;
  SMIInput<bool>? isChecking;
  SMIInput<bool>? isHandsUp;
  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;

  // Role for dropdown
  Role? _role = Role.student; // Default value

  @override
  void initState() {
    super.initState();
  }

  void _onRiveInit(Artboard artboard) {
    controller = StateMachineController.fromArtboard(
      artboard,
      'Login Machine',
    );
    if (controller != null) {
      artboard.addController(controller!);
      isChecking = controller?.findInput('isChecking');
      isHandsUp = controller?.findInput('isHandsUp');
      trigSuccess = controller?.findInput('trigSuccess');
      trigFail = controller?.findInput('trigFail');
    }
  }

  void _validateEmailPassword() async {
    isChecking?.change(true);
    await Future.delayed(const Duration(seconds: 1));
    if (emailController.text == 'test@test.com' &&
        passwordController.text == 'password') {
      trigSuccess?.change(true);

      // Redirect based on role after successful login
      if (_role == Role.student) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const StudentHomepage()),
        );
      } else if (_role == Role.parent) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ParentHomepage()),
        );
      } else if (_role == Role.teacher) {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => const TeacherHomePage()),
        // );
      }
    } else {
      trigFail?.change(true);
    }
    isChecking?.change(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(216, 228, 236, 1.0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 32),
                // Rive Animation Container
                SizedBox(
                  height: 400,
                  width: 400,
                  child: RiveAnimation.asset(
                    "assets/login-teddy.riv",
                    fit: BoxFit.contain,
                    onInit: _onRiveInit,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'UDAAN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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
                // Email TextField
                TextField(
                  controller: emailController,
                  onChanged: (_) => isHandsUp?.change(false),
                  onTap: () => isHandsUp?.change(true),
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Password TextField
                TextField(
                  controller: passwordController,
                  onChanged: (_) => isHandsUp?.change(false),
                  onTap: () => isHandsUp?.change(true),
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _validateEmailPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E2C4D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Navigate to Sign Up
                TextButton(
                  onPressed: () {
                    debugPrint('Navigating to Sign Up Screen...');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SignUpPage()), // Ensure SignUpPage constructor is correct
                    );
                  },
                  child: const Text(
                    'Do not have an account? SignUp',
                    style: TextStyle(
                      color: Color(0xFF1E2C4D),
                      fontSize: 16,
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

  @override
  void dispose() {
    controller?.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
