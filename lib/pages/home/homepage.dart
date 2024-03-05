// ignore_for_file: prefer_const_constructors, sort_child_properties_last, unnecessary_new

import 'package:flutter/material.dart';
import 'package:login_page/pages/authenticate/signup.dart';
import 'package:login_page/pages/home/hotel.dart';
import 'package:login_page/pages/home/transport.dart';
import 'package:login_page/services/auth.dart';

class Myhome extends StatelessWidget {
  const Myhome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('TripKartz'),
      ),
      drawer: ListView(
        padding: EdgeInsets.all(12),
        children: [
          new UserAccountsDrawerHeader(
              accountName: new Text('Test'),
              accountEmail: Text('sanjks@skms.com')),
          new ListTile(
            title: new Text('Create Account'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Appsignup(),
                  ));
            },
          ),
          new ListTile(
            title: new Text('Hotels'),
            onTap: () {
              AuthService().authorizeAccess(context);
            },
          ),
          new ListTile(
            title: new Text('Transport'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Transport(),
                  ));
            },
          )
        ],
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
