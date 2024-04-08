import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'choice.dart';
import 'loginpage.dart';

class Student extends StatefulWidget {
  const Student({Key? key}) : super(key: key);

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  String Username = "", Phonenumber = "", EmailID = "", Password = "";
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

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
          'role': 'student', // Assuming it's a student registration
        }); // Added missing semicolon here
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
            scrollDirection: Axis.horizontal,
            child: Text(
              "Student's Registration Page",
              style: TextStyle(
                fontSize: width * 0.055,
              ),
            ),
          ),
          leading: IconButton(
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
        backgroundColor: Colors.blueAccent,
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formkey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: height * 0.02),
                  Icon(Icons.person_4_rounded, size: width * 0.3),
                  SizedBox(height: height * 0.03),
                  Container(
                    width: width * 0.8,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter Username";
                        }
                        return null;
                      },
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "Username",
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  Container(
                    width: width * 0.8,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter Phone number";
                        }
                        return null;
                      },
                      controller: _phoneNumberController,
                      decoration: InputDecoration(
                        labelText: "Phone number",
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  Container(
                    width: width * 0.8,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter Email ID";
                        }
                        return null;
                      },
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email ID",
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  Container(
                    width: width * 0.8,
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
                        labelText: "Password",
                        filled: true,
                        fillColor: Colors.white,
                      ),
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
                        });
                        registration(); // Move registration call here
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
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
