import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';

class StudentDashboardScreen extends StatefulWidget {
  @override
  _StudentDashboardScreenState createState() => _StudentDashboardScreenState();
}

class Course {
  final String courseName;
  final String teacherName;
  final List<String> days;
  final String classroom;

  Course({
    required this.courseName,
    required this.teacherName,
    required this.days,
    required this.classroom,
  });
}

class Test {
  final String subject;
  final DateTime testDateTime;
  final String portion;

  Test({
    required this.subject,
    required this.testDateTime,
    required this.portion,
  });
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  DateTime currentWeekStart =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  String selectedTerm = 'Term Test 1';

  // Scores for each term test
  final Map<String, List<Map<String, dynamic>>> termScores = {
    'Term Test 1': [
      {
        'subject': 'Math',
        'score': 18,
        'total': 20,
        'details': 'Algebra: 9/10, Geometry: 9/10'
      },
      {
        'subject': 'Science',
        'score': 14,
        'total': 20,
        'details': 'Physics: 7/10, Chemistry: 7/10'
      },
      {
        'subject': 'English',
        'score': 16,
        'total': 20,
        'details': 'Grammar: 8/10, Literature: 8/10'
      },
      {
        'subject': 'History',
        'score': 12,
        'total': 20,
        'details': 'World History: 6/10, Local History: 6/10'
      },
    ],
    'Term Test 2': [
      {
        'subject': 'Math',
        'score': 12,
        'total': 15,
        'details': 'Algebra: 6/7, Geometry: 6/8'
      },
      {
        'subject': 'Science',
        'score': 10,
        'total': 15,
        'details': 'Physics: 5/7, Chemistry: 5/8'
      },
      {
        'subject': 'English',
        'score': 12,
        'total': 15,
        'details': 'Grammar: 6/7, Literature: 6/8'
      },
      {
        'subject': 'History',
        'score': 10,
        'total': 15,
        'details': 'World History: 5/7, Local History: 5/8'
      },
    ],
  };
  final List<Course> enrolledCourses = [
    Course(
      courseName: "Mathematics 101",
      teacherName: "Dr. John Smith",
      days: ["Monday", "Wednesday", "Friday"],
      classroom: "Room 202",
    ),
    Course(
      courseName: "Physics 101",
      teacherName: "Prof. Jane Doe",
      days: ["Tuesday", "Thursday"],
      classroom: "Room 305",
    ),
    Course(
      courseName: "English Literature",
      teacherName: "Mrs. Emily Davis",
      days: ["Monday", "Wednesday"],
      classroom: "Room 101",
    ),
  ];
  final List<Test> upcomingTests = [
    Test(
      subject: "Mathematics - Algebra",
      testDateTime: DateTime(2024, 12, 10, 9, 30),
      portion: "Chapters 1-4, Quadratic Equations", // Portion for Math test
    ),
    Test(
      subject: "Physics - Mechanics",
      testDateTime: DateTime(2024, 12, 12, 14, 0),
      portion: "Kinematics, Laws of Motion", // Portion for Physics test
    ),
    Test(
      subject: "Chemistry - Organic Chemistry",
      testDateTime: DateTime(2024, 12, 15, 11, 0),
      portion:
          "Hydrocarbons, Alcohols and Phenols", // Portion for Chemistry test
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        title: Text(
          'Dashboard',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildSearchBar(),
              //_buildProgressChart(),
              _buildSubjectBreakdown(),
              _buildQuoteCard(),
              _buildUpcomingTests(),
              _buildEnrolledCourses(),
              _buildTasksMilestones(),
              // _buildSkillBreakdown(), // Add skill breakdown section here
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, Simran!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Track your progress',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ],
          ),
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
                'https://example.com/placeholder.jpg'), // Replace with valid image URL
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          decoration: InputDecoration(
            icon: Icon(Icons.search, color: Colors.grey),
            hintText: 'Search...',
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

// Random instance to generate random values
  Random random = Random();

  Widget _buildProgressBar(String day, String date) {
    // Random progress between 0.0 and 1.0
    double progress = random.nextDouble();

    // Randomly select an emoji based on progress
    String emoji = _getEmojiForProgress(progress);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(emoji),
        SizedBox(height: 8),
        Container(
          width: 30,
          height: 110 * progress, // Adjust height based on progress
          decoration: BoxDecoration(
            color: Colors.purple[200],
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        SizedBox(height: 8),
        Text(
          day,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        Text(
          date,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  String _getEmojiForProgress(double progress) {
    if (progress < 0.3) {
      return '😞'; // Sad emoji for low progress
    } else if (progress < 0.6) {
      return '😐'; // Neutral emoji for medium progress
    } else if (progress < 0.9) {
      return '🙂'; // Slightly happy emoji for good progress
    } else {
      return '😊'; // Very happy emoji for excellent progress
    }
  }

  // Week Navigator logic
  Widget _buildWeekNavigator() {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () {
            setState(() {
              currentWeekStart = currentWeekStart.subtract(Duration(days: 7));
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios, size: 18),
          onPressed: () {
            setState(() {
              currentWeekStart = currentWeekStart.add(Duration(days: 7));
            });
          },
        ),
      ],
    );
  }

  Widget _buildProgressChart() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        height: 280,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quiz Weekly Progress',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildWeekNavigator(),
              ],
            ),
            SizedBox(height: 10),
            Text(
              '${DateFormat('MMMM d, y').format(currentWeekStart)} - ${DateFormat('MMMM d, y').format(currentWeekStart.add(Duration(days: 6)))}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(7, (index) {
                  DateTime day = currentWeekStart.add(Duration(days: index));
                  return _buildProgressBar(
                    DateFormat('E').format(day),
                    DateFormat('MMM d').format(day),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnrolledCourses() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enrolled Courses',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          CarouselSlider(
            options: CarouselOptions(
              height: 160, // Adjust the height of the carousel
              enlargeCenterPage: true,
              autoPlay: true,
              viewportFraction:
                  0.9, // Make cards slightly smaller for a nice margin
              enableInfiniteScroll: true, // Infinite scrolling
            ),
            items: enrolledCourses
                .map((course) => _buildCourseItem(course))
                .toList(),
          ),
        ],
      ),
    );
  }

  // Course Item Widget for Carousel
  Widget _buildCourseItem(Course course) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            course.courseName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Teacher: ${course.teacherName}",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Days: ${course.days.join(', ')}",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Classroom: ${course.classroom}",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksMilestones() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tasks & Milestones',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          _buildTaskItem('Math Assignment', 'Completed', true),
          _buildTaskItem('Physics Lab Report', 'Due Tomorrow', false),
          _buildTaskItem('Literature Essay', 'Due in 3 days', false),
          _buildTaskItem('Chemistry Quiz', 'Completed', true),
        ],
      ),
    );
  }

  Widget _buildTaskItem(String title, String status, bool completed) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: completed ? Color(0xFFE8F3F1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 4),
              Text(
                status,
                style: TextStyle(
                  color: completed ? Colors.green : Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Icon(
            completed ? Icons.check_circle : Icons.arrow_forward_ios,
            color: completed ? Colors.green : Colors.grey,
          ),
        ],
      ),
    );
  }

  // Upcoming Tests Widget
  Widget _buildUpcomingTests() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 20, horizontal: 20), // Added horizontal padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upcoming Tests',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          // Wrap the ListView.builder with Padding for internal spacing
          Padding(
            padding: EdgeInsets.only(
                left: 10), // Add padding at the start of the list
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: upcomingTests.length,
              itemBuilder: (context, index) {
                final test = upcomingTests[index];
                return _buildTestItem(test);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Test Item Widget
  Widget _buildTestItem(Test test) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Side: Subject and Portion
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                test.subject,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Date: ${DateFormat('MMMM d, yyyy').format(test.testDateTime)}",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              Text(
                "Time: ${DateFormat('h:mm a').format(test.testDateTime)}",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 8),
              // Portion
              Text(
                "Portion: ${test.portion}",
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectBreakdown() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Grades ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          // Overall percentage card
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overall Percentage',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '89.50%',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Current Semester: First Semester 2023-24',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.arrow_upward, size: 16, color: Colors.green),
                    SizedBox(width: 4),
                    Text(
                      '2.5% from last semester',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Best Performing Subject',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.green[700],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Computer Science',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Keep up the excellent work in this subject!',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Test Scores',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),

          // Dropdown for selecting Term Test
          DropdownButton<String>(
            value: selectedTerm,
            items: ['Term Test 1', 'Term Test 2']
                .map((term) => DropdownMenuItem<String>(
                      value: term,
                      child: Text(term),
                    ))
                .toList(),
            onChanged: (newTerm) {
              setState(() {
                selectedTerm = newTerm!;
              });
            },
          ),

          SizedBox(height: 16),

          // Bar chart displaying the subject breakdown for the selected term
          Container(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: selectedTerm == 'Term Test 1'
                    ? 20
                    : 15, // Update maxY based on selected term
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      String subjectName = '';
                      String details = '';
                      int score = 0;
                      int total = 0;

                      // Get the score and details based on selected term
                      var selectedScores = termScores[selectedTerm]!;
                      var subject = selectedScores[group.x.toInt()];
                      subjectName = subject['subject'];
                      score = subject['score'];
                      total = subject['total'];
                      details = subject['details'];

                      return BarTooltipItem(
                        '$subjectName\n',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: '$score / $total\n',
                            style: const TextStyle(
                              color: Colors.yellow,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: details,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        );
                        String text;
                        switch (value.toInt()) {
                          case 0:
                            text = 'Math';
                            break;
                          case 1:
                            text = 'Science';
                            break;
                          case 2:
                            text = 'English';
                            break;
                          case 3:
                            text = 'History';
                            break;
                          default:
                            text = '';
                        }
                        return Text(text, style: style);
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                        color: Colors.black.withOpacity(0.1), width: 1)),
                barGroups:
                    termScores[selectedTerm]!.asMap().entries.map((entry) {
                  int index = entry.key;
                  var subject = entry.value;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                          toY: subject['score'].toDouble(),
                          color: _getColorForSubject(index),
                          width: 20),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForSubject(int index) {
    // Colors for the bars based on subject index
    switch (index) {
      case 0:
        return Colors.purple[300]!;
      case 1:
        return Colors.orange[300]!;
      case 2:
        return Colors.blue[300]!;
      case 3:
        return Colors.green[300]!;
      default:
        return Colors.grey;
    }
  }

  Widget _buildQuoteCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.purple[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.format_quote, color: Colors.purple),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                '"The journey of a thousand miles begins with one step." - Lao Tzu',
                style: TextStyle(color: Colors.purple[800], fontSize: 16),
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
