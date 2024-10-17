import 'package:flutter/material.dart';
import 'package:intelliquiz/admin_components/admin_test_creator.dart';
import 'package:intelliquiz/admin_components/admins_info_page.dart';
import 'package:intelliquiz/models/auth.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePage();
}

class _AdminHomePage extends State<AdminHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> signOut() async {
    await Auth().signOut();
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
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
            ),
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
        ],
      ),
      body: Container(
        color: Colors.grey[400],
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminsInfoPage(),
                  ),
                );
              },
              child: Text(
                "ADMINS",
                style: GoogleFonts.raleway(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminTestCreator(),
                  ),
                );
              },
              child: Text(
                "TEST CREATOR",
                style: GoogleFonts.raleway(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
