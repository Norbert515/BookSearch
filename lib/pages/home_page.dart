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

  bool init = true;

  @override
  void initState() {
    super.initState();
    cardsFirstOpenController = new AnimationController(vsync: this, duration: const Duration(milliseconds: 1300));

    Repository.get().init().then((it){
      setState((){
        init = false;
      });
    });
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
      body: init? new Container(): new CustomScrollView(
        slivers: <Widget>[
          new SliverAppBar(
            actions: <Widget>[
              new IconButton(icon: new Icon(Icons.search), onPressed: () {Navigator.pushNamed(context, '/search_$interfaceType');},),
              new IconButton(icon: new Icon(Icons.collections), onPressed: () {Navigator.pushNamed(context, '/stamp_collection_$interfaceType');},),
            ],
            backgroundColor: Colors.white,
            elevation: 2.0,
            iconTheme: new IconThemeData(color: Colors.black),
            floating: true,
            forceElevated: true,
          ),
          new SliverList(delegate: new SliverChildListDelegate(
            [
              wrapInAnimation(myCollection(), 0),
              wrapInAnimation(collectionPreview(new Color(0xffffffff), "Biographies", ["wO3PCgAAQBAJ","_LFSBgAAQBAJ","8U2oAAAAQBAJ", "yG3PAK6ZOucC"]), 1),
              wrapInAnimation(collectionPreview(new Color(0xffffffff), "Fiction", ["OsUPDgAAQBAJ", "3e-dDAAAQBAJ", "-ITZDAAAQBAJ","rmBeDAAAQBAJ", "vgzJCwAAQBAJ"]), 2),
              wrapInAnimation(collectionPreview(new Color(0xffffffff), "Mystery & Thriller", ["1Y9gDQAAQBAJ", "Pz4YDQAAQBAJ", "UXARDgAAQBAJ"]), 3),
              wrapInAnimation(collectionPreview(new Color(0xffffffff), "Sience Ficition", ["JMYUDAAAQBAJ","PzhQydl-QD8C", "nkalO3OsoeMC", "VO8nDwAAQBAJ", "Nxl0BQAAQBAJ"]), 4),
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
              new Center(
                child: new Text("Magic Switch, press for different style", style: const TextStyle(fontSize: 18.0),),
              ),
            ],
          ))
        ],
      )
    );
  }


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

  Widget wrapInAnimation(Widget child, int index) {
    Animation offsetAnimation = new CurvedAnimation(parent: cardsFirstOpenController, curve: new IndexOffsetCurve(index));
    Animation fade = new CurvedAnimation(parent: offsetAnimation, curve: Curves.ease);
    return new SlideTransition(
        position: new Tween<Offset>(begin: new Offset(0.5, 0.0), end: new Offset(0.0, 0.0)).animate(fade),
        child: new FadeTransition(
          opacity: fade,
          child: child,
        )
    );
  }


  Widget collectionPreview(Color color, String name, List<String> ids) {
    return new FutureBuilder<List<Book>>(
      future: Repository.get().getBooksByIdFirstFromDatabaseAndCache(ids),
      builder: (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
        List<Book> books = [];
        if(snapshot.data != null) books = snapshot.data;
        return new CollectionPreview(
          books: books,
          color: color,
          title: name,
          loading: snapshot.data == null,
        );
      },
    );
  }


  Widget myCollection() {
    return new FutureBuilder<List<Book>>(
      future: Repository.get().getFavoriteBooks(),
      builder: (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
        List<Book> books = [];
        if(snapshot.data != null) books = snapshot.data;
        if(books.isEmpty) {
          return new Container();
        }
        return new CollectionPreview(
          books: books,
          //color: new Color(0xffFC96BC),
          color: new Color(0xffffffff),
          title: "My Collection",
          loading: snapshot.data == null,
        );
      },
    );
  }
}