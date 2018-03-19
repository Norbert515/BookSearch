import 'package:meta/meta.dart';

class Book {
  static final db_title = "title";
  static final db_url = "url";
  static final db_id = "id";
  static final db_notes = "notes";
  static final db_star = "star";
  static final db_author = "author";
  static final db_description = "description";
  static final db_subtitle = "subtitle";

  String title, url, id, notes, description, subtitle;
  //First author
  String author;
  bool starred;
  Book({
    @required this.title,
    @required this.url,
    @required this.id,
    @required this.author,
    @required this.description,
    @required this.subtitle,
    this.starred = false,
    this.notes = "",
  });

  Book.fromMap(Map<String, dynamic> map): this(
    title: map[db_title],
    url: map[db_url],
    id: map[db_id],
    starred: map[db_star] == 1,
    notes: map[db_notes],
    description: map[db_description],
    author: map[db_author],
    subtitle: map[db_subtitle],
  );

  // Currently not used
  Map<String, dynamic> toMap() {
    return {
      db_title: title,
      db_url: url,
      db_id: id,
      db_notes: notes,
      db_star: starred? 1:0,
      db_description: description,
      db_author: author,
      db_subtitle: subtitle,
    };
  }
}
