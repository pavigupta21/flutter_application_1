import 'package:flutter/material.dart';
import 'choice.dart';
import 'loginpage.dart';

class Teacher extends StatefulWidget {
  const Teacher({Key? key}) : super(key: key);

  @override
  State<Teacher> createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _subjectController = TextEditingController();

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
            scrollDirection:
                Axis.horizontal, // Set scroll direction to horizontal
            child: Text(
              "Teacher's Registration Page",
              // Update the title text here
              style: TextStyle(
                  fontSize: width * 0.055), // Adjust font size if needed
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
            child: Column(
              children: <Widget>[
                SizedBox(height: height * 0.02),
                Icon(Icons.person_4_rounded, size: width * 0.3),
                SizedBox(height: height * 0.02),
                buildTextField("Name", _nameController,
                    width: width * 0.8, height: height * 0.1),
                SizedBox(height: height * 0.03),
                buildTextField("Phone number", _phoneNumberController,
                    width: width * 0.8, height: height * 0.1),
                SizedBox(height: height * 0.03),
                buildTextField("Email ID", _emailController,
                    width: width * 0.8, height: height * 0.1),
                SizedBox(height: height * 0.03),
                buildTextField("Subject you teach", _subjectController,
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
