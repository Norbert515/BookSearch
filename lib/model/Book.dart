import 'package:meta/meta.dart';

class Book {
  static final db_title = "title";
  static final db_url = "url";
  static final db_id = "id";
  static final db_notes = "notes";
  static final db_star = "star";

  String title, url, id, notes;
  bool starred;
  Book({
    @required this.title,
    @required this.url,
    @required this.id,
    this.starred = false,
    this.notes = "",
  });

  Book.fromMap(Map<String, dynamic> map): this(
    title: map[db_title],
    url: map[db_url],
    id: map[db_id],
    starred: map[db_star] == 1,
    notes: map[db_notes],
  );

  // Currently not used
  Map<String, dynamic> toMap() {
    return {
      db_title: title,
      db_url: url,
      db_id: id,
      db_notes: notes,
      db_star: starred? 1:0,
    };
  }
}
