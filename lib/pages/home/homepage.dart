// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_page/pages/home/hotel.dart';
import 'package:login_page/pages/home/transport.dart';
import 'package:login_page/services/auth.dart';

class Myhome extends StatelessWidget {
  const Myhome({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('TripKartz'),
      ),
      drawer: FutureBuilder<User?>(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (userSnapshot.hasError) {
            return Text('Error: ${userSnapshot.error}');
          } else {
            final user = userSnapshot.data;
            if (user == null) {
              return Text('User not logged in');
            }

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Text('User data not found');
                } else {
                  final userDoc = snapshot.data!;
                  if (!userDoc.exists) {
                    return Text('User data not found');
                  }

                  final userData = userDoc.data();
                  if (userData == null || userData is! Map<String, dynamic>) {
                    return Text('User data is invalid');
                  }

                  final userRole = userData['role'];
                  if (userRole == null || userRole != 'admin') {
                    // If user is not an admin, return a drawer without admin-specific elements
                    return ListView(
                      padding: EdgeInsets.all(12),
                      children: [
                        UserAccountsDrawerHeader(
                          accountName:
                              Text(userData['name'] ?? 'Name not provided'),
                          accountEmail:
                              Text(userData['email'] ?? 'Email not provided'),
                        ),
                        ListTile(
                          title: Text('Hotels'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Hotel(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: Text('Transport'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Transport(),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  }

                  // If user is admin, return a drawer with admin-specific elements
                  return ListView(
                    padding: EdgeInsets.all(12),
                    children: [
                      UserAccountsDrawerHeader(
                        accountName:
                            Text(userData['name'] ?? 'Name not provided'),
                        accountEmail:
                            Text(userData['email'] ?? 'Email not provided'),
                      ),
                      ListTile(
                        title: Text('Create Account'),
                        onTap: () {
                          AuthService().authorizeAccess(context);
                        },
                      ),
                      ListTile(
                        title: Text('Hotels'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Hotel(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Transport'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Transport(),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }
              },
            );
          }
        },
      ),
      body: Center(
        child: Text('Hi there!!'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await AuthService().signOut();
        },
        child: Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
