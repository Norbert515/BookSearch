import 'package:flutter/material.dart';
import 'package:test_app/model/Book.dart';


class BookCardCompact extends StatelessWidget {


  BookCardCompact(this.book);

  final Book book;


  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Row(
        children: <Widget>[
          new Image.network(book.url),
          new Expanded(
            child: new Padding(
              padding: const EdgeInsets.only(top : 8.0, left: 24.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(_short(book.title, 25), style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 20.0),),
                  new SizedBox(height: 4.0,),
                  new Text(book.author),
                  new SizedBox(height: 8.0,),
                  new Text(_short(book.subtitle, 30)),
                //  new Divider(height: 16.0, color: Colors.black),
                  new Divider(color: Colors.black,),
                  new Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new SizedBox(height: 24.0, width: 24.0, child: new IconButton(icon: new Icon(Icons.star_border), onPressed: (){}, padding: const EdgeInsets.all(0.0), )),
                      new SizedBox(height: 24.0, width: 24.0, child: new IconButton(icon: new Icon(Icons.star_border), onPressed: (){}, padding: const EdgeInsets.all(0.0), )),
                      new SizedBox(height: 24.0, width: 24.0, child: new IconButton(icon: new Icon(Icons.star_border), onPressed: (){}, padding: const EdgeInsets.all(0.0), )),
                      new SizedBox(height: 24.0, width: 24.0, child: new IconButton(icon: new Icon(Icons.star_border), onPressed: (){}, padding: const EdgeInsets.all(0.0), )),
                      new SizedBox(height: 24.0, width: 24.0, child: new IconButton(icon: new Icon(Icons.star_border), onPressed: (){}, padding: const EdgeInsets.all(0.0), )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  String _short(String title, int targetLength) {
    var list = title.split(" ");
    int buffer = 0;
    String result = "";
    bool showedAll = true;
    for(String item in list) {
      if(buffer + item.length <= targetLength) {
        buffer += item.length;
        result += item += " ";
      } else {
        showedAll = false;
        break;
      }
    }
    //Handle case of one very long word
    if(result == "" && title.length > 18) {
      result = title.substring(0, 18);
      showedAll = false;
    }

    if(!showedAll) result += "...";
    return result;
  }
}