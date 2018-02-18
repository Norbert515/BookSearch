import 'package:meta/meta.dart';

class Book {
  String title, url, id;
  bool starred;
  Book({
    @required this.title,
    @required this.url,
    @required this.id,
    this.starred = false,
  });
}
