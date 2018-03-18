import 'package:flutter/material.dart';


class BookCardCompact extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Row(
        children: <Widget>[
          new Image.asset("assets/test_img.jpg"),
          new Expanded(
            child: new Padding(
              padding: const EdgeInsets.only(top : 8.0, left: 24.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text("Life 3.0", style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 20.0),),
                  new SizedBox(height: 4.0,),
                  new Text("Elon Musk"),
                  new SizedBox(height: 8.0,),
                  new Text("Some great description about the"),
                //  new Divider(height: 16.0, color: Colors.black),
                  new Divider(color: Colors.black,),
                  new Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new SizedBox(height: 24.0, width: 24.0, child: new IconButton(icon: new Icon(Icons.star), onPressed: (){}, padding: const EdgeInsets.all(0.0), )),
                      new SizedBox(height: 24.0, width: 24.0, child: new IconButton(icon: new Icon(Icons.star), onPressed: (){}, padding: const EdgeInsets.all(0.0), )),
                      new SizedBox(height: 24.0, width: 24.0, child: new IconButton(icon: new Icon(Icons.star), onPressed: (){}, padding: const EdgeInsets.all(0.0), )),
                      new SizedBox(height: 24.0, width: 24.0, child: new IconButton(icon: new Icon(Icons.star), onPressed: (){}, padding: const EdgeInsets.all(0.0), )),
                      new SizedBox(height: 24.0, width: 24.0, child: new IconButton(icon: new Icon(Icons.star), onPressed: (){}, padding: const EdgeInsets.all(0.0), )),
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

}