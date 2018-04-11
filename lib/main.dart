import 'package:flutter/material.dart';
import 'package:test_app/pages/universal/collection_page.dart';
import 'package:test_app/pages/formal/stamp_collection_page_formal.dart';
import 'package:test_app/pages/home_page.dart';
import 'package:test_app/pages/material/search_book_page_material.dart';
import 'package:test_app/pages/formal/search_book_page_formal.dart';
import 'package:test_app/pages/material/stamp_collection_page_material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:test_app/redux/app_state.dart';
import 'package:test_app/redux/reducers.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  final Store<AppState> store = new Store(readBookReducer, initialState: AppState.initState());
  @override
  Widget build(BuildContext context) {
    return new StoreProvider<AppState>(
      store:store,
      child: new MaterialApp(
        title: 'Book search',
        theme: new ThemeData(
          primaryColor: new Color(0xFF0F2533),
        ),
        routes: {
          '/': (BuildContext context) => new HomePage(),
          '/search_material': (BuildContext context) => new SearchBookPage(),
          '/search_formal': (BuildContext context) => new SearchBookPageNew(),
          '/collection': (BuildContext context) => new CollectionPage(),
          '/stamp_collection_material': (BuildContext context) => new StampCollectionPage(),
          '/stamp_collection_formal': (BuildContext context) => new StampCollectionFormalPage(),
        },
      ),
    );
  }


}
