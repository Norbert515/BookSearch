import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:test_app/database.dart';
import 'package:test_app/model/Book.dart';
import 'package:http/http.dart' as http;



class Repository {

  static final Repository _repo = new Repository._internal();

  BookDatabase database;

  static Repository get() {
    return _repo;
  }

  Repository._internal() {
    database = BookDatabase.get();
  }

  Future init() async {
    await database.init();
  }

  Future<List<Book>> getBooks(String input) async{
    var books = [];
    List<dynamic> list = await http.get("https://www.googleapis.com/books/v1/volumes?q=$input")
        .then((response) => response.body)
        .then(JSON.decode)
        .then((map) => map["items"]);

    for(dynamic jsonBook in list) {
      Book book = new Book(
          title: jsonBook["volumeInfo"]["title"],
          url: jsonBook["volumeInfo"]["imageLinks"]["smallThumbnail"],
          id: jsonBook["id"]
      );
      Book databaseBook = await database.getBook(book.id);
      if(databaseBook != null) {
        book = databaseBook;
      }
      books.add(book);
    }
    return books;
  }


  Future<Book> getBook(String id) async{
    return database.getBook(id);
  }

  Future updateBook(Book book) async {
    database.updateBook(book);
  }

  Future close() async {
    return database.close();
  }









}