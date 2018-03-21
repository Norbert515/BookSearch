import 'package:flutter/material.dart';


class Stamp extends StatefulWidget {


  Stamp(this.imageUrl);

  final bool withStartAnimation = false;
  final String imageUrl;

  @override
  State<StatefulWidget> createState() => new _StampState();

}


class _StampState extends State<Stamp> with SingleTickerProviderStateMixin{

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

    return new Container(
      child: new Center(
        child: new SizedBox(
          width: card_width,
          height: card_height,
          child: new Material(
            elevation: 8.0,
            color: Colors.transparent,
            child: new Center(
              child: new SizedBox(
                width: card_width,
                height: card_height,
                child: _clippedNetwork(context, card_width, card_height),
              ),
            ),
          ),
        ),
      ),
    );

  }

  Widget _clippedV1(BuildContext context, double card_width, double card_height) {
    return new ClipPath(
      clipper: new StampClipper(),
      child: new Image.asset("assets/test_img.jpg",
        width: card_width,
        height: card_height,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _clippedNetwork(BuildContext context, double card_width, double card_height) {
    return new ClipPath(
      clipper: new StampClipper(),
      child: new Container(
        color: Colors.white,
        child: new Align(
            alignment: Alignment.topCenter,
            child: new Image.network(widget.imageUrl,
              width: card_width,
              height: card_height,
              fit: BoxFit.cover,
            )
        ),
      ),
    );
  }

  Widget _clippedV2(BuildContext context, double card_width, double card_height) {
    return new ClipPath(
      clipper: new StampClipper(),
      child: new Container(
        color: Colors.white,
        child: new Column(
          children: <Widget>[
            new Align(
                alignment: Alignment.topCenter,
                child: new Image.asset("assets/test_img.jpg",
                  width: card_width,
                  height: card_height- 30.0,
                  fit: BoxFit.cover,
                )
            ),
            new Text("Elon Musk", style: const TextStyle(fontSize: 20.0),),
          ],
        ),
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
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return holeRadii != holeRadii;
  }
}