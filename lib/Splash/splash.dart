import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:news_app/Splash/dialoagLister.dart';
import 'package:news_app/Splash/noInterNet.dart';
import 'package:news_app/Splash/splashListner.dart';
import 'package:news_app/const.dart';
import 'package:news_app/database/database.dart';
import 'package:news_app/database/sqlLitedatabase.dart';
import 'package:news_app/language/language.dart';
import 'package:news_app/language/languageListner.dart';
import 'package:news_app/model/news.dart';
import 'package:news_app/model/systemInfo.dart';
import 'package:news_app/res/curvePainter.dart';
import 'package:news_app/res/resources.dart';

class Splash extends StatefulWidget {
  final SplashStateListner splashStateListner;
  final LanguageStateListner languageStateListner;
  final Key languageKey;
  Splash({Key key,@required this.splashStateListner, this.languageStateListner, this.languageKey}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> implements NoInterNetTryAginListen{
  double _height = 0.0;
  double _width = 0.0;
  double _screenHeight = 0.0;
  double _logoPostion = 0.0;
  double _loadingPostion = 0.0;
  double _languagePageHeight = 0.0;

  bool _loadingData = false;
  bool _waitTimeComplete = false;
  bool _firstLoading = true;
  bool _moveTolanguageScreen = true;
  bool _loadingSystemData = false;
  bool _loadComplete = false;


  @override
  void initState() {
    super.initState();
    print("splah page run"+_loadComplete.toString());
    WidgetsBinding.instance.addPostFrameCallback((_) { 
      _startLoadData();
    });
  }

  _startLoadData() async{
    //check sqlLite data avalablity
    bool avalablity = await DBProvider.db.databaseAvalablity();

    //check internet avalablity
    bool internet = await Resousers.checkInternetConectivity();

    if(!internet && !avalablity){
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, _, __) => NoInternet(
            netTryAginListen: this,
          ),
          opaque: false
        ),
      );
      return;
    }
    else{
      if(!_loadComplete){
        _setPosition();
        _loadData();
        _loadingTime();
        _loadSystemData();
      }
    }
  }


  _loadingTime() async{
    await new Future.delayed(const Duration(seconds : 3));
    _waitTimeComplete = true;
    _exitFormPage();
  }

  _exitFormPage(){
    if(_loadingData && _waitTimeComplete && _loadingSystemData){

      setState(() {
        _loadComplete = true;
      });

      widget.splashStateListner.loadingState(true);
      print("set height");

      if(_moveTolanguageScreen){
        setState(() {
          _screenHeight = 0.0;
          _languagePageHeight = _height;
        });
      }
      else{
        widget.splashStateListner.moveToNewsPage(AppData.isDark);
        _screenHeight = 0.0;
        _languagePageHeight = _height;
      }
    }
  }

  _loadData() async{
    List<News> newsList = [];
    List<News> articleList = [];
    List<News> hotNewsList = [];
    Database database = Database();

    //get firebase last added news only use when add news
    //// int firebaseNewsCount =await database.getNewsCount();

    //get firebase last added news only use when add news
    ////int firebaseArticleCount =await database.getArticaleCount();

    //get system data
    await database.getSystemData();

    //get sql lite last added news only use when retrive news
    int id = await DBProvider.db.getLastNewsId();

    //get sql lite last added article id only use when retrive news
    int articleiId = await DBProvider.db.getLastArticaleId();
    
   ////print("last firsbase id "+firebaseNewsCount.toString());
    print("last sql ite id "+id.toString());

    ////print("last artcle firsbase id "+firebaseNewsCount.toString());
    print("last sqllite artcle id "+id.toString());

    //get articles
    articleList = await database.readArticles(articleiId);
    
    //get normal news
    newsList = await database.readNews(id);

    //get hot news
    hotNewsList = await database.readHotNews();
    print(newsList.length);

    if(newsList.length != 0){
      await DBProvider.db.addNewsData(newsList);
    }

    if(hotNewsList.length != 0){
      await DBProvider.db.addHotNewsData(hotNewsList);
    }

    if(articleList.length != 0){
      await DBProvider.db.addAtricaleData(articleList);
    }

    //get deleted news id
    List<int> deltedNewsId = await database.deleteNews();
    //get delted article id
    List<int> deltedArticleId = await database.deleteArticles();
    
    if(deltedNewsId.length != 0){
      await DBProvider.db.deleteNews(deltedNewsId);
    }

    if(deltedArticleId.length != 0){
      await DBProvider.db.deleteArticale(deltedArticleId);
    }

    _loadingData = true;
    _exitFormPage();
  }

  _loadSystemData() async{
    SystemInfo systemInfo = await DBProvider.db.getSystemData();
    if(systemInfo == null){
      _moveTolanguageScreen = true;
    }
    else{
      print("splash");
      print(systemInfo.isDrak);
      AppData.language = systemInfo.language;
      AppData.isDark = systemInfo.isDrak;
      _moveTolanguageScreen = false;
    }

    _loadingSystemData =true;
    _exitFormPage();
  }

  _setPosition(){
    setState(() {
      _logoPostion = 125;
      _loadingPostion = 150;
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _height = MediaQuery.of(context).size.height;
      _width = MediaQuery.of(context).size.width;
      if(_firstLoading){
        _screenHeight = _height;
        _firstLoading =false;
      }
    });

    return Container(
      height: _height,
      width: _width,
      child: Stack(
        children: <Widget>[
          
          //background image
          Container(
            height: _height,
            width:_width,
            child: Image.asset(
              AppData.BACKGROUND,
              fit: BoxFit.cover,
            ),
          ),

          //canves
          Container(
            height: _height,
            width:_width,
            child: CustomPaint(
              painter:CurvePainter() ,
            ),
          ),
          
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                AnimatedContainer(
                  duration: Duration(milliseconds: 1000),
                  height: _screenHeight,
                  width: _width,
                  child: Stack(
                    children: <Widget>[

                      //logo
                      AnimatedPositioned(
                        duration: Duration(milliseconds:1000),
                        top:_logoPostion,
                        child: Container(
                          width: _width,
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 160,
                              width: 160,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Image.asset(
                                    AppData.LOGO
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xff161617),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2.0,
                                    spreadRadius: 2.0, 
                                    offset: Offset(
                                      1.0,
                                      2.0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ), 
                      ),

                      //loading
                      !_loadComplete?AnimatedPositioned(
                        duration: Duration(milliseconds:1000),
                        bottom:_loadingPostion,
                        child: Container(
                          width: _width,
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 50,
                              width: 50,
                              child: SpinKitFadingCube(
                                color: AppData.ALLCOLOR,
                                size: 50.0,
                              ),
                            ),
                          ),
                        ), 
                      ):Container(),


                    ],
                  ),
                ),

                AnimatedContainer(
                  height: _languagePageHeight,
                  width: _width,
                  duration: Duration(milliseconds: 500),
                  color: Colors.grey[200].withOpacity(0.7),
                  child: SingleChildScrollView(
                    child: Language(languageStateListner: widget.languageStateListner,key:widget.languageKey)
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void tryAgainClick() async{
    await new Future.delayed(const Duration(seconds : 3));
    _startLoadData();
  }
}