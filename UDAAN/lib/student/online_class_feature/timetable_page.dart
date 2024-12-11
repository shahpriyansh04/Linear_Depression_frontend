import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this package for date formatting

import 'class_details_page.dart';

class SchedulePage extends StatelessWidget {
  // Get the current date
  DateTime now = DateTime.now();

  // Get the current day of the week index (1 = Monday, 7 = Sunday)
  int currentDayIndex;

  SchedulePage({Key? key})
      : currentDayIndex = DateTime.now().weekday - 1,
        super(key: key);

  // Generate the list of weekdays dynamically based on current day
  List<String> generateWeekDays() {
    List<String> weekDays = [];
    for (int i = 0; i < 7; i++) {
      // Calculate the weekday starting from today
      DateTime date = now.add(Duration(days: i - currentDayIndex));
      // Format the weekday
      String formattedDay = DateFormat('EEE').format(date).toUpperCase();
      weekDays.add(formattedDay);
    }
    return weekDays;
  }

  // Generate the list of dates dynamically for this week
  List<String> generateDates() {
    List<String> dates = [];
    for (int i = 0; i < 7; i++) {
      // Calculate the date starting from today
      DateTime date = now.add(Duration(days: i - currentDayIndex));
      // Format the date
      dates.add(DateFormat('dd').format(date));
    }
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> weekDays = generateWeekDays();
    final List<String> dates = generateDates();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text('Time Table',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Icon(Icons.search),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('This week',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {},
                    child:
                        Text('See all', style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(7, (index) {
                  bool isSelected = index == currentDayIndex;
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: isSelected
                        ? BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          )
                        : null,
                    child: Column(
                      children: [
                        Text(
                          weekDays[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          dates[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  ScheduleItem(
                    time: '8:00am',
                    subject: 'Basic mathematics',
                    duration: '08:00am - 8:45am',
                    color: Colors.blue[50]!,
                  ),
                  ScheduleItem(
                    time: '10:00am',
                    subject: 'English Grammar',
                    duration: '10:00am - 11:10am',
                    color: Colors.cyan[50]!,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ClassDetailsPage()),
                      );
                    },
                  ),
                  ScheduleItem(
                    time: '12:00am',
                    subject: 'Science',
                    duration: '12:00am - 12:45am',
                    color: Colors.yellow[50]!,
                  ),
                  ScheduleItem(
                    time: '1:00pm',
                    subject: 'World history',
                    duration: '1:00pm - 1:50pm',
                    color: Colors.purple[50]!,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScheduleItem extends StatelessWidget {
  final String time;
  final String subject;
  final String duration;
  final Color color;
  final VoidCallback? onTap;

  const ScheduleItem({
    Key? key,
    required this.time,
    required this.subject,
    required this.duration,
    required this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(time, style: TextStyle(color: Colors.grey)),
          SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(subject,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(duration, style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
