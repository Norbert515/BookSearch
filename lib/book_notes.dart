import 'package:flutter/material.dart';
import 'package:test_app/model/Book.dart';


class BookNotes extends StatefulWidget  {

  BookNotes(this.book);


  final Book book;


  @override
  State<StatefulWidget> createState() => new _BookNotes();

}

class _BookNotes extends State<BookNotes> {


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: const Text("Notes"),),
      body: new Column(
        children: <Widget>[
          new Hero(
            child: new Image.network(widget.book.url),
            tag: widget.book.id
          ),
          new Expanded(
              child: new TextField(),
          ),
        ],
      ),
    );
  }

}