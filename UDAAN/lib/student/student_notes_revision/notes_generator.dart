import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

class NotesGenerator extends StatefulWidget {
  const NotesGenerator({Key? key}) : super(key: key);

  @override
  _NotesGeneratorState createState() => _NotesGeneratorState();
}

class _NotesGeneratorState extends State<NotesGenerator> {
  int selectedIndex = 0; // To track the selected tab index

  //for youtube notes
  final TextEditingController linkController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  int currentStep = 0;
  bool isLoading = false;
  bool isGenerating = false;
  bool isCompleted = false;
  String _YT_notes = '';

//for lecture notes
  String? lectureSelectedSubject;
  String? lectureSelectedTopic;
  int lectureCurrentStep = 0;
  bool lectureIsGenerating = false;
  bool lectureIsCompleted = false;
  bool lectureIsLoading = false;
  final TextEditingController lectureNumberController = TextEditingController();
  List<String> subjects = ['Mathematics', 'Physics', 'Chemistry', 'Biology'];
  Map<String, List<String>> topics = {
    'Mathematics': ['Algebra', 'Geometry', 'Calculus'],
    'Physics': ['Mechanics', 'Thermodynamics', 'Electromagnetism'],
    'Chemistry': ['Organic', 'Inorganic', 'Physical'],
    'Biology': ['Botany', 'Zoology', 'Genetics'],
  };

  //for pdf notes
  String? selectedFile;
  String? pdfSelectedSubject;
  bool pdfIsLoading = false;
  bool pdfIsGenerating = false;
  bool pdfIsCompleted = false;
  late File myFile;
  String _PDF_notes = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildTabBar(),
                const SizedBox(height: 24),
                _buildTabContent(), // Display content dynamically
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> generateNotes(String link) async {
    final url = Uri.parse(
        'http://127.0.0.1:5001/yt_notes'); // Replace with your backend URL

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'youtube_url': link,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        if (data['notes'] != null) {
          return data[
              'notes']; // Assuming backend returns JSON with 'text' field
        } else {
          throw Exception('Response data is null');
        }
        // Assuming backend returns JSON with 'text' field
      } else {
        throw Exception('Failed to generate notes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<String> generateNotes_pdf(File pdf_file) async {
    final url =
        'http://127.0.0.1:5001/upload_pdfs'; // Replace with your backend URL

    try {
      final dio = Dio();

      // Create a FormData object to hold the file
      final formData = FormData.fromMap({
        'pdf_file': await MultipartFile.fromFile(
          pdf_file.path,
          filename: pdf_file.path.split('/').last, // Extract file name
        ),
      });

      // Post the file to the backend
      final response = await dio.post(
        url,
        data: formData,
      );

      // Check if the response is successful
      if (response.statusCode == 200) {
        final data = response.data;
        print(data);

        if (data['notes'] != null) {
          return data[
              'notes']; // Assuming backend returns JSON with 'notes' field
        } else {
          throw Exception('Response data is null');
        }
      } else {
        throw Exception('Failed to generate notes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.menu_book, color: Color(0xFF6C5CE7)),
        ),
        const SizedBox(width: 16),
        const Text(
          'Notes Generator',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3436),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedIndex = 0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selectedIndex == 0
                      ? const Color(0xFF6C5CE7)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Youtube',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selectedIndex == 0
                        ? Colors.white
                        : const Color(0xFF2D3436),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedIndex = 1),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selectedIndex == 1
                      ? const Color(0xFF6C5CE7)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Lecture Notes',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selectedIndex == 1
                        ? Colors.white
                        : const Color(0xFF2D3436),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedIndex = 2),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selectedIndex == 2
                      ? const Color(0xFF6C5CE7)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'PDF',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selectedIndex == 2
                        ? Colors.white
                        : const Color(0xFF2D3436),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    if (selectedIndex == 0) {
      return _youtubeNotesContent();
    } else if (selectedIndex == 1) {
      return _lectureNotesContent();
    } else {
      return _PDFNotesContent();
    }
  }

  Widget _youtubeNotesContent() {
    final ScrollController scrollController = ScrollController();

    void scrollToField(GlobalKey fieldKey) {
      final context = fieldKey.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }

    final linkFieldKey = GlobalKey();
    final subjectFieldKey = GlobalKey();
    final titleFieldKey = GlobalKey();

    return StatefulBuilder(
      builder: (context, setState) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Generate comprehensive notes from any YouTube video',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3436),
                        ),
                        textAlign: TextAlign.center,
                        // maxLines: 2,
                        // overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Link Input
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(LucideIcons.link,
                            color: currentStep >= 0
                                ? const Color(0xFF6C5CE7)
                                : Colors.grey,
                            size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Step 1: Video Link',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: currentStep >= 0
                                ? const Color(0xFF6C5CE7)
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      key: linkFieldKey,
                      controller: linkController,
                      enabled: currentStep == 0,
                      decoration: InputDecoration(
                        hintText: 'Paste YouTube video link here',
                        prefixIcon: const Icon(LucideIcons.youtube,
                            color: Color(0xFF6C5CE7)),
                        suffixIcon: IconButton(
                          icon: const Icon(LucideIcons.arrowRight),
                          onPressed: linkController.text.isNotEmpty
                              ? () {
                                  setState(() => currentStep = 1);
                                  scrollToField(subjectFieldKey);
                                }
                              : null,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFFE0E0E0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFFE0E0E0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFF6C5CE7)),
                        ),
                      ),
                      onChanged: (value) => setState(() {}),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Subject Input
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(LucideIcons.bookOpen,
                            color: currentStep >= 1
                                ? const Color(0xFF6C5CE7)
                                : Colors.grey,
                            size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Step 2: Subject',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: currentStep >= 1
                                ? const Color(0xFF6C5CE7)
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      key: subjectFieldKey,
                      controller: subjectController,
                      enabled: currentStep == 1,
                      decoration: InputDecoration(
                        hintText: 'Enter subject name',
                        prefixIcon: const Icon(LucideIcons.graduationCap,
                            color: Color(0xFF6C5CE7)),
                        suffixIcon: IconButton(
                          icon: const Icon(LucideIcons.arrowRight),
                          onPressed: subjectController.text.isNotEmpty
                              ? () {
                                  setState(() => currentStep = 2);
                                  scrollToField(titleFieldKey);
                                }
                              : null,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFFE0E0E0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFFE0E0E0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFF6C5CE7)),
                        ),
                      ),
                      onChanged: (value) => setState(() {}),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Title Input
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(LucideIcons.text,
                            color: currentStep >= 2
                                ? const Color(0xFF6C5CE7)
                                : Colors.grey,
                            size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Step 3: Title',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: currentStep >= 2
                                ? const Color(0xFF6C5CE7)
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      key: titleFieldKey,
                      controller: titleController,
                      enabled: currentStep == 2,
                      decoration: InputDecoration(
                        hintText: 'Enter notes title',
                        prefixIcon: const Icon(LucideIcons.heading1,
                            color: Color(0xFF6C5CE7)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFFE0E0E0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFFE0E0E0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFF6C5CE7)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Generate Button
                if (!isGenerating && !isCompleted)
                  ElevatedButton.icon(
                    icon: const Icon(LucideIcons.fileText, color: Colors.white),
                    label: const Text(
                      'Generate Notes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: currentStep == 2
                        ? _handleGenerate
                        : null, // Remove titleController.text.isNotEmpty check
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C5CE7),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                if (isCompleted)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(LucideIcons.plus),
                          label: const Text('Generate New'),
                          onPressed: _handleReset,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF6C5CE7),
                            side: const BorderSide(
                              color: Color(0xFF6C5CE7),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(LucideIcons.folderOpen,
                              color: Colors.white),
                          label: const Text('Resources',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            // Navigate to resources
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C5CE7),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleGenerate() async {
    setState(() {
      isLoading = true;
      isGenerating = true;
    });

    // Mock API call
    // await Future.delayed(const Duration(seconds: 2));

    try {
      final generatedText = await generateNotes(linkController.text);

      setState(() {
        isLoading = false;
        isCompleted = true;
        _YT_notes = generatedText; // Store the response
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notes have been generated and added to resources'),
          backgroundColor: Color(0xFF6C5CE7),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
        isGenerating = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      );
    }
  }

  void _handleReset() {
    setState(() {
      currentStep = 0;
      isGenerating = false;
      isCompleted = false;
      linkController.clear();
      subjectController.clear();
      titleController.clear();
    });
  }

  Widget _lectureNotesContent() {
    final ScrollController scrollController = ScrollController();

    void scrollToField(GlobalKey fieldKey) {
      final context = fieldKey.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }

    final subjectFieldKey = GlobalKey();
    final topicFieldKey = GlobalKey();
    final lectureNumberFieldKey = GlobalKey();

    return StatefulBuilder(
      builder: (context, setState) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Generate comprehensive notes from classroom lectures',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3436),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Subject Dropdown
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(LucideIcons.bookOpen,
                            color: lectureCurrentStep >= 0
                                ? const Color(0xFF6C5CE7)
                                : Colors.grey,
                            size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Step 1: Select Subject',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: lectureCurrentStep >= 0
                                ? const Color(0xFF6C5CE7)
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      key: subjectFieldKey,
                      value: lectureSelectedSubject,
                      decoration: InputDecoration(
                        hintText: 'Select a subject',
                        prefixIcon: const Icon(LucideIcons.graduationCap,
                            color: Color(0xFF6C5CE7)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFFE0E0E0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFFE0E0E0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFF6C5CE7)),
                        ),
                      ),
                      items: subjects.map((String subject) {
                        return DropdownMenuItem<String>(
                          value: subject,
                          child: Text(subject),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          lectureSelectedSubject = newValue;
                          lectureSelectedTopic = null;
                          lectureCurrentStep = 1;
                        });
                        scrollToField(topicFieldKey);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Topic Dropdown
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(LucideIcons.bookMarked,
                            color: lectureCurrentStep >= 1
                                ? const Color(0xFF6C5CE7)
                                : Colors.grey,
                            size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Step 2: Select Topic',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: lectureCurrentStep >= 1
                                ? const Color(0xFF6C5CE7)
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      key: topicFieldKey,
                      value: lectureSelectedTopic,
                      decoration: InputDecoration(
                        hintText: 'Select a topic',
                        prefixIcon: const Icon(LucideIcons.bookOpen,
                            color: Color(0xFF6C5CE7)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFFE0E0E0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFFE0E0E0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFF6C5CE7)),
                        ),
                      ),
                      items: lectureSelectedSubject != null
                          ? topics[lectureSelectedSubject]!.map((String topic) {
                              return DropdownMenuItem<String>(
                                value: topic,
                                child: Text(topic),
                              );
                            }).toList()
                          : [],
                      onChanged: (String? newValue) {
                        setState(() {
                          lectureSelectedTopic = newValue;
                          lectureCurrentStep = 2;
                        });
                        scrollToField(lectureNumberFieldKey);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Lecture Number Input
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(LucideIcons.listOrdered,
                            color: lectureCurrentStep >= 2
                                ? const Color(0xFF6C5CE7)
                                : Colors.grey,
                            size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Step 3: Lecture Number',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: lectureCurrentStep >= 2
                                ? const Color(0xFF6C5CE7)
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      key: lectureNumberFieldKey,
                      controller: lectureNumberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter lecture number',
                        prefixIcon: const Icon(LucideIcons.hash,
                            color: Color(0xFF6C5CE7)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFFE0E0E0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFFE0E0E0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFF6C5CE7)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Generate Button
                if (!lectureIsGenerating && !lectureIsCompleted)
                  ElevatedButton.icon(
                    icon: const Icon(LucideIcons.fileText, color: Colors.white),
                    label: const Text(
                      'Generate Notes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: lectureCurrentStep == 2
                        ? _handleGenerateLectureNotes
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C5CE7),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                if (lectureIsCompleted)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(LucideIcons.plus),
                          label: const Text('Generate New'),
                          onPressed: _handleResetLectureNotes,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF6C5CE7),
                            side: const BorderSide(
                              color: Color(0xFF6C5CE7),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(LucideIcons.folderOpen,
                              color: Colors.white),
                          label: const Text('Resources',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            // Navigate to resources
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C5CE7),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleGenerateLectureNotes() async {
    setState(() {
      lectureIsLoading = true;
      lectureIsGenerating = true;
    });

    // Mock API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      lectureIsLoading = false;
      lectureIsCompleted = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text('Lecture notes have been generated and stored in resources'),
        backgroundColor: Color(0xFF6C5CE7),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }

  void _handleResetLectureNotes() {
    setState(() {
      lectureCurrentStep = 0;
      lectureIsGenerating = false;
      lectureIsCompleted = false;
      lectureSelectedSubject = null;
      lectureSelectedTopic = null;
      lectureNumberController.clear();
    });
  }

  Widget _PDFNotesContent() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Generate comprehensive notes from textbook PDFs',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // PDF Upload Section
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Color(0xFFF8F9FD),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Color(0xFFE0E0E0),
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Color(0xFF6C5CE7).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        LucideIcons.fileText,
                        size: 40,
                        color: Color(0xFF6C5CE7),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      selectedFile ?? 'Upload your PDF file',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3436),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Any file supports under 1GB',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(LucideIcons.upload),
                          label: const Text('Browse File'),
                          onPressed: () async {
                            // Implement file picking logic here
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['pdf'],
                            );

                            if (result != null) {
                              setState(() {
                                selectedFile = result.files.single.name;
                                myFile  = File(result.files.single.path!);
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6C5CE7),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Subject Selection
              if (selectedFile != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          LucideIcons.bookOpen,
                          color: Color(0xFF6C5CE7),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Select Subject',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6C5CE7),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: pdfSelectedSubject,
                      decoration: InputDecoration(
                        hintText: 'Select a subject',
                        prefixIcon: const Icon(
                          LucideIcons.graduationCap,
                          color: Color(0xFF6C5CE7),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFFE0E0E0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFFE0E0E0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFF6C5CE7)),
                        ),
                      ),
                      items: [
                        'Mathematics',
                        'Physics',
                        'Chemistry',
                        'Biology',
                      ].map((String subject) {
                        return DropdownMenuItem<String>(
                          value: subject,
                          child: Text(subject),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          pdfSelectedSubject = newValue;
                        });
                      },
                    ),
                  ],
                ),
              const SizedBox(height: 32),

              // Generate Button
              if (selectedFile != null && !pdfIsGenerating && !pdfIsCompleted)
                ElevatedButton.icon(
                  icon: const Icon(LucideIcons.fileText, color: Colors.white),
                  label: const Text(
                    'Generate Notes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: pdfSelectedSubject != null
                      ? () async {
                          setState(() {
                            pdfIsLoading = true;
                            pdfIsGenerating = true;
                          });

                          // Mock API call
                          // await Future.delayed(const Duration(seconds: 2));

                          try{ 
                          final generatedPdfNotes = await generateNotes_pdf(myFile);

                          setState(() {
                            pdfIsLoading = false;
                            pdfIsCompleted = true;
                            _PDF_notes = generatedPdfNotes; // Store the response
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Notes have been generated and stored in resources',
                              ),
                              backgroundColor: Color(0xFF6C5CE7),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                          );
                          } catch (e) {
                            setState(() {
                              pdfIsLoading = false;
                              pdfIsGenerating = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: ${e.toString()}'),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C5CE7),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

              if (pdfIsCompleted)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(LucideIcons.plus),
                        label: const Text('Generate New'),
                        onPressed: () {
                          setState(() {
                            selectedFile = null;
                            pdfSelectedSubject = null;
                            pdfIsGenerating = false;
                            pdfIsCompleted = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF6C5CE7),
                          side: const BorderSide(
                            color: Color(0xFF6C5CE7),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(LucideIcons.folderOpen,
                            color: Colors.white),
                        label: const Text(
                          'Resources',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          // Navigate to resources
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C5CE7),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required String count,
    required String subtitle,
    required double progress,
    required bool recentUsers,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$count $subtitle',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
