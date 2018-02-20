import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'package:test_app/book_notes_page.dart';
import 'package:test_app/database.dart';
import 'package:test_app/model/Book.dart';
import 'package:test_app/utils/utils.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Book search',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      routes: {
        '/': (BuildContext context) => new MyHomePage(title: 'Book Search'),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    subject.stream.debounce(new Duration(milliseconds: 600)).listen(_textChanged);
    new BookDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
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
    bookState = widget.book;
    new BookDatabase().getBook(widget.book.id)
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
                                new BookDatabase().updateBook(bookState);
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