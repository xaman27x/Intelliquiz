import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelliquiz/models/auth.dart';
import 'package:intelliquiz/shared_components/login_state_page.dart';

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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool isObscure = true;

  // Method to authenticate user
  Future<void> _authenticateAndLogin(BuildContext context) async {
    try {
      // Authenticating user with email and password
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
      // Trigger Firestore role check after successful authentication
      // ignore: use_build_context_synchronously
      context.read<LoginCubit>().loginUser(email: _controllerEmail.text);
    } catch (e) {
      // Handle login error here
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Failed: ${e.toString()}')),
      );
    }
  }

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
              _entryField('Email-ID', _controllerEmail, false),
              _entryField('Password', _controllerPassword, isObscure),
              const SizedBox(height: 20),
              IconButton(
                icon: Icon(
                  color: Colors.black,
                  isObscure ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                onPressed: () {
                  // Trigger login and authentication flow
                  _authenticateAndLogin(context);
                },
                child: Text(
                  "LOGIN",
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
