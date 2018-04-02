import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test_app/data/repository.dart';
import 'package:test_app/pages/abstract/search_book_page_abstract.dart';
import 'package:test_app/pages/universal/book_notes_page.dart';
import 'package:test_app/model/Book.dart';
import 'package:test_app/pages/formal/book_details_page_formal.dart';
import 'package:test_app/utils/utils.dart';
import 'package:test_app/widgets/BookCard.dart';
import 'package:test_app/widgets/book_card_compact.dart';
import 'package:test_app/widgets/book_card_minimalistic.dart';


class SearchBookPageNew extends StatefulWidget {

  @override
  _SearchBookStateNew createState() => new _SearchBookStateNew();
}

class _SearchBookStateNew extends AbstractSearchBookState<SearchBookPageNew> {

  @override
  Widget build(BuildContext context) {
    const textStyle = const TextStyle(
      fontSize: 35.0,
      fontFamily: 'Butler',
      fontWeight: FontWeight.w400
    );
    return new Scaffold(
      key: scaffoldKey,
      body: new CustomScrollView(
        slivers: <Widget>[
          new SliverAppBar(
            forceElevated: true,
            backgroundColor: Colors.white,
            elevation: 1.0,
            iconTheme: new IconThemeData(color: Colors.black),
          ),
          new SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: new SliverToBoxAdapter(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new SizedBox(height: 8.0,),
                  new Text("Search for Books", style: textStyle,),
                  new SizedBox(height: 16.0),
                  new Card(
                      elevation: 4.0,
                      child: new Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new TextField(
                          decoration: new InputDecoration(
                              hintText: "What books did your read?",
                              prefixIcon: new Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Icon(Icons.search),
                              ),
                              border: InputBorder.none
                          ),
                          onChanged: (string) => (subject.add(string)),
                        ),
                      )
                  ),
                  new SizedBox(height: 16.0,),
                ],
              ),
            ),
          ),
          isLoading? new SliverToBoxAdapter(child: new Center(child: new CircularProgressIndicator()),): new SliverToBoxAdapter(),
          new SliverList(delegate: new SliverChildBuilderDelegate((BuildContext context, int index){
            return new BookCardCompact(items[index], onClick: (){
              Navigator.of(context).push(
                  new FadeRoute(
                    builder: (BuildContext context) => new BookDetailsPageFormal(items[index]),
                    settings: new RouteSettings(name: '/book_detais_formal', isInitialRoute: false),
                  ));
            },);
          },
          childCount: items.length)
          )
        ],
      ),
    );
  }
}

