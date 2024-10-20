import 'package:flutter/material.dart';
import 'package:intelliquiz/admin_components/admin_test_creator.dart';
import 'package:intelliquiz/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'IntelliQuiz',
      home: AdminTestDetailsPage(),
    );
  }
}
