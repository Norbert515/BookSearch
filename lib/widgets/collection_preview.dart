import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:test_app/data/repository.dart';
import 'package:test_app/model/Book.dart';
import 'package:test_app/widgets/stamp.dart';



class CollectionPreview extends StatefulWidget {


  final List<String> bookIds;

  final Color color;

  final String title;



  CollectionPreview({@required this.bookIds, this.color = Colors.white, @required this.title});

  @override
  State<StatefulWidget> createState() => new _CollectionPreviewState();

}


class _CollectionPreviewState extends State<CollectionPreview> {



  List<Book> books = [];


  @override
  void initState(){
    super.initState();
    _fetchBooks().then((it){
      setState((){});
    });

  }

  Future _fetchBooks() async{
    var repository = Repository.get();
    for(String id in widget.bookIds) {
      ParsedResponse response = await repository.getBook(id);
      books.add(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = const TextStyle(
        fontSize: 35.0,
        fontFamily: 'CrimsonText',
        fontWeight: FontWeight.w400
    );
    return new ConstrainedBox(
      constraints: new BoxConstraints(minWidth: double.INFINITY, maxWidth: double.INFINITY, minHeight: 0.0, maxHeight: double.INFINITY),
      child: new Container(
        padding: const EdgeInsets.all(8.0),
        color: widget.color,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(widget.title, style: textStyle,),
            new SizedBox(
              height: 200.0,
              child: new ListView(
                scrollDirection: Axis.horizontal,
                children: books.map((book)=>new Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: new Stamp(book.url, width: 100.0,),
                )).toList()
              ),
            ),
          ],
        )
      ),
    );
  }
}