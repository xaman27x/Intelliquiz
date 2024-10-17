import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminManagementPage extends StatefulWidget {
  const AdminManagementPage({super.key});

  @override
  State<AdminManagementPage> createState() => _AdminManagementPageState();
}

class _AdminManagementPageState extends State<AdminManagementPage> {
  final Stream<QuerySnapshot> adminStream =
      FirebaseFirestore.instance.collection('Admins').snapshots();

  Future<void> revokeAdmin({required String email}) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Admins')
        .where('EmailID', isEqualTo: email)
        .get();
    final dynamic id = querySnapshot.docs.first.id;
    await FirebaseFirestore.instance.collection('Admins').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            color: Colors.white,
            Icons.arrow_back_ios,
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
      body: Container(
        color: Colors.grey[350],
        child: Center(
          child: StreamBuilder<QuerySnapshot>(
            stream: adminStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Text('Error Occurred');
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text('No Admins Found');
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var adminData = snapshot.data!.docs[index];
                    String adminName =
                        adminData['First Name'] + ' ' + adminData['Last Name'];
                    String adminEmail = adminData['EmailID'];

                    return ListTile(
                      title: Text(adminName),
                      subtitle: Text(adminEmail),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Show confirmation dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Delete Admin'),
                                content: Text(
                                  'Are you sure you want to Remove $adminName as an Admin?',
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text(
                                      'Revoke Admin Role',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () {
                                      revokeAdmin(email: adminEmail);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
