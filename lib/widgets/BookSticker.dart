import 'package:flutter/material.dart';


class BookSticker extends StatefulWidget {


  final bool withStartAnimation = false;

  @override
  State<StatefulWidget> createState() => new _BookStickerState();

}


class _BookStickerState extends State<BookSticker> with SingleTickerProviderStateMixin{

  AnimationController animationController;
  Animation animation;


  @override
  void initState() {
    animationController = new AnimationController(vsync: this, duration: new Duration(milliseconds: 1000));

    animation  = new Tween(begin: 0.0, end: 4.0).animate(animationController);

    animationController.forward();

  }


  @override
  Widget build(BuildContext context) {

    return new AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget child) {
          return new Transform(
            transform:
            new Matrix4.rotationY(animation.value * 3.14),
            alignment: Alignment.center,
            child: animation.value % 2 < 0.5 || animation.value % 2 > 1.5
                ? _buildFront(context)
                : new Transform(
                transform: new Matrix4.rotationY(
                    animation.value * 3.14),
                alignment: Alignment.center,
                child: _buildBack(context)),
          );
        });
  }

  _buildFront(BuildContext context) {
    var style = const TextStyle(fontSize: 15.0);
    return new Card(
      elevation: 6.0,
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

  _buildBack(BuildContext context) {
    return new Card(
      elevation: 6.0,
      child: new Container(
        width: 200.0,
        height: 350.0,
      ),
    );
  }




}