import 'package:flutter/material.dart';

import '../widgets/defaultbuttons.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      right: false,
      left: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Food Location',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Spacer(
              flex: 1,
            ),
            Expanded(
              flex: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  HomeScreenButtons(buttonText: 'Freezer'),
                  HomeScreenButtons(buttonText: 'Fridge'),
                  HomeScreenButtons(buttonText: 'Other')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
