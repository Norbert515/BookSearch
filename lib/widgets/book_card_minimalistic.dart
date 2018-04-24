import 'package:flutter/material.dart';
import 'package:test_app/model/Book.dart';


class BookCardMinimalistic extends StatelessWidget {



  BookCardMinimalistic(this.book);

  final Book book;


  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Image.network(book.url),
        ],
      ),
    );
  }

}