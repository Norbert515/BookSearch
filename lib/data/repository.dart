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

  /// Fetches the books from the Google Books Api with the query parameter being input.
  /// If a book also exists in the local storage (eg. a book with notes/ stars) that version of the book will be used instead
  Future<List<Book>> getBooks(String input) async{
    var books = [];
     http.Response response = await http.get("https://www.googleapis.com/books/v1/volumes?q=$input");

     //If there was an error return an empty list, error handling will be implemented later on
     if(response.statusCode < 200 || response.statusCode >= 300) {
       return books;
     }
     // Decode and go to the items part where the necessary book information is
     List<dynamic> list = JSON.decode(response.body)['items'];

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

  Future updateBook(Book book) async {
    database.updateBook(book);
  }

  Future close() async {
    return database.close();
  }









}