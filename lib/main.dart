import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import 'Pages/Student_pg.dart';
import 'Pages/Teacher_pg.dart';
import 'Pages/choice.dart';
import 'Pages/loginpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool _disposed = false;

  bool isLogin=false;
  bool isTeacher=false;

  @override
  void dispose() {
    _disposed = true;
    _controller.dispose(); // Dispose the animation controller
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    getInfo();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Adjust the duration as needed
    );
    _controller.forward(); // Start the animation

    Timer(Duration(seconds: 7), () {
      if (!_disposed) {

        if (FirebaseAuth.instance.currentUser == null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          if(isTeacher){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Answer()),
            );
          }else{
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Doubt()),
            );
          }

        }


      }
    });
  }

  getInfo() async {
    if (FirebaseAuth.instance.currentUser != null) {
      isLogin=true;
    }

    if(isLogin){
      User? user = FirebaseAuth.instance.currentUser;
      print(user?.uid);

      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();

      // Check if the document exists
      if (userDoc.exists) {
        // Access the data from the document
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      if(userData['role']=="teacher"){
        isTeacher=true;
      }else{
        isTeacher=false;
      }

      setState(() {});

      } else {
        print('No user found with the ID');
      }


    }
  }

  @override
  Widget build(BuildContext context) {





    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Center(
            child: Lottie.asset(
              "lib/assets/Animation - 1711341571230.json",
              height: 140, // Adjust the height as needed
              width: 140, // Adjust the width as needed
            ),
          ),
          SizedBox(height: 16), // Add some spacing
          // Add a fade transition for the text
          FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
              parent: _controller,
              curve: Interval(0.5, 1, curve: Curves.easeInOut),
            )),
            child: Text(
              "ASKMENTOR",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      nextScreen: isLogin?isTeacher?Answer():Doubt():LoginPage(),
      duration: 5000,
      splashIconSize: 190, // Adjust the size as needed
      backgroundColor: Colors.black,
    );
  }
}
