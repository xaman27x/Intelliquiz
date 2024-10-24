import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RootStagedTestPage extends StatefulWidget {
  const RootStagedTestPage({super.key});

  @override
  State<RootStagedTestPage> createState() => _RootStagedTestPageState();
}

class _RootStagedTestPageState extends State<RootStagedTestPage> {
  late Stream<QuerySnapshot> testDetailsStream = const Stream.empty();
  late TimeOfDay? selectedTime = TimeOfDay.now();
  late DateTime? selectedDate = DateTime.now();
  late bool showQuestions = false;
  final TextEditingController _controllerDuration = TextEditingController();

  Future<void> scheduleTest(
      {required String testName,
      required String testID,
      required scheduledYear,
      required scheduledMonth,
      required scheduledDay,
      required scheduledHour,
      required scheduledMin,
      required durationInMin}) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Test_Staging')
        .where('testName', isEqualTo: testName)
        .where('testID', isEqualTo: testID)
        .get();
    final dynamic data = querySnapshot.docs.first;
    final int durationInMinInt = int.parse(durationInMin);
    final Timestamp timestamp = Timestamp.fromDate(
      DateTime(
        scheduledYear,
        scheduledMonth,
        scheduledDay,
        scheduledHour,
        scheduledMin,
        0,
      ),
    );
    final Map<String, dynamic> dataUpload = {
      'testID': testID,
      'testName': testName,
      'questions': data['questions'],
      'scheduledTime': timestamp,
      'durationInMin': durationInMinInt,
    };
    await FirebaseFirestore.instance.collection('Tests').add(dataUpload);
  }

  @override
  void initState() {
    testDetailsStream =
        FirebaseFirestore.instance.collection('Test_Staging').snapshots();
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
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            color: Colors.white,
            Icons.arrow_back_ios,
          ),
        ),
      ),
      body: Container(
        color: Colors.grey[400],
        child: StreamBuilder<QuerySnapshot>(
          stream: testDetailsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("An Error Occured"),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data!.docs[index];
                  return ListTile(
                    tileColor: Colors.white,
                    hoverColor: Colors.white,
                    leading: IconButton(
                      onPressed: () => {
                        setState(
                          () {
                            showQuestions = !showQuestions;
                          },
                        ),
                      },
                      icon: Icon(
                        showQuestions
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                      ),
                      color: showQuestions ? Colors.red : Colors.green,
                    ),
                    title: Text(
                      "TEST: ${data['testName']}",
                      style: GoogleFonts.raleway(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "ID: ${data['testID']}",
                      style: GoogleFonts.raleway(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 23, 182, 28),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  content: Column(
                                    children: [
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue[400],
                                        ),
                                        onPressed: () async {
                                          selectedTime = await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          );
                                          setState(() => ());
                                        },
                                        child: Text(
                                          "Select Time",
                                          style: GoogleFonts.raleway(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      Text(
                                        "Picked Time: ${selectedTime!.format(context)}",
                                        style: GoogleFonts.raleway(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue[400],
                                        ),
                                        onPressed: () async {
                                          selectedDate = await showDatePicker(
                                            context: context,
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2050),
                                          );
                                          setState(() => ());
                                        },
                                        child: Text(
                                          "Select Date",
                                          style: GoogleFonts.raleway(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      Text(
                                        "Picked Date: ${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
                                        style: GoogleFonts.raleway(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextField(
                                        controller: _controllerDuration,
                                        decoration: InputDecoration(
                                          icon: const Icon(
                                            Icons.timelapse,
                                            color: Colors.black,
                                          ),
                                          fillColor: Colors.grey[300],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.amber[300],
                                        ),
                                        onPressed: () => {
                                          Navigator.pop(context),
                                          scheduleTest(
                                            testName: data['testName'],
                                            testID: data['testID'],
                                            scheduledYear: selectedDate!.year,
                                            scheduledMonth: selectedDate!.month,
                                            scheduledDay: selectedDate!.day,
                                            scheduledHour: selectedTime!.hour,
                                            scheduledMin: selectedTime!.minute,
                                            durationInMin:
                                                _controllerDuration.text,
                                          ),
                                        },
                                        child: Text(
                                          "FINALISE",
                                          style: GoogleFonts.raleway(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Text(
                        "SCHEDULE",
                        style: GoogleFonts.raleway(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
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
