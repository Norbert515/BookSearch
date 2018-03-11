import 'package:flutter/material.dart';


class BookSticker extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _BookStickerState();

}


class _BookStickerState extends State<BookSticker> {


  @override
  Widget build(BuildContext context) {

    var style = const TextStyle(fontSize: 15.0);
    return new Card(
      elevation: 8.0,
      child: new Container(
        padding: new EdgeInsets.all(16.0),
        width: 200.0,
        height: 350.0,
        child: new Column(
          children: <Widget>[
            new Image.asset("assets/test_img.jpg"),
            new Text("Pages: 368", style: style,),
            new Text("Genre: Biography & Autobiography", style: style,),
            new Text("Authors: Ashlee Vance, Elon Musk", style: style,),
          ],
        )
      ),
    );
  }

}