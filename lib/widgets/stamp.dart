import 'package:flutter/material.dart';


class Stamp extends StatefulWidget {


  Stamp(this.imageUrl, {this.width = 150.0, this.locked = false, this.onClick});

  final bool withStartAnimation = false;
  final String imageUrl;

  final double width;

  final double aspectRatio = 1.5333333;

  final double relativeHoleRadius = 1.0;

  final bool locked;

  final VoidCallback onClick;

  @override
  State<StatefulWidget> createState() => new _StampState();

}


class _StampState extends State<Stamp> with SingleTickerProviderStateMixin{

//  AnimationController animationController;
  Animation animation;


  @override
  void initState() {
    super.initState();
  //  animationController = new AnimationController(vsync: this, duration: new Duration(milliseconds: 1000));

 //   animation  = new Tween(begin: 0.0, end: 4.0).animate(animationController);

 //   animationController.forward();

  }


  @override
  Widget build(BuildContext context) {


    var width  = widget.width;
    var height = widget.width * widget.aspectRatio;

    var holeRadius = widget.relativeHoleRadius * (width / 10.0);

    Widget result =  new GestureDetector(
      onTap: widget.onClick,
      child: new Container(
        child: new Center(
          child: new ConstrainedBox(
            constraints: new BoxConstraints.tight(new Size(width, height)),
            child: new Material(
              elevation: 8.0,
              color: Colors.transparent,
              child: new Center(
                child: _clippedNetwork(context, width, height, holeRadius),
              ),
            ),
          ),
        ),
      ),
    );



    return result;

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

  Widget _clippedNetwork(BuildContext context, double card_width, double card_height, double holeRadius) {
    List<Widget> stackChildren = [];

    stackChildren.add(
        new Image.network(widget.imageUrl,
          width: card_width,
          height: card_height,
          fit: BoxFit.cover,
    ));

    if(widget.locked) {
      stackChildren.add(
          new Container(
            color: const Color(0xbb000000),
            width: card_width,
            height: card_height,
          ));
      stackChildren.add(new Align(alignment: Alignment.center,child: new Icon(Icons.lock, color: Colors.white,)));
    }



    return new ClipPath(
      clipper: new StampClipper(holeRadius: holeRadius),
      child: new Container(
        color: Colors.white,
        child: new Align(
            alignment: Alignment.center,
            child: new Stack(
              children: stackChildren
            )
        ),
      ),
    );
  }

  Widget _clippedNetwork2(BuildContext context, double card_width, double card_height) {
    return new Container(
      color: Colors.white,
      child: new Align(
          alignment: Alignment.topCenter,
          child: new Image.network(widget.imageUrl,
            width: card_width,
            height: card_height,
            fit: BoxFit.cover,
          )
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

  @override
  void dispose() {

    super.dispose();
  }


}

class StampClipper extends CustomClipper<Path> {


  StampClipper({this.holeRadius = 15.0});


  final holeRadius;

  @override
  Path getClip(Size size) {
    Path path = new Path();

    int num = (size.width / holeRadius).round();

    double radius;
    if(num % 2 == 0) {
      num++;
    }
    radius = size.width / num;

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
    return holeRadius != holeRadius;
  }
}