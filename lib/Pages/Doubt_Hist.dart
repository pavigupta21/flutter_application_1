import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/Chatbox.dart';
import 'package:flutter_application_1/Pages/Student_pg.dart';
import 'Ask_doubt.dart';

class Hist extends StatefulWidget {
  const Hist({super.key});

  @override
  State<Hist> createState() => _HistState();
}

class _HistState extends State<Hist> {

  String username="";
  List<Map<String, dynamic>> doubtList=[];

  void _deleteDoubt(String id) {

    try {
      FirebaseFirestore.instance
          .collection('doubt')
          .doc(id)
          .delete();
      print('Doubt deleted successfully.');
    } catch (e) {
      print('Error deleting document: $e');
    }

  }

  void _showDeleteDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Doubt"),
          content: Text("Are you sure you want to delete this doubt?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _deleteDoubt(id);
                Navigator.of(context).pop();
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  getDoubt() async {
    try {

      User? user = FirebaseAuth.instance.currentUser;


      Stream<QuerySnapshot> chatStream= await FirebaseFirestore.instance.collection('doubt').snapshots();

      chatStream.listen((QuerySnapshot querySnapshot) {
        List<QueryDocumentSnapshot> userDocs = querySnapshot.docs;
        List<Map<String, dynamic>> list = userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();

        doubtList.clear();
        for(int i =0;i<list.length;i++){
          if(list[i]['student']==user!.uid){
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
    getDoubt();
    super.initState();
  }

  solve(Map<String, dynamic> map){

    DocumentReference documentReference = FirebaseFirestore.instance.collection('doubt').doc(map['id']);

    documentReference.update({
      'status':1
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Doubt History"),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: _buildDrawer(),
      body: ListView.builder(
        itemCount: doubtList.length,
        itemBuilder: (context, index) {
          final doubt = doubtList[index];
          return GestureDetector(
            onLongPress: (){
              _showDeleteDialog(context,doubt['id']);
            },
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Chat(doubt['id'])),
              );
            },
            child: Card(
              color: doubt['status'] == 0 ? Colors.red.withOpacity(0.5) : Colors.green.withOpacity(0.5),
              child: ListTile(
                title: Text(doubt['subject']),
                trailing: doubt['status'] ==0?
                  InkWell(
                  onTap: (){
                    print("solved");
                    solve(doubt);
                  },
                    child: Text("Mark as Solve",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 14),)):Container(child: Text(""),),


              ),
            ),
          );
        },
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
              // Replace this with the appropriate page
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => Doubt(),
              //   ),
              // );
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
              // Replace this with the appropriate page
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => Ask(),
              //   ),
              // );
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
              // You can keep it as is or replace it with the appropriate page
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
