import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intelliquiz/candidate_components/candidate_test_review_page.dart';
import 'package:intelliquiz/models/auth.dart';

StreamBuilder questionPage({
  required String testName,
  required String questionDomain,
  required Map<String, dynamic> candidateResponses,
  required Function(String questionID, dynamic response)
      onResponseUpdate, // Callback to update response
}) {
  final Stream<QuerySnapshot> questionStream = FirebaseFirestore.instance
      .collection('Questions')
      .where("testName", isEqualTo: testName)
      .where("questionDomain", isEqualTo: questionDomain)
      .snapshots();

  return StreamBuilder<QuerySnapshot>(
    stream: questionStream,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text(
          "An Error Occurred",
          style: GoogleFonts.raleway(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        );
      } else if (questionDomain == '') {
        return Center(
          child: Text(
            "Select The Question Domain",
            style: GoogleFonts.raleway(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
        );
      } else {
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var data = snapshot.data!.docs[index];
            String questionDocID = data.id;
            var selectedOption =
                candidateResponses[questionDocID]?['selectedOption'];
            var descriptiveAnswer =
                candidateResponses[questionDocID]?['descriptiveAnswer'];

            return ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data["question"],
                    style: GoogleFonts.raleway(
                      color: Colors.black,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (data["optionRequired"]) ...[
                    Text(
                      "Select an option:",
                      style: GoogleFonts.raleway(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      children: List.generate(data["options"].length, (i) {
                        String optionKey = (i + 1).toString();
                        String optionText = data["options"][optionKey];
                        return CheckboxListTile(
                          title: Text(optionText),
                          value: selectedOption == optionKey,
                          onChanged: (bool? value) {
                            if (value != null && value) {
                              onResponseUpdate(
                                questionDocID,
                                {'selectedOption': optionKey},
                              );
                            }
                          },
                        );
                      }),
                    ),
                  ],
                  const SizedBox(height: 10),
                  if (data["descriptionRequired"]) ...[
                    Text(
                      "Provide a description:",
                      style: GoogleFonts.raleway(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      initialValue: descriptiveAnswer,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Type your answer here...",
                      ),
                      onChanged: (value) {
                        onResponseUpdate(
                          questionDocID,
                          {'descriptiveAnswer': value},
                        );
                      },
                    ),
                  ],
                ],
              ),
            );
          },
        );
      }
    },
  );
}

class CandidateTestViewPage extends StatefulWidget {
  final String testName;
  final String testID;
  final int testDuration; // in minutes

  const CandidateTestViewPage({
    super.key,
    required this.testName,
    required this.testID,
    required this.testDuration,
  });

  @override
  State<CandidateTestViewPage> createState() => _CandidateTestViewPageState();
}

class _CandidateTestViewPageState extends State<CandidateTestViewPage> {
  Set<String> domains = {};
  String currQuestionDomain = '';
  bool isLoading = true;
  bool isUpdated = false;

  Map<String, dynamic> candidateResponses = {};

  Future<void> retrieveQuestionDomains({required String testName}) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Questions')
        .where("testName", isEqualTo: testName)
        .get();

    Set<String> questionDomains = {};

    for (var element in querySnapshot.docs) {
      questionDomains.add(element["questionDomain"] as String);
    }

    setState(() {
      domains = questionDomains;
      isLoading = false;
    });
  }

  Future<void> submitResponse(
      {required Map<String, dynamic> candidateReponses}) async {
    final String userID = Auth().currentUser!.uid;
    final String email = Auth().currentUser!.email!;
    Map<String, dynamic> dataUpload = {
      'UserID': userID,
      'EmailID': email,
      'Reponses': candidateResponses,
      'submissionTime': DateTime.now(),
    };
    await FirebaseFirestore.instance.collection('Responses').add(dataUpload);
  }

  late Timer _timer;
  late int _remainingTime;

  @override
  void initState() {
    super.initState();
    _startTimer();
    retrieveQuestionDomains(testName: widget.testName);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _remainingTime = widget.testDuration * 60;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        _remainingTime--;
        setState(() => {});
      } else {
        timer.cancel();
        _onTimeUp();
      }
    });
  }

  void _onTimeUp() {
    submitResponse(candidateReponses: candidateResponses);
  }

  void onResponseUpdate(String questionDocID, dynamic response) {
    setState(() {
      candidateResponses[questionDocID] = response;
    });
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Time Remaining: ${(_remainingTime ~/ 60).toString().padLeft(2, '0')}:${(_remainingTime % 60).toString().padLeft(2, '0')}",
              style: GoogleFonts.openSans(
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 25),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        icon: const Icon(
                          Icons.query_builder,
                          color: Colors.black,
                        ),
                        title: Text(
                          "Are you sure you want to submit the test for grading?\nRemaining Time: ${_remainingTime ~/ 60}:${_remainingTime % 60}",
                          style: GoogleFonts.raleway(
                            color: Colors.black,
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                            ),
                            onPressed: () {
                              submitResponse(
                                candidateReponses: candidateResponses,
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CandidateTestReviewPage(),
                                ),
                              );
                            },
                            child: Text(
                              "SUBMIT",
                              style: GoogleFonts.raleway(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "RETURN",
                              style: GoogleFonts.raleway(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
            child: Text(
              "SUBMIT",
              style: GoogleFonts.raleway(
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Container(
        color: Colors.grey[300],
        child: Row(
          children: [
            // Sidebar for Question Domains
            Container(
              height: double.infinity,
              width: 200,
              color: Colors.black,
              child: Column(
                children: [
                  Text(
                    "QUESTIONS",
                    style: GoogleFonts.raleway(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: domains.length,
                            itemBuilder: (context, index) {
                              var questionDomain = domains.toList()[index];
                              return ListTile(
                                enabled: true,
                                leading: const Icon(
                                  Icons.bookmark,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  questionDomain,
                                  style: GoogleFonts.raleway(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                onTap: () {
                                  if (currQuestionDomain != questionDomain) {
                                    setState(() {
                                      currQuestionDomain = questionDomain;
                                    });
                                  }
                                },
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),

            Expanded(
              child: questionPage(
                testName: widget.testName,
                questionDomain: currQuestionDomain,
                candidateResponses: candidateResponses,
                onResponseUpdate: onResponseUpdate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
