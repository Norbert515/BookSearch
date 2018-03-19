import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test_app/data/repository.dart';
import 'package:test_app/pages/book_notes_page.dart';
import 'package:test_app/model/Book.dart';
import 'package:test_app/utils/utils.dart';
import 'package:test_app/widgets/BookCard.dart';
import 'package:test_app/widgets/book_card_compact.dart';
import 'package:test_app/widgets/book_card_minimalistic.dart';


class SearchBookPageNew extends StatefulWidget {

  @override
  _SearchBookStateNew createState() => new _SearchBookStateNew();
}

class _SearchBookStateNew extends State<SearchBookPageNew> {
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
    const textStyle = const TextStyle(
      fontSize: 35.0,
      fontFamily: 'Butler',
      fontWeight: FontWeight.w400
    );
    return new Scaffold(
      key: scaffoldKey,
      body: new CustomScrollView(
        slivers: <Widget>[
          new SliverAppBar(
            forceElevated: true,
            backgroundColor: Colors.white,
            elevation: 1.0,
            iconTheme: new IconThemeData(color: Colors.black),
          ),
          new SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: new SliverToBoxAdapter(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text("Search for Books", style: textStyle,),
                  new Card(
                      elevation: 4.0,
                      child: new Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new TextField(
                          decoration: new InputDecoration(
                              hintText: "What books did your read?",
                              prefixIcon: new Icon(Icons.search),
                              border: InputBorder.none
                          ),
                          onChanged: (string) => (subject.add(string)),
                        ),
                      )
                  ),
                  new SizedBox(height: 16.0,),
                ],
              ),
            ),
          ),
          _isLoading? new SliverToBoxAdapter(child: new Center(child: new CircularProgressIndicator()),): new SliverToBoxAdapter(),
          new SliverList(delegate: new SliverChildBuilderDelegate((BuildContext context, int index){
            return new BookCardCompact(_items[index]);
          },
          childCount: _items.length)
          )
        ],
      ),
    );
  }
}

