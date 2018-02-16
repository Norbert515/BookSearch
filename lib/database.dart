import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:test_app/main.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';



class BookDatabase {
  static final BookDatabase _bookDatabase = new BookDatabase._internal();


  Database db;



  factory BookDatabase() {
    return _bookDatabase;
  }



  bool getBookReadStatus(Book book) {
    return false;
  }

  BookDatabase._internal() {
    start();
  }


  Future start() async {
    // Get a location using path_provider
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "demo.db");

    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              "CREATE TABLE Test (id STRING PRIMARY KEY, title TEXT, url TEXT, read NUM)");
        });


  }
}