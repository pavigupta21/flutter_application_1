import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/Student_pg.dart';
import 'Ask_doubt.dart';

class Hist extends StatefulWidget {
  const Hist({super.key});

  @override
  State<Hist> createState() => _HistState();
}

class _HistState extends State<Hist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Doubt History"),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: _buildDrawer(),
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
