import 'package:flutter/material.dart';
import 'choice.dart';
import 'FP.dart';
import 'RP.dart';
import 'Student_pg.dart';
import 'Teacher_pg.dart';

enum Choice {
  student,
  teacher,
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                  duration: Duration(seconds: 1),
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
                Container(
                  width: width * 0.8,
                  padding: EdgeInsets.symmetric(
                      vertical: height * 0.005, horizontal: width * 0.04),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(width * 0.04),
                  ),
                  child: TextFormField(
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
                    if (_selectedRole == Choice.student) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Doubt()),
                      );
                    } else if (_selectedRole == Choice.teacher) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Answer()),
                      );
                    }
                    print("Login Button Pressed");
                  },
                  child: Text('Login'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
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
                    primary: Colors.white,
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
