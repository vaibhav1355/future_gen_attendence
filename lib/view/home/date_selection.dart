import 'package:flutter/material.dart';
import 'package:futuregen_attendance/view/home/date_and_hour.dart';
import 'package:intl/intl.dart';

import '../navigationbar/navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigation();
            },
            child: Icon(Icons.menu, size: 26, color: Colors.white)
        ),
        centerTitle: true,
        title: Text(
          'Home',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
    );
  }
}
