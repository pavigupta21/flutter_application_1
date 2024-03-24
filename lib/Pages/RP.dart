import 'package:flutter/material.dart';
import 'loginpage.dart';

class ResetPass extends StatefulWidget {
  const ResetPass({Key? key}) : super(key: key);

  @override
  _ResetPassState createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmNewPasswordController = TextEditingController();

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.03),
              // Username TextField
              SizedBox(
                width: width * 1.0,
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: height * 0.03),
              // Current Password TextField
              SizedBox(
                width: width * 1.0,
                child: TextField(
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
                child: TextField(
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
                child: TextField(
                  controller: _confirmNewPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: height * 0.03),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: width * 0.5,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your logic to handle the inputs
                        String username = _usernameController.text;
                        String currentPassword =
                            _currentPasswordController.text;
                        String newPassword = _newPasswordController.text;
                        String confirmNewPassword =
                            _confirmNewPasswordController.text;

                        // You can use the variables as needed.

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text('Reset Password'),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.35,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your logic for "Cancel" button
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Color.fromARGB(255, 218, 113, 113),
                      ),
                      child: Text('Cancel'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
