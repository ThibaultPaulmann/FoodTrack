import 'package:flutter/material.dart';
import 'package:fodtracker/Screens/fridge.dart';

class HomeScreenButtons extends StatefulWidget {
  String buttonText;

  HomeScreenButtons({this.buttonText});

  @override
  _HomeScreenButtonsState createState() => _HomeScreenButtonsState();
}

class _HomeScreenButtonsState extends State<HomeScreenButtons> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: OutlineButton(
        textColor: Colors.black,
        highlightedBorderColor: Theme.of(context).accentColor,
        borderSide: BorderSide(width: 2, color: Theme.of(context).accentColor),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ItemList(widget.buttonText)));
        },
        child: Text(
          widget.buttonText,
          style: TextStyle(fontSize: 20,letterSpacing: 1.5),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20),
      ),
    );
  }
}
