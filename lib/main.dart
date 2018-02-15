import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rxdart/rxdart.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Book search',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new MyHomePage(title: 'Book Search'),
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
      _items.add(new Book(book["volumeInfo"]["title"], book["volumeInfo"]["imageLinks"]["smallThumbnail"]));
    });
  }

  @override
  void initState() {
    super.initState();
    subject.stream.debounce(new Duration(milliseconds: 600)).listen(_textChanged);
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
                  return new Card(
                    child: new Padding(
                        padding: new EdgeInsets.all(8.0),
                        child: new Row(
                          children: <Widget>[
                            _items[index].url != null? new Image.network(_items[index].url): new Container(),
                            new Flexible(
                                child: new Text(_items[index].title, maxLines: 10),
                            ),
                          ],
                        )
                    )
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Book {
  String title, url;
  Book(String title, String url) {
    this.title = title;
    this.url = url;
  }
}