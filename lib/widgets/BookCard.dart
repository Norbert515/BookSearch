import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:test_app/database.dart';
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
      onTap: widget.onCardClick,
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