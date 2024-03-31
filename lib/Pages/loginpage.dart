import 'package:flutter/material.dart';
import 'choice.dart';
import 'FP.dart';
import 'RP.dart';
import 'Student_pg.dart';
import 'Teacher_pg.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: username, password: password);
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
                            } else if (value.length < 8) {
                              return "Password must be at least 8 characters long";
                            } else if (!RegExp(r'\d').hasMatch(value)) {
                              return "Password must have at least 1 no.";
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
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Login as:',
                                style: TextStyle(
                                  fontSize: width * 0.04,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Radio(
                                value: Choice.student,
                                groupValue: _selectedRole,
                                onChanged: (Choice? value) {
                                  setState(() {
                                    _selectedRole = value;
                                  });
                                },
                              ),
                              Text('Student'),
                              SizedBox(width: width * 0.04),
                              Radio(
                                value: Choice.teacher,
                                groupValue: _selectedRole,
                                onChanged: (Choice? value) {
                                  setState(() {
                                    _selectedRole = value;
                                  });
                                },
                              ),
                              Text('Teacher'),
                            ],
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            print("Form is valid. Proceeding to login page.");
                            if (_selectedRole == Choice.student) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Doubt()),
                              );
                            } else if (_selectedRole == Choice.teacher) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Answer()),
                              );
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
