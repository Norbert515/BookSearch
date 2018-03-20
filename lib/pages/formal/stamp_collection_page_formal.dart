import 'package:flutter/material.dart';
import 'package:test_app/data/repository.dart';
import 'package:test_app/model/Book.dart';
import 'package:test_app/pages/abstract/stamp_collection_page_abstract.dart';
import 'package:test_app/widgets/stamp.dart';
import 'package:test_app/widgets/book_card_compact.dart';


class StampCollectionFormalPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _StampCollectionPageFormalState();

}


class _StampCollectionPageFormalState extends StampCollectionPageAbstractState<StampCollectionFormalPage> {



  @override
  Widget build(BuildContext context) {

    const textStyle = const TextStyle(
        fontSize: 35.0,
        fontFamily: 'Butler',
        fontWeight: FontWeight.w400
    );

    Widget body;

    if(items.isEmpty) {
      body = new Center(child: new Text("You have no collection yet"));
    } else {
      body = new ListView.builder(itemBuilder: (BuildContext context, int index){
        return new Stamp(items[index].url);
      },
        itemCount: items.length,
      );
    }
/*
    body = new ListView(
      children: <Widget>[
        new Stamp(items[0].url),
        new Stamp(items[0].url),
        new Stamp(items[0].url),
      ],
    );*/

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Stamp Collection"),
        backgroundColor: Colors.white,
        elevation: 1.0,
        iconTheme: new IconThemeData(color: Colors.black),
      ),
      body: body,
    );
  }


}