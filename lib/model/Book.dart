import 'package:meta/meta.dart';

class Book {
  String title, url, id, notes;
  bool starred;
  Book({
    @required this.title,
    @required this.url,
    @required this.id,
    this.starred = false,
    this.notes
  });
}
