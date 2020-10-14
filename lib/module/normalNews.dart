import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/const.dart';
import 'package:news_app/model/news.dart';
import 'package:news_app/module/newsListner.dart';
import 'package:news_app/module/shadowText.dart';
import 'package:news_app/res/remaningTime.dart';

class NormalNews extends StatefulWidget {
  final NewsClickListener newsClickListener;
  final News news; 
  final Color secondColor;
  final TabType tabType;
  NormalNews({Key key,@required this.newsClickListener,@required this.news, this.secondColor,@required this.tabType}) : super(key: key);

  @override
  _NormalNewsState createState() => _NormalNewsState();
}

class _NormalNewsState extends State<NormalNews> {
  String fontFamily = "Abhaya";
  double _width = 0.0;

  @override
  void initState() { 
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    setState(() {
      _width = MediaQuery.of(context).size.width;
    });
    return Padding(
      padding: const EdgeInsets.only(left:10.0,right:10.0,bottom: 20),
      child: GestureDetector(
        onTap: (){
          if(widget.tabType == TabType.News){
            widget.newsClickListener.clickedNews(widget.news);
          }else{
            widget.newsClickListener.clickedArticle(widget.news);
          }
        },
        child: Container(
          height: 100,
          width: _width-6,
          child: Stack(
            children: <Widget>[
              Container(
                height: 100,
                width: _width-6,
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 100,
                      width:125,
                      decoration: BoxDecoration(
                        image:DecorationImage(
                          image: CachedNetworkImageProvider(widget.news.imgUrl[0]),
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
                            Container(
                              width: _width-160,
                              child: Text(
                                 widget.news.titleSinhala,
                                style:TextStyle(
                                  color:AppData.isDark == 1?  AppData.WHITE : AppData.BLACK,
                                  fontSize: 18,
                                  fontFamily: fontFamily,
                                  fontWeight: FontWeight.w700
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              // color: Colors.amber,
                              child: Text(
                                widget.news.contentSinhala.trim(),
                                style:TextStyle(
                                  color:AppData.isDark == 1?  AppData.WHITE : AppData.BLACK,
                                  fontSize: 13,
                                  fontFamily: fontFamily,
                                  height: 1.3,
                                  fontWeight: FontWeight.w500
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  // width: _width-6,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "Read more...",
                                      style:TextStyle(
                                        color: widget.secondColor,
                                        fontSize: 12,
                                        fontFamily: "Lato",
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                                Container(
                                  // width: (_width-6)/2,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: ShadowText(
                                      TimeCalculator.timeDifferentCalculator(widget.news.date),
                                      style:TextStyle(
                                        color: widget.secondColor,
                                        fontSize: 12,
                                        fontFamily: "Lato",
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    )  
                  ],
                ),
              ),

              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right:3.0,top:3.0),
                  child: GestureDetector(
                    onTap: (){
                      if(widget.tabType == TabType.News){
                        widget.newsClickListener.savedNews(widget.news);
                      }
                      else{
                        widget.newsClickListener.savedArticle(widget.news);
                      }
                    },
                    child: Container(
                      child: Icon(
                        widget.news.isSaved ==0 ? 
                          Icons.bookmark_border :
                          Icons.bookmark,
                        color:AppData.ALLCOLOR,
                      ),  
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}