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
    List<News> hotNewsList = [];
    Database database = Database();

    int firebaseNewsCount =await database.getNewsCount();
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

    // news = News(
    //   id:++firebaseNewsCount,
    //   titleEnglish:"local news 2 English",
    //   titleSinhala:"local news 2 Sinhala",
    //   titleTamil:"local news 2 Tamil",
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

    // news = News(
    //   id:++firebaseNewsCount,
    //   titleEnglish:"hot news all English",
    //   titleSinhala:"hot news all Sinhala",
    //   titleTamil:"hot news all Tamil",
    //   imgUrl:["https://cdn.newsfirst.lk/english-uploads/2020/05/13b23a13-97cc2493-f18fe9cb-cbsl_850x460_acf_cropped_850x460_acf_cropped.jpg"],
    //   contentEnglish: "English Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   contentSinhala:"Sinhala Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   contentTamil:"Tamil Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   date:currentData.toString(),
    //   author:"author",
    //   bigNews:0,
    //   isRead:0,
    //   type:NewsType.AllTop,
    //   timeStamp:timeStamp
    // );

    // await database.addNews(news);
    // await database.addHotNews(news,NewsType.AllTop);

    // news = News(
    //   id:++firebaseNewsCount,
    //   titleEnglish:"hot news local English",
    //   titleSinhala:"hot news local Sinhala",
    //   titleTamil:"hot news local Tamil",
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
    // await database.addHotNews(news,NewsType.Local);

    // news = News(
    //   id:++firebaseNewsCount,
    //   titleEnglish:"hot news forign English",
    //   titleSinhala:"hot news forign Sinhala",
    //   titleTamil:"hot news forign Tamil",
    //   imgUrl:["https://cdn.newsfirst.lk/english-uploads/2020/05/13b23a13-97cc2493-f18fe9cb-cbsl_850x460_acf_cropped_850x460_acf_cropped.jpg"],
    //   contentEnglish: "English Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   contentSinhala:"Sinhala Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   contentTamil:"Tamil Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   date:currentData.toString(),
    //   author:"author",
    //   bigNews:0,
    //   isRead:0,
    //   type:NewsType.Forign,
    //   timeStamp:timeStamp
    // );

    // await database.addNews(news);
    // await database.addHotNews(news,NewsType.Forign);

    // news = News(
    //   id:++firebaseNewsCount,
    //   titleEnglish:"hot news sports English",
    //   titleSinhala:"hot news sports Sinhala",
    //   titleTamil:"hot news sports Tamil",
    //   imgUrl:["https://cdn.newsfirst.lk/english-uploads/2020/05/13b23a13-97cc2493-f18fe9cb-cbsl_850x460_acf_cropped_850x460_acf_cropped.jpg"],
    //   contentEnglish: "English Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   contentSinhala:"Sinhala Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   contentTamil:"Tamil Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   date:currentData.toString(),
    //   author:"author",
    //   bigNews:0,
    //   isRead:0,
    //   type:NewsType.Sport,
    //   timeStamp:timeStamp
    // );

    // await database.addNews(news);
    // await database.addHotNews(news,NewsType.Sport);

    // news = News(
    //   id:++firebaseNewsCount,
    //   titleEnglish:"hot news weather English",
    //   titleSinhala:"hot news weather Sinhala",
    //   titleTamil:"hot news weather Tamil",
    //   imgUrl:["https://cdn.newsfirst.lk/english-uploads/2020/05/13b23a13-97cc2493-f18fe9cb-cbsl_850x460_acf_cropped_850x460_acf_cropped.jpg"],
    //   contentEnglish: "English Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   contentSinhala:"Sinhala Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   contentTamil:"Tamil Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   date:currentData.toString(),
    //   author:"author",
    //   bigNews:0,
    //   isRead:0,
    //   type:NewsType.Whether,
    //   timeStamp:timeStamp
    // );

    // await database.addNews(news);
    // await database.addHotNews(news,NewsType.Whether);

    // news = News(
    //   id:++firebaseNewsCount,
    //   titleEnglish:"1 news forign English",
    //   titleSinhala:"1 news forign Sinhala",
    //   titleTamil:"1 news forign Tamil",
    //   imgUrl:["https://cdn.newsfirst.lk/english-uploads/2020/05/13b23a13-97cc2493-f18fe9cb-cbsl_850x460_acf_cropped_850x460_acf_cropped.jpg"],
    //   contentEnglish: "English Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   contentSinhala:"Sinhala Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   contentTamil:"Tamil Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   date:currentData.toString(),
    //   author:"author",
    //   bigNews:0,
    //   isRead:0,
    //   type:NewsType.Forign,
    //   timeStamp:timeStamp
    // );

    // await database.addNews(news);

    // news = News(
    //   id:++firebaseNewsCount,
    //   titleEnglish:"2 news forign English",
    //   titleSinhala:"2 news forign Sinhala",
    //   titleTamil:"2 news forign Tamil",
    //   imgUrl:["https://cdn.newsfirst.lk/english-uploads/2020/05/13b23a13-97cc2493-f18fe9cb-cbsl_850x460_acf_cropped_850x460_acf_cropped.jpg"],
    //   contentEnglish: "English Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   contentSinhala:"Sinhala Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   contentTamil:"Tamil Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   date:currentData.toString(),
    //   author:"author",
    //   bigNews:0,
    //   isRead:0,
    //   type:NewsType.Forign,
    //   timeStamp:timeStamp
    // );

    // await database.addNews(news);

    // news = News(
    //   id:++firebaseNewsCount,
    //   titleEnglish:"1 news sports English",
    //   titleSinhala:"1 news sports Sinhala",
    //   titleTamil:"1 news sports Tamil",
    //   imgUrl:["https://cdn.newsfirst.lk/english-uploads/2020/05/13b23a13-97cc2493-f18fe9cb-cbsl_850x460_acf_cropped_850x460_acf_cropped.jpg"],
    //   contentEnglish: "English Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   contentSinhala:"Sinhala Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   contentTamil:"Tamil Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   date:currentData.toString(),
    //   author:"author",
    //   bigNews:0,
    //   isRead:0,
    //   type:NewsType.Sport,
    //   timeStamp:timeStamp
    // );

    // await database.addNews(news);

    // news = News(
    //   id:++firebaseNewsCount,
    //   titleEnglish:"2 news sports English",
    //   titleSinhala:"2 news sports Sinhala",
    //   titleTamil:"2 news sports Tamil",
    //   imgUrl:["https://cdn.newsfirst.lk/english-uploads/2020/05/13b23a13-97cc2493-f18fe9cb-cbsl_850x460_acf_cropped_850x460_acf_cropped.jpg"],
    //   contentEnglish: "English Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   contentSinhala:"Sinhala Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   contentTamil:"Tamil Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   date:currentData.toString(),
    //   author:"author",
    //   bigNews:0,
    //   isRead:0,
    //   type:NewsType.Sport,
    //   timeStamp:timeStamp
    // );

    // await database.addNews(news);

    // news = News(
    //   id:++firebaseNewsCount,
    //   titleEnglish:"1 news weather English",
    //   titleSinhala:"1 news weather Sinhala",
    //   titleTamil:"1 news weather Tamil",
    //   imgUrl:["https://cdn.newsfirst.lk/english-uploads/2020/05/13b23a13-97cc2493-f18fe9cb-cbsl_850x460_acf_cropped_850x460_acf_cropped.jpg"],
    //   contentEnglish: "English Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   contentSinhala:"Sinhala Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   contentTamil:"Tamil Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   date:currentData.toString(),
    //   author:"author",
    //   bigNews:0,
    //   isRead:0,
    //   type:NewsType.Whether,
    //   timeStamp:timeStamp
    // );

    // await database.addNews(news);

    // news = News(
    //   id:++firebaseNewsCount,
    //   titleEnglish:"2 news weather English",
    //   titleSinhala:"2 news weather Sinhala",
    //   titleTamil:"2 news weather Tamil",
    //   imgUrl:["https://cdn.newsfirst.lk/english-uploads/2020/05/13b23a13-97cc2493-f18fe9cb-cbsl_850x460_acf_cropped_850x460_acf_cropped.jpg"],
    //   contentEnglish: "English Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   contentSinhala:"Sinhala Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   contentTamil:"Tamil Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   date:currentData.toString(),
    //   author:"author",
    //   bigNews:0,
    //   isRead:0,
    //   type:NewsType.Whether,
    //   timeStamp:timeStamp
    // );

    // await database.addNews(news);









    // news = News(
    //   id:++firebaseNewsCount,
    //   titleEnglish:"hot news all English",
    //   titleSinhala:"hot news all Sinhala",
    //   titleTamil:"hot news all Tamil",
    //   imgUrl:["https://cdn.newsfirst.lk/english-uploads/2020/05/13b23a13-97cc2493-f18fe9cb-cbsl_850x460_acf_cropped_850x460_acf_cropped.jpg"],
    //   contentEnglish: "English Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   contentSinhala:"Sinhala Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   contentTamil:"Tamil Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   date:currentData.toString(),
    //   author:"author",
    //   bigNews:0,
    //   isRead:0,
    //   type:NewsType.AllTop,
    //   timeStamp:timeStamp
    // );
    
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