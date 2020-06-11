import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fodtracker/Screens/fridge.dart';
import 'package:fodtracker/Screens/homescreen.dart';
import 'package:fodtracker/Screens/selectscreen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      title: 'FoodTracker',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 235, 235, 235),
        accentColor: Colors.blueGrey,
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
