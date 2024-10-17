import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminsInfoPage extends StatefulWidget {
  const AdminsInfoPage({super.key});

  @override
  State<AdminsInfoPage> createState() => _AdminsInfoPageState();
}

class _AdminsInfoPageState extends State<AdminsInfoPage> {
  final Stream<QuerySnapshot> adminStream =
      FirebaseFirestore.instance.collection('Admins').snapshots();

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
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.grey[400],
        child: Center(
          child: StreamBuilder(
            stream: adminStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator.adaptive();
              } else if (!snapshot.hasData) {
                return Text(
                  "Error Fetching Admin Details",
                  style: GoogleFonts.raleway(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var adminData = snapshot.data!.docs[index];
                    var adminName =
                        adminData['First Name'] + ' ' + adminData['Last Name'];
                    var adminEmail = adminData['EmailID'];
                    return ListTile(
                      title: Text(adminName),
                      subtitle: Text(adminEmail),
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
