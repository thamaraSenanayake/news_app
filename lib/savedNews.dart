import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:news_app/const.dart';
import 'package:news_app/database/sqlLitedatabase.dart';
import 'package:news_app/module/newsListner.dart';
import 'package:news_app/module/normalNews.dart';
import 'package:news_app/newspages/fullPageArticle.dart';
import 'package:news_app/newspages/fullPageNews.dart';

import 'homePageListner.dart';
import 'model/news.dart';

class SavedNews extends StatefulWidget {
  final HomePageListner homePageActivity;
  SavedNews({Key key, this.homePageActivity}) : super(key: key);

  @override
  _SavedNewsState createState() => _SavedNewsState();
}

class _SavedNewsState extends State<SavedNews> implements NewsClickListner {
  double _height = 0.0;
  double _width = 0.0;
  ScrollController _controller;
  String _title ="Saved News";
  bool _rightArrow = false;
  List<News> _savedNews = [];
  List<Widget> _savedNewsWidget = [];
  List<News> _savedArticles = [];
  List<Widget> _savedArticlesWidget = [];

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    _loadSaveNews();
    _loadSaveArticale();
  }

  _scrollListener() {
    //news scroll to next tab
    if (_controller.position.userScrollDirection == ScrollDirection.reverse) {
      if (_controller.position.pixels >   40 ) {
        _next();
      }
    }
    //news scroll to previous step
    else if (_controller.position.userScrollDirection == ScrollDirection.forward) {
      if (_controller.position.pixels < _width - 40 ) {
        _back();
      }
    }
  }

  _next(){
    _controller.animateTo(_width,duration: Duration(milliseconds: 300), curve: Curves.linear);
    setState(() {
      _title ="Saved Article";
      _rightArrow = true;
    });
  }

  _back(){
    _controller.animateTo(0,duration: Duration(milliseconds: 300), curve: Curves.linear);
    setState(() {
      _title ="Saved News";
      _rightArrow = false;
    });
  }



  _loadSaveNews() async{
    _savedNews = await DBProvider.db.viewSavedNews();
    _viewNews(_savedNews);
  }

  _viewNews(List<News> newsList){

    List<Widget> _savedNewsWidgetTemp = []; 
    for (var item in newsList) {
      _savedNewsWidgetTemp.add(
        NormalNews(
          news: item,
          newsClickListner: this,
          secondColor: AppData.ALLCOLOR,
          tabType: TabType.News,
        )
      );
    }

    //show when news is empty
    if(newsList.length ==0){
      _savedNewsWidgetTemp.add(
        Container(
          height: 100,
          child: Center(
            child: Text(
              "No Saved News yet",
              style:TextStyle(
                fontSize: 20,
                color: AppData.isDark ==1 ? AppData.WHITE:AppData.BLACK,
              )
            ),
          ),
        )
      );
    }

    setState(() {
      _savedNewsWidget = _savedNewsWidgetTemp;
    });

  }

  _loadSaveArticale() async{
    _savedArticles = await DBProvider.db.viewSavedArticale();
    _viewArticle(_savedArticles);
  }

  _viewArticle(List<News> articleList){
    List<Widget> _savedArticleWidgetTemp = []; 

    for (var item in articleList) {
      _savedArticleWidgetTemp.add(
        NormalNews(
          news: item,
          newsClickListner: this,
          secondColor: AppData.ALLCOLOR,
          tabType: TabType.Article,
        )
      );
    }

    //show when article is empty
    if(articleList.length ==0){
      _savedArticleWidgetTemp.add(
        Container(
          height: 100,
          child: Center(
            child: Text(
              "No Saved Articles yet",
              style:TextStyle(
                fontSize: 20,
                color: AppData.isDark ==1 ? AppData.WHITE:AppData.BLACK,
              )
            ),
          ),
        )
      );
    }

    setState(() {
      _savedArticlesWidget = _savedArticleWidgetTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _height = MediaQuery.of(context).size.height;
      _width = MediaQuery.of(context).size.width;
    });
    return Scaffold(
      body: Container(
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
                          Navigator.pop(context);
                        },
                        child: Card(
                          child: Container(
                            height: 40,
                            width:40,
                            child:Icon(
                              Icons.arrow_back,
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
                    padding: const EdgeInsets.only(bottom:5.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        _title,
                        style:TextStyle(
                          color: AppData.ALLCOLOR,
                          fontSize: 28,
                          fontFamily: "lato",
                          fontWeight: FontWeight.w600
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  _rightArrow?Padding(
                    padding: const EdgeInsets.only(left:50.0),
                    child: GestureDetector(
                      onTap: (){
                        _back();
                      },
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Icon(
                          Icons.arrow_left,
                          color: AppData.isDark == 1? AppData.WHITE:AppData.BLACK,
                          size: 40,
                        ),
                      ),
                    )
                  ):Container(),

                  !_rightArrow?Padding(
                    padding: const EdgeInsets.only(bottom:0.0),
                    child: GestureDetector(
                      onTap: (){
                        _next();
                      },
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(
                          Icons.arrow_right,
                          color: AppData.isDark == 1? AppData.WHITE:AppData.BLACK,
                          size: 40,
                        ),
                      ),
                    )
                  ):Container(),

                ],
              ),
              
            ),

            Container(
              width: _width,
              height: _height-80,
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  controller:_controller,
                  children: <Widget>[
                    Container(
                      width: _width,
                      height: _height-80,
                      child: ListView(
                        children: _savedNewsWidget,
                      ),
                    ),
                    Container(
                      width: _width,
                      height: _height-80,
                      child: ListView(
                        children: _savedArticlesWidget,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  clickedNews(News news) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullPageNews(news: news,)
      ),
    );
  }

  @override
  savedNews(News news) async{

    await DBProvider.db.saveUnSaveNewsDB(news.id.toString(),0);
    widget.homePageActivity.homePageActivityClick(HomePageActivity.SavedNewsPAgeback);
    _savedNews.remove(news);
    _viewNews(_savedNews);
    
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
  savedArticle(News article) async{
    await DBProvider.db.saveUnsaveArticaleDB(article.id.toString(),0);
    widget.homePageActivity.homePageActivityClick(HomePageActivity.SavedNewsPAgeback);
    _savedArticles.remove(article);
    _viewArticle(_savedArticles);
  }
}