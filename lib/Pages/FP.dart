import 'package:flutter/material.dart';
import 'FPN.dart';

void main() {
  runApp(const ForgotPass());
}

class ForgotPass extends StatefulWidget {
  const ForgotPass({Key? key}) : super(key: key);

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _answerController = TextEditingController();
  String _selectedItem = 'Who is your favourite author?';

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
        title: Text("Forgot Password?"),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: height * 0.04),
            Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: TextStyle(fontSize: width * 0.04),
              ),
            ),
            SizedBox(height: height * 0.03),
            Text(
              'Secret Question',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: width * 0.04,
              ),
            ),
            SizedBox(height: height * 0.02),
            Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: DropdownButton<String>(
                value: _selectedItem,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedItem = newValue!;
                  });
                },
                items: <String>[
                  'Who is your favourite author?',
                  'Which is your favourite book?',
                  "What was your first pet's name?",
                  "What is the last name of your best friend?",
                  "Who is your favourite movie star?",
                  "What town were you born in?",
                  "What is your favourite restaurant?",
                  "Who is your favourite historical person?",
                  "What is the name of your eldest cousin?",
                  "What is your favourite travelling destination?",
                  "What is your favourite sport?",
                  "What was your favourite food as a child?",
                  "What is your favourite hobby?",
                  'What is your favourite car model?',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(fontSize: width * 0.03),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: height * 0.02),
            Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: TextField(
                controller: _answerController,
                decoration: InputDecoration(
                  labelText: 'Answer to the secret question',
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: TextStyle(fontSize: width * 0.04),
              ),
            ),
            SizedBox(height: height * 0.03),
            ElevatedButton(
              onPressed: () {
                if (_selectedItem.isNotEmpty &&
                    _answerController.text.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgotPassNew()),
                  );
                  String username = _usernameController.text;
                  String selectedItem = _selectedItem;
                  String answer = _answerController.text;
                  // You can use the variables as needed.
                } else {
                  // Show an error message or handle the case where no option is selected or answer is provided.
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blueAccent,
                disabledForegroundColor: Colors.white,
              ),
              child: Text(
                'Next',
                style: TextStyle(fontSize: width * 0.04),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
