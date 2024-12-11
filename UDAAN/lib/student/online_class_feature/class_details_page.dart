import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math' as math;
import 'package:udaan_app/views/HomePage.dart';
//import 'package:udaan_app/student/online_class_feature/video_call_screen.dart';

class ClassDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('English grammar',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('Will start in 1:20 min',
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Students',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          CircleAvatar(child: Text('U1')),
                          SizedBox(width: 4),
                          CircleAvatar(child: Text('U2')),
                          SizedBox(width: 4),
                          CircleAvatar(child: Text('U3')),
                          SizedBox(width: 4),
                          CircleAvatar(
                              child: Text('+12'), backgroundColor: Colors.grey),
                        ],
                      ),
                      SizedBox(height: 24),
                      Text('Lessons theme',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text(
                        'Review and extend your knowledge of the present simple, present perfect and present continuous tenses.',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 24),
                      Text('Additional materials',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          FlippingBook(
                            frontColor: Colors.green,
                            backColor: Colors.green[100]!,
                            frontTitle: 'Book 1',
                            backTitle: '',
                          ),
                          SizedBox(width: 16),
                        ],
                      ),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                  child: Text('Join class'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    Get.to(() => HomePage());
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class FlippingBook extends StatefulWidget {
  final Color frontColor;
  final Color backColor;
  final String frontTitle;
  final String backTitle;

  const FlippingBook({
    Key? key,
    required this.frontColor,
    required this.backColor,
    required this.frontTitle,
    required this.backTitle,
  }) : super(key: key);

  @override
  _FlippingBookState createState() => _FlippingBookState();
}

class _FlippingBookState extends State<FlippingBook>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleFlip() {
    if (_isFlipped) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    _isFlipped = !_isFlipped;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFlip,
      child: SizedBox(
        width: 160,
        height: 120,
        child: Stack(
          children: [
            Transform(
              alignment: Alignment.centerRight,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(-math.pi * _animation.value),
              child: _animation.value <= 0.5
                  ? _buildBookSide(widget.frontColor, widget.frontTitle)
                  : Container(),
            ),
            Transform(
              alignment: Alignment.centerLeft,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(math.pi * (1 - _animation.value)),
              child: _animation.value > 0.5
                  ? _buildBookSide(widget.backColor, widget.backTitle)
                  : Container(),
            ),
            if (_animation.value == 1.0)
              Positioned(
                left: 80,
                child: _buildBookSide(widget.backColor, widget.backTitle),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookSide(Color color, String title) {
    return Container(
      width: 80,
      height: 120,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
