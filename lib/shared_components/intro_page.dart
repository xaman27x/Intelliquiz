import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intelliquiz/shared_components/login_state_page.dart';
import 'package:intelliquiz/shared_components/pass_reset.dart';
import 'package:intelliquiz/shared_components/register_page.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
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
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/background.jpg'),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          // Foreground content
          Container(
            color: const Color.fromARGB(255, 206, 205, 205)
                .withOpacity(0.5), // Optional: to darken the background
            child: Column(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    "Welcome to SDS Online Quiz Portal!",
                    style: GoogleFonts.orbitron(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 45),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginStatePage(),
                      ),
                    );
                  },
                  child: Text(
                    "LOGIN",
                    style: GoogleFonts.oxanium(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                  child: Text(
                    "REGISTER",
                    style: GoogleFonts.oxanium(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PasswordResetPage(),
                      ),
                    );
                  },
                  child: Text(
                    "Forgot Password?",
                    style: GoogleFonts.oxanium(
                      color: Colors.white,
                      fontSize: 19,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () {},
                  child: Text(
                    "Admin Registration",
                    style: GoogleFonts.oxanium(
                      color: Colors.white,
                      fontSize: 19,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
