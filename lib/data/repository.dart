import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:test_app/database.dart';
import 'package:test_app/model/Book.dart';
import 'package:http/http.dart' as http;


/// A class similar to http.Response but instead of a String describing the body
/// it already contains the parsed Dart-Object
class ParsedResponse<T> {
  ParsedResponse(this.statusCode, this.body);
  final int statusCode;
  final T body;

  bool isOk() {
    return statusCode >= 200 && statusCode < 300;
  }
}


final int NO_INTERNET = 404;

class Repository {

  static final Repository _repo = new Repository._internal();

  BookDatabase database;

  static Repository get() {
    return _repo;
  }

  Repository._internal() {
    database = BookDatabase.get();
  }


  /// Fetches the books from the Google Books Api with the query parameter being input.
  /// If a book also exists in the local storage (eg. a book with notes/ stars) that version of the book will be used instead
  Future<ParsedResponse<List<Book>>> getBooks(String input) async{
    var books = [];
    //http request, catching error like no internet connection.
    //If no internet is available for example response is 
     http.Response response = await http.get("https://www.googleapis.com/books/v1/volumes?q=$input")
         .catchError((resp) {});
     
     if(response == null) {
       return new ParsedResponse(NO_INTERNET, books);
     }

     //If there was an error return an empty list
     if(response.statusCode < 200 || response.statusCode >= 300) {
       return new ParsedResponse(response.statusCode, books);
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
    return new ParsedResponse(response.statusCode, books);
  }

  Future updateBook(Book book) async {
    database.updateBook(book);
  }

  Future close() async {
    return database.close();
  }





  Future<List<Book>> getFavoriteBooks() {
    return database.getFavoriteBooks();
  }




}