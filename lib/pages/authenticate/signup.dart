// ignore_for_file: prefer_const_constructors, sort_child_properties_last, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:login_page/models/user.dart';
import 'package:login_page/services/auth.dart';
import 'package:login_page/services/firestore.dart';

class Appsignup extends StatefulWidget {
  const Appsignup({Key? key}) : super(key: key);

  @override
  State<Appsignup> createState() => _AppsignupState();
}

class _AppsignupState extends State<Appsignup> {
  User userLogin = User();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();

  bool passkey = true;

  bool conpassKey = true;

  bool userRole = false;

  bool adminRole = false;

  bool roleSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.0),
              TextFormField(
                controller: nameController,
                onChanged: (value) {
                  setState(
                    () {
                      userLogin.name = value;
                    },
                  );
                },
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(10.0), // Circular border radius
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.0),
              TextFormField(
                controller: phoneController,
                onChanged: (value) {
                  setState(
                    () {
                      userLogin.phoneNum = value;
                    },
                  );
                },
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(10.0), // Circular border radius
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.0),
              TextFormField(
                controller: emailController,
                onChanged: (value) {
                  setState(
                    () {
                      userLogin.emailId = value;
                    },
                  );
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(10.0), // Circular border radius
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.0),
              TextFormField(
                controller: passwordController,
                obscureText: passkey,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon:
                        Icon(passkey ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        passkey = !passkey;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.0),
              TextFormField(
                controller: confirmPassword,
                obscureText: conpassKey,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          conpassKey = !conpassKey;
                        });
                      },
                      icon: Icon(
                          passkey ? Icons.visibility : Icons.visibility_off)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value != passwordController.text) {
                    return 'Password does not macth';
                  }

                  return null;
                },
              ),
              SizedBox(height: 20.0),
              Text(
                'Mandatory',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Checkbox(
                    value: userRole,
                    onChanged: (bool? value) {
                      setState(() {
                        userRole = value!;
                        adminRole = !value;
                        userLogin.role = userRole ? 'user' : 'admin';
                        roleSelected = true;
                      });
                    },
                  ),
                  Text('User'),
                  Checkbox(
                      value: adminRole,
                      onChanged: (bool? value) {
                        setState(() {
                          adminRole = value!;
                          userRole = !value;
                          userLogin.role = userRole ? 'user' : 'admin';
                          roleSelected = true;
                        });
                      }),
                  Text('Admin')
                ],
              ),
              Center(
                child: ElevatedButton(
                  onPressed: roleSelected
                      ? () async {
                          if (_formKey.currentState!.validate()) {
                            String name = nameController.text;
                            String phone = phoneController.text;
                            String email = emailController.text;
                            String password = passwordController.text;
                            String role = userLogin.role.toString();

                            await FirestoreService()
                                .addUser(name, phone, email, role);

                            try {
                              await _auth.registerAcc(email, password);
                            } catch (e) {
                              print('Error');
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Registered successfully')),
                            );
                            nameController.clear();
                            phoneController.clear();
                            emailController.clear();
                            passwordController.clear();

                            Navigator.pop(context);
                          }
                        }
                      : null,
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 1, 38, 245))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
