import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intelliquiz/models/auth.dart";

class CandidateFeedbackPage extends StatefulWidget {
  final String testName;
  const CandidateFeedbackPage({
    super.key,
    required this.testName,
  });

  @override
  State<CandidateFeedbackPage> createState() => _CandidateFeedbackPageState();
}

class _CandidateFeedbackPageState extends State<CandidateFeedbackPage> {
  final TextEditingController _controllerFeedback = TextEditingController();

  Future<void> submitFeedback({required String feedback}) async {
    final uid = Auth().currentUser!.uid;
    final Map<String, dynamic> dataUpload = {
      'testName': widget.testName,
      'feedback': feedback,
      'uid': uid,
      'timestamp': DateTime.now(),
    };
    await FirebaseFirestore.instance.collection('Feedbacks').add(dataUpload);
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
      ),
      body: Container(
        color: Colors.grey[350],
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Text(
              "We Hoped You Liked The Test Experience! Do Drop Your Suggestions or Recommendations Below",
              style: GoogleFonts.raleway(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
            TextField(
              style: GoogleFonts.raleway(),
              controller: _controllerFeedback,
              decoration: const InputDecoration(fillColor: Colors.black),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              onPressed: () {
                submitFeedback(
                  feedback: _controllerFeedback.text,
                );
              },
              child: Text(
                "SUBMIT",
                style: GoogleFonts.raleway(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
