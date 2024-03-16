import 'package:flutter/material.dart';
import 'loginpage.dart';

void main() {
  runApp(Answer());
}

class Answer extends StatefulWidget {
  const Answer({Key? key}) : super(key: key);

  @override
  State<Answer> createState() => _AnswerState();
}

class _AnswerState extends State<Answer> {
  // Dummy data for levels
  List<Level> levels = [
    Level(number: 1, achieved: true),
    Level(number: 2, achieved: false),
    Level(number: 3, achieved: true),
    Level(number: 4, achieved: false),
    Level(number: 5, achieved: false),
    Level(number: 6, achieved: true),
    Level(number: 7, achieved: false),
    Level(number: 8, achieved: true),
    Level(number: 9, achieved: false),
    Level(number: 10, achieved: true),
  ];

  // Variable to store the filter status
  bool showAchievedLevels = true;

  // Options for the filter dropdown
  List<String> filterOptions = ['Ticked First', 'Unticked First'];
  String selectedFilterOption = 'Ticked First';

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
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            "Doubts asked by students",
            style: TextStyle(fontSize: width * 0.05),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              _showUserProfile();
            },
          ),
          PopupMenuButton<String>(
            onSelected: (String value) {
              _setFilterOption(value);
            },
            itemBuilder: (BuildContext context) {
              return filterOptions.map((String option) {
                return PopupMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/Design2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: levels.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Row(
                children: [
                  Checkbox(
                    value: levels[index].achieved,
                    onChanged: (bool? value) {
                      setState(() {
                        levels[index].achieved = value ?? false;
                      });
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle tapping on a level if needed
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        levels[index].achieved ? Colors.green : Colors.red,
                      ),
                    ),
                    child: Text(
                      "Student ${levels[index].number}",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Function to show the user profile card
  void _showUserProfile() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('User Profile'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Username: User123'),
              Text('Email: user@example.com'),
              Text('Phone No.: +1 123-456-7890'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  _logOut();
                },
                child: Text('Log out'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to handle log out
  void _logOut() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
    // Add your log out logic here
    print('Logging out...');
  }

  // Function to set the filter option
  void _setFilterOption(String value) {
    setState(() {
      selectedFilterOption = value;
      _applyFilter();
    });
  }

  // Function to apply the selected filter
  void _applyFilter() {
    if (selectedFilterOption == 'Ticked First') {
      levels.sort((a, b) => a.achieved ? -1 : 1);
    } else {
      levels.sort((a, b) => a.achieved ? 1 : -1);
    }
  }
}

// Model class for representing a level
class Level {
  int number;
  bool achieved;

  Level({required this.number, required this.achieved});
}
