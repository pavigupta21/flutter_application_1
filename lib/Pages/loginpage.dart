import 'package:flutter/material.dart';
import 'choice.dart';
import 'FP.dart';
import 'RP.dart';
import 'Student_pg.dart';
import 'Teacher_pg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum Choice {
  student,
  teacher,
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username = "", password = "";
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  registration() async {
    if (password != null) {
      try {
        if (FirebaseAuth.instance.currentUser != null)
          print(FirebaseAuth.instance.currentUser?.uid);
      } catch (e) {
        print("Error occurred: $e");
        // Handle error
      }
    }
  }

  double _opacity = 0.0;
  double _containerHeight = 80.0;
  Choice? _selectedRole;

  @override
  void initState() {
    super.initState();
    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      _opacity = 1.0;
      _containerHeight = 80.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size;
    var height;
    var width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blueAccent,
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.1),
                AnimatedOpacity(
                  duration: Duration(seconds: 3),
                  opacity: _opacity,
                  child: Text(
                    "Let's get started...",
                    style: TextStyle(
                      fontSize: width * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Container(
                        width: width * 0.8,
                        padding: EdgeInsets.symmetric(
                            vertical: height * 0.005, horizontal: width * 0.04),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(width * 0.04),
                        ),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter Username";
                            }
                            return null;
                          },
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Container(
                        width: width * 0.8,
                        padding: EdgeInsets.symmetric(
                            vertical: height * 0.005, horizontal: width * 0.04),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(width * 0.04),
                        ),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter Password";
                            }
                            return null;
                          },
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.005),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            print("Form is valid. Proceeding to login page.");
                            // Your existing login logic
                            try {
                              final userDoc = await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(_nameController.text)
                                  .get();
                              if (userDoc.exists) {
                                final userData = userDoc.data();
                                final storedPassword = userData?['password'];
                                final role = userData?['role'];
                                if (storedPassword ==
                                    _passwordController.text) {
                                  if (role == 'student') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Doubt()),
                                    );
                                  } else if (role == 'teacher') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Answer()),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Invalid role"),
                                      ),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Incorrect password"),
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Username not found"),
                                  ),
                                );
                              }
                            } catch (e) {
                              print("Error occurred: $e");
                            }
                          } else {
                            print("Form validation failed.");
                          }
                          print("Login Button Pressed");
                        },
                        child: Text('Login'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                        ),
                      ),
                      SizedBox(height: height * 0.005),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildLink('forgot_password', 'Forgot Password'),
                          SizedBox(width: width * 0.05),
                          buildLink('reset_password', 'Reset Password'),
                        ],
                      ),
                      SizedBox(height: height * 0.01),
                      Text("Don't have an account?"),
                      SizedBox(height: height * 0.01),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                          );
                        },
                        child: Text('Create an account'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLink(String route, String text) {
    return InkWell(
      onTap: () {
        if (route == 'forgot_password') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ForgotPass()),
          );
        } else if (route == 'reset_password') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ResetPass()),
          );
        }
      },
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
