import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:intl/intl.dart';
import 'package:udaan_app/student/viva_training/report_page.dart';

class ModernRecordingScreen extends StatefulWidget {
  const ModernRecordingScreen({Key? key}) : super(key: key);

  @override
  State<ModernRecordingScreen> createState() => _ModernRecordingScreenState();
}

class _ModernRecordingScreenState extends State<ModernRecordingScreen>
    with SingleTickerProviderStateMixin {
  final AudioRecorder audioRecorder = AudioRecorder();
  late AnimationController _blobAnimationController;
  final List<double> _amplitudes = List.filled(180, 0.0);
  int _amplitudeIndex = 0;
  final ScrollController _scrollController = ScrollController();

  RecordState _recordState = RecordState.stop;
  String _currentRecordingPath = "";
  String _accumulatedText = "";
  String _currentWords = "";
  String _currentQuestion = '';
  Duration _recordingDuration = Duration.zero;
  final Duration _maxDuration = const Duration(minutes: 5);
  Timer? _timer;
  String _saveLocation = "";

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _blobAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _updateSaveLocation();
    _fetchQuestion();
  }

  @override
  void dispose() {
    _blobAnimationController.dispose();
    _timer?.cancel();
    _scrollController.dispose();
    audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    final hasPermission = await audioRecorder.hasPermission();
    if (!hasPermission) {
      print("Microphone permission denied");
    }
  }

  Future<void> _fetchQuestion() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _currentQuestion = 'What are the main features of Flutter?';
    });
  }

  Future<void> _updateSaveLocation() async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      _saveLocation = directory.path;
    });
  }

  Future<String> _getRecordingPath() async {
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    return p.join(directory.path, 'recording_$timestamp.m4a');
  }

  Future<String> _getTranscriptPath() async {
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    return p.join(directory.path, 'transcript_$timestamp.txt');
  }

  Future<void> _startRecording() async {
    try {
      _currentRecordingPath = await _getRecordingPath();
      await audioRecorder.start(RecordConfig(), path: _currentRecordingPath);

      setState(() {
        _recordState = RecordState.record;
      });

      _startTimer();
      _startAmplitudeListener();
    } catch (e) {
      print("Error starting recording: $e");
    }
  }

  void _startAmplitudeListener() {
    audioRecorder
        .onAmplitudeChanged(const Duration(milliseconds: 100))
        .listen((amp) {
      setState(() {
        _amplitudes[_amplitudeIndex] = amp.current * 2;
        _amplitudeIndex = (_amplitudeIndex + 1) % 180;
      });
    });
  }

  Future<void> _pauseRecording() async {
    try {
      await audioRecorder.pause();
      setState(() {
        _recordState = RecordState.pause;
      });
      _timer?.cancel();
    } catch (e) {
      print("Error pausing recording: $e");
    }
  }

  Future<void> _resumeRecording() async {
    try {
      await audioRecorder.resume();
      setState(() {
        _recordState = RecordState.record;
      });
      _startTimer();
      _startAmplitudeListener();
    } catch (e) {
      print("Error resuming recording: $e");
    }
  }

  Future<void> _stopRecording() async {
    try {
      await audioRecorder.stop();
      await _saveRecordingAndTranscript();

      setState(() {
        _recordState = RecordState.stop;
        _recordingDuration = Duration.zero;
      });

      await _fetchQuestion();
    } catch (e) {
      print("Error stopping recording: $e");
    }
  }

  Future<void> _saveRecordingAndTranscript() async {
    try {
      final transcriptPath = await _getTranscriptPath();
      final transcriptFile = File(transcriptPath);
      await transcriptFile.writeAsString(_accumulatedText);

      setState(() {
        _saveLocation =
            'Audio: $_currentRecordingPath\nTranscript: $transcriptPath';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Recording and transcript saved locally\n$_saveLocation',
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    } catch (e) {
      print("Error saving recording and transcript: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error saving recording and transcript'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_recordingDuration < _maxDuration) {
          _recordingDuration += const Duration(seconds: 1);
        } else {
          _stopRecording();
        }
      });
    });
  }

  String _formatTimeRemaining() {
    final remaining = _maxDuration - _recordingDuration;
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(remaining.inMinutes.remainder(60));
    String seconds = twoDigits(remaining.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  void _toggleRecording() {
    switch (_recordState) {
      case RecordState.stop:
        _startRecording();
        break;
      case RecordState.record:
        _pauseRecording();
        break;
      case RecordState.pause:
        _resumeRecording();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: const [
                  Text(
                    'Viva training',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7E57C2),
                    borderRadius: BorderRadius.circular(48),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        painter: BlobPainter(
                          animation: _blobAnimationController,
                          isRecording: _recordState == RecordState.record,
                          amplitudes: _amplitudes,
                        ),
                        size: const Size(300, 300),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_recordState == RecordState.stop)
                              _currentQuestion.isEmpty
                                  ? const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    )
                                  : Text(
                                      _currentQuestion,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                        height: 1.2,
                                      ),
                                    ),
                            if (_recordState != RecordState.stop) ...[
                              Text(
                                _recordState == RecordState.pause
                                    ? 'Paused'
                                    : 'Recording...',
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _formatTimeRemaining(),
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (_recordState != RecordState.stop)
                        Positioned(
                          bottom: 32,
                          left: 32,
                          right: 32,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _currentWords,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.question_mark,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildRecordButton(),
                      const SizedBox(width: 16),
                      if (_recordState != RecordState.stop) _buildStopButton(),
                      const SizedBox(width: 16),
                      _buildMenuButton(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'SaveLocation: $_saveLocation',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordButton() {
    return GestureDetector(
      onTap: _toggleRecording,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: _recordState == RecordState.record
              ? Colors.red
              : const Color(0xFF7E57C2),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _recordState == RecordState.stop
                  ? Icons.mic
                  : (_recordState == RecordState.record
                      ? Icons.pause
                      : Icons.mic),
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              _recordState == RecordState.stop
                  ? 'Record'
                  : (_recordState == RecordState.record ? 'Pause' : 'Resume'),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStopButton() {
    return GestureDetector(
      onTap: _stopRecording,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(32),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.stop,
              color: Colors.white,
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              'Stop',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ReportPage()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF7E57C2),
          borderRadius: BorderRadius.circular(32),
        ),
        child: const Icon(
          Icons.grid_view_rounded,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}

// Enum to track recording state
enum RecordState { stop, record, pause }

// BlobPainter remains the same as in the original code
class BlobPainter extends CustomPainter {
  final Animation<double> animation;
  final bool isRecording;
  final List<double> amplitudes;

  BlobPainter({
    required this.animation,
    required this.isRecording,
    required this.amplitudes,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final path = Path();
    const points = 180;

    for (var i = 0; i < points; i++) {
      final angle = (i * 2 * math.pi) / points;
      double amplitude = isRecording
          ? amplitudes[i] * animation.value * 2
          : (0.05 * animation.value * (1 + 0.5 * (1 + math.sin(10 * angle))));

      final x = center.dx + (radius + amplitude * 30) * math.cos(angle);
      final y = center.dy + (radius + amplitude * 30) * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BlobPainter oldDelegate) => true;
}
