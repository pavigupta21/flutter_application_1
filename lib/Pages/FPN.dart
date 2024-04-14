import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPassNew extends StatefulWidget {
  const ForgotPassNew({Key? key}) : super(key: key);

  @override
  State<ForgotPassNew> createState() => _ForgotPassNewState();
}

class _ForgotPassNewState extends State<ForgotPassNew> {
  final _auth = FirebaseAuth.instance;
  String newPassword = "";
  String confirmNewPassword = "";
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmNewPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Confirm New Password"),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.05, vertical: height * 0.02),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.05),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This field is required";
                    } else if (value.length < 8) {
                      return "Password must be at least 8 characters long";
                    } else if (!value.contains(new RegExp(r'\d'))) {
                      return "Password must contain at least one number";
                    }
                    return null;
                  },
                  controller: _newPasswordController,
                  decoration: InputDecoration(
                    hintText: "New Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: height * 0.03),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This field is required";
                    } else if (value != _newPasswordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                  controller: _confirmNewPasswordController,
                  decoration: InputDecoration(
                    hintText: "Confirm New Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: height * 0.05),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      newPassword = _newPasswordController.text;
                      confirmNewPassword = _confirmNewPasswordController.text;

                      try {
                        User? user = _auth.currentUser;
                        if (user != null) {
                          await user.updatePassword(
                              newPassword); // Update the user's password
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Password updated successfully'),
                            ),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to update password'),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blueAccent,
                  ),
                  child: Text('Confirm'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
