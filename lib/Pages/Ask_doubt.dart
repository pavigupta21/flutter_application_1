import 'package:flutter/material.dart';
import 'Student_pg.dart';
import 'Doubt_Hist.dart';
import 'Chatbox.dart';

void main() {
  runApp(Ask());
}

class Ask extends StatefulWidget {
  const Ask({Key? key}) : super(key: key);

  @override
  State<Ask> createState() => _AskState();
}

class _AskState extends State<Ask> {
  // Selected values for the dropdowns
  String? selectedSubject;
  String? selectedTeacher;

  // Dummy data for dropdowns (replace with your data)
  List<String> subjects = ['EM', 'BXE', 'Phy', 'Chem'];
  List<String> teachers = ['Teacher A', 'Teacher B', 'Teacher C'];

  @override
  Widget build(BuildContext context) {
    var size;
    var height;
    var width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar: AppBar(),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text for Doubt Subjects
            Text('Doubt related to which subject?'),
            Align(
              alignment: Alignment.center,
              child: DropdownButton<String>(
                value: selectedSubject,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSubject = newValue!;
                  });
                },
                items: subjects.map((String subject) {
                  return DropdownMenuItem<String>(
                    value: subject,
                    child: Text(subject),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: height * 0.03),
            // Text for Teachers
            Text('Choose the teacher whom you want to ask'),
            Align(
              alignment: Alignment.center,
              child: DropdownButton<String>(
                value: selectedTeacher,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedTeacher = newValue!;
                  });
                },
                items: teachers.map((String teacher) {
                  return DropdownMenuItem<String>(
                    value: teacher,
                    child: Text(teacher),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: height * 0.02),
            // Additional content below the dropdowns

            // "Next" button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Chat()),
                );
                // Add your logic for the "Next" button
                // It can navigate to the next screen or perform any other action
                print('Next button pressed');
              },
              child: Text('Next'),
            ),
            // Add your other widgets and content here
            // Example: Text('Your other content goes here'),
          ],
        ),
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.person_2_sharp,
                  color: Colors.white,
                  size: 60,
                ),
                SizedBox(height: 8),
                Text(
                  'Username',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Doubt(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Ask Doubt'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Ask(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Doubt History'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Hist(),
                ),
              );

              // You can replace this with the appropriate page
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => Hist(),
              //   ),
              // );
            },
          ),
        ],
      ),
    );
  }
}
