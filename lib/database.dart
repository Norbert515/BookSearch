import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test_app/model/Book.dart';


class BookDatabase {
  static final BookDatabase _bookDatabase = new BookDatabase._internal();

  final String tableName = "Books";

  Database db;

  factory BookDatabase() {
    return _bookDatabase;
  }

  Future<bool> getBookStarStatus(Book book) async{
    var result = await db.rawQuery('SELECT star FROM $tableName WHERE id = "${book.id}"');
    if(result.length == 0)return false;
    print(result[0]);
    return result[0]["star"] == 1? true: false;
  }

  Future updateBookStarStatus(Book book) async {
    await db.inTransaction(() async {
      int id1 = await db.rawInsert(
          'INSERT OR REPLACE INTO $tableName(id, title, url, star) VALUES("${book.id}", "${book.title}", "${book.url}", ${book.starred? 1:0})');
    });
  }

  Future<String> getBookNotes(Book book) async{
    var result = await db.rawQuery('SELECT notes FROM $tableName WHERE id = "${book.id}"');
    if(result.length == 0)return "";
    return result[0]["notes"];
  }


  Future updateBookStarStatusWithNotes(Book book) async {
    print(book);
    await db.inTransaction(() async {
      int id1 = await db.rawInsert(
          'INSERT OR REPLACE INTO $tableName(id, title, url, star, notes) VALUES("${book.id}", "${book.title}", "${book.url}", ${book.starred? 1:0}, "${book.notes}")');
    });
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
              "CREATE TABLE $tableName (id STRING PRIMARY KEY, title TEXT, url TEXT, star BIT, notes TEXT)");
        });


  }
}