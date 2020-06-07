import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/const.dart';
import 'package:news_app/model/news.dart';
import 'package:news_app/module/newsListner.dart';
import 'package:news_app/res/remaningTime.dart';

class NormalNews extends StatefulWidget {
  final NewsClickListner newsClickListner;
  final News news; 
  final Color secondColor;
  final TabType tabType;
  NormalNews({Key key,@required this.newsClickListner,@required this.news, this.secondColor,@required this.tabType}) : super(key: key);

  @override
  _NormalNewsState createState() => _NormalNewsState();
}

class _NormalNewsState extends State<NormalNews> {
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
  double _width = 0.0;
  @override
  Widget build(BuildContext context) {
    setState(() {
      _width = MediaQuery.of(context).size.width;
      //print(TimeCalculater.timeDifferentCalculator("2020-06-02 14:08:57.495216"));
    });
    return Padding(
      padding: const EdgeInsets.only(left:3.0,right:3.0,bottom: 3),
      child: GestureDetector(
        onTap: (){
          if(widget.tabType == TabType.News){
            widget.newsClickListner.clickedNews(widget.news);
          }else{
            widget.newsClickListner.clickedArticle(widget.news);
          }
        },
        child: Card(
          child: Container(
            height: 100,
            width: _width-6,
            child: Stack(
              children: <Widget>[
                Container(
                  height: 100,
                  width: _width-6,
                  decoration: BoxDecoration(
                    gradient: AppData.isDark == 1? 
                      LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppData.DARKGRAY, AppData.DARKGRAY]
                      )
                    
                      :LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xffFFFFFF), Color.fromRGBO(255, 255, 255, 0.8)]
                      ),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.grey[200],
                    //     blurRadius: 2.0,
                    //     spreadRadius: 2.0, 
                    //     offset: Offset(
                    //       1.0,
                    //       2.0,
                    //     ),
                    //   )
                    // ],
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
                              Text(
                                AppData.language == LanguageList.Sinhala?
                                 widget.news.titleSinhala:
                                AppData.language == LanguageList.English?
                                  widget.news.titleEnglish:
                                widget.news.titleTamil,
                                style:TextStyle(
                                  color: widget.secondColor,
                                  fontSize: 16,
                                  fontFamily: fontFamily,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                              Text(
                                AppData.language == LanguageList.Sinhala?
                                 widget.news.contentSinhala:
                                AppData.language == LanguageList.English?
                                  widget.news.contentEnglish:
                                widget.news.contentTamil,
                                style:TextStyle(
                                  color:AppData.isDark == 1?  AppData.WHITE : AppData.BLACK,
                                  fontSize: 13,
                                  fontFamily: fontFamily,
                                  height: 1.3,
                                  fontWeight: FontWeight.w500
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.justify,
                              ),
                              Container(
                                width: _width-6,
                                child: Text(
                                  TimeCalculater.timeDifferentCalculator(widget.news.date),
                                  style:TextStyle(
                                    color: widget.secondColor,
                                    fontSize: 12,
                                    fontFamily: "Lato",
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
      ),
    );
  }
}