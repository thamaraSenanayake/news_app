import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/const.dart';
import 'package:news_app/model/news.dart';
import 'package:news_app/module/newsListner.dart';
import 'package:news_app/res/remaningTime.dart';

class TopNews extends StatefulWidget {
  final NewsClickListner newsClickListner;
  final News news; 
  final Color secondColor;
  final TabType tabType;
  TopNews({Key key,@required this.newsClickListner,@required this.news, this.secondColor,@required this.tabType}) : super(key: key);

  @override
  _TopNewsState createState() => _TopNewsState();
}

class _TopNewsState extends State<TopNews> {
  double _width = 0.0;
  String fontFamily = "Lato";

  @override
  void initState() {
    super.initState();
    if(AppData.language == LanguageList.Sinhala){
      fontFamily = "Abhaya";
    }
    else if(AppData.language == LanguageList.Tamil){
      fontFamily = "HindMadurai";
    }
    else{
      fontFamily = "Lato";
    }
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
            widget.newsClickListner.clickedNews(widget.news);
          }else{
            widget.newsClickListner.clickedArticle(widget.news);
          }
        },
        child: Container(
          height:250,
          width: _width,
          child: Stack(
            children: <Widget>[
              Container(
                height:250,
                width: _width,
                padding: EdgeInsets.all(3),
                child: CachedNetworkImage(
                  imageUrl:widget.news.imgUrl[0],
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
                            AppData.language == LanguageList.Sinhala?
                              widget.news.titleSinhala:
                            AppData.language == LanguageList.English?
                              widget.news.titleEnglish:
                            widget.news.titleTamil,
                            style:TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: fontFamily,
                              fontWeight: FontWeight.w600
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          Container(
                            width: _width-6,
                            child: Text(
                              TimeCalculater.timeDifferentCalculator(widget.news.date),
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

              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right:3.0,top:3.0),
                  child: GestureDetector(
                    onTap: (){
                      if(widget.tabType == TabType.News){
                        widget.newsClickListner.savedNews(widget.news);
                      }
                      else{
                        widget.newsClickListner.savedArticle(widget.news);
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
      );
  }
}