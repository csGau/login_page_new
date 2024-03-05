// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Center(
        child: Text(
          'Contact admin',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
