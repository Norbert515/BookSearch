import 'package:flutter/material.dart';
import 'package:test_app/data/repository.dart';
import 'package:test_app/model/Book.dart';
import 'package:test_app/pages/abstract/stamp_collection_page_abstract.dart';
import 'package:test_app/pages/formal/book_details_page_formal.dart';
import 'package:test_app/utils/utils.dart';
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
        return new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Stamp(items[index].url,),
        );
      },
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
      );
    }


    body = new GridView.extent(
      maxCrossAxisExtent: 150.0,
      mainAxisSpacing: 20.0,
      children: items.map((Book book)=> new Stamp(book.url, width: 90.0, onClick: (){
        Navigator.of(context).push(
            new FadeRoute(
              builder: (BuildContext context) => new BookDetailsPageFormal(book),
              settings: new RouteSettings(name: '/book_detais_formal', isInitialRoute: false),
            ));
      },)).toList(),

    );

    body = new Container(
      padding: const EdgeInsets.all(16.0),
      child: body,
      color: new Color(0xFFF5F5F5),
    );


    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Stamp Collection", style: const TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        elevation: 1.0,
        iconTheme: new IconThemeData(color: Colors.black),
      ),
      body: body,
    );
  }


}