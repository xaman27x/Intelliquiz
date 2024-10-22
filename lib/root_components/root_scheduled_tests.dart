import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RootScheduledTestPage extends StatefulWidget {
  const RootScheduledTestPage({super.key});

  @override
  State<RootScheduledTestPage> createState() => _RootScheduledTestPageState();
}

class _RootScheduledTestPageState extends State<RootScheduledTestPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Image.asset(
          'images/sds.png',
          scale: 11,
          fit: BoxFit.fitHeight,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            color: Colors.white,
            Icons.arrow_back_ios,
          ),
        ),
      ),
    );
  }
}
