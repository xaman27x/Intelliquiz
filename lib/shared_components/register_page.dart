import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intelliquiz/models/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String errorMessage = '';

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

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _controllerMIS = TextEditingController();
  final TextEditingController _controllerFirstName = TextEditingController();
  final TextEditingController _controllerLastName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerAdminAccessCode =
      TextEditingController(); // Controller for Admin Access Code
  bool isObscure = false;
  bool isAdmin = false;
  bool isCandidate = false;

  Future<void> registerUser() async {
    bool adminPerms =
        await checkAdminAccessCode(code: _controllerAdminAccessCode.text);
    try {
      Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
    final Map<String, dynamic> dataUpload = {
      'First Name': _controllerFirstName.text,
      'Last Name': _controllerLastName.text,
      'MIS': int.parse(_controllerMIS.text),
      'EmailID': _controllerEmail.text,
      'isAdmin': adminPerms,
    };

    if (adminPerms && isAdmin) {
      await FirebaseFirestore.instance.collection('Admins').add(dataUpload);
      debugPrint("Admin Added!");
    } else if (!adminPerms && isAdmin) {
      setState(() {
        errorMessage = "Incorrect Admin Access Key!";
      });
    } else {
      await FirebaseFirestore.instance.collection('Candidates').add(dataUpload);
      debugPrint('Candidate Added!');
    }
  }

  Future<bool> checkAdminAccessCode({required String code}) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Admin_Access_Code')
        .where('isCode', isEqualTo: true)
        .get();

    final dynamic data = querySnapshot.docs.first;
    if (data['AccessCode'] == code) {
      debugPrint("Access Granted!");
      return true;
    }
    return false;
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
              _entryField('First Name', _controllerFirstName, false),
              _entryField('Last Name', _controllerLastName, false),
              _entryField('MIS ID', _controllerMIS, false),
              _entryField('Email-ID', _controllerEmail, false),
              _entryField('Password', _controllerPassword, isObscure),
              const SizedBox(height: 20),
              IconButton(
                color: Colors.black,
                icon: Icon(
                  isObscure ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(
                    () {
                      isObscure = !isObscure;
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
              ToggleButtons(
                isSelected: [isAdmin, isCandidate],
                onPressed: (index) {
                  setState(() {
                    if (index == 0) {
                      isAdmin = true;
                      isCandidate = false;
                    } else {
                      isAdmin = false;
                      isCandidate = true;
                    }
                  });
                },
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isAdmin ? Colors.green : Colors.black,
                      side: isAdmin
                          ? const BorderSide(color: Colors.green, width: 2)
                          : const BorderSide(color: Colors.white, width: 1),
                    ),
                    onPressed: () {
                      setState(() {
                        isAdmin = true;
                        isCandidate = false;
                      });
                    },
                    child: Text(
                      "Admin",
                      style: GoogleFonts.orbitron(
                        color: isAdmin ? Colors.black : Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isCandidate ? Colors.green : Colors.black,
                      side: isCandidate
                          ? const BorderSide(color: Colors.green, width: 2)
                          : const BorderSide(color: Colors.white, width: 1),
                    ),
                    onPressed: () {
                      setState(() {
                        isAdmin = false;
                        isCandidate = true;
                      });
                    },
                    child: Text(
                      "Candidate",
                      style: GoogleFonts.orbitron(
                        color: isCandidate ? Colors.black : Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              if (isAdmin)
                _entryField(
                    'Admin Access Code', _controllerAdminAccessCode, false),
              const SizedBox(
                height: 15,
              ),
              Text(
                errorMessage,
                style: const TextStyle(
                  color: Color.fromARGB(255, 232, 18, 18),
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                onPressed: () {
                  registerUser();
                },
                child: Text(
                  "REGISTER",
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
