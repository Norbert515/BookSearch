import 'package:flutter/material.dart';
import 'package:test_app/data/repository.dart';
import 'package:test_app/model/Book.dart';
import 'package:test_app/widgets/book_card_compact.dart';


abstract class StampCollectionPageAbstractState<T extends StatefulWidget> extends State<T> {


  List<Book> items = new List();


  @override
  void initState() {
    super.initState();
    Repository.get().getFavoriteBooks()
        .then((books) {
      setState(() {
        items = books;
      });
    });
  }


}