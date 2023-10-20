import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // Importing the Home screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ASL Translation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(), // Set the HomeScreen as the initial route
    );
  }
}