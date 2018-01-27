import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.green,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _items = new List();
  TextEditingController _controller = new TextEditingController();

  final subject = new PublishSubject<String>();

  bool _isLoading = false;


  void _floatingClick() {
    setState(() {
      _items.add(_controller.text);
    });
  }

  void _textChanged(String text) {
    _isLoading = true;
    print(text);
    _clearList();
    http.get("https://www.googleapis.com/books/v1/volumes?q=$text")
        .then((response) => response.body)
        .then(JSON.decode)
        .then((map) => map["items"])
        .then((list) => list.forEach(_printBook))
        .catchError(_onError)
        .asStream()
        .listen((e) => _isLoading = false);




  }



  void _onError(dynamic d) {

  }

  void _clearList() {
    setState(() {
      _items.clear();
    });
  }
  void _printBook(dynamic book) {
    print(book["volumeInfo"]["title"]);
    setState(() {
      _items.add(book["volumeInfo"]["title"]);
    });
  }

  @override
  void initState() {
    super.initState();
    subject.stream.debounce(new Duration(milliseconds: 200)).listen(_textChanged);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new Container(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        padding: new EdgeInsets.all(8.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new TextField(
              decoration: new InputDecoration(
                hintText: 'Choose a book',
              ),
              //onChanged: (string) => (_textChanged(string)),
              onChanged: (string) => (subject.add(string)),
              controller: _controller,
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
                        child: new Text(_items[index], maxLines: 10),
                    )
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _floatingClick,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
