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

  bool didInit = false;

  static BookDatabase get() {
    return _bookDatabase;
  }

  BookDatabase._internal();


  /// Use this method to access the database, because initialization of the database (it has to go through the method channel)
  Future<Database> _getDb() async{
    if(!didInit) await _init();
    return db;
  }

  Future init() async {
    return await _init();
  }

  Future _init() async {
    // Get a location using path_provider
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "demo.db");
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              "CREATE TABLE $tableName ("
                  "${Book.db_id} STRING PRIMARY KEY,"
                  "${Book.db_title} TEXT,"
                  "${Book.db_url} TEXT,"
                  "${Book.db_star} BIT,"
                  "${Book.db_notes} TEXT,"
                  "${Book.db_author} TEXT,"
                  "${Book.db_description} TEXT,"
                  "${Book.db_subtitle} TEXT"
                  ")");
        });
    didInit = true;


  }

  /// Get a book by its id, if there is not entry for that ID, returns null.
  Future<Book> getBook(String id) async{
    var db = await _getDb();
    var result = await db.rawQuery('SELECT * FROM $tableName WHERE ${Book.db_id} = "$id"');
    if(result.length == 0)return null;
    return new Book.fromMap(result[0]);
  }

  /// Get all books with ids, will return a list with all the books found
  Future<List<Book>> getBooks(List<String> ids) async{
    var db = await _getDb();
    // Building SELECT * FROM TABLE WHERE ID IN (id1, id2, ..., idn)
    var idsString = ids.map((it) => '"$it"').join(',');
    var result = await db.rawQuery('SELECT * FROM $tableName WHERE ${Book.db_id} IN ($idsString)');
    List<Book> books = [];
    for(Map<String, dynamic> item in result) {
      books.add(new Book.fromMap(item));
    }
    return books;
  }


  Future<List<Book>> getFavoriteBooks() async{
    var db = await _getDb();
    var result = await db.rawQuery('SELECT * FROM $tableName WHERE ${Book.db_star} = "1"');
    if(result.length == 0)return [];
    List<Book> books = [];
    for(Map<String,dynamic> map in result) {
      books.add(new Book.fromMap(map));
    }
    return books;
  }


  //TODO escape not allowed characters eg. ' " '
  /// Inserts or replaces the book.
  Future updateBook(Book book) async {
    var db = await _getDb();
    await db.rawInsert(
        'INSERT OR REPLACE INTO '
            '$tableName(${Book.db_id}, ${Book.db_title}, ${Book.db_url}, ${Book.db_star}, ${Book.db_notes}, ${Book.db_author}, ${Book.db_description}, ${Book.db_subtitle})'
            ' VALUES(?, ?, ?, ?, ?, ?, ?, ?)',
        [book.id, book.title, book.url, book.starred? 1:0, book.notes, book.author, book.description, book.subtitle]);

  }

  Future close() async {
    var db = await _getDb();
    return db.close();
  }

}