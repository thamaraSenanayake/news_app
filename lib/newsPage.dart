import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:news_app/const.dart';
import 'package:news_app/fullPageNews.dart';
import 'package:news_app/homePageListner.dart';
import 'package:news_app/model/news.dart';
import 'package:news_app/module/newsListner.dart';
import 'package:news_app/module/normalNews.dart';
import 'package:news_app/module/topNews.dart';

import 'database/sqlLitedatabase.dart';

class NewsPage extends StatefulWidget {
  final HomePageListner homePageActivity;
  NewsPage({Key key, this.homePageActivity}) : super(key: key);

  @override
  NewsPageState createState() => NewsPageState();
}

class NewsPageState extends State<NewsPage>  implements NewsClickListner{
  double _height = 0.0;
  double _width = 0.0;
  List<News> topNewsList =[];
  List<Widget> topNewsWidgetAll = [];
  List<Widget> topNewsWidgetLocal = [];
  List<Widget> topNewsWidgetForign = [];
  List<Widget> topNewsWidgetSports = [];
  List<Widget> topNewsWidgetWeather = [];

  List<News> normalNews =[];
  List<Widget> normalNewsWidgetAll =[];
  List<Widget> normalNewsWidgetLocal = [];
  List<Widget> normalNewsWidgetForign = [];
  List<Widget> normalNewsWidgetSports = [];
  List<Widget> normalNewsWidgetWeather = [];

  ScrollController _controller;

  String mainTitle = "All News";
  Color mainTitleColor = AppData.ALLCOLOR;
  String nextTitle = "Local";
  Color nextTitleColor = AppData.LOCALCOLOR;
  int currentNewsTab = 0;

  double _newsTabPostion = 0.0;


  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    News topNewsLoacal = News(
      titleEnglish: "top news Title local 1",
      contentEnglish: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
      imgUrl:["https://cdn.newsfirst.lk/english-uploads/2020/05/13b23a13-97cc2493-f18fe9cb-cbsl_850x460_acf_cropped_850x460_acf_cropped.jpg"],
      type: NewsType.Local
    );

    News news = News(
      titleEnglish: "Title local 1",
      contentEnglish: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
      imgUrl:["https://ichef.bbci.co.uk/news/1024/branded_news/33D6/production/_108207231_f63d6143-fff6-48af-a4a2-071b0de87628.gif"],
      type: NewsType.Local
    );

    News news1 = News(
      titleEnglish: "Title local 2",
      contentEnglish: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
      imgUrl:["https://img.youtube.com/vi/IC4BpAJzXTI/0.jpg"],
      type: NewsType.Local
    );

    News news2 = News(
      titleEnglish: "Title forign 1",
      contentEnglish: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
      imgUrl:["https://drop.ndtv.com/albums/NEWS/Newspaper_Headl_637076707145778984/637076707168904594.jpeg"],
      type: NewsType.Forign
    );

    News news3 = News(
      titleEnglish: "Title forign 2",
      contentEnglish: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
      imgUrl:["https://iotcdn.oss-ap-southeast-1.aliyuncs.com/news.jpg"],
      type: NewsType.Forign
    );

    News newstopForign = News(
      titleEnglish: "Title forign 2",
      contentEnglish: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
      imgUrl:["https://iotcdn.oss-ap-southeast-1.aliyuncs.com/news.jpg"],
      type: NewsType.Forign
    );

    News news4 = News(
      titleEnglish: "Title sports 2",
      contentEnglish: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
      imgUrl:["https://iotcdn.oss-ap-southeast-1.aliyuncs.com/news.jpg"],
      type:NewsType.Sport
    );

    News news5 = News(
      titleEnglish: "Title sports 2",
      contentEnglish: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
      imgUrl:["https://iotcdn.oss-ap-southeast-1.aliyuncs.com/news.jpg"],
      type:NewsType.Sport
    );

    News topSports = News(
      titleEnglish: "Title sports 2",
      contentEnglish: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
      imgUrl:["https://iotcdn.oss-ap-southeast-1.aliyuncs.com/news.jpg"],
      type:NewsType.Sport
    );

     News news6 = News(
      titleEnglish: "Title Whether 2",
      contentEnglish: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
      imgUrl:["https://iotcdn.oss-ap-southeast-1.aliyuncs.com/news.jpg"],
      type: NewsType.Whether
    );

    News news7 = News(
      titleEnglish: "Title Whether 2",
      contentEnglish: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
      imgUrl:["https://iotcdn.oss-ap-southeast-1.aliyuncs.com/news.jpg"],
      type: NewsType.Whether
    );

    News topWhether = News(
      titleEnglish: "Title Whether 2",
      contentEnglish: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
      imgUrl:["https://iotcdn.oss-ap-southeast-1.aliyuncs.com/news.jpg"],
      type: NewsType.Whether
    );

    News topNews = News(
      titleEnglish: "top news Title 2",
      contentEnglish: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
      imgUrl:["https://ichef.bbci.co.uk/news/490/cpsprodpb/14C2E/production/_112383058_mediaitem112383057.jpg"],
      type:NewsType.AllTop
    );

    print("init news");
    normalNews.add(news);
    normalNews.add(news1);
    normalNews.add(news2);
    normalNews.add(news3);
    normalNews.add(news4);
    normalNews.add(news5);
    normalNews.add(news6);
    normalNews.add(news7);
    
    topNewsList.add(topNewsLoacal);
    topNewsList.add(topNews);
    topNewsList.add(newstopForign);
    topNewsList.add(topSports);
    topNewsList.add(topWhether);
    _topNewsLoad();
    _normalNewsLoad();
  }

  loadNews(){
    // normalNews = await DBProvider.db.viewNews(LanguageList.English);
    // _topNewsLoad();
    // _normalNewsLoad();
  }

  _setTitle(int pageNum){
    if(pageNum == 0){
      setState(() {
        mainTitle = "All News";
        nextTitle= "Local";
        mainTitleColor = AppData.ALLCOLOR;
        nextTitleColor = AppData.LOCALCOLOR;
      });
    }
    else if(pageNum == 1){
      setState(() {
        mainTitle = "Local News";
        nextTitle= "Forign";
        mainTitleColor = AppData.LOCALCOLOR;
        nextTitleColor = AppData.FORIGNCOLOR;
      });
    }
    else if(pageNum == 2){
      setState(() {
        mainTitle = "Forign News";
        nextTitle= "Sport";
        mainTitleColor = AppData.FORIGNCOLOR;
        nextTitleColor = AppData.SPORTCOLOR;
      });
    }
    else if(pageNum == 3){
      setState(() {
        mainTitle = "Sport News";
        nextTitle= "Weather";
        mainTitleColor = AppData.SPORTCOLOR;
        nextTitleColor = AppData.WEATHERCOLOR;
      });
    }
    else if(pageNum == 4){
      setState(() {
        mainTitle = "Weather News";
        nextTitle= "";
        mainTitleColor = AppData.WEATHERCOLOR;
        nextTitleColor = AppData.WEATHERCOLOR;
      });
    }
  }

  //news scroll listner
  _scrollListener() {
    //news scroll to next tab
    if (_controller.position.userScrollDirection == ScrollDirection.reverse) {
      if (_controller.position.pixels > _newsTabPostion + 40 && _newsTabPostion < _width*4) {
        _next();
      }
    }
    //news scroll to previous step
    else if (_controller.position.userScrollDirection == ScrollDirection.forward) {
      if (_controller.position.pixels < _newsTabPostion - 40 && _newsTabPostion > 0) {
        _back();
      }
    }
  }

  _next(){
      _controller.animateTo(_width + _newsTabPostion,duration: Duration(milliseconds: 500), curve: Curves.linear);
      _newsTabPostion += _width;
      _setTitle(++currentNewsTab);
    
  }

  _back(){
      _controller.animateTo(_newsTabPostion - _width,duration: Duration(milliseconds: 500), curve: Curves.linear);
      _newsTabPostion -= _width;
      _setTitle(--currentNewsTab);
    if (_controller.position.pixels < _newsTabPostion - 40 && _newsTabPostion > 0) {
    }
  }

  _topNewsLoad(){
    List<Widget> topNewsWidgetTemp =[];
    List<Widget> topNewsWidgetLocalTemp = [];
    List<Widget> topNewsWidgetForignTemp = [];
    List<Widget> topNewsWidgetSportsTemp = [];
    List<Widget> topNewsWidgetWeatherTemp = [];

    for (var item in topNewsList) {

      if(item.type == NewsType.AllTop){
        topNewsWidgetTemp.add(
          TopNews(
            news: item,
            newsClickListner: this,
            secondColor: AppData.ALLCOLOR,
          )
        );
      }
      else if(item.type == NewsType.Local){
        topNewsWidgetLocalTemp.add(
          TopNews(
            news: item,
            newsClickListner: this,
            secondColor: AppData.LOCALCOLOR,
          )
        );
      }
      else if(item.type == NewsType.Forign){
        topNewsWidgetForignTemp.add(
          TopNews(
            news: item,
            newsClickListner: this,
            secondColor: AppData.FORIGNCOLOR,
          )
        );
      }

      else if(item.type == NewsType.Sport){
        topNewsWidgetSportsTemp.add(
          TopNews(
            news: item,
            newsClickListner: this,
            secondColor: AppData.SPORTCOLOR,
          )
        );
      }

      else if(item.type == NewsType.Whether){
        topNewsWidgetWeatherTemp.add(
          TopNews(
            news: item,
            newsClickListner: this,
            secondColor: AppData.WEATHERCOLOR,
          )
        );
      }
      
    }

    setState(() {
      topNewsWidgetAll = topNewsWidgetTemp;
      topNewsWidgetLocal = topNewsWidgetLocalTemp;
      topNewsWidgetForign = topNewsWidgetForignTemp;
      topNewsWidgetSports = topNewsWidgetSportsTemp;
      topNewsWidgetWeather = topNewsWidgetWeatherTemp;
    });

  }

  _normalNewsLoad(){
    List<Widget> normalNewsWidgetAllTemp = [];
    List<Widget> normalNewsWidgetLocalTemp = [];
    List<Widget> normalNewsWidgetForignTemp = [];
    List<Widget> normalNewsWidgetSportsTemp = [];
    List<Widget> normalNewsWidgetWeatherTemp = [];

    for (var item in normalNews) {
      normalNewsWidgetAllTemp.add(
        NormalNews(
          news: item,
          newsClickListner: this,
          secondColor: AppData.ALLCOLOR,
        )
      );
      if(item.type == NewsType.Local){
        normalNewsWidgetLocalTemp.add(
          NormalNews(
            news: item,
            newsClickListner: this,
            secondColor: AppData.LOCALCOLOR,
          )
        );
      }      
      else if(item.type == NewsType.Forign){
        normalNewsWidgetForignTemp.add(
          NormalNews(
            news: item,
            newsClickListner: this,
            secondColor: AppData.FORIGNCOLOR,
          )
        );
      }
      else if(item.type == NewsType.Sport){
        normalNewsWidgetSportsTemp.add(
          NormalNews(
            news: item,
            newsClickListner: this,
            secondColor: AppData.SPORTCOLOR,
          )
        );
      }
      else if(item.type == NewsType.Whether){
        normalNewsWidgetWeatherTemp.add(
          NormalNews(
            news: item,
            newsClickListner: this,
            secondColor: AppData.WEATHERCOLOR,
          )
        );
      }
    }

    setState(() {
      normalNewsWidgetAll = normalNewsWidgetAllTemp;
      normalNewsWidgetLocal = normalNewsWidgetLocalTemp;
      normalNewsWidgetForign = normalNewsWidgetForignTemp;
      normalNewsWidgetSports = normalNewsWidgetSportsTemp;
      normalNewsWidgetWeather = normalNewsWidgetWeatherTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _height = MediaQuery.of(context).size.height;
      _width = MediaQuery.of(context).size.width;
    });

    return Container(
      height: _height,
      width: _width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xffFFFFFF), Color.fromRGBO(255, 255, 255, 0.8)]
        ),
      ),
      child: Column(
        children: <Widget>[

          //top bar
          Container(
            height: 100,
            width: _width,
            child: Stack(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left:8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: (){
                        widget.homePageActivity.homePageActivityClick(HomePageActivity.MenuOpen);
                      },
                      child: Card(
                        child: Container(
                          height: 50,
                          width:50,
                          
                          child:Icon(
                            Icons.menu,
                            color: AppData.BLACK,
                          ),
                          decoration: BoxDecoration(
                            color: AppData.WHITE,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                nextTitle !=""? Padding(
                  padding: const EdgeInsets.only(right:8.0,top:20.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child:GestureDetector(
                      onTap: (){
                        _next();
                      },
                      child: Container(
                        width:105,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              nextTitle,
                              style:TextStyle(
                                color: mainTitleColor,
                                fontSize: 18,
                                fontFamily: "lato",
                              )
                            ),
                            SizedBox(
                              width:10
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: AppData.BLACK,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ):Container(),

                Padding(
                  padding: EdgeInsets.only(bottom:15.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      mainTitle,
                      style:TextStyle(
                        color: mainTitleColor,
                        fontSize: 28,
                        fontFamily: "lato",
                        fontWeight: FontWeight.w600
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )

              ],
            ),
            decoration: BoxDecoration(
              // color: AppData.BLACK,
              boxShadow: [
                // BoxShadow(
                //   color: Colors.grey,
                //   blurRadius: 2.0,
                //   spreadRadius: 2.0, 
                //   offset: Offset(
                //     1.0,
                //     2.0,
                //   ),
                // )
              ],
            ),
          ),

          //news container
          Container(
            width: _width,
            height: _height-100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              controller: _controller,
              children: <Widget>[
                
                //all news 
                Container(
                  width: _width,
                  height: _height-100,

                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop:true,
                    child: ListView(
                      children: <Widget>[
                        Column(
                          children: topNewsWidgetAll,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: normalNewsWidgetAll
                        )
                      ]
                    ),
                  )
                ),
                

                //local
                Container(
                  width: _width,
                  height: _height-100,

                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop:true,
                    child: ListView(
                      children: <Widget>[
                        Column(
                          children: topNewsWidgetLocal
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: normalNewsWidgetLocal
                        )
                      ]
                    ),
                  )
                ),

                //forign
                Container(
                  width: _width,
                  height: _height-100,

                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop:true,
                    child: ListView(
                      children: <Widget>[
                        Column(
                          children: topNewsWidgetForign
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: normalNewsWidgetForign
                        )
                      ]
                    ),
                  )
                ),

                //sports
                Container(
                  width: _width,
                  height: _height-100,

                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop:true,
                    child: ListView(
                      children: <Widget>[
                        Column(
                          children: topNewsWidgetSports
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: normalNewsWidgetSports
                        )
                      ]
                    ),
                  )
                ),

                //weather
                Container(
                  width: _width,
                  height: _height-100,

                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop:true,
                    child: ListView(
                      children: <Widget>[
                        Column(
                          children: topNewsWidgetWeather
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: normalNewsWidgetWeather
                        )
                      ]
                    ),
                  )
                ),
                      

                      


              ],
            ),
          )

        ],
      ),
    );
  }

  @override
  clickedNews(News news) {
    // print()
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullPageNews(news: news,)
      ),
    );
  }
}