// ignore_for_file: unused_field, unused_local_variable

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_page/pages/authenticate/signup.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loginAcc(String email, String password) async {
    final log =
        _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> registerAcc(String email, String password) async {
    final reg =
        _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future signOut() async {
    await _auth.signOut();
  }

  Future<void> authorizeAccess(BuildContext context) async {
    final user = _auth.currentUser;
    if (user != null) {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('/users')
          .where('uid', isEqualTo: user.uid)
          .get();
      if (userSnapshot.docs.isNotEmpty) {
        final userData = userSnapshot.docs[0].data();
        final role = userData['role'];
        if (role == 'admin') {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Appsignup()),
          );
        } else {
          print('Not Authorized');
        }
      } else {
        print('User data not found');
      }
    } else {
      print('User not logged in');
    }
  }
}
