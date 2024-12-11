import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_svg/flutter_svg.dart';

class UploadNotesScreen extends StatefulWidget {
  const UploadNotesScreen({Key? key}) : super(key: key);

  @override
  _UploadNotesScreenState createState() => _UploadNotesScreenState();
}

class _UploadNotesScreenState extends State<UploadNotesScreen> {
  final List<FileInfo> _selectedFiles = [];
  final Dio _dio = Dio();
  bool _isUploading = false;

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'mp3', 'mp4'],
        allowMultiple: true,
      );

      if (result != null) {
        for (var file in result.files) {
          if (file.size <= 50 * 1024 * 1024 && // 50MB limit
              ['pdf', 'mp3', 'mp4'].contains(path.extension(file.name).toLowerCase().replaceAll('.', ''))) {
            await _showFileInfoDialog(file);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${file.name} is not supported or exceeds the 50MB limit.')),
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Error picking files: $e');
    }
  }

  Future<void> _showFileInfoDialog(PlatformFile file) async {
    String subject = '';
    String topic = '';
    String gradeLevel = '';
    String additionalNotes = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('File Information'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Subject'),
                  onChanged: (value) => subject = value,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Topic'),
                  onChanged: (value) => topic = value,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Grade Level'),
                  onChanged: (value) => gradeLevel = value,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Additional Notes'),
                  onChanged: (value) => additionalNotes = value,
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                setState(() {
                  _selectedFiles.add(FileInfo(
                    file: file,
                    subject: subject,
                    topic: topic,
                    gradeLevel: gradeLevel,
                    additionalNotes: additionalNotes,
                  ));
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _uploadFiles() async {
    if (_selectedFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select files to upload')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      FormData formData = FormData();
      
      for (var fileInfo in _selectedFiles) {
        formData.files.addAll([
          MapEntry(
            'files[]',
            await MultipartFile.fromFile(
              fileInfo.file.path!,
              filename: fileInfo.file.name,
            ),
          ),
        ]);
        formData.fields.addAll([
          MapEntry('subjects[]', fileInfo.subject),
          MapEntry('topics[]', fileInfo.topic),
          MapEntry('gradeLevels[]', fileInfo.gradeLevel),
          MapEntry('additionalNotes[]', fileInfo.additionalNotes),
        ]);
      }

      // Replace with your API endpoint
      await _dio.post(
        'YOUR_UPLOAD_ENDPOINT',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer YOUR_AUTH_TOKEN',
          },
        ),
        onSendProgress: (int sent, int total) {
          debugPrint('$sent / $total');
          // You can use this to show upload progress
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your notes have been successfully uploaded')),
      );

      setState(() {
        _selectedFiles.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading files: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  Widget _buildFileTypeIcon(String extension) {
    String assetName;
    switch (extension.toLowerCase()) {
      case 'pdf':
        assetName = 'assets/pdf_icon.svg';
        break;
      case 'mp3':
        assetName = 'assets/audio_icon.svg';
        break;
      case 'mp4':
        assetName = 'assets/video_icon.svg';
        break;
      default:
        assetName = 'assets/file_icon.svg';
    }
    return SvgPicture.asset(assetName, width: 24, height: 24);
  }

  Widget _buildFilePreview(FileInfo fileInfo) {
    switch (path.extension(fileInfo.file.name).toLowerCase()) {
      case '.pdf':
        return Container(
          width: 100,
          height: 100,
          color: Colors.grey[200],
          child: Center(child: Text('PDF Preview')),
        );
      case '.mp3':
        return Container(
          width: 100,
          height: 100,
          color: Colors.blue[100],
          child: Icon(Icons.audiotrack, size: 50, color: Colors.blue),
        );
      case '.mp4':
        return Container(
          width: 100,
          height: 100,
          color: Colors.red[100],
          child: Icon(Icons.video_library, size: 50, color: Colors.red),
        );
      default:
        return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/subtle_education_bg.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.9),
              BlendMode.lighten,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Upload Study Materials',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: Icon(Icons.add),
                  label: Text('Add Files'),
                  onPressed: _isUploading ? null : _pickFiles,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Only PDF, MP3, and MP4 formats are allowed. Max file size: 50MB.',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Expanded(
                  child: _selectedFiles.isEmpty
                      ? Center(
                          child: Text(
                            'No files selected',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        )
                      : ListView(
                          children: [
                            if (_selectedFiles.any((f) => path.extension(f.file.name).toLowerCase() == '.pdf'))
                              _buildFileCategory('PDFs', (f) => path.extension(f.file.name).toLowerCase() == '.pdf'),
                            if (_selectedFiles.any((f) => path.extension(f.file.name).toLowerCase() == '.mp3'))
                              _buildFileCategory('Audio Files', (f) => path.extension(f.file.name).toLowerCase() == '.mp3'),
                            if (_selectedFiles.any((f) => path.extension(f.file.name).toLowerCase() == '.mp4'))
                              _buildFileCategory('Video Files', (f) => path.extension(f.file.name).toLowerCase() == '.mp4'),
                          ],
                        ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isUploading ? null : _uploadFiles,
                  child: _isUploading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Upload Notes', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFileCategory(String title, bool Function(FileInfo) filter) {
    List<FileInfo> files = _selectedFiles.where(filter).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: files.length,
          itemBuilder: (context, index) {
            FileInfo fileInfo = files[index];
            return Card(
              child: ListTile(
                leading: _buildFileTypeIcon(path.extension(fileInfo.file.name)),
                title: Text(fileInfo.file.name, style: TextStyle(fontSize: 14)),
                subtitle: Text('${fileInfo.subject} - ${fileInfo.topic}', style: TextStyle(fontSize: 12)),
                trailing: IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: _isUploading ? null : () => _removeFile(_selectedFiles.indexOf(fileInfo)),
                ),
                onTap: () => _showFilePreview(fileInfo),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showFilePreview(FileInfo fileInfo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(fileInfo.file.name),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFilePreview(fileInfo),
                SizedBox(height: 16),
                Text('Subject: ${fileInfo.subject}'),
                Text('Topic: ${fileInfo.topic}'),
                Text('Grade Level: ${fileInfo.gradeLevel}'),
                Text('Additional Notes: ${fileInfo.additionalNotes}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}

class FileInfo {
  final PlatformFile file;
  final String subject;
  final String topic;
  final String gradeLevel;
  final String additionalNotes;

  FileInfo({
    required this.file,
    required this.subject,
    required this.topic,
    required this.gradeLevel,
    required this.additionalNotes,
  });
}

