import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test_app/data/repository.dart';
import 'package:test_app/pages/book_notes_page.dart';
import 'package:test_app/model/Book.dart';
import 'package:test_app/utils/utils.dart';
import 'package:test_app/widgets/BookCard.dart';


class SearchBookPage extends StatefulWidget {

  @override
  _SearchBookState createState() => new _SearchBookState();
}

class _SearchBookState extends State<SearchBookPage> {
  List<Book> _items = new List();

  final subject = new PublishSubject<String>();

  bool _isLoading = false;

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();


  void _textChanged(String text) {
    if(text.isEmpty) {
      setState((){_isLoading = false;});
      _clearList();
      return;
    }
    setState((){_isLoading = true;});
    _clearList();
    Repository.get().getBooks(text)
    .then((books){
      setState(() {
        _isLoading = false;
        if(books.isOk()) {
          _items = books.body;
        } else {
          scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Something went wrong, check your internet connection")));
        }
      });
    });
  }


  void _clearList() {
    setState(() {
      _items.clear();
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
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
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
                  return new BookCard(
                    book: _items[index],
                    onCardClick: (){
                      Navigator.of(context).push(
                          new FadeRoute(
                            builder: (BuildContext context) => new BookNotesPage(_items[index]),
                            settings: new RouteSettings(name: '/notes', isInitialRoute: false),
                          ));
                    },
                    onStarClick: (){
                      setState(() {
                        _items[index].starred = !_items[index].starred;
                      });
                      Repository.get().updateBook(_items[index]);
                    },
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

