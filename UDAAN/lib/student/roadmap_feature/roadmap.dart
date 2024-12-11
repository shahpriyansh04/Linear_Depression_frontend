import 'dart:math' as math;
import 'dart:ui';

import 'package:chiclet/chiclet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:udaan_app/student/roadmap_feature/roadmap_generator.dart';
import 'package:udaan_app/student/roadmap_feature/roadmap_history.dart';
import 'package:udaan_app/student/student_homepage.dart';

class RoadmapPage extends StatefulWidget {
  const RoadmapPage({Key? key}) : super(key: key);

  @override
  State<RoadmapPage> createState() => _RoadmapPageState();
}

class _RoadmapPageState extends State<RoadmapPage> {
  int currentStep = 0;
  final int totalSteps = 6;
  final List<bool> stepCompletionStatus = List.generate(6, (index) => false);
  late Path _path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roadmap Generator'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            //Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RoadmapHistory()),
            );
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);

          // Create the curvy path based on screen size
          _path = _createCurvyPath(size);

          return SingleChildScrollView(
            // Scrollable content
            child: Container(
              color: Colors.white,
              height: size.height +
                  50, // Ensures the content fits the screen height
              child: Stack(
                children: [
                  CustomPaint(
                    size: size,
                    painter: CurvyPathPainter(path: _path),
                  ),
                  _buildSteps(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSteps(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;

        return Stack(
          children: List.generate(totalSteps, (index) {
            final double t = index / (totalSteps - 1);
            final Offset position = _getStepPosition(t, width, height);

            final stepDetail = getStepDetails(index);

            return Positioned(
              left: position.dx - 50,
              top: position.dy - 50,
              child: GestureDetector(
                onTap: () {
                  _showStepDetails(index, stepDetail);
                },
                child: Material(
                  elevation: 8,
                  shadowColor: Colors.black.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: ChicletOutlinedAnimatedButton(
                    buttonColor: _getButtonStepColor(index),
                    backgroundColor: _getStepColor(index),
                    borderColor: _getStepColor(index),
                    buttonHeight: 20,
                    //foregroundColor: Colors.blue[100],
                    onPressed: () {
                      _showStepDetails(index, stepDetail);
                    },
                    width: 100,
                    height: 70,
                    buttonType: ChicletButtonTypes.oval,
                    child: Icon(
                      Icons.auto_stories_sharp,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Offset _getStepPosition(double t, double width, double height) {
    final pathMetrics = _path.computeMetrics();
    final pathMetric = pathMetrics.first;
    final totalLength = pathMetric.length;
    final distance = totalLength * t;

    final tangent = pathMetric.getTangentForOffset(distance);

    return tangent?.position ?? Offset(width * 0.5, height * t);
  }

  Color _getStepColor(int index) {
    if (stepCompletionStatus[index]) {
      return Colors.amber;
    } else if (index == currentStep) {
      return Colors.green;
    } else {
      return Colors.grey[300]!;
    }
  }

  Color _getButtonStepColor(int index) {
    if (stepCompletionStatus[index]) {
      return Colors.amber[300]!;
    } else if (index == currentStep) {
      return Colors.green[300]!;
    } else {
      return Colors.grey[300]!;
    }
  }

  Widget _getStepIcon(int index) {
    if (stepCompletionStatus[index]) {
      return const Icon(Icons.check, color: Colors.white, size: 40);
    } else if (index == currentStep) {
      return const Icon(Icons.book, color: Colors.white, size: 40);
    } else {
      return const Icon(Icons.lock, color: Colors.white, size: 40);
    }
  }

  Map<String, dynamic> getStepDetails(int index) {
    final DateTime completionDate =
        DateTime.now().add(Duration(days: 30 * (index + 1)));
    final String formattedDate =
        DateFormat('MMM dd, yyyy').format(completionDate);

    return {
      'title': 'Step ${index + 1}',
      'description': 'Description for Step ${index + 1}',
      'completionDate': formattedDate,
      'isCurrent': index == currentStep,
    };
  }

  void _showStepDetails(int index, Map<String, dynamic> stepDetail) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.2,
          maxChildSize: 0.75,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(16),
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text(
                    stepDetail['title'],
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    stepDetail['description'],
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Completion Date',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stepDetail['completionDate'],
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        stepCompletionStatus[index] =
                            !stepCompletionStatus[index];
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: stepCompletionStatus[index]
                          ? Colors.red
                          : Colors.green,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: Text(
                      stepCompletionStatus[index]
                          ? 'Mark as Not Done'
                          : 'Mark as Done',
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Path _createCurvyPath(Size size) {
    final path = Path();
    path.moveTo(
        size.width * 0.3, size.height * 0.1); // Start at a later Y position

    for (int i = 1; i <= totalSteps; i++) {
      final t = i / totalSteps;
      final prevT = (i - 1) / totalSteps;

      final startX =
          size.width * 0.5 + (size.width * 0.4) * math.sin(prevT * math.pi * 2);
      final startY = size.height * prevT;

      final endX =
          size.width * 0.5 + (size.width * 0.4) * math.sin(t * math.pi * 2);
      final endY = size.height * t;

      final controlX =
          (startX + endX) / 2 + (i % 2 == 0 ? 0.1 : -0.1) * size.width * 0.1;
      final controlY = (startY + endY) / 2;

      path.quadraticBezierTo(controlX, controlY, endX, endY);
    }

    return path;
  }
}

class CurvyPathPainter extends CustomPainter {
  final Path path;

  CurvyPathPainter({required this.path});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0
      ..isAntiAlias = true;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
