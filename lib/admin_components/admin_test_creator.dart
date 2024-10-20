import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intelliquiz/models/question_details.dart';

class AdminTestCreator extends StatefulWidget {
  const AdminTestCreator({super.key});

  @override
  State<AdminTestCreator> createState() => _AdminTestCreatorState();
}

class AdminTestDetailsPage extends StatefulWidget {
  const AdminTestDetailsPage({super.key});

  @override
  State<AdminTestDetailsPage> createState() => _AdminTestDetailsPageState();
}

// ignore: must_be_immutable
class AdminTestModificationPage extends StatefulWidget {
  final String testName;

  const AdminTestModificationPage({
    super.key,
    required this.testName,
  });

  @override
  State<AdminTestModificationPage> createState() =>
      _AdminTestModificationPageState();
}

class _AdminTestCreatorState extends State<AdminTestCreator> {
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
        color: Colors.grey[400],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminTestDetailsPage(),
                    ),
                  );
                },
                child: Text(
                  "Ongoing Test Staging",
                  style: GoogleFonts.raleway(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () {},
                child: Text(
                  'Create New Test',
                  style: GoogleFonts.raleway(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminTestDetailsPageState extends State<AdminTestDetailsPage> {
  final Stream<QuerySnapshot> testDetailStream =
      FirebaseFirestore.instance.collection('Test_Staging').snapshots();
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
        color: Colors.grey[400],
        child: Center(
          child: StreamBuilder(
            stream: testDetailStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError || !snapshot.hasData) {
                return const Center(
                  child: Text("An Error Occured"),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index];
                    final testName = data['testName'];
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminTestModificationPage(
                              testName: testName,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        testName,
                        style: GoogleFonts.raleway(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class _AdminTestModificationPageState extends State<AdminTestModificationPage> {
  late final Stream<QuerySnapshot> questionStream;

  @override
  void initState() {
    super.initState();

    questionStream = FirebaseFirestore.instance
        .collection('Questions')
        .where('testName', isEqualTo: widget.testName)
        .snapshots();
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
        color: Colors.grey[400],
        child: StreamBuilder<QuerySnapshot>(
          stream: questionStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator.adaptive();
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("An Error Occurred while Fetching Questions"),
              );
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("No Questions Found"),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data!.docs[index];
                  final QuestionDetails questionDetails = QuestionDetails(
                    questionID: data['questionID'],
                    questionDomain: data['questionDomain'],
                    question: data['question'],
                    optionRequired: data['optionRequired'],
                    options: Map<String, String>.from(data['options']),
                    correctOption: data['correctOption'],
                    mediaRequired: data['mediaRequired'],
                    mediaLink: data['mediaLink'],
                    descriptionRequired: data['descriptionRequired'],
                    marks: data['marks'],
                    negativeMarks: data['negativeMarks'],
                  );

                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Question Domain
                          Text(
                            questionDetails.questionDomain,
                            style: GoogleFonts.raleway(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Main Question Text
                          Text(
                            questionDetails.question,
                            style: GoogleFonts.raleway(fontSize: 16),
                          ),
                          const SizedBox(height: 10),

                          // Conditionally render options if required
                          if (questionDetails.optionRequired) ...[
                            const SizedBox(height: 10),
                            Text(
                              "Options:",
                              style: GoogleFonts.raleway(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: questionDetails.options.entries
                                  .map(
                                    (entry) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            "${entry.key}: ${entry.value}",
                                            style: GoogleFonts.raleway(
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],

                          // Conditionally render media if required
                          if (questionDetails.mediaRequired &&
                              questionDetails.mediaLink.isNotEmpty)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Image.network(
                                questionDetails.mediaLink,
                                fit: BoxFit.cover,
                              ),
                            ),

                          // Conditionally render description if required
                          if (questionDetails.descriptionRequired)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                "Description: ${questionDetails.question}",
                                style: GoogleFonts.raleway(fontSize: 14),
                              ),
                            ),

                          // Marks and negative marks
                          const SizedBox(height: 10),
                          Text(
                            "Marks: ${questionDetails.marks}, Negative Marks: -${questionDetails.negativeMarks}, Correct Choice: ${questionDetails.correctOption}",
                            style: GoogleFonts.raleway(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
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
