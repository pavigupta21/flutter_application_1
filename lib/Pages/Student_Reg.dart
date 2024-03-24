import 'package:flutter/material.dart';
import 'choice.dart';
import 'loginpage.dart';

class Student extends StatefulWidget {
  const Student({Key? key}) : super(key: key);

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _registrationIDController = TextEditingController();

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
            // Wrap the title with SingleChildScrollView
            scrollDirection: Axis.horizontal,
            child: Text(
              "Student's Registration Page",
              style: TextStyle(
                  fontSize: width * 0.055), // Adjust the font size as needed
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              // Handle back button press here
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
            child: Column(
              children: <Widget>[
                SizedBox(height: height * 0.02),
                Icon(Icons.person_4_rounded, size: width * 0.3),
                SizedBox(height: height * 0.03),
                buildTextField("Name", _nameController,
                    width: width * 0.8, height: height * 0.1),
                SizedBox(height: height * 0.03),
                buildTextField("Phone number", _phoneNumberController,
                    width: width * 0.8, height: height * 0.1),
                SizedBox(height: height * 0.03),
                buildTextField("Email ID", _emailController,
                    width: width * 0.8, height: height * 0.1),
                SizedBox(height: height * 0.03),
                buildTextField("Registration ID", _registrationIDController,
                    width: width * 0.8, height: height * 0.1),
                SizedBox(height: height * 0.02),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller,
      {double? width, double? height}) {
    return Container(
      width: width,
      height: height,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
