import 'package:flutter/material.dart';
import 'package:test_app/pages/collection_page.dart';
import 'package:test_app/pages/home_page.dart';
import 'package:test_app/pages/search_book_page.dart';
import 'package:test_app/pages/stamp_collection_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Book search',
      theme: new ThemeData(
       // primarySwatch: Colors.deepOrangeAccent,
        primaryColor: new Color(0xFF0F2533),
      ),
      routes: {
        '/': (BuildContext context) => new HomePage(),
        '/search': (BuildContext context) => new SearchBookPage(),
        '/collection': (BuildContext context) => new CollectionPage(),
        '/stamp_collection': (BuildContext context) => new StampCollectionPage(),
      },
    );
  }


}

