import 'package:flutter/material.dart';
import 'package:test_app/widgets/stamp.dart';



class HomePage extends StatefulWidget {






  @override
  State<StatefulWidget> createState() => new _HomePageState();
}



class _HomePageState extends State<HomePage> {


  String interfaceType = "formal";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.search), onPressed: () {Navigator.pushNamed(context, '/search_$interfaceType');},),
          new IconButton(icon: new Icon(Icons.collections), onPressed: () {Navigator.pushNamed(context, '/stamp_collection_$interfaceType');},),
        ],
        backgroundColor: Colors.white,
        elevation: 1.0,
        iconTheme: new IconThemeData(color: Colors.black),
      ),
      body: new Center(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
           // new Stamp(""),
            new Switch(value: interfaceType != "formal", onChanged: (bool){
              setState((){
                if(bool) {
                  interfaceType = "material";
                } else {
                  interfaceType = "formal";
                }
              });
            }),
          ],
        ),
      )
    );
  }

}