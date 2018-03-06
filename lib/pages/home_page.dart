import 'package:flutter/material.dart';



class HomePage extends StatefulWidget {






  @override
  State<StatefulWidget> createState() => new _HomePageState();
}



class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.search), onPressed: () {Navigator.pushNamed(context, '/search');},),
          new IconButton(icon: new Icon(Icons.collections), onPressed: () {Navigator.pushNamed(context, '/collection');},),
        ],
      ),
      body: new Center(
        child: new Text("Main Page"),
      )
    );
  }

}