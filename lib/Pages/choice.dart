import 'package:flutter/material.dart';
import 'Student_Reg.dart';
import 'Teacher_Reg.dart';
import 'loginpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size;
    var height;
    var width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Disable default back button
        leading: Padding(
          padding: EdgeInsets.symmetric(vertical: height * 0.01),
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              // Handle back button press here
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'lib/assets/images.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * 0.5),
                  Text(
                    "Choose your role:",
                    style: TextStyle(
                      fontSize: width * 0.06, // Adjusted font size
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Center(
                // Wrap the row with Center widget
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Align buttons to the center
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              width * 0.05), // Add padding around the button
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Student()),
                          );
                        },
                        icon: const Icon(Icons.person),
                        label: const Text(
                          "Student",
                          style: TextStyle(fontSize: 13), // Adjusted font size
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              width * 0.05), // Add padding around the button
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Teacher()),
                          );
                        },
                        icon: const Icon(Icons.person),
                        label: const Text(
                          "Teacher",
                          style: TextStyle(fontSize: 13), // Adjusted font size
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
