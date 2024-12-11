import 'package:flutter/material.dart';
import 'package:udaan_app/student/quiz_feature/make_quiz.dart';
import 'package:udaan_app/student/quiz_feature/quiz_history.dart';
import 'package:udaan_app/student/quiz_feature/quiz_screen.dart';

class QuizApp extends StatefulWidget {
  const QuizApp({Key? key}) : super(key: key);

  @override
  _QuizAppState createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  int _selectedIndex = 0;

  // List of screens for each bottom navigation item
  final List<Widget> _screens = [
    const QuizHomeScreen(),
    const StatsScreen(),
    QuizHistoryPage(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
      ),
      body: _screens[_selectedIndex], // Show the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // Handle item taps
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal[700],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
          BottomNavigationBarItem(
              icon: Icon(Icons.history), label: 'Quiz History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class QuizHomeScreen extends StatelessWidget {
  const QuizHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(
                            context); // Navigate back to the previous screen
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'What Subject do\nyou want to improve\ntoday?',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search here',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.green[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  SubjectCard(
                    title: 'Geometry',
                    color: Colors.teal[700]!,
                    icon: Icons.category,
                    onTap: () => _startQuiz(context, 'Geometry'),
                  ),
                  SubjectCard(
                    title: 'Physics',
                    color: Colors.blue[700]!,
                    icon: Icons.science,
                    onTap: () => _startQuiz(context, 'Physics'),
                  ),
                  SubjectCard(
                    title: 'Chemistry',
                    color: Colors.purple[700]!,
                    icon: Icons.science_outlined,
                    onTap: () => _startQuiz(context, 'Chemistry'),
                  ),
                  SubjectCard(
                    title: 'Maths',
                    color: Colors.orange[700]!,
                    icon: Icons.functions,
                    onTap: () => _startQuiz(context, 'Maths'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startQuiz(BuildContext context, String subject) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MakeQuiz(subject: subject), // Pass the subject
      ),
    );
  }
  // void _startQuiz(BuildContext context, String subject) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => QuizScreen(subject: subject),
  //     ),
  //   );
  // }
}

class SubjectCard extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const SubjectCard({
    Key? key,
    required this.title,
    required this.color,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: color,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatsScreen extends StatelessWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Stats Screen'));
  }
}

// class QuizHistoryScreen extends StatelessWidget {
//   const QuizHistoryScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(child: Text('Quiz History Screen'));
//   }
// }

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Profile Screen'));
  }
}
