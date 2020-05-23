import 'package:flutter/material.dart';
import 'package:news_app/const.dart';
import 'package:news_app/model/news.dart';
import 'package:news_app/module/newsListner.dart';

class TopNews extends StatefulWidget {
  final NewsClickListner newsClickListner;
  final News news; 
  final Color secondColor;
  TopNews({Key key, this.newsClickListner, this.news, this.secondColor}) : super(key: key);

  @override
  _TopNewsState createState() => _TopNewsState();
}

class _TopNewsState extends State<TopNews> {
  double _width = 0.0;
  @override
  Widget build(BuildContext context) {

    setState(() {
      _width = MediaQuery.of(context).size.width;
    });
    return //Top news
      Container(
        height:250,
        width: _width,
        child: Stack(
          children: <Widget>[
            Container(
              height:250,
              width: _width,
              padding: EdgeInsets.all(3),
              child: Image.network(
                widget.news.imgUrl,
                fit: BoxFit.cover,
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(left:3,right:3),
                child: Container(
                  height:50,
                  width: _width-6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppData.BLACK.withOpacity(0.8), Color.fromRGBO(255, 255, 255, 0.0)]
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal:10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.news.titleEnglish,
                          style:TextStyle(
                            color: AppData.WHITE,
                            fontSize: 20,
                            fontFamily: "lato",
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  }
}