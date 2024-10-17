import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDetails {
  late String userID;
  late String firstName;
  late String lastName;
  late String email;
  late Timestamp timestamp;
  late String permissions;
  AdminDetails({
    required this.userID,
    required this.firstName,
    required this.lastName,
    required this.timestamp,
    required this.permissions,
  });
}
