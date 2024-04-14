/*import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResetPass extends StatefulWidget {
  const ResetPass({Key? key}) : super(key: key);

  @override
  _ResetPassState createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  String Email_ID = "";
  String currentPassword = "";
  String newPassword = "";
  String confirmNewPassword = "";
  String errorMessage = "";
  TextEditingController _Email_IDController = TextEditingController();
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmNewPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var size;
    var height;
    var width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.05, vertical: height * 0.01),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.03),
                // Username TextField
                SizedBox(
                  width: width * 1.0,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter Email ID";
                      }
                      return null;
                    },
                    controller: _Email_IDController,
                    decoration: InputDecoration(
                      labelText: 'Email ID',
                      errorText: errorMessage,
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.03),
                // Current Password TextField
                SizedBox(
                  width: width * 1.0,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                    controller: _currentPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Current Password',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.03),
                // New Password TextField
                SizedBox(
                  width: width * 1.0,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                    controller: _newPasswordController,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.03),
                // Confirm New Password TextField
                SizedBox(
                  width: width * 1.0,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                    controller: _confirmNewPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm New Password',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.05),
                // Update Button
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        await resetPassword();
                        showSnackBar("Password updated successfully", context);
                      } catch (e) {
                        errorMessage = e.toString();
                        setState(() {});
                      }
                    }
                  },
                  child: Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blueAccent,
                    disabledForegroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> resetPassword() async {
    try {
      String email = _Email_IDController.text.trim();
      if (email.isEmpty) {
        throw ("Please enter Email ID");
      }
      // Check if the user is registered in Firestore
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      if (snapshot.docs.isEmpty) {
        throw ("User not registered in Firestore");
      }
      // Update the user's password
      await FirebaseAuth.instance.currentUser!
          .updatePassword(_newPasswordController.text);
      showSnackBar("Password updated successfully", context);
    } catch (e) {
      errorMessage = e.toString();
      setState(() {});
    }
  }
}*/
