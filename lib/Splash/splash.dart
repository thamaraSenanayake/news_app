import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:news_app/Splash/dialoagLister.dart';
import 'package:news_app/Splash/noInterNet.dart';
import 'package:news_app/Splash/splashListner.dart';
import 'package:news_app/const.dart';
import 'package:news_app/database/database.dart';
import 'package:news_app/database/sqlLitedatabase.dart';
import 'package:news_app/model/news.dart';
import 'package:news_app/model/systemInfo.dart';
import 'package:news_app/res/resources.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class Splash extends StatefulWidget {
  final SplashStateListener splashStateListener;
  final Key languageKey;
  Splash({Key key,@required this.splashStateListener, this.languageKey}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> implements NoInterNetTryAginListen{
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  double _height = 0.0;
  double _width = 0.0;
  double _screenHeight = 0.0;

  bool _loadingData = false;
  bool _waitTimeComplete = false;
  bool _firstLoading = true;
  bool _loadingSystemData = false;
  bool _loadComplete = false;
  bool _noInterNet = false;
  bool internet = false;

  _noInternetDialog() async{
    setState(() {
      _noInterNet = true;
    });
    await new Future.delayed(const Duration(seconds : 3));
    setState(() {
      _noInterNet =false;
    });
  }

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        // print("onMessage: $message");
        // _showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        // print("onLaunch: $message");
        // _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        // print("onResume: $message");
        // _navigateToItemDetail(message);
      },
    );
    // print("splash page run"+_loadComplete.toString());
    WidgetsBinding.instance.addPostFrameCallback((_) { 
      _startLoadData();
    });
  }

  _startLoadData() async{
    //check sqlLite data availability
    bool availability = await DBProvider.db.databaseAvailability();

    //check internet avalablity
    internet = await Resources.checkInternetConnectivity();
    // print("internet"+internet.toString());

    if(!internet && !availability){
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
      if(!internet){
        _noInternetDialog();
      }
      if(!_loadComplete){
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

      widget.splashStateListener.loadingState(true);
      // print("set height");

      // if(_moveTolanguageScreen){
      //   setState(() {
      //     _screenHeight = 0.0;
      //     _languagePageHeight = _height;
      //   });
      // }
      // else{
      //   widget.splashStateListner.moveToNewsPage(AppData.isDark);
      //   _screenHeight = 0.0;
      //   _languagePageHeight = _height;
      // }
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

    //get sql lite last added news only use when retrieve news
    int id = await DBProvider.db.getLastNewsId();

    //get sql lite last added article id only use when retrieve news
    int articleId = await DBProvider.db.getLastArticleId();
    
   

    if(internet){

      //get articles
      articleList = await database.readArticles(articleId);
      
      //get normal news
      newsList = await database.readNews(id);

      //get hot news
      hotNewsList = await database.readHotNews();
      
    }

    // print(newsList.length);

    if(newsList.length != 0){
      await DBProvider.db.addNewsData(newsList);
    }

    if(hotNewsList.length != 0){
      await DBProvider.db.addHotNewsData(hotNewsList);
    }

    if(articleList.length != 0){
      await DBProvider.db.addArticleData(articleList);
    }

    //get deleted news id
    List<int> deletedNewsId = await database.deleteNews();
    //get deleted article id
    List<int> deletedArticleId = await database.deleteArticles();
    
    if(deletedNewsId.length != 0){
      await DBProvider.db.deleteNews(deletedNewsId);
    }

    if(deletedArticleId.length != 0){
      await DBProvider.db.deleteArticle(deletedArticleId);
    }

    _loadingData = true;
    _exitFormPage();
  }

  _loadSystemData() async{
    SystemInfo systemInfo = await DBProvider.db.getSystemData();
    if(systemInfo == null){
      // _moveTolanguageScreen = true;
    }
    else{
      // print("splash");
      // print(systemInfo.isDrak);
      AppData.isDark = systemInfo.isDrak;
      // _moveTolanguageScreen = false;
    }

    _loadingSystemData =true;
    _exitFormPage();
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
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppData.BACKGROUND),
                fit: BoxFit.cover
              )
            ),
            child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: new Container(
                decoration: new BoxDecoration(color: Colors.white.withOpacity(0.0)),
              ),
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
                      Positioned(
                        top:125,
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
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.grey,
                                //     blurRadius: 2.0,
                                //     spreadRadius: 2.0, 
                                //     offset: Offset(
                                //       1.0,
                                //       2.0,
                                //     ),
                                //   )
                                // ],
                              ),
                            ),
                          ),
                        ), 
                      ),

                      //loading
                      !_loadComplete?Positioned(
                        bottom:150.0,
                        child: Container(
                          width: _width,
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 50,
                              width: 50,
                              child: SpinKitSquareCircle(
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

                // AnimatedContainer(
                //   height: _languagePageHeight,
                //   width: _width,
                //   duration: Duration(milliseconds: 500),
                //   color: Colors.grey[200].withOpacity(0.7),
                //   child: SingleChildScrollView(
                //     child: Language(languageStateListner: widget.languageStateListner,key:widget.languageKey)
                //   ),
                // ),
              ],
            ),
          ),

          _noInterNet?Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: Align(
              alignment: Alignment.bottomCenter,
              child:Chip(
                label: Text(
                  "Connect app to the internet to load more news",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.grey[800],
              ) ,
            ),
          ):Container(),
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