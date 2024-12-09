import 'package:flutter/material.dart';
import 'package:futuregen_attendance/view/Home/home_page.dart';
import 'package:futuregen_attendance/view/login/forgot_password.dart';
import 'package:futuregen_attendance/view/login/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      //Login(),
    );
  }
}
