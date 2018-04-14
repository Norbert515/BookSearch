import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:test_app/data/database.dart';
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

  Future init() async{
    return await database.init();
  }

  /// Fetches the books from the Google Books Api with the query parameter being input.
  /// If a book also exists in the local storage (eg. a book with notes/ stars) that version of the book will be used instead
  Future<ParsedResponse<List<Book>>> getBooks(String input) async{
    //http request, catching error like no internet connection.
    //If no internet is available for example response is
    //TODO restricted language to english, feel free to remove that
     http.Response response = await http.get("https://www.googleapis.com/books/v1/volumes?q=$input&langRestrict=en")
         .catchError((resp) {});
     
     if(response == null) {
       return new ParsedResponse(NO_INTERNET, []);
     }

     //If there was an error return an empty list
     if(response.statusCode < 200 || response.statusCode >= 300) {
       return new ParsedResponse(response.statusCode, []);
     }
     // Decode and go to the items part where the necessary book information is
     List<dynamic> list = JSON.decode(response.body)['items'];

     Map<String, Book> networkBooks = {};

    for(dynamic jsonBook in list) {
      Book book = parseNetworkBook(jsonBook);
      networkBooks[book.id] = book;
    }

    //Adds information (if available) from database
    List<Book> databaseBook = await database.getBooks([]..addAll(networkBooks.keys));
    for(Book book in databaseBook) {
      networkBooks[book.id] = book;
    }

    return new ParsedResponse(response.statusCode, []..addAll(networkBooks.values));
  }

  Future<ParsedResponse<Book>> getBook(String id) async {
    http.Response response = await http.get("https://www.googleapis.com/books/v1/volumes/$id")
        .catchError((resp) {});
    if(response == null) {
      return new ParsedResponse(NO_INTERNET, null);
    }

    //If there was an error return null
    if(response.statusCode < 200 || response.statusCode >= 300) {
      return new ParsedResponse(response.statusCode, null);
    }

    dynamic jsonBook = JSON.decode(response.body);

    Book book = parseNetworkBook(jsonBook);

    //Adds information (if available) from database
    List<Book> databaseBook = await database.getBooks([]..add(book.id));
    for(Book databaseBook in databaseBook) {
      if(databaseBook != null) {
        book = databaseBook;
      }
    }

    return new ParsedResponse(response.statusCode, book);
  }


  //TODO optimize and add status code (Parsed Response)
  Future<List<Book>> getBooksById(List<String> ids) async{
    List<Book> books = [];

  //  int statusCode = 200;
    for(String id in ids) {
      ParsedResponse<Book> book = await getBook(id);

      // One of the books went wrong, save status code and continue
   //   if(book.statusCode < 200 || book.statusCode >= 300) {
   //     statusCode = book.statusCode;
  //    }

      if(book.body != null) {
        books.add(book.body);
      }
    }

    return books;
  //  return new ParsedResponse(statusCode, books);
  }

  Future<List<Book>> getBooksByIdFirstFromDatabaseAndCache(List<String> ids) async {
    List<Book> books = [];
    List<String> idsToFetch = ids;

    List<Book> databaseBook = await database.getBooks([]..addAll(ids));


    for(Book databaseBook in databaseBook) {
      books.add(databaseBook);
      idsToFetch.remove(databaseBook.id);
    }


    for(String id in idsToFetch) {
      http.Response response = await http.get("https://www.googleapis.com/books/v1/volumes/$id")
          .catchError((resp) {});
    /*  if(response == null) {
        return new ParsedResponse(NO_INTERNET, null);
      }

      //If there was an error return null
      if(response.statusCode < 200 || response.statusCode >= 300) {
        return new ParsedResponse(response.statusCode, null);
      }*/

      dynamic jsonBook = JSON.decode(response.body);

      Book book = parseNetworkBook(jsonBook);
      updateBook(book);
      books.add(book);
    }

    return books;


  }

  Book parseNetworkBook(jsonBook) {

    Map volumeInfo = jsonBook["volumeInfo"];
    String author = "No author";
    if(volumeInfo.containsKey("authors")) {
      author = volumeInfo["authors"][0];
    }
    String description = "No description";
    if(volumeInfo.containsKey("description")) {
      description = volumeInfo["description"];
    }
    String subtitle = "No subtitle";
    if(volumeInfo.containsKey("subtitle")) {
      subtitle = volumeInfo["subtitle"];
    }
    return new Book(
      title: jsonBook["volumeInfo"]["title"],
      url: jsonBook["volumeInfo"]["imageLinks"] != null? jsonBook["volumeInfo"]["imageLinks"]["smallThumbnail"]: "",
      id: jsonBook["id"],
      //only first author
      author: author,
      description: description,
      subtitle: subtitle,
    );
  }

  Future updateBook(Book book) async {
    await database.updateBook(book);
  }

  Future close() async {
    return database.close();
  }





  Future<List<Book>> getFavoriteBooks()  {
    return database.getFavoriteBooks();
  }



}