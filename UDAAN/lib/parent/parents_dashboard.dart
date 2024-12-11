import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ParentProgressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildProgressChart(),
              // _buildQuoteCard(),
              // _buildTasksMilestones(),
              _buildSubjectBreakdown(),
              _buildSkillProgress(),
              _buildBottomNav(),
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
                'Hi, Parent!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Track your child progress',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ],
          ),
          CircleAvatar(
            radius: 20,
            backgroundImage:
                NetworkImage('/placeholder.svg?height=40&width=40'),
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

  Widget _buildProgressChart() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildProgressBar('Sun', 0.8, '😊'),
                  _buildProgressBar('Mon', 0.6, '😐'),
                  _buildProgressBar('Tue', 0.7, '🙂'),
                  _buildProgressBar('Wed', 0.4, '😕'),
                  // _buildProgressBar('Thu', 0.9, '😊'),
                  _buildProgressBar('Thu', 0.5, '😐'),
                  _buildProgressBar('Fri', 0.7, '🙂'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(String day, double progress, String emoji) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(emoji),
        SizedBox(height: 8),
        Container(
          width: 30,
          height: 120 * progress,
          decoration: BoxDecoration(
            color: Color(0xFFE8F3F1),
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
      ],
    );
  }

  Widget _buildSubjectBreakdown() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Subject Breakdown',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Container(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(enabled: false),
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
                            break;
                        }
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 4,
                          child: Text(text, style: style),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 20,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [
                    BarChartRodData(toY: 85, color: Color(0xFFE8F3F1))
                  ]),
                  BarChartGroupData(x: 1, barRods: [
                    BarChartRodData(toY: 70, color: Color(0xFFFFF4D4))
                  ]),
                  BarChartGroupData(x: 2, barRods: [
                    BarChartRodData(toY: 90, color: Color(0xFFE8F3F1))
                  ]),
                  BarChartGroupData(x: 3, barRods: [
                    BarChartRodData(toY: 75, color: Color(0xFFFFF4D4))
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillProgress() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Skill Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Builder(
            builder: (BuildContext context) {
              return Column(
                children: [
                  _buildSkillProgressItem(context, 'Communication', 0.75),
                  _buildSkillProgressItem(context, 'Critical Thinking', 0.85),
                  _buildSkillProgressItem(context, 'Problem Solving', 0.70),
                  _buildSkillProgressItem(context, 'Teamwork', 0.80),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSkillProgressItem(
      BuildContext context, String skill, double progress) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            skill,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          LinearPercentIndicator(
            width: MediaQuery.of(context).size.width - 40,
            animation: true,
            lineHeight: 20.0,
            animationDuration: 2000,
            percent: progress,
            center: Text("${(progress * 100).toInt()}%"),
            linearStrokeCap: LinearStrokeCap.roundAll,
            progressColor: Color(0xFFE8F3F1),
            backgroundColor: Colors.grey[200],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.home, color: Colors.black),
          Icon(Icons.bar_chart, color: Colors.grey),
          Icon(Icons.book, color: Colors.grey),
          Icon(Icons.person, color: Colors.grey),
        ],
      ),
    );
  }
}
