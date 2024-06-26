import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({Key? key}) : super(key: key);

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  String Email_ID = "";
  TextEditingController _Email_IDController = TextEditingController();
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
        title: const Text("Forgot/Reset Password"),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: height * 0.1), // Adjusted height for spacing
              Center(
                child: Text(
                  'Verify your email',
                  style: TextStyle(
                    fontSize: width * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter Email ID";
                    } else if (!EmailValidator.validate(value)) {
                      return "Please enter a valid email address";
                    }
                    return null;
                  },
                  controller: _Email_IDController,
                  decoration: InputDecoration(
                    labelText: 'Email ID',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  style: TextStyle(fontSize: width * 0.04),
                ),
              ),
              SizedBox(height: height * 0.03),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      Email_ID = _Email_IDController.text;
                    });
                    try {
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: Email_ID);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Password reset email sent'),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to send password reset email'),
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blueAccent,
                  disabledForegroundColor: Colors.white,
                ),
                child: Text(
                  'Send Password Reset Email',
                  style: TextStyle(fontSize: width * 0.04),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
