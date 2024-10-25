import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminTestResultGroupPage extends StatelessWidget {
  final Stream<QuerySnapshot> testStream =
      FirebaseFirestore.instance.collection("Tests").snapshots();
  AdminTestResultGroupPage({super.key});

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
                  "An Error Occured",
                  style: GoogleFonts.raleway(),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data!.docs[index];
                  return ListTile(
                    leading: const Icon(
                      Icons.bookmark_added,
                      color: Colors.black,
                    ),
                    title: Text(
                      data["testName"],
                      style: GoogleFonts.raleway(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      "Scheduled Time: ${data["scheduledTime"]}",
                      style: GoogleFonts.raleway(
                        color: Colors.black,
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
    );
  }
}
