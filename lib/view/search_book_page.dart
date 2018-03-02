import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'package:test_app/view/book_notes_page.dart';
import 'package:test_app/database.dart';
import 'package:test_app/model/Book.dart';
import 'package:test_app/utils/utils.dart';


class SearchBookPage extends StatefulWidget {

  @override
  _SearchBookState createState() => new _SearchBookState();
}

class _SearchBookState extends State<SearchBookPage> {
  List<Book> _items = new List();

  final subject = new PublishSubject<String>();

  bool _isLoading = false;


  void _textChanged(String text) {
    if(text.isEmpty) {
      setState((){_isLoading = false;});
      _clearList();
      return;
    }
    setState((){_isLoading = true;});
    _clearList();
    http.get("https://www.googleapis.com/books/v1/volumes?q=$text")
        .then((response) => response.body)
        .then(JSON.decode)
        .then((map) => map["items"])
        .then((list) {list.forEach(_addBook);})
        .catchError(_onError)
        .then((e){setState((){_isLoading = false;});});
  }

  void _onError(dynamic d) {
    setState(() {
      _isLoading = false;
    });
  }

  void _clearList() {
    setState(() {
      _items.clear();
    });
  }
  void _addBook(dynamic book) {
    setState(() {
      _items.add(new Book(
          title: book["volumeInfo"]["title"],
          url: book["volumeInfo"]["imageLinks"]["smallThumbnail"],
          id: book["id"]
      ));
    });
  }

  @override
  void dispose() {
    subject.close();
    BookDatabase.get().close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    subject.stream.debounce(new Duration(milliseconds: 600)).listen(_textChanged);
    BookDatabase.get().init();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Book Search"),
      ),
      body: new Container(
        padding: new EdgeInsets.all(8.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new TextField(
              decoration: new InputDecoration(
                hintText: 'Choose a book',
              ),
              onChanged: (string) => (subject.add(string)),
            ),
            _isLoading? new CircularProgressIndicator(): new Container(),
            new Expanded(
              child: new ListView.builder(
                padding: new EdgeInsets.all(8.0),
                itemCount: _items.length,
                itemBuilder: (BuildContext context, int index) {
                  return new BookCard(_items[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookCard extends StatefulWidget {


  BookCard(this.book);

  final Book book;

  @override
  State<StatefulWidget> createState() => new BookCardState();

}

class BookCardState extends State<BookCard> {

  Book bookState;


  @override
  void initState() {
    super.initState();
    bookState = widget.book;
    BookDatabase.get().getBook(widget.book.id)
        .then((book){
      if (book == null) return;
      setState((){
        bookState = book;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: (){
        Navigator.of(context).push(
            new FadeRoute(
              builder: (BuildContext context) => new BookNotesPage(bookState),
              settings: new RouteSettings(name: '/notes', isInitialRoute: false),
            ));
      },
      child: new Card(
          child: new Container(
            height: 200.0,
            child: new Padding(
                padding: new EdgeInsets.all(8.0),
                child: new Row(
                  children: <Widget>[
                    bookState.url != null?
                    new Hero(
                      child: new Image.network(bookState.url),
                      tag: bookState.id,
                    ):
                    new Container(),
                    new Expanded(
                      child: new Stack(
                        children: <Widget>[
                          new Align(
                            child: new Padding(
                              child: new Text(bookState.title, maxLines: 10),
                              padding: new EdgeInsets.all(8.0),
                            ),
                            alignment: Alignment.center,
                          ),
                          new Align(
                            child: new IconButton(
                              icon: bookState.starred? new Icon(Icons.star): new Icon(Icons.star_border),
                              color: Colors.black,
                              onPressed: (){
                                setState(() {
                                  bookState.starred = !bookState.starred;
                                });
                                BookDatabase.get().updateBook(bookState);
                              },
                            ),
                            alignment: Alignment.topRight,
                          ),

                        ],
                      ),
                    ),

                  ],
                )
            ),
          )
      ),
    );
  }

}