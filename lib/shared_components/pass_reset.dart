import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intelliquiz/models/auth.dart';

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

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({super.key});

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  Future<void> resetPassword({
    required String email,
  }) async {
    await Auth().sendPasswordResetEmail(email: email);
  }

  final TextEditingController _controllerEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
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
          Container(
            color: const Color.fromARGB(255, 206, 205, 205).withOpacity(0.5),
          ),
          Column(
            children: [
              _entryField(
                'Email-ID',
                _controllerEmail,
                false,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                onPressed: () {
                  resetPassword(email: _controllerEmail.text);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    Text(
                      "Send Password Reset Link",
                      style: GoogleFonts.orbitron(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
