import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:fodtracker/Models/item.dart';
import 'package:fodtracker/Utils/database_helper.dart';
import 'package:fodtracker/Utils/image_helper.dart';
import 'package:fodtracker/Screens/fridge.dart';
import 'package:fodtracker/Utils/name_helper.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:numberpicker/numberpicker.dart';

class ItemDetail extends StatefulWidget {
  final String appBarTitle;
  final Item item;
  final bool preloaded;

  ItemDetail(this.item, this.appBarTitle, this.preloaded);

  @override
  ItemDetailState createState() =>
      ItemDetailState(this.item, this.appBarTitle, this.preloaded);
}

class ItemDetailState extends State<ItemDetail> {
  bool imageLoaded = false;
  bool nameLoaded = false;

  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Item item;
  bool preloaded;
  String imageUrl =
      'https://omegamma.com.au/wp-content/uploads/2017/04/default-image.jpg';
  String productName;

  ItemDetailState(this.item, this.appBarTitle, this.preloaded);

  TextEditingController productNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (preloaded == false) {
      getImage().then((value) => imageLoaded = true);
      getName().then((value) => {
            productNameController =
                TextEditingController(text: item.productName),
            nameLoaded = true
          });
    } else {
      productNameController = TextEditingController(text: item.productName);
      imageLoaded = true;
      nameLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: Text(appBarTitle),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              //First Element
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: screenWidth * 0.4,
                  height: screenWidth * 0.4,
                  child: imageLoaded && nameLoaded
                      ? Image.network(item.productImageUrl)
                      : CircularProgressIndicator(),
                ),
              ),

              //Second Element
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: imageLoaded && nameLoaded
                    ? TextFormField(
                        controller: productNameController,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        onChanged: (value) {
                          debugPrint(
                              'Something changed in Product Name Text Field');
                          updateProductName();
                        },
                        decoration: InputDecoration(
                            labelText: 'Product Name',
                            labelStyle: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).accentColor),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      )
                    : CircularProgressIndicator(),
              ),

              //Third Element
              Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: TextFormField(
                    enabled: false,
                    initialValue: item.productId,
                    decoration: InputDecoration(
                        labelText: 'Product Id',
                        labelStyle: TextStyle(
                            fontSize: 20, color: Theme.of(context).accentColor),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  )),

              //Fourth Element
              Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: GestureDetector(
                    onTap: _numberPickerDialog,
                    child: InputDecorator(
                      child: Text(item.productAmount.toString()),
                      decoration: InputDecoration(
                          labelText: 'Product Amount',
                          labelStyle: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).accentColor),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  )),
              //Fifth Element
              Row(
                children: <Widget>[
                  Flexible(
                    flex: 10,
                    child: ListTile(
                        title: RaisedButton(
                            child: Text('Delete Item'),
                            onPressed: () {
                              _delete();
                            })),
                  ),
                  Flexible(
                    flex: 10,
                    child: ListTile(
                        title: RaisedButton(
                            child: Text(appBarTitle),
                            onPressed: () {
                              _save();
                            })),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void _save() async {
    moveToLastScreen();
    debugPrint('location :' + item.productLocation);
    //await getImage();
    //item.productName = 'Glorious Bag of sweets';
    //item.productImageUrl = await ImageHelper.getData(item.productId);
    var result;
    if (item.id != null) {
      // Case 1: Update operation
      result = await helper.updateItem(item);
    } else {
      // Case 2: Insert Operation
      result = await helper.insertItem(item);
    }
    if (result != 0) {
      // Success
      debugPrint('Item Saved Successfully');
    } else {
      // Failure
      debugPrint('Problem Saving Item');
    }
  }

  void _delete() async {
    moveToLastScreen();
    var result;
    if (item.id != null) {
      result = await helper.deleteItem(item.id);
    }
  }

  Future<void> getImage() async {
    await ImageHelper.getData(item.productId).then((result) {
      setState(() {
        print('result: ' + result);
        imageUrl = result;
        print('imageUrl: ' + imageUrl);
        item.productImageUrl = result;
        imageLoaded = true;
      });
    });
    //return await ImageHelper.getData(item.productId);
  }

  Future getName() async {
    await NameHelper.getName(item.productId).then((result) {
      setState(() {
        print('result: ' + result);
        productName = result;
        item.productName = result;
        nameLoaded = true;
      });
    });
  }

  void updateProductName() {
    item.productName = productNameController.text;
  }

  Future _numberPickerDialog() async {
    await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return NumberPickerDialog.integer(
          minValue: 1,
          maxValue: 50,
          step: 1,
          initialIntegerValue: item.productAmount,
        );
      },
    ).then((num value) {
      if (value != null) {
        setState(() => item.productAmount = value);
      }
    });
  }
}
