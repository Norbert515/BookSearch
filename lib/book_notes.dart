import 'package:flutter/material.dart';
import 'package:test_app/database.dart';
import 'package:test_app/model/Book.dart';


class BookNotesPage extends StatefulWidget  {

  BookNotesPage(this.book);


  final Book book;


  @override
  State<StatefulWidget> createState() => new _BookNotesPageState();

}

class _BookNotesPageState extends State<BookNotesPage> {


  TextEditingController _textController;

  @override
  void initState() {
    _textController = new TextEditingController();
    new BookDatabase()
        .getBookNotes(widget.book)
        .then((notes){
          setState((){
            _textController.text = notes;
          });
        });

  }


  @override
  void dispose() {
    widget.book.notes = _textController.text;
    new BookDatabase().updateBookStarStatusWithNotes(widget.book);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: const Text("Notes"),),
      body: new Container(
        child: new Padding(
          padding: new EdgeInsets.all(8.0),
          child: new Column(
            children: <Widget>[
              new Hero(
                child: new Image.network(widget.book.url),
                tag: widget.book.id
              ),
              new Expanded(
                  child: new Card(
                    child: new Padding(
                      padding: new EdgeInsets.all(8.0),
                      child: new TextField(
                        style: new TextStyle(fontSize: 18.0, color: Colors.black),
                        maxLines: null,
                        decoration: null,
                        controller: _textController,
                      ),
                    ),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}