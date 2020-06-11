import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:fodtracker/Models/item.dart';
import 'package:fodtracker/Utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fodtracker/Screens/item_detail.dart';
import 'package:fodtracker/Utils/image_helper.dart';

class ItemList extends StatefulWidget {
  final String location;
  ItemList(this.location);
  @override
  ItemListState createState() => ItemListState(this.location);
}

class ItemListState extends State<ItemList> {
  String location;
  ScanResult scanResult;
  static String imageUrl;

  int count = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Item> itemList;

  ItemListState(this.location);

  Future scan() async {
    var result = await BarcodeScanner.scan();
    print(result.type);
    if (result.type.toString() == 'Barcode'){
    setState(() {
      scanResult = result;
    });
    navigateToDetail(Item(scanResult.rawContent, 'ProductName', 1, location),
        'Add Item', false);
    //navigateToDetail(Item(scanResult.rawContent, 'PlaceHolder ProductName', 1), 'Add Item');
  }}

  Widget build(BuildContext context) {
    if (itemList == null) {
      itemList = List<Item>();
      updateListView();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
          title: Text(location),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back),
          )),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
        child: getGridView(),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              heroTag: 'Btn1',
              onPressed: () {
                scan();
              },
              child: Icon(
                Icons.add,
                size: 35,
              ),
              elevation: 5,
            ),
          ],
        ),
      ),
    );
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initialiseDatabase();
    dbFuture.then((database) {
      Future<List<Item>> itemListFuture = databaseHelper.getItemList(location);
      itemListFuture.then((itemList) {
        setState(() {
          this.itemList = itemList;
          this.count = itemList.length;
        });
      });
    });
  }

  GridView getGridView() {
    return GridView.builder(
        itemCount: count,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 125,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (BuildContext context, int position) {
          return GestureDetector(
            onTap: () {
              debugPrint('GridTile Tapped');
              navigateToDetail(this.itemList[position], 'Edit Item', true);
            },
            child: SizedBox(
              width: 200,
              height: 200,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).accentColor
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 100,
                        height: 80,
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(
                              child: Center(
                                child: Image.network(
                                    this.itemList[position].productImageUrl,
                                    fit: BoxFit.contain),
                              ),
                            ),
                            Positioned(
                              left: -5,
                              top: 5,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(                                      
                                    boxShadow: [BoxShadow(
                                      spreadRadius: 0.1,
                                      blurRadius: 3,
                                      offset: Offset(1, 1)
                                    )],
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).accentColor),
                                  child: Center(
                                    child: Text(
                                      this
                                          .itemList[position]
                                          .productAmount
                                          .toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        this.itemList[position].productName,
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void navigateToDetail(Item item, String title, bool preloaded) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ItemDetail(item, title, preloaded);
    }));

    if (result == true) {
      Future.delayed(Duration(milliseconds: 500), () {
        updateListView();
      });
    }
  }
}
