import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'choice.dart';
import 'loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Teacher extends StatefulWidget {
  const Teacher({Key? key}) : super(key: key);

  @override
  State<Teacher> createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> {
  String Username = "",
      Phonenumber = "",
      EmailID = "",
      Password = "",
      Subjectyouteach = "";
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String? _selectedSubject;

  final _formkey = GlobalKey<FormState>();

  registration() async {
    if (Password != null) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: EmailID, password: Password);
        await FirebaseFirestore.instance
            .collection('students')
            .doc(userCredential.user!.uid)
            .set({
          'username': Username,
          'phoneNumber': Phonenumber,
          'email': EmailID,
          'role': 'teacher', // Set role here
          'subject': Subjectyouteach
        }); // Added closing parenthesis here
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registered successfully"),
          ),
        );
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          // If email already in use, show snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Account already exists"),
            ),
          );
        }
      } catch (e) {
        print("Error occurred: $e");
        // Handle error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size;
    var height;
    var width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: SingleChildScrollView(
            // Wrap the title text widget with SingleChildScrollView
            scrollDirection: Axis.horizontal,
            child: Text(
              "Teacher's Registration Page",
              style: TextStyle(
                fontSize: width * 0.055,
              ),
            ),
          ),
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.black,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
            ),
          ),
        ),
        backgroundColor: Colors.blueAccent,
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formkey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: height * 0.02),
                  Icon(Icons.person_4_rounded, size: width * 0.3),
                  SizedBox(height: height * 0.02),
                  Container(
                    width: width * 0.8,
                    height: height * 0.1,
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
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  Container(
                    width: width * 0.8,
                    height: height * 0.1,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter Phone number";
                        }
                        return null;
                      },
                      controller: _phoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Phone number',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  Container(
                    width: width * 0.8,
                    height: height * 0.1,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter Email ID";
                        }
                        return null;
                      },
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email ID',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  Container(
                    width: width * 0.8,
                    height: height * 0.1,
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
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  Container(
                    width: width * 0.8,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Subject you teach',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      value: _selectedSubject,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedSubject = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please choose a subject';
                        }
                        return null;
                      },
                      items: <String>['EM', 'BXE', 'phy', 'chem']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        setState(() {
                          EmailID = _emailController.text;
                          Username = _nameController.text;
                          Password = _passwordController.text;
                          Phonenumber = _phoneNumberController.text;
                          Subjectyouteach = _selectedSubject ?? '';
                        });
                        registration(); // Move registration call here
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      } else {
                        print("Form validation failed.");
                      }
                    },
                    child: Text('Register'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
