import 'package:flutter/material.dart';
import 'package:test_app/data/repository.dart';
import 'package:test_app/model/Book.dart';
import 'package:test_app/pages/abstract/stamp_collection_page_abstract.dart';
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
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Stamp Collection"),
        backgroundColor: Colors.white,
        elevation: 1.0,
        iconTheme: new IconThemeData(color: Colors.black),
      ),
      body: new ListView.builder(itemBuilder: (BuildContext context, int index){
        return new BookCardCompact(items[index]);
      },
      itemCount: items.length,
      ),
    );
  }


}