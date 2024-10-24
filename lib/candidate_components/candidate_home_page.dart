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
  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  void initState() {
    finalTestStream =
        FirebaseFirestore.instance.collection('Tests').snapshots();
    super.initState();
    return;
  }

  @override
  void dispose() {
    super.dispose();
    return;
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
                  "An Error Occured",
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
                  int? questionCount = data['questions'].length;
                  int? durationInMin = data['durationInMin'];
                  String testName = data['testName'];
                  String testID = data['testID'];
                  DateTime scheduledTime =
                      (data['scheduledTime'] as Timestamp).toDate();
                  return Card(
                    child: ListTile(
                      leading: IconButton(
                        icon: const Icon(
                          Icons.school_sharp,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          const AlertDialog();
                        },
                      ),
                      title: Text(
                        "Test: ${data['testName']}",
                        style: GoogleFonts.raleway(
                          color: Colors.black,
                          fontSize: 19,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Text(
                            "Questions: $questionCount",
                            style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Scheduled Time: $scheduledTime",
                            style: GoogleFonts.raleway(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () => {
                          if (DateTime.now().isBefore(scheduledTime))
                            {
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
                              )
                            }
                          else if ((DateTime.now()
                                  .isAtSameMomentAs(scheduledTime)) ||
                              (DateTime.now().isAfter(scheduledTime) &&
                                  DateTime.now().isBefore(
                                    scheduledTime.add(
                                      const Duration(
                                        minutes: 15,
                                      ),
                                    ),
                                  )))
                            {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text(
                                      instructionBuilder(
                                        questionCount: questionCount!,
                                        durationInMin: durationInMin!,
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
                                              builder: (context) =>
                                                  CandidateTestViewPage(
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
                                        onPressed: () => {
                                          Navigator.pop(context),
                                        },
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
                              )
                            }
                          else
                            {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text(
                                      instructionBuilder(
                                        questionCount: questionCount!,
                                        durationInMin: durationInMin!,
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
                                              builder: (context) =>
                                                  CandidateTestViewPage(
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
                                        onPressed: () => {
                                          Navigator.pop(context),
                                        },
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
                              )
                            }
                        },
                        child: Text(
                          "PROCEED",
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
}
