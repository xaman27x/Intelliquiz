import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intelliquiz/models/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RootStagedTestPage extends StatefulWidget {
  const RootStagedTestPage({super.key});

  @override
  State<RootStagedTestPage> createState() => _RootStagedTestPageState();
}

class _RootStagedTestPageState extends State<RootStagedTestPage> {
  late Stream<QuerySnapshot> testDetailsStream = const Stream.empty();
  Future<void> signOut() async {
    await Auth().signOut();
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
                            return AlertDialog(content: Column());
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
