import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:translator/translator.dart';
import 'package:udaan_app/student/online_class_feature/class_details_page.dart';
import 'package:udaan_app/student/quiz_feature/quiz_app.dart';
import 'package:udaan_app/student/online_class_feature/timetable_page.dart';
import 'package:udaan_app/student/student_dashboard.dart';

class TeacherHomepage extends StatefulWidget {
  const TeacherHomepage({Key? key}) : super(key: key);

  @override
  _TeacherHomepageState createState() => _TeacherHomepageState();
}

class _TeacherHomepageState extends State<TeacherHomepage> {
  int _selectedIndex = 0;
  final translator = GoogleTranslator();
  bool _isEnglish = true;

  final List<Map<String, dynamic>> _features = [
    {
      'title': 'Dropout Detection Alerts',
      'icon': Icons.warning,
      'color': Colors.blue,
      'description': 'AI-predicted warnings for at-risk students',
    },
    {
      'title': 'Student Reports',
      'icon': Icons.assessment,
      'color': Colors.orange,
      'description': 'View individual and batch performance analytics',
    },
    {
      'title': 'Educational Content Upload',
      'icon': Icons.psychology_outlined,
      'color': Colors.green,
      'description': 'Upload materials with tagging and classification',
    },
  ];

  Future<String> _translateText(String text) async {
    if (_isEnglish) {
      return text;
    } else {
      var translation = await translator.translate(text, from: 'en', to: 'hi');
      return translation.text;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigation logic
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SchedulePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String>(
          future: _translateText('Teacher Homepage'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Text(snapshot.data ?? 'Teacher Homepage');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          IconButton(
            icon: Icon(_isEnglish ? Icons.language : Icons.translate),
            onPressed: () {
              setState(() {
                _isEnglish = !_isEnglish;
              });
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Text(
                ' ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: FutureBuilder<String>(
                future: _translateText('Home'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Text(snapshot.data ?? 'Home');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: FutureBuilder<String>(
                future: _translateText('Dashboard'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Text(snapshot.data ?? 'Dashboard');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StudentDashboardScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: FutureBuilder<String>(
                future: _translateText('Quiz'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Text(snapshot.data ?? 'Quiz');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizApp()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_call),
              title: FutureBuilder<String>(
                future: _translateText('Online Class'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Text(snapshot.data ?? 'Online Class');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SchedulePage()),
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // User Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<String>(
                      future: _translateText('Mr Smith'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Text(
                            snapshot.data ?? 'Mr Smith',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                    FutureBuilder<String>(
                      future: _translateText('12th Grade'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Text(
                            snapshot.data ?? '12th Grade',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search for lessons',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 20),

            // Metrics Row
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    icon: Icons.class_,
                    value: '5',
                    label: 'Classes Today',
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricCard(
                    icon: Icons.add,
                    value: 'Math',
                    label: 'Course',
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Application Tracker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FutureBuilder<String>(
                  future: _translateText('Student Report'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Text(
                        snapshot.data ?? 'Student Report',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      FutureBuilder<String>(
                        future: _translateText('See All'),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Text(snapshot.data ?? 'See All');
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                      const Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<String>(
                    future: _translateText('Student Report'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Text(
                          snapshot.data ?? 'Student Report',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder<String>(
                    future: _translateText('Check your class report'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Text(
                          snapshot.data ?? 'Check your class report',
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Features Section
            FutureBuilder<String>(
              future: _translateText('Features'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Text(
                    snapshot.data ?? 'Features',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return _buildFeatureCard(
                    _features[index]['title'],
                    _features[index]['icon'],
                    _features[index]['color'],
                    _features[index]['description'],
                  );
                },
                itemCount: _features.length,
                viewportFraction: 0.8,
                scale: 0.9,
                pagination: const SwiperPagination(),
                control: const SwiperControl(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Subjects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_call),
            label: 'Online Class',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Chat Bubble Pressed');
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.chat_bubble_outline),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          FutureBuilder<String>(
            future: _translateText(label),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Text(snapshot.data ?? label);
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    String title,
    IconData icon,
    Color color,
    String description,
  ) {
    return GestureDetector(
      onTap: () {
        // todo
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 12),
            FutureBuilder<String>(
              future: _translateText(title),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Text(
                    snapshot.data ?? title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            const SizedBox(height: 4),
            FutureBuilder<String>(
              future: _translateText(description),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Text(
                    snapshot.data ?? description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
