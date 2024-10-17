import 'package:cloud_firestore/cloud_firestore.dart';

class CandidateDetails {
  late String userID;
  late dynamic misID;
  late String firstName;
  late String lastName;
  late String email;
  late String testStatus;
  late Timestamp accessExpiry;
  CandidateDetails({
    required this.userID,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.testStatus,
    required this.accessExpiry,
  });
}
