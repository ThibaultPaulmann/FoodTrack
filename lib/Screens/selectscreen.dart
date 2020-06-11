import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SelectScreen extends StatefulWidget {
  @override
  _SelectScreenState createState() => _SelectScreenState();
}

class _SelectScreenState extends State<SelectScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      left: false,
      right: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(
          child: RaisedButton(
            onPressed: () {
              getName();
            },
            child: Text("Get Data")
          ),
        ),
      ),
    );
  }
  String barcodeApi = 'https://api.ean-search.org/api?token=5731c2fea322d632f0923ba64a9310&op=barcode-lookup&format=json&ean=8410505041118';
  static const API = 'https://customsearch.googleapis.com/customsearch/v1?key=AIzaSyDudd94Drzk1RJKt1fDmbTuw1QCxYSkj9A&cx=013819178164194751105:srnhx3kpl3o&q=' + '8411509152107' +'&searchType=image&start=1&num=1';

  Future<String> getName() async {
    var response = await http.read(Uri.encodeFull(barcodeApi));
    List<dynamic> data = jsonDecode(response);
    print(data[0]['name']);
    //print(data['name']);
    return response;
  }

  Future<String> getData() async {
    var response = await http.read(Uri.encodeFull(API), headers: {
      //"key": "AIzaSyDudd94Drzk1RJKt1fDmbTuw1QCxYSkj9A",
      //"Accept": "application/json",
      //"cx": "013819178164194751105:srnhx3kpl3o",
      //"q": "tomatoes"
    });
    Map<String, dynamic> data = jsonDecode(response);
    print("_break_");
    for (var item in data['items']) {
      print(item['title']);
      print(item['link']);
    }
    print("_break_");
    return response;
  }
}
