import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intelliquiz/models/question_details.dart';
import 'package:random_string_generator/random_string_generator.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

var gen_6 = RandomStringGenerator(fixedLength: 6, hasSymbols: false);

Widget _entryField(
    String title, TextEditingController controller, bool obscureText) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
        hintText:
            title == 'Password' ? 'Enter your Password' : 'Enter your $title',
        filled: true,
        fillColor: const Color.fromARGB(193, 66, 66, 66).withOpacity(0.8),
        labelStyle: const TextStyle(color: Colors.white),
        hintStyle: const TextStyle(color: Color.fromARGB(174, 255, 255, 255)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      style: const TextStyle(color: Colors.white),
      obscureText: obscureText,
    ),
  );
}

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
  final TextEditingController _controllerQuestion = TextEditingController();
  final TextEditingController _controllerQuestionDomain =
      TextEditingController();
  final TextEditingController _controllerCorrectOption =
      TextEditingController();
  final TextEditingController _controllerMarks = TextEditingController();
  final TextEditingController _controllerNegativeMarks =
      TextEditingController();
  final TextEditingController _controllerOpt1 = TextEditingController();
  final TextEditingController _controllerOpt2 = TextEditingController();
  final TextEditingController _controllerOpt3 = TextEditingController();
  final TextEditingController _controllerOpt4 = TextEditingController();
  dynamic globalFiles;
  bool optionRequired = false;
  bool descriptionRequired = false;
  bool mediaRequired = false;
  String fileName = '';
  dynamic fileSize = 0;

  Future<void> uploadQuestion({
    required String question,
    required String questionDomain,
    required bool optionRequired,
    Map<dynamic, dynamic>? options,
    required bool descriptionRequired,
    required bool mediaRequired,
    required String testName,
    dynamic file,
    required String fileName,
    int? correctOption,
    required int? marks,
    required int? negativeMarks,
  }) async {
    String? mediaUrl;
    final questionID = gen_6.generate();

    try {
      if (mediaRequired && file != null) {
        final storageRef =
            FirebaseStorage.instance.ref('questions/$testName/$fileName');
        UploadTask task = storageRef.putBlob(file.first);
        TaskSnapshot taskSnapshot = await task;
        mediaUrl = await taskSnapshot.ref.getDownloadURL();
        debugPrint('media URL: $mediaUrl');
      }

      final Map<String, dynamic> dataUpload = {
        'testName': testName,
        'question': question,
        'questionDomain': questionDomain,
        'questionID': questionID,
        'optionRequired': optionRequired,
        'options': options,
        'mediaRequired': mediaRequired,
        'mediaLink': mediaRequired ? mediaUrl : "",
        'descriptionRequired': descriptionRequired,
        'marks': marks,
        'negativeMarks': negativeMarks,
        'correctOption': correctOption,
      };

      // Add the question to 'Questions' collection
      final DocumentReference questionRef = await FirebaseFirestore.instance
          .collection('Questions')
          .add(dataUpload);

      // Get the document ID of the added question
      final String questionDocID = questionRef.id;

      // Query 'Test_Staging' to update the test document with the new question ID
      final QuerySnapshot testRef = await FirebaseFirestore.instance
          .collection('Test_Staging')
          .where('testName', isEqualTo: testName)
          .get();

      if (testRef.docs.isNotEmpty) {
        final String testRefID = testRef.docs.first.id;

        await FirebaseFirestore.instance
            .collection('Test_Staging')
            .doc(testRefID)
            .update({
          'questions': FieldValue.arrayUnion([questionDocID]),
        });
      } else {
        debugPrint('Test with the given name not found');
      }
    } catch (e) {
      debugPrint('Error uploading question: $e');
    }
  }

  Future<void> deleteQuestion(
      {required String questionID,
      required String question,
      required String testName}) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Questions')
        .where('question', isEqualTo: question)
        .where('questionID', isEqualTo: questionID)
        .get();
    final docID = querySnapshot.docs.first.id;
    await FirebaseFirestore.instance
        .collection('Questions')
        .doc(docID)
        .delete();
    final QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
        .collection('Test_Staging')
        .where('testName', isEqualTo: testName)
        .get();
    final docIdTest = querySnapshot2.docs.first.id;
    await FirebaseFirestore.instance
        .collection('Test_Staging')
        .doc(docIdTest)
        .update(
      {
        'questions': FieldValue.arrayRemove(
          [
            docID,
          ],
        )
      },
    );
  }

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
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setState) => AlertDialog(
                      backgroundColor: Colors.black,
                      title: const Text("Add a Question",
                          style: TextStyle(color: Colors.white)),
                      content: SingleChildScrollView(
                        // <-- Makes the dialog scrollable
                        child: Column(
                          children: [
                            _entryField(
                              'Question',
                              _controllerQuestion,
                              false,
                            ),
                            _entryField(
                              'Question Domain',
                              _controllerQuestionDomain,
                              false,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Options Required?',
                                  style: GoogleFonts.raleway(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: optionRequired,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      optionRequired = value!;
                                    });
                                  },
                                )
                              ],
                            ),
                            if (optionRequired) ...[
                              _entryField('Option1', _controllerOpt1, false),
                              _entryField('Option2', _controllerOpt2, false),
                              _entryField('Option3', _controllerOpt3, false),
                              _entryField('Option4', _controllerOpt4, false),
                            ],
                            Row(
                              children: [
                                Text(
                                  'Description Required?',
                                  style: GoogleFonts.raleway(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: descriptionRequired,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      descriptionRequired = value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Media Required?',
                                  style: GoogleFonts.raleway(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: mediaRequired,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      mediaRequired = value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                            if (mediaRequired)
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      html.FileUploadInputElement uploadInput =
                                          html.FileUploadInputElement();
                                      uploadInput.click();

                                      uploadInput.onChange.listen((e) {
                                        final files = uploadInput.files;
                                        if (files != null && files.isNotEmpty) {
                                          globalFiles = files;

                                          setState(() {
                                            fileName = files.first.name;
                                            fileSize = (files.first.size / 1000)
                                                .toStringAsFixed(
                                              2,
                                            );
                                          });
                                        }
                                      });
                                    },
                                    color: Colors.white,
                                    icon: const Icon(
                                      Icons.upload_file_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '$fileName  $fileSize kB',
                                    style: GoogleFonts.raleway(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            if (optionRequired) ...[
                              _entryField('Correct Option',
                                  _controllerCorrectOption, false),
                            ],
                            _entryField(
                                'Marks Awarded', _controllerMarks, false),
                            _entryField('Negative Marks',
                                _controllerNegativeMarks, false),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                uploadQuestion(
                                  question: _controllerQuestion.text,
                                  questionDomain:
                                      _controllerQuestionDomain.text,
                                  optionRequired: optionRequired,
                                  descriptionRequired: descriptionRequired,
                                  mediaRequired: mediaRequired,
                                  testName: widget.testName,
                                  options: {
                                    '1': _controllerOpt1.text,
                                    '2': _controllerOpt2.text,
                                    '3': _controllerOpt3.text,
                                    '4': _controllerOpt4.text,
                                  },
                                  file: globalFiles,
                                  fileName: fileName,
                                  correctOption:
                                      int.parse(_controllerCorrectOption.text),
                                  marks: int.parse(_controllerMarks.text),
                                  negativeMarks:
                                      int.parse(_controllerNegativeMarks.text),
                                );
                              },
                              child: Text(
                                'UPLOAD',
                                style: GoogleFonts.raleway(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: Text(
              'ADD A QUESTION',
              style: GoogleFonts.raleway(
                color: Colors.black,
                fontSize: 19,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
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
                                questionDetails.mediaLink.toString(),
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
                          Row(
                            children: [
                              Text(
                                "Marks: ${questionDetails.marks}, Negative Marks: -${questionDetails.negativeMarks}, Correct Choice: ${questionDetails.correctOption}",
                                style: GoogleFonts.raleway(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                          "Are you sure you want to delete this question?",
                                          style: GoogleFonts.raleway(
                                            color: Colors.black,
                                          ),
                                        ),
                                        backgroundColor: const Color.fromARGB(
                                            255, 196, 195, 193),
                                        actions: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              deleteQuestion(
                                                  questionID: questionDetails
                                                      .questionID,
                                                  question:
                                                      questionDetails.question,
                                                  testName: widget.testName);
                                            },
                                            child: Text(
                                              "Delete",
                                              style: GoogleFonts.raleway(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.black),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Return to Questions",
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
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
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
