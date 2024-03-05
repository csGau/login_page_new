// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:login_page/pages/authenticate/forgotpassword.dart';
import 'package:login_page/services/auth.dart';
import 'package:login_page/services/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Applogin extends StatefulWidget {
  const Applogin({Key? key}) : super(key: key);

  @override
  State<Applogin> createState() => _ApploginState();
}

class _ApploginState extends State<Applogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _auth = AuthService();

  final _loginKey = GlobalKey<FormState>();

  bool loading = false;

  bool rememberMeChecked = false;

  bool passKey = true;

  @override
  void initState() {
    loadRememberedPreference();
    super.initState();
  }

  Future<void> loadRememberedPreference() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      rememberMeChecked = pref.getBool('rememberMe') ?? false;
      if (rememberMeChecked) {
        emailController.text = pref.getString('email') ?? '';
        passwordController.text = pref.getString('password') ?? '';
      }
    });
  }

  Future<void> saveRememberedPreference(bool value) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('rememberMe', value);
    if (!value) {
      await pref.remove('email');
      await pref.remove('password');
    }
  }

  Future<void> setPersistence(bool rememberMeChecked) async {
    final persist = rememberMeChecked ? Persistence.SESSION : Persistence.NONE;
    await FirebaseAuth.instance.setPersistence(persist);
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                  Text(
                    'Portal',
                    style: TextStyle(color: Colors.indigo),
                  )
                ],
              ),
            ),
            body: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Form(
                  key: _loginKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.0),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(),
                        ),
                        child: TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.mail_lock_outlined),
                            border: InputBorder.none,
                            labelText: 'Email Id',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 2.0),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email is required';
                            } else if (!RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 24.0),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(),
                        ),
                        child: TextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: passKey,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Password',
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    passKey = !passKey;
                                  });
                                },
                                icon: Icon(passKey
                                    ? Icons.visibility
                                    : Icons.visibility_off)),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 2.0),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Must not be empty';
                            }
                            return null;
                          },
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPassword(),
                              ));
                        },
                        child: Text(
                          'Forgot Password',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        children: [
                          Checkbox(
                            value: rememberMeChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                rememberMeChecked = value!;
                                saveRememberedPreference(value);
                                setPersistence(rememberMeChecked);
                              });
                            },
                          ),
                          Text('Remember me'),
                        ],
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_loginKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });
                              final email = emailController.text.trim();
                              final password = passwordController.text.trim();

                              try {
                                await _auth.loginAcc(email, password);
                                if (rememberMeChecked) {
                                  saveCredentials(email, password);
                                }
                              } catch (e) {
                                setState(() {
                                  loading = false;
                                });
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Invalid credentials')));
                            }
                          },
                          child: Text(
                            'Sign In',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Color.fromARGB(255, 2, 39, 246))),
                        ),
                      ),
                      SizedBox(height: 2.0),
                      SizedBox(
                        height: 3.0,
                      ),
                      Center(
                        child: Text(
                          'Not a member? Contact Admin',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Future<void> saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
