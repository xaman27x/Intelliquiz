import 'package:flutter/material.dart';
import 'package:intelliquiz/admin_components/admin_home_page.dart';
import 'package:intelliquiz/candidate_components/candidate_home_page.dart';
import 'package:intelliquiz/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intelliquiz/root_components/root_home_page.dart';
import 'package:intelliquiz/shared_components/intro_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        "/candidate_home_page": (context) => const CandidateHomePage(),
      },
      title: 'IntelliQuiz',
      home: const IntroPage(),
    );
  }
}
