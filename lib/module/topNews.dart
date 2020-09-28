import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/const.dart';
import 'package:news_app/model/news.dart';
import 'package:news_app/module/newsListner.dart';
import 'package:news_app/module/shadowText.dart';
import 'package:news_app/res/remaningTime.dart';

class TopNews extends StatefulWidget {
  final NewsClickListener newsClickListener;
  final News news; 
  final Color secondColor;
  final TabType tabType;
  TopNews({Key key,@required this.newsClickListener,@required this.news, this.secondColor,@required this.tabType}) : super(key: key);

  @override
  _TopNewsState createState() => _TopNewsState();
}

class _TopNewsState extends State<TopNews> {
  double _width = 0.0;
  String fontFamily = "Abhaya";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    setState(() {
      _width = MediaQuery.of(context).size.width;
    });
    return //Top news
      GestureDetector(
        onTap: (){
          if(widget.tabType == TabType.News){
            widget.newsClickListener.clickedNews(widget.news);
          }else{
            widget.newsClickListener.clickedArticle(widget.news);
          }
        },
        child: Padding(
          padding:  EdgeInsets.only(bottom: widget.tabType == TabType.News ?0.0:20.0),
          child: Container(
            height:250,
            width: _width,
            child: Stack(
              children: <Widget>[
                Container(
                  height:250,
                  width: _width,
                  padding: EdgeInsets.symmetric(vertical: 0,horizontal:5,),
                  child: CachedNetworkImage(
                    imageUrl:widget.news.imgUrl[0],
                    fit: BoxFit.cover,
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(left:5,right:5),
                    child: Container(
                      // height:250,
                      width: _width,
                      color: AppData.BLACK.withOpacity(0.4),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0,),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              widget.news.titleSinhala,
                              style:TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontFamily: fontFamily,
                                fontWeight: FontWeight.w700
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            Container(
                              // width: _width-6,
                              // height:250,
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: ShadowText(
                                  TimeCalculator.timeDifferentCalculator(widget.news.date),
                                  style:TextStyle(
                                    color: AppData.ALLCOLOR,
                                    fontSize: 13,
                                    fontFamily: "lato",
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                          widget.news.isSaved == 0 ? 
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