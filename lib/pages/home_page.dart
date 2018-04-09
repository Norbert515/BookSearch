import 'package:flutter/material.dart';
import 'package:test_app/data/repository.dart';
import 'package:test_app/model/Book.dart';
import 'package:test_app/widgets/collection_preview.dart';
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
      body: new ListView(

        children: <Widget>[
          new StreamBuilder<List<Book>>(
            stream: Repository.get().getFavoriteBooksStream(),
            builder: (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
              if(snapshot.data == null || snapshot.data.isEmpty) return new Container();
              return new CollectionPreview(
                //TODO redundant, image url already fetched
                books: snapshot.data,
                color: new Color(0xff8FC0A9),
                title: "My Collection",
              );
            },
          ),
          new CollectionPreview(
            bookIds: ["wO3PCgAAQBAJ","_LFSBgAAQBAJ","8U2oAAAAQBAJ"],
            color: new Color(0xff4F518C),
            title: "Biographies",
          ),
          new CollectionPreview(
            bookIds: ["wO3PCgAAQBAJ","_LFSBgAAQBAJ","8U2oAAAAQBAJ"],
            color: new Color(0xff3B5249),
            title: "Biographies",
          ),
          new Center(
            child: new Switch(value: interfaceType != "formal", onChanged: (bool){
              setState((){
                if(bool) {
                  interfaceType = "material";
                } else {
                  interfaceType = "formal";
                }
              });
            }),
          ),
        ],
      )
    );
  }

}