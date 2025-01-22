import 'package:flutter/material.dart';
import 'package:udaan_app/ar_game/ar_pano.dart';
import 'package:udaan_app/login_screen.dart';
import 'package:udaan_app/parent/news_feature/resource_list.dart';
import 'package:udaan_app/student/chat-feature/chat.dart';
import 'package:udaan_app/student/chat-feature/mentor_profile.dart';
import 'package:udaan_app/parent/community_learning.dart';
import 'package:udaan_app/student/chatbot_screen.dart';
import 'package:udaan_app/student/financial_aid/filterPage.dart';
import 'package:get/get.dart';

//import 'package:udaan_app/notification_page.dart';
import 'package:udaan_app/parent/dropout_details.dart';
import 'package:udaan_app/parent/parent_homepage.dart';
import 'package:udaan_app/student/notification_page.dart';
import 'package:udaan_app/student/quiz_feature/quiz_app.dart';
//import 'package:udaan_app/student/quiz_feature/topic_selection_screen.dart';
import 'package:udaan_app/student/roadmap_feature/roadmap.dart';
import 'package:udaan_app/student/roadmap_feature/roadmap_history.dart';
import 'package:udaan_app/student/schedular_feature/schedular_page.dart';
//import 'package:udaan_app/student/scheduler/ai-generated-schedular.dart';
//import 'package:udaan_app/student/scheduler/schedular_page.dart';

// import 'package:udaan_app/student/online_class_feature/video_call_scre
import 'package:udaan_app/student/quiz_feature/quiz_app.dart';
import 'package:udaan_app/student/student_homepage.dart';
import 'package:udaan_app/student/student_notes_revision/first_page.dart';
import 'package:udaan_app/student/student_notes_revision/music_vinyl_player/ui/my_library/my_library_page.dart';
import 'package:udaan_app/student/student_notes_revision/notes_generator.dart';
import 'package:udaan_app/sign_up.dart';
import 'package:udaan_app/student/student_dashboard.dart';
import 'package:udaan_app/student/student_notes_revision/video_content.dart';

//import 'package:udaan_app/somepage.dart';
import 'package:udaan_app/student/viva_training/report_page.dart';
import 'package:udaan_app/student/viva_training/start_page.dart';
import 'package:udaan_app/student/viva_training/viva_training.dart';
import 'package:udaan_app/teacher/notes_upload.dart';
import 'package:udaan_app/teacher/student_report.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/', // Home page route
      routes: {
        '/': (context) => LoginScreen(), // Define the home page
        '/notifications': (context) =>
            NotificationsPage(), // Define notifications route
      },
    );
  }
}