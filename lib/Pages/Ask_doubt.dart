import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'Student_pg.dart';
import 'Doubt_Hist.dart';
import 'Chatbox.dart';

class Ask extends StatefulWidget {
  const Ask({Key? key}) : super(key: key);

  @override
  State<Ask> createState() => _AskState();
}

class _AskState extends State<Ask> {
  // Selected values for the dropdowns
  String? selectedSubject;
  Map<String, dynamic>? selectedTeacher;

  // Dummy data for dropdowns (replace with your data)

  List<Map<String, dynamic>> allTeacher=[];
  List<Map<String, dynamic>> subjectTeacher=[];

  String username="";

  getSubjectWiseTeacher(){

    selectedTeacher=null;
    subjectTeacher.clear();

    for(int i =0;i<allTeacher.length;i++){
      if(allTeacher[i]['subject']==selectedSubject){
        subjectTeacher.add(allTeacher[i]);
      }
    }
    setState(() {});

  }

  getAllTeacher() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
      List<QueryDocumentSnapshot> userDocs = querySnapshot.docs;
      List<Map<String, dynamic>> list = userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      for(int i =0;i<list.length;i++){
        if(list[i]['role']=='teacher'){
          allTeacher.add(list[i]);
        }
      }

      print('tetachert    ${allTeacher}');
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  next() async {

    if(selectedSubject!.isEmpty){
      return;
    }

    if(selectedTeacher==null){
      return;
    }

    print(" ${ selectedSubject}    ${selectedTeacher?['uid']}");

    User? user = FirebaseAuth.instance.currentUser;

    DocumentReference documentReference = FirebaseFirestore.instance.collection('doubt').doc();

    documentReference.set({
      'id':documentReference.id.toString(),
      'student': user!.uid,
      'teacher': selectedTeacher?['uid'],
      'subject':selectedSubject,
      'status':0
    });
    //Navigator.pop(context);
     Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Chat(documentReference.id.toString())),
                );
  }

  getUserInfo() async {

    User? user = FirebaseAuth.instance.currentUser;
    print(user?.uid);

    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();

    // Check if the document exists
    if (userDoc.exists) {
      // Access the data from the document
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      // Now you can use userData as needed
      print('User data: $userData');
      username=userData['username'];

      setState(() {

      });


    } else {
      print('No user found with the ID');
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();
    getAllTeacher();
    super.initState();
  }
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
                hint: Text('Select Subject'),
                value: selectedSubject,
                onChanged: (String? newValue) {

                    selectedSubject = newValue!;
                    getSubjectWiseTeacher();

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
              child: DropdownButton<Map<String, dynamic>>(
                hint: Text('Select Teacher'),
                value: selectedTeacher,
                onChanged: (Map<String, dynamic>? newValue) {
                  setState(() {
                    selectedTeacher = newValue!;
                  });
                },
                items: subjectTeacher.map((Map<String, dynamic> teacher) {
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: teacher,
                    child: Text(teacher['username']),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: height * 0.02),
            // Additional content below the dropdowns

            // "Next" button
            ElevatedButton(
              onPressed: () {

                next();
              },
              child: Text('Save & Next'),
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
                  '${username}',
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
