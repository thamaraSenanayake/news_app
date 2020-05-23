import 'package:flutter/material.dart';
import 'package:news_app/const.dart';
import 'package:news_app/model/news.dart';
import 'package:news_app/module/newsListner.dart';

class NormalNews extends StatefulWidget {
  final NewsClickListner newsClickListner;
  final News news; 
  final Color secondColor;
  NormalNews({Key key, this.newsClickListner, this.news, this.secondColor}) : super(key: key);

  @override
  _NormalNewsState createState() => _NormalNewsState();
}

class _NormalNewsState extends State<NormalNews> {
  double _width = 0.0;
  @override
  Widget build(BuildContext context) {
    setState(() {
      _width = MediaQuery.of(context).size.width;
    });
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        child: Container(
          height: 100,
          width: _width-6,
          decoration: BoxDecoration(
            // color: Colors.red,
            borderRadius: BorderRadius.circular(3)
          ),
          child: Row(
            children: <Widget>[
              Container(
                height: 100,
                width:125,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(3),
                    bottomLeft:Radius.circular(3),
                  ),
                  image:DecorationImage(
                    image: NetworkImage(widget.news.imgUrl),
                    fit: BoxFit.cover
                  ),
                  color: Colors.blue, 
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        widget.news.titleEnglish,
                        style:TextStyle(
                          color: AppData.BLACK,
                          fontSize: 15,
                          fontFamily: "lato",
                        ),
                      ),
                      Text(
                        widget.news.contentEnglish,
                        style:TextStyle(
                          color: AppData.BLACK,
                          fontSize: 13,
                          fontFamily: "lato",
                          height: 1.3
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                      ),
                      Container(
                        width: _width-6,
                        child: Text(
                          "1 S ago",
                          style:TextStyle(
                            color: widget.secondColor,
                            fontSize: 12,
                            fontFamily: "lato",
                          ),
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )
              )  
            ],
          ),

        ),
      ),
    );
  }
}