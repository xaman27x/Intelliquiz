import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminTestCreator extends StatefulWidget {
  const AdminTestCreator({super.key});

  @override
  State<AdminTestCreator> createState() => _AdminTestCreatorState();
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
            children: [
              ElevatedButton(
                onPressed: () {},
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
