import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intelliquiz/models/question_details.dart';

class AdminTestCreator extends StatefulWidget {
  const AdminTestCreator({super.key});

  @override
  State<AdminTestCreator> createState() => _AdminTestCreatorState();
}

class AdminTestModificationPage extends StatefulWidget {
  const AdminTestModificationPage({super.key});

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
                      builder: (context) => const AdminTestModificationPage(),
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

class _AdminTestModificationPageState extends State<AdminTestModificationPage> {
  final Stream<QuerySnapshot> questionStream =
      FirebaseFirestore.instance.collection('Questions').snapshots();

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
                child: Text("An Error Occured while Fetching Questions"),
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
                    options: List<String>.from(data['options']),
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
                          Text(
                            questionDetails.questionDomain,
                            style: GoogleFonts.raleway(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
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
                              children: questionDetails.options
                                  .map((option) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2.0),
                                        child: Text(
                                          option,
                                          style:
                                              GoogleFonts.raleway(fontSize: 14),
                                        ),
                                      ))
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

                          if (questionDetails.descriptionRequired)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                "Description: ${questionDetails.question}",
                                style: GoogleFonts.raleway(fontSize: 14),
                              ),
                            ),
                          const SizedBox(height: 10),
                          Text(
                            "Marks: ${questionDetails.marks}, Negative Marks: ${questionDetails.negativeMarks}",
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
