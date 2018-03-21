import 'package:flutter/material.dart';
import 'package:test_app/model/Book.dart';
import 'package:test_app/pages/abstract/book_details_page_abstract.dart';



class BookDetailsPageFormal extends StatefulWidget {


  BookDetailsPageFormal(this.book);

  final Book book;

  @override
  State<StatefulWidget> createState() => new _BookDetailsPageFormalState();

}


class _BookDetailsPageFormalState extends AbstractBookDetailsPageState<BookDetailsPageFormal> {


  @override
  Widget build(BuildContext context) {
    return new Scaffold(

    );
  }

}