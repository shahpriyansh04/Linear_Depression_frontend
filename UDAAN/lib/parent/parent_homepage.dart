import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:translator/translator.dart';
import 'package:udaan_app/parent/community_learning.dart';
import 'package:udaan_app/parent/dropout_details.dart';
import 'package:udaan_app/parent/news_feature/resource_list.dart';
import 'package:udaan_app/parent/parent_notification.dart';
import 'package:udaan_app/student/student_dashboard.dart';

class ParentHomepage extends StatefulWidget {
  const ParentHomepage({Key? key}) : super(key: key);

  @override
  _ParentHomepageState createState() => _ParentHomepageState();
}

class _ParentHomepageState extends State<ParentHomepage>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  final translator = GoogleTranslator();
  bool _isEnglish = true;

  // Dummy student data
  String studentName = "Jane Doe";
  double dropoutRisk = 0.0;

  // Feature data
  final List<Map<String, dynamic>> _features = [
    {
      'title': 'Community Learning',
      'icon': Icons.group_outlined,
      'color': Colors.blue,
      'description': 'Collaborative learning with other parents and children',
    },
    {
      'title': 'AI Drop-out Detection',
      'icon': Icons.warning_amber_outlined,
      'color': Colors.orange,
      'description': 'Identify potential dropouts early with AI algorithms',
    },
    {
      'title': 'AI Powered Chatbot',
      'icon': Icons.chat_bubble_outline,
      'color': Colors.green,
      'description': 'Get instant AI-based assistance for parenting',
    },
    {
      'title': 'Progress Monitoring for Children',
      'icon': Icons.trending_up_outlined,
      'color': Colors.purple,
      'description': 'Track academic progress and behavior of your children',
    },
  ];

  late AnimationController _animationController;

  // Translate text based on language
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
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => StudentDashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String>(
          future: _translateText('Parent Homepage'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Text(snapshot.data ?? 'Parent Homepage');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => NotificationsPage()),
              );
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
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage('assets/drawer_header.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/profile_picture.jpg'),
                  ),
                  SizedBox(height: 8),
                  FutureBuilder<String>(
                    future: _translateText('Jane Doe'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Text(
                          snapshot.data ?? 'Jane Doe',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                  FutureBuilder<String>(
                    future: _translateText('Parent'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Text(
                          snapshot.data ?? 'Parent',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
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
            _buildDrawerListTile('Home', Icons.home),
            _buildDrawerListTile('Parent Dashboard', Icons.dashboard),
            _buildDrawerListTile('Progress Monitoring', Icons.assignment),
            _buildDrawerListTile('AI Chatbot', Icons.chat),
            _buildDrawerListTile('News', Icons.library_books, onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ResourceListScreen()),
              );
            }),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<String>(
                      future: _translateText(studentName),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Text(
                            snapshot.data ?? studentName,
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
                      future: _translateText('Parent'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Text(
                            snapshot.data ?? 'Parent',
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
            FutureBuilder<String>(
              future: _translateText('Search for lessons'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return TextField(
                    decoration: InputDecoration(
                      hintText: snapshot.data ?? 'Search for lessons',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    icon: Icons.calendar_today,
                    value: '85%',
                    label: 'Attendance',
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricCard(
                    icon: Icons.star,
                    value: '1023',
                    label: 'Total Points',
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildUpcomingEventsSection(),
            const SizedBox(height: 20),
            _buildFeatureCardSection(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'School',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_call),
            label: 'Online Class',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('AI Chatbot Pressed');
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.chat_bubble_outline, color: Colors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildDrawerListTile(String title, IconData icon,
      {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: FutureBuilder<String>(
        future: _translateText(title),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Text(snapshot.data ?? title);
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      onTap: onTap,
    );
  }

  Widget _buildFeatureCardSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
    );
  }

  Widget _buildFeatureCard(
      String title, IconData icon, Color color, String description) {
    return GestureDetector(
      onTap: () {
        if (title == 'Community Learning') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CommunityPage()),
          );
        }
        // Add navigation or actions for other features
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 12),
            FutureBuilder<String>(
              future: _translateText(title),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Text(
                    snapshot.data ?? title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            const SizedBox(height: 8),
            FutureBuilder<String>(
              future: _translateText(description),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Text(
                    snapshot.data ?? description,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
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

  Widget _buildMetricCard(
      {required IconData icon,
      required String value,
      required String label,
      required Color color}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingEventsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder<String>(
          future: _translateText('Upcoming Events'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Text(
                snapshot.data ?? 'Upcoming Events',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            ListTile(
              leading: Icon(Icons.event, color: Colors.orange),
              title: Text('Annual Day'),
              subtitle: Text('December 25, 2024'),
            ),
            ListTile(
              leading: Icon(Icons.event, color: Colors.green),
              title: Text('Parent-Teacher Meeting'),
              subtitle: Text('December 12, 2024'),
            ),
          ],
        ),
      ],
    );
  }
}
