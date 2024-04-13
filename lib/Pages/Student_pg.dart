import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Ask_doubt.dart';
import 'Doubt_Hist.dart';
import 'loginpage.dart';

class Doubt extends StatefulWidget {
  const Doubt({super.key});

  @override
  State<Doubt> createState() => _DoubtState();
}

class _DoubtState extends State<Doubt> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  String username="";
  String email="";
  String phone="";

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
      email=userData['email'];
      phone=userData['phoneNumber'];
      setState(() {

      });

    } else {
      print('No user found with the ID');
    }

  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
    // Set up the animation controller
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    // Set up the opacity animation
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Start the animation
    _controller.forward();
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
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.person_3_outlined),
            onPressed: () {
              _showUserProfile();
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/Design2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: height * 0.009),
            AnimatedBuilder(
              animation: _opacityAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimation.value,
                  child: Text(
                    "Get your doubts cleared by your teachers anytime!",
                    style: TextStyle(fontSize: width * 0.07),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ],
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            },
          ),
        ],
      ),
    );
  }
}
