import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelliquiz/admin_components/admin_home_page.dart';
import 'package:intelliquiz/candidate_components/candidate_home_page.dart';
import 'package:intelliquiz/root_components/root_home_page.dart';
import 'package:intelliquiz/shared_components/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intelliquiz/models/auth.dart';

enum LoginStatus { initial, loading, authenticated, error }

class LoginState {
  final LoginStatus status;
  final int? role;
  final String? errorMessage;

  LoginState({
    this.status = LoginStatus.initial,
    this.role,
    this.errorMessage,
  });
}

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState());

  Future<void> loginUser({required String email}) async {
    debugPrint("Login process started");
    emit(LoginState(status: LoginStatus.loading));

    try {
      // Check if the user is authenticated first
      final user = Auth().currentUser;
      if (user == null || user.email != email) {
        debugPrint("User not authenticated or email mismatch");
        emit(LoginState(
            status: LoginStatus.error, errorMessage: "Authentication failed"));
        return;
      }

      // User is authenticated, now check the role
      debugPrint("User authenticated. Checking role...");

      // Check Root Admin role
      final QuerySnapshot querySnapshot1 = await FirebaseFirestore.instance
          .collection('Root_Admin')
          .where('EmailID', isEqualTo: email)
          .get();

      if (querySnapshot1.docs.isNotEmpty) {
        debugPrint("User is Root Admin");
        emit(LoginState(status: LoginStatus.authenticated, role: 2));
        return;
      }

      // Check Admin role
      final QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
          .collection('Admins')
          .where('EmailID', isEqualTo: email)
          .get();

      if (querySnapshot2.docs.isNotEmpty) {
        debugPrint("User is Admin");
        emit(LoginState(status: LoginStatus.authenticated, role: 1));
        return;
      }

      // If not in Root_Admin or Admin, default to Candidate
      debugPrint("User is Candidate");
      emit(LoginState(status: LoginStatus.authenticated, role: 0));
    } catch (e) {
      debugPrint("Error during login: $e");
      emit(LoginState(status: LoginStatus.error, errorMessage: e.toString()));
    }
  }
}

class LoginStatePage extends StatelessWidget {
  const LoginStatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          if (state.status == LoginStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == LoginStatus.authenticated) {
            debugPrint("User authenticated with role: ${state.role}");
            if (state.role == 2) {
              return const RootHomePage(); // Root Admin Page
            } else if (state.role == 1) {
              return const AdminHomePage(); // Admin Page
            } else {
              return const CandidateHomePage(); // Candidate Page
            }
          }

          if (state.status == LoginStatus.error) {
            return Center(
              child: Text(
                "Login Error: ${state.errorMessage}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const LoginPage(); // Default back to login if not authenticated
        },
      ),
    );
  }
}
