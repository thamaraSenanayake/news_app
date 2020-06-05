import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:news_app/Splash/splashListner.dart';
import 'package:news_app/const.dart';
import 'package:news_app/database/database.dart';
import 'package:news_app/database/sqlLitedatabase.dart';
import 'package:news_app/language/language.dart';
import 'package:news_app/language/languageListner.dart';
import 'package:news_app/model/news.dart';
import 'package:news_app/model/systemInfo.dart';
import 'package:news_app/res/curvePainter.dart';

class Splash extends StatefulWidget {
  final SplashStateListner splashStateListner;
  final LanguageStateListner languageStateListner;
  final Key languageKey;
  Splash({Key key,@required this.splashStateListner, this.languageStateListner, this.languageKey}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
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
      if(!_loadComplete){
        _setPosition();
        _loadData();
        _loadingTime();
        _loadSystemData();
      }
    });
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
    List<News> hotNewsList = [];
    Database database = Database();

    //get firebase last added news only use when add news
    int firebaseNewsCount =await database.getNewsCount();

    //get sql lite last added news only use when retrive news
    int id = await DBProvider.db.getLastNewsId();
    
    print("last firsbase id "+firebaseNewsCount.toString());
    print("last sql ite id "+id.toString());

    // var timeStamp = new DateTime.now().millisecondsSinceEpoch;
    // var currentData = new DateTime.now();
    
    // News news = News(
    //   id:++firebaseNewsCount,
    //   titleEnglish:"local news 1 English",
    //   titleSinhala:"local news 1 Sinhala",
    //   titleTamil:"local news 1 Tamil",
    //   imgUrl:["https://cdn.newsfirst.lk/english-uploads/2020/05/13b23a13-97cc2493-f18fe9cb-cbsl_850x460_acf_cropped_850x460_acf_cropped.jpg"],
    //   contentEnglish: "English Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   contentSinhala:"Sinhala Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   contentTamil:"Tamil Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   date:currentData.toString(),
    //   author:"author",
    //   bigNews:0,
    //   isRead:0,
    //   type:NewsType.Local,
    //   timeStamp:timeStamp
    // );

    // await database.addNews(news);
    
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
}