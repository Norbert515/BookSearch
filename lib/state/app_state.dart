import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:test_app/data/repository.dart';
import 'package:test_app/model/Book.dart';


class AppState extends InheritedWidget {


  const AppState({
    Key key,
    @required Widget child,
    this.readBooks
  }) :assert(child != null),
        super(key: key, child: child);

  final List<Book> readBooks;





  static AppState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AppState);
  }

  @override
  bool updateShouldNotify(AppState old) => readBooks != old.readBooks;

}