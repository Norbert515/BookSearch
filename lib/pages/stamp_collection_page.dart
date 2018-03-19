import 'package:flutter/material.dart';
import 'package:test_app/data/repository.dart';
import 'package:test_app/model/Book.dart';
import 'package:test_app/widgets/book_card_compact.dart';


class StampCollectionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _StampCollectionPageState();

}


class _StampCollectionPageState extends State<StampCollectionPage> {


  List<Book> _items = new List();




  @override
  void initState() {
    super.initState();
    Repository.get().getFavoriteBooks()
        .then((books) {
      setState(() {
        _items = books;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    Matrix4 transform = new Matrix4.skewX(10.0);
    transform.translate(-100.0);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Stamp Collection"),
      ),
      body: new Transform(
        transform: transform,
        child: new ListView.builder(itemBuilder: (BuildContext context, int index){
          return new BookCardCompact(_items[index]);
        },
        itemCount: _items.length,
        ),
      ),
    );
  }


}