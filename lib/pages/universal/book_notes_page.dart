import 'package:flutter/material.dart';
import 'package:test_app/data/repository.dart';
import 'package:test_app/model/Book.dart';
import 'package:rxdart/rxdart.dart';


class BookNotesPage extends StatefulWidget  {

  BookNotesPage(this.book);


  final Book book;


  @override
  State<StatefulWidget> createState() => new _BookNotesPageState();

}

class _BookNotesPageState extends State<BookNotesPage> {


  TextEditingController _textController;

  final subject = new PublishSubject<String>();


  @override
  void dispose() {
    subject.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _textController = new TextEditingController(text: widget.book.notes);
    subject.stream.debounce(new Duration(milliseconds: 400)).listen((text){
      widget.book.notes = text;
      Repository.get().updateBook(widget.book);
    });

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
                        onChanged: (text) => subject.add(text),
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