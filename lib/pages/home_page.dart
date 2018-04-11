import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:test_app/data/repository.dart';
import 'package:test_app/model/Book.dart';
import 'package:test_app/redux/app_state.dart';
import 'package:test_app/utils/index_offset_curve.dart';
import 'package:test_app/widgets/collection_preview.dart';
import 'package:test_app/widgets/stamp.dart';



class HomePage extends StatefulWidget {






  @override
  State<StatefulWidget> createState() => new _HomePageState();
}



class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {


  AnimationController cardsFirstOpenController;


  String interfaceType = "formal";


  @override
  void initState() {
    super.initState();
    cardsFirstOpenController = new AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    cardsFirstOpenController.forward(from: 0.2);
  }


  @override
  void dispose() {
    cardsFirstOpenController.dispose();
    super.dispose();
  }

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
          new FadeTransition(
            opacity: new CurvedAnimation(parent: cardsFirstOpenController, curve: new IndexOffsetCurve(0)),
          /* child: new StoreConnector<AppState, List<Book>>(
             converter: (Store<AppState> store) => store.state.readBooks,
             builder: (BuildContext context, List<Book> books) {
               return new CollectionPreview(
                 books: books,
                 color: new Color(0xff8FC0A9),
                 title: "My Collection",
                 loading: false,
               );
             },
           ),*/
           child: new FutureBuilder<List<Book>>(
              future: Repository.get().getFavoriteBooks(),
              builder: (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
                List<Book> books = [];
                if(snapshot.data != null) books = snapshot.data;
                return new CollectionPreview(
                  //TODO redundant, image url already fetched
                  books: books,
                  color: new Color(0xff8FC0A9),
                  title: "My Collection",
                  loading: snapshot.data == null,
                );
              },
            ),
          ),
          new FadeTransition(
            opacity: new CurvedAnimation(parent: cardsFirstOpenController, curve: new IndexOffsetCurve(1)),
            child: new FutureBuilder<List<Book>>(
              future: Repository.get().getBooksById(["wO3PCgAAQBAJ","_LFSBgAAQBAJ","8U2oAAAAQBAJ"]),
              builder: (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
                List<Book> books = [];
                if(snapshot.data != null) books = snapshot.data;
                return new CollectionPreview(
                  books: books,
                  color: new Color(0xff4F518C),
                  title: "Biographies",
                  loading: snapshot.data == null,
                );
              },
            ),
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