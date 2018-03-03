import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:test_app/model/Book.dart';


class BookCard extends StatefulWidget {


  BookCard({
    this.book,
    @required this.onCardClick,
    @required this.onStarClick,
  });

  final Book book;


  final VoidCallback onCardClick;
  final VoidCallback onStarClick;

  @override
  State<StatefulWidget> createState() => new BookCardState();

}

class BookCardState extends State<BookCard> {



  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: widget.onCardClick,
      child: new Card(
          child: new Container(
            height: 200.0,
            child: new Padding(
                padding: new EdgeInsets.all(8.0),
                child: new Row(
                  children: <Widget>[
                    widget.book.url != null?
                    new Hero(
                      child: new Image.network(widget.book.url),
                      tag: widget.book.id,
                    ):
                    new Container(),
                    new Expanded(
                      child: new Stack(
                        children: <Widget>[
                          new Align(
                            child: new Padding(
                              child: new Text(widget.book.title + "    " + widget.book.notes, maxLines: 10),
                              padding: new EdgeInsets.all(8.0),
                            ),
                            alignment: Alignment.center,
                          ),
                          new Align(
                            child: new IconButton(
                              icon: widget.book.starred? new Icon(Icons.star): new Icon(Icons.star_border),
                              color: Colors.black,
                              onPressed: widget.onStarClick,
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