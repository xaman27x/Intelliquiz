import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intelliquiz/candidate_components/candidate_test_view_page.dart';
import 'package:intelliquiz/models/auth.dart';
import 'package:google_fonts/google_fonts.dart';

String instructionBuilder({
  required int questionCount,
  required int durationInMin,
}) {
  return '''
TEST INSTRUCTIONS:\n
- Duration: The test will last for $durationInMin Minutes.\n
- Questions: This test contains $questionCount questions.\n
- Do not switch tabs or leave the test window, or you may be disqualified.\n
- Ensure a stable internet connection.\n
- Read each question carefully.\n
- Submit before the time expires.\n
- For technical issues, contact sdsadmin@gmail.com.\n
- Cheating or plagiarism is strictly prohibited.\n
- All the best!
''';
}

class CandidateHomePage extends StatefulWidget {
  const CandidateHomePage({super.key});

  @override
  State<CandidateHomePage> createState() => _CandidateHomePage();
}

class _CandidateHomePage extends State<CandidateHomePage> {
  late Stream<QuerySnapshot> finalTestStream;
  List<String> takenTests = [];

  @override
  void initState() {
    super.initState();
    finalTestStream =
        FirebaseFirestore.instance.collection('Tests').snapshots();
    fetchTakenTests();
  }

  Future<void> fetchTakenTests() async {
    final QuerySnapshot candidateSnapshot = await FirebaseFirestore.instance
        .collection('Candidates')
        .where('UserID', isEqualTo: Auth().currentUser!.uid)
        .get();
    final candidateData = candidateSnapshot.docs.first;
    setState(() {
      takenTests = List<String>.from(candidateData['testTaken'] ?? []);
    });
  }

  Future<void> signOut() async {
    await Auth().signOut();
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
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              signOut();
            },
            child: Text(
              "SIGN OUT",
              style: GoogleFonts.raleway(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: Container(
        color: Colors.grey[350],
        child: StreamBuilder<QuerySnapshot>(
          stream: finalTestStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "An Error Occurred",
                  style: GoogleFonts.raleway(
                    color: Colors.black,
                  ),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data!.docs[index];
                  int questionCount = data['questions'].length;
                  int durationInMin = data['durationInMin'];
                  String testName = data['testName'];
                  String testID = data['testID'];
                  DateTime scheduledTime =
                      (data['scheduledTime'] as Timestamp).toDate();
                  bool isTaken = takenTests.contains(testName);

                  return Card(
                    color: isTaken ? Colors.green[50] : Colors.white,
                    child: ListTile(
                      leading: Icon(
                        isTaken ? Icons.check_circle : Icons.school_sharp,
                        color: isTaken ? Colors.green : Colors.black,
                      ),
                      title: Text(
                        "Test: ${data['testName']}",
                        style: GoogleFonts.raleway(
                          color: Colors.black,
                          fontSize: 19,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Questions: $questionCount",
                            style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "Scheduled Time: $scheduledTime",
                            style: GoogleFonts.raleway(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isTaken)
                            Text(
                              "Status: Already Taken",
                              style: GoogleFonts.raleway(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isTaken ? Colors.grey : Colors.black,
                        ),
                        onPressed: isTaken
                            ? null
                            : () => handleTestAccess(
                                  scheduledTime,
                                  context,
                                  testName,
                                  testID,
                                  questionCount,
                                  durationInMin,
                                ),
                        child: Text(
                          isTaken ? "COMPLETED" : "PROCEED",
                          style: GoogleFonts.raleway(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  void handleTestAccess(DateTime scheduledTime, BuildContext context,
      String testName, String testID, int questionCount, int durationInMin) {
    if (DateTime.now().isBefore(scheduledTime)) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Test Has Not Yet Started!",
              style: GoogleFonts.raleway(),
            ),
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              instructionBuilder(
                questionCount: questionCount,
                durationInMin: durationInMin,
              ),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CandidateTestViewPage(
                        testName: testName,
                        testID: testID,
                        testDuration: durationInMin,
                      ),
                    ),
                  );
                },
                child: Text(
                  "START",
                  style: GoogleFonts.raleway(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "CANCEL",
                  style: GoogleFonts.raleway(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          );
        },
      );
    }
  }
}
