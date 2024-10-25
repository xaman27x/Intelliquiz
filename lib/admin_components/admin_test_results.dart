import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminTestResultGroupPage extends StatelessWidget {
  final Stream<QuerySnapshot> testStream =
      FirebaseFirestore.instance.collection("Tests").snapshots();

  AdminTestResultGroupPage({super.key});

  void updateFinalScore(BuildContext context, String userID, String testName,
      int addedScore, DocumentReference resultDoc) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot resultSnapshot = await transaction.get(resultDoc);

      if (resultSnapshot.exists) {
        int currentScore = resultSnapshot.get("finalScore") ?? 0;
        int updatedScore = currentScore + addedScore;

        transaction.update(resultDoc, {
          "finalScore": updatedScore,
          "manualCheckRequired": false,
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Score updated for $userID"),
          backgroundColor: Colors.green,
        ));
      }
    });
  }

  void showReviewDialog(
    BuildContext context,
    String userID,
    String testName,
    Map<String, dynamic> responses,
    DocumentReference resultDoc,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Manual Grading for $userID"),
          content: SingleChildScrollView(
            child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection("Questions")
                  .where("testName", isEqualTo: testName)
                  .get(),
              builder: (context, questionSnapshot) {
                if (questionSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (!questionSnapshot.hasData ||
                    questionSnapshot.data!.docs.isEmpty) {
                  return Text(
                    "No questions found.",
                    style: GoogleFonts.raleway(),
                  );
                } else {
                  return Column(
                    children: questionSnapshot.data!.docs.map((doc) {
                      var questionData = doc.data() as Map<String, dynamic>;
                      String questionID = questionData['questionID'];
                      String questionText = questionData['question'];
                      Map<String, String> options =
                          (questionData['options'] as Map).map((key, value) =>
                              MapEntry(key.toString(), value.toString()));
                      String correctOption =
                          questionData['correctOption'].toString();
                      int marks = questionData['marks'];
                      int negativeMarks = questionData['negativeMarks'];

                      String selectedOption =
                          responses[questionID]?['selectedOption'] ?? "";

                      String displaySelectedOption =
                          selectedOption.isNotEmpty ? selectedOption : "N/A";
                      int assignedMarks = 0;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Q: $questionText",
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          ...options.entries.map((entry) {
                            return Text(
                              "${entry.key}. ${entry.value}",
                              style: GoogleFonts.raleway(
                                color: entry.key == correctOption
                                    ? Colors.green
                                    : Colors.black,
                              ),
                            );
                          }).toList(),
                          const SizedBox(height: 4),
                          Text(
                            "Selected Option: $displaySelectedOption",
                            style: GoogleFonts.raleway(
                              color: displaySelectedOption == correctOption
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          const SizedBox(height: 4),
                          TextField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: "Assign Marks for this Question",
                              hintText: "Enter positive or negative marks",
                            ),
                            onChanged: (value) {
                              assignedMarks = int.tryParse(value) ?? 0;
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              updateFinalScore(context, userID, testName,
                                  assignedMarks, resultDoc);
                            },
                            child: Text("Submit", style: GoogleFonts.raleway()),
                          ),
                          const Divider(),
                        ],
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close", style: GoogleFonts.raleway()),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset(
          "images/sds.png",
          scale: 11,
          fit: BoxFit.fitHeight,
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: IconButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        color: Colors.grey[350],
        child: StreamBuilder(
          stream: testStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator.adaptive();
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "An Error Occurred",
                  style: GoogleFonts.raleway(),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var testData = snapshot.data!.docs[index];
                  String testName = testData['testName'];
                  DateTime scheduledTime =
                      (testData['scheduledTime'] as Timestamp).toDate();

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: ExpansionTile(
                      leading: const Icon(
                        Icons.bookmark_added,
                        color: Colors.black,
                      ),
                      title: Text(
                        testName,
                        style: GoogleFonts.raleway(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        "Scheduled Time: $scheduledTime",
                        style: GoogleFonts.raleway(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("Final_Scores")
                              .where("testName", isEqualTo: testName)
                              .snapshots(),
                          builder: (context, resultSnapshot) {
                            if (resultSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (resultSnapshot.hasError) {
                              return Center(
                                child: Text(
                                  "Error loading results",
                                  style: GoogleFonts.raleway(),
                                ),
                              );
                            } else if (!resultSnapshot.hasData ||
                                resultSnapshot.data!.docs.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "No results available for this test.",
                                  style: GoogleFonts.raleway(
                                    color: Colors.black54,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              );
                            } else {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: resultSnapshot.data!.docs.length,
                                itemBuilder: (context, resultIndex) {
                                  var resultData =
                                      resultSnapshot.data!.docs[resultIndex];
                                  String userID = resultData['UserID'];
                                  int finalScore = resultData['finalScore'];
                                  bool manualCheckRequired =
                                      resultData['manualCheckRequired'];
                                  DateTime submissionTime =
                                      (resultData['submissionTime']
                                              as Timestamp)
                                          .toDate();

                                  return ListTile(
                                    title: Text(
                                      "User: $userID",
                                      style: GoogleFonts.raleway(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Final Score: $finalScore",
                                            style: GoogleFonts.raleway()),
                                        Text("Submission Time: $submissionTime",
                                            style: GoogleFonts.raleway()),
                                        Text(
                                          manualCheckRequired
                                              ? "Status: Requires manual review"
                                              : "Status: Completed",
                                          style: GoogleFonts.raleway(
                                            color: manualCheckRequired
                                                ? Colors.red
                                                : Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: manualCheckRequired
                                        ? ElevatedButton(
                                            onPressed: () async {
                                              final QuerySnapshot
                                                  querySnapshot =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("Responses")
                                                      .where("testName",
                                                          isEqualTo: testName)
                                                      .where("UserID",
                                                          isEqualTo: userID)
                                                      .get();
                                              final data =
                                                  querySnapshot.docs.first;
                                              showReviewDialog(
                                                  context,
                                                  userID,
                                                  testName,
                                                  data['Responses'],
                                                  resultData.reference);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                            child: Text(
                                              "Review",
                                              style: GoogleFonts.raleway(
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        : null,
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
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
