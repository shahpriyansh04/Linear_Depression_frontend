import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teacher\'s Interface',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ReportScreen(),
    );
  }
}

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<Student> students = [
    Student(name: 'Alice', grade: 'A', dropoutScore: 0.2, weeklyProgress: 0.8, monthlyProgress: 0.75),
    Student(name: 'Bob', grade: 'B', dropoutScore: 0.4, weeklyProgress: 0.6, monthlyProgress: 0.7),
    Student(name: 'Charlie', grade: 'C', dropoutScore: 0.6, weeklyProgress: 0.5, monthlyProgress: 0.55),
    Student(name: 'David', grade: 'B+', dropoutScore: 0.3, weeklyProgress: 0.7, monthlyProgress: 0.8),
    Student(name: 'Eva', grade: 'A-', dropoutScore: 0.1, weeklyProgress: 0.9, monthlyProgress: 0.85),
    Student(name: 'Frank', grade: 'C+', dropoutScore: 0.5, weeklyProgress: 0.55, monthlyProgress: 0.6),
  ];

  String? selectedClass;
  String? selectedGrade;
  bool filterWeeklyProgress = false;
  bool filterMonthlyProgress = false;

  void _showStudentDetails(Student student) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StudentDetailsSheet(student: student),
    );
  }

  List<Student> get filteredStudents {
    return students.where((student) {
      if (selectedClass != null && student.name[0] != selectedClass) return false;
      if (selectedGrade != null && student.grade != selectedGrade) return false;
      if (filterWeeklyProgress && student.weeklyProgress < 0.7) return false;
      if (filterMonthlyProgress && student.monthlyProgress < 0.7) return false;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Reports'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          FilterBar(
            onClassSelected: (value) => setState(() => selectedClass = value),
            onGradeSelected: (value) => setState(() => selectedGrade = value),
            onWeeklyProgressSelected: (value) => setState(() => filterWeeklyProgress = value),
            onMonthlyProgressSelected: (value) => setState(() => filterMonthlyProgress = value),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filteredStudents.length,
              itemBuilder: (context, index) {
                return StudentCard(
                  student: filteredStudents[index],
                  onTap: () => _showStudentDetails(filteredStudents[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Student {
  final String name;
  final String grade;
  final double dropoutScore;
  final double weeklyProgress;
  final double monthlyProgress;

  Student({
    required this.name,
    required this.grade,
    required this.dropoutScore,
    required this.weeklyProgress,
    required this.monthlyProgress,
  });
}

class StudentCard extends StatelessWidget {
  final Student student;
  final VoidCallback onTap;

  const StudentCard({Key? key, required this.student, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Grade: ${student.grade}',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Dropout Risk',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: 1 - student.dropoutScore,
                    backgroundColor: Colors.red[100],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      student.dropoutScore < 0.3 ? Colors.green :
                      student.dropoutScore < 0.6 ? Colors.orange : Colors.red,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Dropout Risk: ${(student.dropoutScore * 100).toStringAsFixed(0)}%',
                    style: GoogleFonts.roboto(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.3,
                      height: 1.4,
                      color: Color(0xff1d1b20),
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.start,
                    textHeightBehavior: TextHeightBehavior(
                      applyHeightToFirstAscent: false,
                      applyHeightToLastDescent: false,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class FilterBar extends StatelessWidget {
  final Function(String?) onClassSelected;
  final Function(String?) onGradeSelected;
  final Function(bool) onWeeklyProgressSelected;
  final Function(bool) onMonthlyProgressSelected;

  const FilterBar({
    Key? key,
    required this.onClassSelected,
    required this.onGradeSelected,
    required this.onWeeklyProgressSelected,
    required this.onMonthlyProgressSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            DropdownButton<String>(
              hint: Text('Class'),
              items: ['A', 'B', 'C', 'D', 'E', 'F'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: onClassSelected,
            ),
            SizedBox(width: 16),
            DropdownButton<String>(
              hint: Text('Grade'),
              items: ['A', 'B', 'C', 'D', 'F'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: onGradeSelected,
            ),
            SizedBox(width: 16),
            FilterChip(
              label: Text('High Weekly Progress'),
              onSelected: onWeeklyProgressSelected,
            ),
            SizedBox(width: 8),
            FilterChip(
              label: Text('High Monthly Progress'),
              onSelected: onMonthlyProgressSelected,
            ),
          ],
        ),
      ),
    );
  }
}

class StudentDetailsSheet extends StatelessWidget {
  final Student student;

  const StudentDetailsSheet({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: controller,
            padding: EdgeInsets.all(24),
            children: [
              Text(
                student.name,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
              SizedBox(height: 8),
              Text(
                'Grade: ${student.grade}',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              SizedBox(height: 24),
              _buildProgressSection(
                title: 'Dropout Risk',
                value: student.dropoutScore,
                color: student.dropoutScore < 0.3 ? Colors.green :
                       student.dropoutScore < 0.6 ? Colors.orange : Colors.red,
              ),
              SizedBox(height: 32),
              Text('Progress Over Time', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              SizedBox(height: 16),
              Container(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey[300]!, width: 1)),
                    minX: 0,
                    maxX: 6,
                    minY: 0,
                    maxY: 1,
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          FlSpot(0, 0.5),
                          FlSpot(1, 0.6),
                          FlSpot(2, 0.55),
                          FlSpot(3, 0.7),
                          FlSpot(4, 0.8),
                          FlSpot(5, 0.75),
                          FlSpot(6, student.monthlyProgress),
                        ],
                        isCurved: true,
                        color: Colors.deepPurple,
                        barWidth: 4,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: true, color: Colors.deepPurple.withOpacity(0.1)),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),
              _buildProgressSection(
                title: 'Weekly Progress',
                value: student.weeklyProgress,
                color: Colors.blue,
              ),
              SizedBox(height: 24),
              _buildProgressSection(
                title: 'Monthly Progress',
                value: student.monthlyProgress,
                color: Colors.green,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressSection({required String title, required double value, required Color color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
        SizedBox(height: 8),
        LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
        ),
        SizedBox(height: 8),
        Text(
          '${(value * 100).toStringAsFixed(0)}%',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}

