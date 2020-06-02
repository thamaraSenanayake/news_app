import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:news_app/const.dart';
import 'package:news_app/database/database.dart';
import 'package:news_app/database/sqlLitedatabase.dart';
import 'package:news_app/dropDown/dropDownOverlay.dart';
import 'package:news_app/newspages/fullPageNews.dart';
import 'package:news_app/homePageListner.dart';
import 'package:news_app/model/news.dart';
import 'package:news_app/module/newsListner.dart';
import 'package:news_app/module/normalNews.dart';
import 'package:news_app/module/topNews.dart';


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

  List<News> newNormalNews =[];
  List<Widget> newNormalNewsWidgetAll =[];
  List<Widget> newNormalNewsWidgetLocal = [];
  List<Widget> newNormalNewsWidgetForign = [];
  List<Widget> newNormalNewsWidgetSports = [];
  List<Widget> newNormalNewsWidgetWeather = [];

  bool _isloaded = false;

  ScrollController _controller;

  String mainTitle = "All News";
  String nextTitle = "Articales";
  int currentNewsTab = 0;
  bool _showToster = false;
  String _tosterMsg = "New News";

  double _newsTabPostion = 0.0;
  Database database = Database();


  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    _getLiveUpdate();

  }

  loadNews() async{
    normalNews = await DBProvider.db.viewNews("");
    topNewsList = await DBProvider.db.viewHotNews();
    _topNewsLoad();
    _normalNewsLoad(normalNews,true);
    _isloaded = true;
  }

  _setTitle(int pageNum){
    if(pageNum == 0){
      setState(() {
        mainTitle = "All News";
        nextTitle= "Articales";
      });
    }
    else if(pageNum == 1){
      setState(() {
        mainTitle = "Articales";
        nextTitle= "Local";
      });
    }
    else if(pageNum == 1){
      setState(() {
        mainTitle = "Local News";
        nextTitle= "Forign";
      });
    }
    else if(pageNum == 2){
      setState(() {
        mainTitle = "Forign News";
        nextTitle= "Sport";
      });
    }
    else if(pageNum == 3){
      setState(() {
        mainTitle = "Sport News";
        nextTitle= "Weather";
      });
    }
    else if(pageNum == 4){
      setState(() {
        mainTitle = "Weather News";
        nextTitle= "";
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
            secondColor: AppData.ALLCOLOR,
          )
        );
      }
      else if(item.type == NewsType.Forign){
        topNewsWidgetForignTemp.add(
          TopNews(
            news: item,
            newsClickListner: this,
            secondColor: AppData.ALLCOLOR,
          )
        );
      }

      else if(item.type == NewsType.Sport){
        topNewsWidgetSportsTemp.add(
          TopNews(
            news: item,
            newsClickListner: this,
            secondColor: AppData.ALLCOLOR,
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

  _normalNewsLoad(List<News> newsList,bool _isFrirstLoad){
    List<Widget> normalNewsWidgetAllTemp = [];
    List<Widget> normalNewsWidgetLocalTemp = [];
    List<Widget> normalNewsWidgetForignTemp = [];
    List<Widget> normalNewsWidgetSportsTemp = [];
    List<Widget> normalNewsWidgetWeatherTemp = [];

    for (var item in newsList) {
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
            secondColor: AppData.ALLCOLOR,
          )
        );
      }      
      else if(item.type == NewsType.Forign){
        normalNewsWidgetForignTemp.add(
          NormalNews(
            news: item,
            newsClickListner: this,
            secondColor: AppData.ALLCOLOR,
          )
        );
      }
      else if(item.type == NewsType.Sport){
        normalNewsWidgetSportsTemp.add(
          NormalNews(
            news: item,
            newsClickListner: this,
            secondColor: AppData.ALLCOLOR,
          )
        );
      }
      else if(item.type == NewsType.Whether){
        normalNewsWidgetWeatherTemp.add(
          NormalNews(
            news: item,
            newsClickListner: this,
            secondColor: AppData.ALLCOLOR,
          )
        );
      }
    }

    if(_isFrirstLoad){
      print("add old news");
      setState(() {
        normalNewsWidgetAll = normalNewsWidgetAllTemp;
        normalNewsWidgetLocal = normalNewsWidgetLocalTemp;
        normalNewsWidgetForign = normalNewsWidgetForignTemp;
        normalNewsWidgetSports = normalNewsWidgetSportsTemp;
        normalNewsWidgetWeather = normalNewsWidgetWeatherTemp;
        newNormalNewsWidgetAll =[];
        newNormalNewsWidgetLocal =[];
        newNormalNewsWidgetForign =[];
        newNormalNewsWidgetSports =[];
        newNormalNewsWidgetWeather =[];
      });
    }else{
      print("add new news");
      setState(() {
        newNormalNewsWidgetAll = normalNewsWidgetAllTemp;
        newNormalNewsWidgetLocal = normalNewsWidgetLocalTemp;
        newNormalNewsWidgetForign = normalNewsWidgetForignTemp;
        newNormalNewsWidgetSports = normalNewsWidgetSportsTemp;
        newNormalNewsWidgetWeather = normalNewsWidgetWeatherTemp;
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

                      nextTitle !=""? Padding(
                        padding: const EdgeInsets.only(right:8.0,top:25.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child:GestureDetector(
                            onTap: (){
                              // _next();
                              Navigator.of(context).push(DropDownOverlay());
                            },
                            child: Container(
                              width:105,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    nextTitle,
                                    style:TextStyle(
                                      color: AppData.ALLCOLOR,
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
                              Column(
                                children: normalNewsWidgetAll
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
                          child: ListView(
                            children: <Widget>[
                              Text("not yet")
                            ]
                          )
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
                                children: newNormalNewsWidgetLocal
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
                                children: newNormalNewsWidgetForign
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
                                children: newNormalNewsWidgetSports
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
                                children: newNormalNewsWidgetWeather
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
}