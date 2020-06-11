import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:fodtracker/Models/item.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String itemTable = 'item_table';
  String colId = 'id';
  String colProductId = 'productId';
  String colProductName = 'productName';
  String colProductImageUrl = 'productImageUrl';
  String colProductImagePath = 'productImagePath';
  String colProductAmount = 'productAmount';
  String colProductLocation = 'productLocation';

  DatabaseHelper._createInstance(); //Named constructor to create isntance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initialiseDatabase();
    }
    return _database;
  }

  Future<Database> initialiseDatabase() async {
    //Get directory path for Android and IOS for where to store database
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'items.db';

    //Open / create database at given path
    var itemsDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return itemsDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $itemTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colProductId TEXT, '
        '$colProductName TEXT, $colProductImageUrl TEXT, $colProductImagePath TEXT, $colProductAmount Integer, $colProductLocation TEXT)');
  }

  //Get the objects from the database as a list of 'Maps'
  Future<List<Map<String, dynamic>>> getItemMapList(String location) async {
    Database db = await this.database;

    var result = await db.query(itemTable,
        where: '$colProductLocation = ?',
        whereArgs: [location],
        orderBy: '$colId ASC');
    return result;
  }

  //Get the 'Map List' and convert it to 'Items List'
  Future<List<Item>> getItemList(String location) async {
    var itemMapList = await getItemMapList(location);
    int count = itemMapList.length;

    List<Item> itemList = List<Item>();
    for (int i = 0; i < count; i++) {
      itemList.add(Item.fromMapObject(itemMapList[i]));
    }
    return itemList;
  }

  //Insert an Item object to the database
  Future<int> insertItem(Item item) async {
    Database db = await this.database;
    var result = await db.insert(itemTable, item.toMap());
    return result;
  }

  //Update an Item object of the databse
  Future<int> updateItem(Item item) async {
    Database db = await this.database;
    var result = await db.update(itemTable, item.toMap(),
        where: '$colId = ?', whereArgs: [item.id]);
    return result;
  }

  //Delete an Item object of the database
  Future<int> deleteItem(int id) async {
    Database db = await this.database;
    var result = await db.delete(itemTable, where: '$colId = $id');
    return result;
  }

  //Get number of Item objects in the database
  Future<int> getCount(String location) async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) FROM $itemTable WHERE $colProductLocation = $location');
    int result = Sqflite.firstIntValue(x);
    return result;
  }
}
