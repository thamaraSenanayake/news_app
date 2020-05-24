import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:news_app/Splash/splashListner.dart';
import 'package:news_app/const.dart';
import 'package:news_app/database/database.dart';
import 'package:news_app/database/sqlLitedatabase.dart';
import 'package:news_app/language/language.dart';
import 'package:news_app/language/languageListner.dart';
import 'package:news_app/model/news.dart';

class Splash extends StatefulWidget {
  final SplashStateListner splashStateListner;
  final LanguageStateListner languageStateListner;
  Splash({Key key,@required this.splashStateListner, this.languageStateListner}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) { 
      _setPosition();
      _loadData();
      _loadingTime();
    });
  }

  _loadingTime() async{
    await new Future.delayed(const Duration(seconds : 3));
    _waitTimeComplete = true;
    _exitFormPage();
  }

  _exitFormPage(){
    if(_loadingData && _waitTimeComplete){
      widget.splashStateListner.loadingState(true);
      print("set height");
      setState(() {
        _screenHeight = 0.0;
        _languagePageHeight = _height;
      });
    }
  }

  _loadData() async{
    List<News> newsList = [];
    Database database = Database();
    int id = await DBProvider.db.getLastNewsId();

    var date = new DateTime.now().millisecondsSinceEpoch;
    
    News news = News(
      id:id+1,
      imgUrl:"url",
      titleEnglish:"title English",
      titleSinhala:"title Sinhala",
      titleTamil:"title Tamil",
      contentEnglish:"English Lorem ipsum dolor sit amet",
      contentSinhala:"Sinhala Lorem ipsum dolor sit amet",
      contentTamil:"Tamil Lorem ipsum dolor sit amet",
      date:"date",
      author:"author",
      bigNews:0,
      isRead:0,
      type:NewsType.Local,
      timeStamp:date
    );
    //await database.addNews(news);

    news = News(
      id:id+2,
      imgUrl:"url1",
      titleEnglish:"title 1 English",
      titleSinhala:"title 1 Sinhala",
      titleTamil:"title 1 Tamil",
      contentEnglish:"English Lorem ipsum dolor sit amet",
      contentSinhala:"Sinhala Lorem ipsum dolor sit amet",
      contentTamil:"Tamil Lorem ipsum dolor sit amet",
      date:"date1",
      author:"author1",
      bigNews:1,
      isRead:0,
      type:NewsType.Forign,
      timeStamp:date
    );

    //await database.addNews(news);

    newsList = await database.readNews(id);

    if(newsList.length != 0){
      await DBProvider.db.addNewsData(newsList);
    }

    _loadingData = true;
    _exitFormPage();
  }

  _setPosition(){
    setState(() {
      _logoPostion = 100;
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

          //backgroundImage
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              // color: Colors.green,
              height: 130,
              width: _width,
              child: Image.asset(AppData.BACKGROUND),
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
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                // color: Colors.red,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image:AssetImage(
                                    AppData.LOGODARK,
                                  ),
                                  fit:BoxFit.fill
                                ),
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
                      AnimatedPositioned(
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
                      ),
                    ],
                  ),
                ),

                AnimatedContainer(
                  height: _languagePageHeight,
                  width: _width,
                  duration: Duration(milliseconds: 500),
                  color: Colors.grey[200].withOpacity(0.7),
                  child: SingleChildScrollView(
                    child: Language(languageStateListner: widget.languageStateListner)
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