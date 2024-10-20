import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDetails {
  final String userID;
  final String firstName;
  final String lastName;
  final String email;
  final Timestamp timestamp;
  final String permissions;
  AdminDetails({
    required this.userID,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.timestamp,
    required this.permissions,
  });
}
