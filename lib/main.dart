import 'package:flutter/material.dart';
import 'package:test_app/view/home_page.dart';
import 'package:test_app/view/search_book_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Book search',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      routes: {
        '/': (BuildContext context) => new HomePage(),
        '/search': (BuildContext context) => new SearchBookPage(),
      },
    );
  }
}

