import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Chatbox.dart';
import 'loginpage.dart';

class Answer extends StatefulWidget {
  const Answer({Key? key}) : super(key: key);

  @override
  State<Answer> createState() => _AnswerState();
}

class _AnswerState extends State<Answer> {


  // Variable to store the filter status
  bool showAchievedLevels = true;

  // Options for the filter dropdown
  List<String> filterOptions = ['Ticked First', 'Unticked First'];
  String selectedFilterOption = 'Ticked First';

  String username="";
  String email="";
  String phone="";

  List<Map<String, dynamic>> doubtList=[];
  List<Map<String, dynamic>> studentList=[];
  User? user = FirebaseAuth.instance.currentUser;

  String getUserFromId(String id){
    String name="";
    for(int i=0;i<studentList.length;i++){
      if(studentList[i]['uid']==id){
        name=studentList[i]['username'];
  }
    }
    return name;
  }

  getUserInfo() async {


    print(user?.uid);

    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();

    // Check if the document exists
    if (userDoc.exists) {
      // Access the data from the document
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      // Now you can use userData as needed
      print('User data: $userData');
      username=userData['username'];
      email=userData['email'];
      phone=userData['phoneNumber'];

      getDoubt(userData['subject'],user!.uid);


    } else {
      print('No user found with the ID');
    }

  }

  getAllStudent() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
      List<QueryDocumentSnapshot> userDocs = querySnapshot.docs;
      List<Map<String, dynamic>> list = userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      for(int i =0;i<list.length;i++){
        if(list[i]['role']=='student'){
          studentList.add(list[i]);
        }
      }

      getUserInfo();
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  getDoubt(String sub,String id) async {
    try {


      Stream<QuerySnapshot> chatStream= await FirebaseFirestore.instance.collection('doubt').snapshots();

      chatStream.listen((QuerySnapshot querySnapshot) {
        List<QueryDocumentSnapshot> userDocs = querySnapshot.docs;
        List<Map<String, dynamic>> list = userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();

        doubtList.clear();
        for(int i =0;i<list.length;i++){
          if(list[i]['subject']==sub&&list[i]['teacher']==id){
            doubtList.add(list[i]);
          }
        }
        if(mounted)
          setState(() {});


      }, onError: (error) {
        print('Error fetching chat data: $error');
      });


      print('doubtList    ${doubtList}');
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    getAllStudent();

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
          /*PopupMenuButton<String>(
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
          ),*/
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
          itemCount: doubtList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Chat(doubtList[index]['id'])),
                );
              },
              child: Card(
                color: doubtList[index]['status'] == 0 ? Colors.red : Colors.green,
                child: ListTile(
                  title: Text(getUserFromId(doubtList[index]['student']),style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),),
                  // Set the tile color based on the status

                ),
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
              Text('Username: ${username}'),
              Text('Email: ${email}'),
              Text('Phone No.: ${phone}'),
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
  Future<void> _logOut() async {

    await FirebaseAuth.instance.signOut();
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
      //levels.sort((a, b) => a.achieved ? -1 : 1);
    } else {
      //levels.sort((a, b) => a.achieved ? 1 : -1);
    }
  }
}

// Model class for representing a level
class Level {
  int number;
  bool achieved;

  Level({required this.number, required this.achieved});
}
