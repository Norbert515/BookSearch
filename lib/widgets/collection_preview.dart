import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';
import 'package:test_app/data/repository.dart';
import 'package:test_app/model/Book.dart';
import 'package:test_app/pages/formal/book_details_page_formal.dart';
import 'package:test_app/utils/utils.dart';
import 'package:test_app/widgets/stamp.dart';



class CollectionPreview extends StatefulWidget {



  final List<Book> books;

  final Color color;

  final String title;


  final bool loading;

  CollectionPreview({this.color = Colors.white, @required this.title, this.books, this.loading = false});

  @override
  State<StatefulWidget> createState() => new _CollectionPreviewState();

}


class _CollectionPreviewState extends State<CollectionPreview> {




  @override
  Widget build(BuildContext context) {
    const textStyle = const TextStyle(
        fontSize: 32.0,
        fontFamily: 'CrimsonText',
        fontWeight: FontWeight.w400
    );
    return new ClipRect(
      child: new Align(
        heightFactor: 0.7,
        alignment: Alignment.topCenter,
        child: new ConstrainedBox(
          constraints: new BoxConstraints(minWidth: double.INFINITY, maxWidth: double.INFINITY, minHeight: 0.0, maxHeight: double.INFINITY),
          child: new Container(
            padding: const EdgeInsets.all(8.0),
            color: widget.color,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
         //       new Divider(color: Colors.black,),
                new Text(widget.title, style: textStyle,),
                new Stack(
                  children: <Widget>[
                    new SizedBox(
                      height: 200.0,
                      child: new ListView(
                        scrollDirection: Axis.horizontal,
                        children: widget.books.map((book)=>new Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: new Stamp(book.url, width: 100.0, locked: !book.starred, onClick: (){
                            Navigator.of(context).push(
                                new FadeRoute(
                                  builder: (BuildContext context) => new BookDetailsPageFormal(book),
                                  settings: new RouteSettings(name: '/book_detais_formal', isInitialRoute: false),
                                ));
                          },),
                        )).toList()
                      ),
                    ),
                    widget.loading ? new Center(child: new CircularProgressIndicator(),): new Container(),
                  ],
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}