import 'package:flutter/material.dart';
import 'loginpage.dart';

class ForgotPassNew extends StatefulWidget {
  const ForgotPassNew({Key? key}) : super(key: key);

  @override
  State<ForgotPassNew> createState() => _ForgotPassNewState();
}

class _ForgotPassNewState extends State<ForgotPassNew> {
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
        title: Text("Confirm New Password"), // Set the title here
        backgroundColor: Colors.blueAccent, // Set the background color here
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press here
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
                SizedBox(height: height * 0.02),
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
                    labelText: 'Confirm New Password',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: height * 0.02),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Add your logic to handle the passwords
                      String newPassword = _newPasswordController.text;
                      String confirmNewPassword =
                          _confirmNewPasswordController.text;
                      // You can use the 'newPassword' and 'confirmNewPassword' variables as needed.
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blueAccent,
                    // Set the button background color here
                    disabledForegroundColor:
                        Colors.white, // Set the text color here
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
