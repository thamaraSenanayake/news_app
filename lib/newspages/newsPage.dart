import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:news_app/const.dart';
import 'package:news_app/database/database.dart';
import 'package:news_app/database/sqlLitedatabase.dart';
import 'package:news_app/dropDown/dropDownListner.dart';
import 'package:news_app/newspages/fullPageArticle.dart';
import 'package:news_app/newspages/fullPageNews.dart';
import 'package:news_app/homePageListner.dart';
import 'package:news_app/model/news.dart';
import 'package:news_app/module/newsListner.dart';
import 'package:news_app/module/normalNews.dart';
import 'package:news_app/module/topNews.dart';
import 'package:news_app/res/addmob.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';



class NewsPage extends StatefulWidget {
  final HomePageListner homePageActivity;
  NewsPage({Key key, this.homePageActivity}) : super(key: key);

  @override
  NewsPageState createState() => NewsPageState();
}

class NewsPageState extends State<NewsPage>  implements NewsClickListner,DropDownListner{
  double _height = 0.0;
  double _width = 0.0;
  List<News> topNewsList =[];
  List<Widget> topNewsWidgetAll = [];


  List<News> normalNews =[];
  List<Widget> normalNewsWidgetAll =[];
  List<Widget> normalNewsWidgetLocal = [];
  List<Widget> normalNewsWidgetForign = [];
  List<Widget> normalNewsWidgetSports = [];
  List<Widget> normalNewsWidgetWeather = [];

  List<News> newNormalNews =[];
  List<Widget> newNormalNewsWidgetAll =[];
  List<Widget> newNormalNewsWidgetLocal = [];
  List<Widget> newNormalNewsWidgetForign = [];
  List<Widget> newNormalNewsWidgetSports = [];
  List<Widget> newNormalNewsWidgetWeather = [];

  List<News> articleList =[];
  List<Widget> articleWidget =[];

  bool _isloaded = false;

  ScrollController _controller;

  String mainTitle = "News";
  String nextTitle = "Articales";
  int currentNewsTab = 0;
  bool _showToster = false;
  bool _goForwed = true;
  String _tosterMsg = "New News";

  double _newsTabPostion = 0.0;
  Database database = Database();
  final addMobSerivce = AddMobSerivce();
  var rng = new Random();
  String dateDisplay = "";
  final now = DateTime.now();
  String today = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String yesterday = '';
  String newsDate="";



  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    _getLiveUpdate();
    Admob.initialize(addMobSerivce.getAppId());
    yesterday =  DateFormat("yyyy-MM-dd").format(DateTime(now.year, now.month, now.day - 1));
    print(today);
    print(yesterday);

  }

  reloadNews(){
    _topNewsLoad();
    _normalNewsLoad(normalNews,true);
    _loadArticle();
    
    setState(() {
      newNormalNews =[];
      newNormalNewsWidgetAll =[];
      newNormalNewsWidgetLocal = [];
      newNormalNewsWidgetForign = [];
      newNormalNewsWidgetSports = [];
      newNormalNewsWidgetWeather = [];
    });
  }

  loadNews() async{
    normalNews = await DBProvider.db.viewNews();
    topNewsList = await DBProvider.db.viewHotNews();
    articleList = await DBProvider.db.viewArticale();
    
    _topNewsLoad();
    _normalNewsLoad(normalNews,true);
    _loadArticle();
    DBProvider.db.deleteOldNews();
    _isloaded = true;
  }

  _loadArticle(){

    List<Widget> articleWidgetTemp = [];
    print(articleList.length);

    for(var item in articleList){
      if(articleList.indexOf(item)==0){
        articleWidgetTemp.add(
          TopNews(
            tabType: TabType.Article,
            news: item,
            newsClickListner: this,
            secondColor: AppData.ALLCOLOR,
          )
        );
      }else{
        articleWidgetTemp.add( 
          NormalNews(
            news: item,
            newsClickListner: this,
            secondColor: AppData.ALLCOLOR,
            tabType: TabType.Article,
          )
        );
      }
    }

    setState(() {
      articleWidget = articleWidgetTemp;
    });
  }

  _setTitle(int pageNum){
    print(pageNum);
    if(pageNum == 0){
      setState(() {
        mainTitle = "News";
        nextTitle= "Articles";
        _goForwed = true;
      });
    }
    else if(pageNum == 1){
      setState(() {
        mainTitle = "Articles";
        nextTitle= "News";
        _goForwed = false;
      });        
    }
  }

  //news scroll listner
  _scrollListener() {
    //news scroll to next tab
    if (_controller.position.userScrollDirection == ScrollDirection.reverse) {
      if (_controller.position.pixels > _newsTabPostion + 40 && _newsTabPostion < _width) {
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
    setState(() {
      _goForwed =true;
    });
    _setTitle(++currentNewsTab);
    
  }

  _back(){
      _controller.animateTo(_newsTabPostion - _width,duration: Duration(milliseconds: 500), curve: Curves.linear);
      _newsTabPostion -= _width;
      setState(() {
        _goForwed =false;
      });
      _setTitle(--currentNewsTab);
    
  }

  _topNewsLoad(){
    List<Widget> topNewsWidgetTemp =[];

    for (var item in topNewsList) {

      if(item.type == NewsType.Local){
        topNewsWidgetTemp.add(
          TopNews(
            tabType: TabType.News,
            news: item,
            newsClickListner: this,
            secondColor: AppData.ALLCOLOR,
          )
        );
      }
      
    }
    setState(() {
      topNewsWidgetAll = topNewsWidgetTemp;
    });

  }

  _normalNewsLoad(List<News> newsList,bool _isFrirstLoad){
    int addShow = 0;
    List<Widget> normalNewsWidgetAllTemp = [];
    List<Widget> normalNewsWidgetLocalTemp = [];
    List<Widget> normalNewsWidgetForignTemp = [];
    List<Widget> normalNewsWidgetSportsTemp = [];
    List<Widget> normalNewsWidgetWeatherTemp = [];

    if(newsList.length != 0){
      newsDate = newsList[0].date.split(" ")[0];
    }
    else{
      newsDate = today;
    }

    for (var item in newsList) {
      Widget dateWidget = Container();

      if(item.date.split(" ")[0] != newsDate){
        print("======");
        print(newsList.indexOf(item));
        
        if(newsDate == today){
          dateWidget = Container(
            width: _width,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              child: Text(
                "Today",
                style: TextStyle(
                  color: AppData.DARKGRAY
                ),
              ),
            ),
          );
        }
        else if(newsDate == DateTime(now.year, now.month, now.day - 1).toString()){
          dateWidget = Container(
            width: _width,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              child: Text(
                "Yesterday",
                style: TextStyle(
                  color: AppData.DARKGRAY
                ),
              ),
            ),
          );
        }
        else {
          dateWidget = Container(
            // color: Colors.red,
            width: _width,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              child: Text(
                newsDate,
                style: TextStyle(
                  color: AppData.DARKGRAY
                ),
              ),
            ),
          );
        }
        normalNewsWidgetAllTemp.add(dateWidget);
        if(normalNewsWidgetLocalTemp.length > 0){
          normalNewsWidgetAllTemp.add(
            Container(
              width: _width,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                child: Text(
                  "Local news",
                  style: TextStyle(
                    color: AppData.ALLCOLOR,
                    fontFamily: "Lato",
                    fontSize: 17,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
            )
          );
          normalNewsWidgetAllTemp.addAll(normalNewsWidgetLocalTemp);
        }
        
        if(normalNewsWidgetForignTemp.length > 0){
          normalNewsWidgetAllTemp.add(
            Container(
              width: _width,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                child: Text(
                  "Forign news",
                  style: TextStyle(
                    color: AppData.ALLCOLOR,
                    fontFamily: "Lato",
                    fontSize: 17,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
            )
          );
          normalNewsWidgetAllTemp.addAll(normalNewsWidgetForignTemp);
        }
        if(normalNewsWidgetSportsTemp.length > 0){
          normalNewsWidgetAllTemp.add(
            Container(
              width: _width,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                child: Text(
                  "Sports news",
                  style: TextStyle(
                    color: AppData.ALLCOLOR,
                    fontFamily: "Lato",
                    fontSize: 17,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
            )
          );
          normalNewsWidgetAllTemp.addAll(normalNewsWidgetSportsTemp);
        }
        if(normalNewsWidgetWeatherTemp.length > 0){
          normalNewsWidgetAllTemp.add(
            Container(
              width: _width,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                child: Text(
                  "Weather news",
                  style: TextStyle(
                    color: AppData.ALLCOLOR,
                    fontFamily: "Lato",
                    fontSize: 17,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
            )
          );
          normalNewsWidgetAllTemp.addAll(normalNewsWidgetWeatherTemp);
        }

        normalNewsWidgetWeatherTemp = [];
        normalNewsWidgetLocalTemp =[];
        normalNewsWidgetForignTemp = [];
        normalNewsWidgetSportsTemp = [];
        newsDate = item.date.split(" ")[0];
      }
      addShow = rng.nextInt(8);
      // print(addShow);
      

      // normalNewsWidgetAllTemp.add(
      //   NormalNews(
      //     tabType: TabType.News,
      //     news: item,
      //     newsClickListner: this,
      //     secondColor: AppData.ALLCOLOR,
      //   )
      // );
      if(addShow == 7){
        normalNewsWidgetAllTemp.add(
          Column(
            children: <Widget>[
              AdmobBanner(
                adUnitId: addMobSerivce.getBannerAddId(),
                adSize: AdmobBannerSize.FULL_BANNER
              ),
              Text("Advertisment")
            ],
          )
        );
      }
      if(item.type == NewsType.Local){
        // normalNewsWidgetLocalTemp.add(dateWidget);
        normalNewsWidgetLocalTemp.add(
          NormalNews(
            tabType: TabType.News,
            news: item,
            newsClickListner: this,
            secondColor: AppData.ALLCOLOR,
          )
        );

        if(addShow == 1){
          normalNewsWidgetLocalTemp.add(
            AdmobBanner(
              adUnitId: addMobSerivce.getBannerAddId(),
              adSize: AdmobBannerSize.FULL_BANNER
            )
          );
        }
      }      
      else if(item.type == NewsType.Forign){
        // normalNewsWidgetForignTemp.add(dateWidget);
        normalNewsWidgetForignTemp.add(
          NormalNews(
            tabType: TabType.News,
            news: item,
            newsClickListner: this,
            secondColor: AppData.ALLCOLOR,
          )
        );

        if(addShow == 2){
          normalNewsWidgetForignTemp.add(
            AdmobBanner(
              adUnitId: addMobSerivce.getBannerAddId(),
              adSize: AdmobBannerSize.FULL_BANNER
            )
          );
        }
      }
      else if(item.type == NewsType.Sport){
        // normalNewsWidgetSportsTemp.add(dateWidget);
        normalNewsWidgetSportsTemp.add(
          NormalNews(
            tabType: TabType.News,
            news: item,
            newsClickListner: this,
            secondColor: AppData.ALLCOLOR,
          )
        );
        
        if(addShow == 3){
          normalNewsWidgetSportsTemp.add(
            AdmobBanner(
              adUnitId: addMobSerivce.getBannerAddId(),
              adSize: AdmobBannerSize.FULL_BANNER
            )
          );
        }
      }
      else if(item.type == NewsType.Whether){
        // normalNewsWidgetWeatherTemp.add(dateWidget);
        normalNewsWidgetWeatherTemp.add(
          NormalNews(
            tabType: TabType.News,
            news: item,
            newsClickListner: this,
            secondColor: AppData.ALLCOLOR,
          )
        );
        if(addShow == 4){
          normalNewsWidgetWeatherTemp.add(
            AdmobBanner(
              adUnitId: addMobSerivce.getBannerAddId(),
              adSize: AdmobBannerSize.FULL_BANNER
            )
          );
        }
      }


      if(newsList.indexOf(item) == newsList.length - 1){
        print("======");
        print(newsList.indexOf(item));
        
        if(newsDate == today){
          dateWidget = Container(
            width: _width,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              child: Text(
                "Today",
                style: TextStyle(
                  color: AppData.DARKGRAY
                ),
              ),
            ),
          );
        }
        else if(newsDate == DateTime(now.year, now.month, now.day - 1).toString()){
          dateWidget = Container(
            width: _width,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              child: Text(
                "Yesterday",
                style: TextStyle(
                  color: AppData.DARKGRAY
                ),
              ),
            ),
          );
        }
        else {
          dateWidget = Container(
            // color: Colors.red,
            width: _width,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              child: Text(
                newsDate,
                style: TextStyle(
                  color: AppData.DARKGRAY
                ),
              ),
            ),
          );
        }
        normalNewsWidgetAllTemp.add(dateWidget);
        if(normalNewsWidgetLocalTemp.length > 0){
          normalNewsWidgetAllTemp.add(
            Container(
              width: _width,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                child: Text(
                  "Local news",
                  style: TextStyle(
                    color: AppData.ALLCOLOR,
                    fontFamily: "Lato",
                    fontSize: 17,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
            )
          );
          normalNewsWidgetAllTemp.addAll(normalNewsWidgetLocalTemp);
        }
        
        if(normalNewsWidgetForignTemp.length > 0){
          normalNewsWidgetAllTemp.add(
            Container(
              width: _width,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                child: Text(
                  "Forign news",
                  style: TextStyle(
                    color: AppData.ALLCOLOR,
                    fontFamily: "Lato",
                    fontSize: 17,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
            )
          );
          normalNewsWidgetAllTemp.addAll(normalNewsWidgetForignTemp);
        }
        if(normalNewsWidgetSportsTemp.length > 0){
          normalNewsWidgetAllTemp.add(
            Container(
              width: _width,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                child: Text(
                  "Sports news",
                  style: TextStyle(
                    color: AppData.ALLCOLOR,
                    fontFamily: "Lato",
                    fontSize: 17,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
            )
          );
          normalNewsWidgetAllTemp.addAll(normalNewsWidgetSportsTemp);
        }
        if(normalNewsWidgetWeatherTemp.length > 0){
          normalNewsWidgetAllTemp.add(
            Container(
              width: _width,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                child: Text(
                  "Weather news",
                  style: TextStyle(
                    color: AppData.ALLCOLOR,
                    fontFamily: "Lato",
                    fontSize: 17,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
            )
          );
          normalNewsWidgetAllTemp.addAll(normalNewsWidgetWeatherTemp);
        }

        // normalNewsWidgetWeather = [];
        // normalNewsWidgetLocalTemp =[];
        // normalNewsWidgetForign = [];
        // normalNewsWidgetSports = [];
        newsDate = item.date.split(" ")[0];
      }

      

    }

    if(_isFrirstLoad){
      print("add old news");
      setState(() {
        normalNewsWidgetAll = normalNewsWidgetAllTemp;
      });
    }else{
      print("add new news");
      setState(() {
        newNormalNewsWidgetAll = normalNewsWidgetAllTemp;
      });

    }

    
  }

  _getLiveUpdate(){
    CollectionReference reference = database.systemData;
    reference.snapshots().listen((querySnapshot) {
      querySnapshot.documentChanges.forEach((change) {
        if(_isloaded){
          _loadNewNews();
        }
        
      });
    });
  }

  _loadNewNews() async{
    print("load new news");
    List<News> newNews =[];
    //get last added news id 

    int id = await DBProvider.db.getLastNewsId();
    //get normal news
    newNews = await database.readNews(id);

    if(newNews.length != 0){
      await DBProvider.db.addNewsData(newNews);
      _normalNewsLoad(newNews,false);
      _addToster();
      for (var item in newNews) {
        normalNews.insert(0, item);
      }
    }else{
      print("no new news");
    }
    
  }

  _addToster() async{

    //display toster
    setState(() {
      _tosterMsg = "New News";
      _showToster = true;
    });
    await new Future.delayed(const Duration(seconds : 3));

    //after 3 second hide toster
    setState(() {
      _showToster = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _height = MediaQuery.of(context).size.height;
      _width = MediaQuery.of(context).size.width;
      print(AppData.language);
    });

    return Container(
      height: _height,
      width: _width,
      child: Stack(
        children: <Widget>[
          Container(
            height: _height,
            width: _width,
            decoration: BoxDecoration(
              gradient: AppData.isDark == 1? 
                LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppData.BLACK, Color.fromRGBO(0, 0, 0, 0.8)]
                )
              
                :LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xffFFFFFF), Color.fromRGBO(255, 255, 255, 0.8)]
                ),
            ),
            child: Column(
              children: <Widget>[

                //top bar
                Container(
                  height: 80,
                  width: _width,
                  
                  child: Stack(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left:8.0,bottom:5),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: GestureDetector(
                            onTap: (){
                              widget.homePageActivity.homePageActivityClick(HomePageActivity.MenuOpen);
                            },
                            child: Card(
                              child: Container(
                                height: 40,
                                width:40,
                                
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

                      Padding(
                        padding: const EdgeInsets.only(right:8.0,top:30.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child:GestureDetector(
                            onTap: (){
                              if(currentNewsTab == 0){
                                _next();
                              }else{
                                _back();
                              }
                              // Navigator.of(context).push(DropDownOverlay(dropDownListner:this));
                            },
                            child: Container(
                              width:130,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  !_goForwed?Icon(
                                    Icons.arrow_back,
                                    color: AppData.isDark == 1? AppData.WHITE: AppData.BLACK,
                                  ):Container(),
                                  SizedBox(
                                    width:_goForwed?0:10
                                  ),
                                  Text(
                                    nextTitle,
                                    style:TextStyle(
                                      color: AppData.ALLCOLOR,
                                      fontSize: 18,
                                      fontFamily: "lato",
                                    )
                                  ),
                                  SizedBox(
                                    width:_goForwed?10:0
                                  ),
                                  _goForwed?Icon(
                                    Icons.arrow_forward,
                                    color: AppData.isDark == 1? AppData.WHITE: AppData.BLACK,
                                  ):Container()
                                ],
                              ),
                            ),
                          ),
                        )
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom:5.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            mainTitle,
                            style:TextStyle(
                              color: AppData.ALLCOLOR,
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
                    // color: Colors.grey,
                  ),
                ),

                //news container
                Container(
                  width: _width,
                  height: _height-80,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    controller: _controller,
                    children: <Widget>[
                      
                      //all news 
                      Container(
                        width: _width,
                        height: _height-80,

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
                                children: newNormalNewsWidgetAll
                              ),
                              AnimationLimiter(
                                child: Column(
                                  children: AnimationConfiguration.toStaggeredList(
                                  duration: const Duration(milliseconds: 375),
                                    childAnimationBuilder: (widget) => SlideAnimation(
                                      horizontalOffset: 50.0,
                                      child: FadeInAnimation(
                                        child: widget,
                                      ),
                                    ),
                                    children: normalNewsWidgetAll,
                                  ),
                                ),
                              )
                            ]
                          ),
                        )
                      ),

                      //articales
                      Container(
                        width: _width,
                        height: _height-80,
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop:true,
                          child: AnimationLimiter(
                            child: ListView(
                              children: AnimationConfiguration.toStaggeredList(
                                duration: const Duration(milliseconds: 375),
                                childAnimationBuilder: (widget) => SlideAnimation(
                                  horizontalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: widget,
                                  ),
                                ),
                                children: articleWidget
                              ),
                              
                            ),
                          )
                        )
                      ),

                    ],
                  ),
                )

              ],
            ),
          ),

          //toster
          _showToster?
          Positioned(
            top:105,
            right:10,
            child: Container(
              decoration: BoxDecoration(
                color:AppData.ALLCOLOR,
                borderRadius: BorderRadius.circular(10)
              ),
              padding: EdgeInsets.symmetric(vertical:5,horizontal: 10),
              child: Row(
                children: <Widget>[
                  Text(
                    _tosterMsg,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width:5
                  ),
                  Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                    size:20
                  )
                ],
              ),
            )
          ):Container()

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

  @override
  savedNews(News news) async{
    int save =1;

    if(news.isSaved == 1){
      save = 0;
    }
    else{
      save = 1;
    }
    News newNews = News(
      id:news.id,
      imgUrl:news.imgUrl,
      titleSinhala:news.titleSinhala,
      titleTamil:news.titleTamil,
      titleEnglish:news.titleEnglish,
      contentSinhala:news.contentSinhala,
      contentTamil:news.contentTamil,
      contentEnglish:news.contentEnglish,
      date:news.date,
      author:news.author,
      bigNews:news.bigNews,
      isRead:news.isRead,
      type:news.type,
      timeStamp:news.timeStamp,
      isSaved:save,
    );
    await DBProvider.db.saveUnSaveNewsDB(news.id.toString(),save);
    if(normalNews.contains(news)){
      int index = normalNews.indexOf(news);
      normalNews.insert(index, newNews);
      normalNews.removeAt(index+1);
    }
    else if(topNewsList.contains(news)){
      int index = topNewsList.indexOf(news);
      topNewsList.insert(index, newNews);
      topNewsList.removeAt(index+1);
    }
    reloadNews();
  }

  @override
  dropDownClickListner(PageList page) {
    if(page == PageList.AllNews){
      _controller.animateTo(0,duration: Duration(milliseconds: 500), curve: Curves.linear);
      _newsTabPostion = 0;
      currentNewsTab = 0;
      _setTitle(currentNewsTab);
    }
    else if(page == PageList.Local){
      _controller.animateTo(_width,duration: Duration(milliseconds: 500), curve: Curves.linear);
      _newsTabPostion = _width;
      currentNewsTab = 1;
      _setTitle(currentNewsTab);
    }
    else if(page == PageList.Forign){
      _controller.animateTo(_width*2,duration: Duration(milliseconds: 500), curve: Curves.linear);
      _newsTabPostion = _width*2;
      currentNewsTab = 2;
      _setTitle(currentNewsTab);
    }
    else if(page == PageList.Sport){
      _controller.animateTo(_width*3,duration: Duration(milliseconds: 500), curve: Curves.linear);
      _newsTabPostion = _width*3;
      currentNewsTab =3;
      _setTitle(currentNewsTab);
    }
    else if(page == PageList.Whether){
      _controller.animateTo(_width*4,duration: Duration(milliseconds: 500), curve: Curves.linear);
      _newsTabPostion = _width*4;
      currentNewsTab = 4;
      _setTitle(currentNewsTab);
    }
    else if(page == PageList.Articles){
      _controller.animateTo(_width*5,duration: Duration(milliseconds: 500), curve: Curves.linear);
      _newsTabPostion = _width*5;
      currentNewsTab =5;
      _setTitle(currentNewsTab);
    }
  }

  @override
  clickedArticle(News article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullPageArticle(article: article,)
      ),
    );
  }

  @override
  savedArticle(News article) async {
    int save =1;

    if(article.isSaved == 1){
      save = 0;
    }
    else{
      save = 1;
    }
    News newArticle = News(
      id:article.id,
      imgUrl:article.imgUrl,
      titleSinhala:article.titleSinhala,
      titleTamil:article.titleTamil,
      titleEnglish:article.titleEnglish,
      contentSinhala:article.contentSinhala,
      contentTamil:article.contentTamil,
      contentEnglish:article.contentEnglish,
      date:article.date,
      author:article.author,
      isRead:article.isRead,
      timeStamp:article.timeStamp,
      isSaved:save,
    );
    await DBProvider.db.saveUnsaveArticaleDB(article.id.toString(),save);
    int index = articleList.indexOf(article);
    articleList.insert(index, newArticle);
    articleList.removeAt(index+1);
    
    _loadArticle();
  }
}