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

    var size = 150.0;

    var card_width = 300.0 - size;
    var card_height = 380.0 - size;

    var inner_width = 230.0 - size;
    var inner_height = 300.0 - size;

    return new Material(
      elevation: 6.0,
      color: Colors.transparent,
      child: new SizedBox(
        width: card_width,
        height: card_height,
        child: _clipped(context, card_width, card_height),
      ),
    );


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

  Widget _clipped(BuildContext context, double card_width, double card_height) {
    return new ClipPath(
      clipper: new StampClipper(),
      child: new Align(
          alignment: Alignment.center,
          child: new Image.asset("assets/test_img.jpg",
            width: card_width,
            height: card_height,
            fit: BoxFit.cover,
          )
      ),
    );
  }



}

class StampClipper extends CustomClipper<Path> {


  final holeRadii = 15.0;

  @override
  Path getClip(Size size) {
    Path path = new Path();
    
    int num = (size.width / holeRadii).round();

    double radius;
    if(num % 2 == 0) {
      num++;
      radius = size.width / num;
    }

    for(int i = 0; i < num / 2 - 1; i++) {
      path.relativeLineTo(radius, 0.0);
      path.relativeArcToPoint(new Offset(radius, 0.0), radius: new Radius.circular(radius / 2), clockwise: false);
    }
    path.relativeLineTo(radius, 0.0);


    int numVert = (size.height / radius).round();
    for(int i = 0; i < numVert / 2 - 1; i++) {
      path.relativeLineTo(0.0, radius);
      path.relativeArcToPoint(new Offset(0.0, radius), radius: new Radius.circular(radius / 2), clockwise: false);
    }
    path.relativeLineTo(0.0, radius);


    for(int i = 0; i < num / 2 - 1; i++) {
      path.relativeLineTo(-radius, 0.0);
      path.relativeArcToPoint(new Offset(-radius, 0.0), radius: new Radius.circular(radius / 2), clockwise: false);
    }
    path.relativeLineTo(-radius, 0.0);

    for(int i = 0; i < numVert / 2 - 1; i++) {
      path.relativeLineTo(0.0, -radius);
      path.relativeArcToPoint(new Offset(0.0, -radius), radius: new Radius.circular(radius / 2), clockwise: false);
    }
    path.relativeLineTo(0.0, -radius);


    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}