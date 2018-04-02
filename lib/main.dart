import 'package:flutter/material.dart';
import 'package:test_app/pages/universal/collection_page.dart';
import 'package:test_app/pages/formal/stamp_collection_page_formal.dart';
import 'package:test_app/pages/home_page.dart';
import 'package:test_app/pages/material/search_book_page_material.dart';
import 'package:test_app/pages/formal/search_book_page_formal.dart';
import 'package:test_app/pages/material/stamp_collection_page_material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Book search',
      theme: new ThemeData(
     //   primarySwatch: Colors.green,
        // primarySwatch: Colors.deepOrangeAccent,
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
    );
  }


}

