import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:news_app/homePageListner.dart';
import 'package:news_app/Splash/splash.dart';
import 'package:news_app/Splash/splashListner.dart';
import 'package:news_app/const.dart';
import 'package:news_app/database/sqlLitedatabase.dart';
import 'package:news_app/language/language.dart';
import 'package:news_app/language/languageListner.dart';
import 'package:news_app/newspages/newsPage.dart';
import 'package:news_app/savedNews.dart';
import 'package:launch_review/launch_review.dart'; 
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';



class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> implements SplashStateListner, LanguageStateListner, HomePageListner{

  double _height = 0.0;
  double _width = 0.0;
  ScrollController _controller;
  bool _isDark = false;
  
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<NewsPageState> _newsPageState = GlobalKey();
  final GlobalKey<LanguageState> _languagePageState = GlobalKey();


  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }


  @override
  Widget build(BuildContext context) {
    setState(() {
      _height = MediaQuery.of(context).size.height;
      _width = MediaQuery.of(context).size.width;
    });
    return Scaffold(
      key: _scaffoldKey,
      drawer:Theme(
        data: Theme.of(context).copyWith(
          canvasColor: AppData.BLACK,
        ),
        child: Drawer(
          child: ListView(
            children: _appDrawerContent(context),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xffFFFFFF), Color.fromRGBO(255, 255, 255, 0.8)]
          ),
        ),
        child:ListView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          controller: _controller,
          children: <Widget>[
            
            Container(
              height: _height,
              width: _width,
              child: Column(
                children: <Widget>[
                  Splash(splashStateListner: this,languageStateListner: this,languageKey:_languagePageState),
                ],
              )
            ),

            Container(
              height: _height,
              width: _width,
              child: NewsPage(
                homePageActivity: this,
                key: _newsPageState,
              ),
            ),

          ],
        )
       ),
    );
  }

  @override
  loadingState(bool load) {
    //load news
    //_newsPageState
    print("load news done");
    print(load);

    //callling news page
    _newsPageState.currentState.loadNews();

  }

  @override
  languageState(LanguageList language) {
    AppData.language = language;
    _newsPageState.currentState.reloadNews();
    print("languageState");
    print(AppData.isDark);
    DBProvider.db.addSystemData(AppData.language,AppData.isDark);
    print(language);
    
    if(language == LanguageList.English){
      _firebaseMessaging.subscribeToTopic(language.toString());
      _firebaseMessaging.unsubscribeFromTopic(LanguageList.Tamil.toString());
      _firebaseMessaging.unsubscribeFromTopic(LanguageList.Sinhala.toString());
    }
    else if(language == LanguageList.Sinhala){
      _firebaseMessaging.subscribeToTopic(language.toString());
      _firebaseMessaging.unsubscribeFromTopic(LanguageList.English.toString());
      _firebaseMessaging.unsubscribeFromTopic(LanguageList.Tamil.toString());
    }
    else if(language == LanguageList.Tamil){
      _firebaseMessaging.subscribeToTopic(language.toString());
      _firebaseMessaging.unsubscribeFromTopic(LanguageList.English.toString());
      _firebaseMessaging.unsubscribeFromTopic(LanguageList.Sinhala.toString());
    }

    _controller.animateTo(_width,duration: Duration(milliseconds: 500), curve: Curves.linear);
  }

  @override
  homePageActivityClick(HomePageActivity homePageActivity) {
    if(homePageActivity == HomePageActivity.MenuOpen){
      _scaffoldKey.currentState.openDrawer();
    }
    else if(homePageActivity == HomePageActivity.SavedNewsPAgeback){
      _newsPageState.currentState.loadNews();
    }
  }

  @override
  moveToNewsPage(int isDark) {
    setState(() {
      AppData.isDark = isDark;
      _isDark = isDark==1?true:false;
    });
    _languagePageState.currentState.choseLanguage();
    _controller.animateTo(_width,duration: Duration(milliseconds: 500), curve: Curves.linear);
  }

  _changetheme(bool value) async{
    
    if(value){
      setState(() {
        AppData.isDark = 1;
      });
    }
    else{
      setState(() {
        AppData.isDark = 0;
      });
    }

    print(AppData.isDark);
    await DBProvider.db.addSystemData(AppData.language,AppData.isDark);
    _newsPageState.currentState.reloadNews();
    _controller.animateTo(_width,duration: Duration(milliseconds: 500), curve: Curves.linear);
  }

  _shareWithOther(){
    Share.share('Andriod https://play.google.com/store/apps/details?id='+AppData.appIdAndriod+' iOS https://apps.apple.com/us/app/clash-of-clans/id'+AppData.appIdIos+'', subject: 'Check This new News App');
  }

  _rateUs(){
    LaunchReview.launch(androidAppId: AppData.appIdAndriod,iOSAppId: AppData.appIdIos);
  }

  _sendMail() async{
    
    var emailaddress = 'mailto:'+AppData.email;

    if(await canLaunch(emailaddress)) {
      await launch(emailaddress);
    }   
  
  }

  //app drawer
  List<Widget> _appDrawerContent(context) {
    return [
      Container(
        color: AppData.BLACK,
        height: 170,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left:8.0),
                child: Align(
                  child: Container(
                    height: 150,
                    width: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Image.asset(
                          AppData.LOGO
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff161617),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      SizedBox(
        height:20
      ),

      Container(
        height: _height -170,
        width: _width,
        color: AppData.isDark == 1? AppData.BLACK: Colors.white,
        child: Column(
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.symmetric(horizontal:20.0),
              child: GestureDetector(
                onTap: (){
                  _controller.animateTo(0,duration: Duration(milliseconds: 500), curve: Curves.linear);
                  _scaffoldKey.currentState.openEndDrawer();
                },
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.language,
                          color: AppData.ALLCOLOR,
                        ),
                        SizedBox(width:40),
                        Text(
                          "Change Language",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppData.isDark == 1? AppData.WHITE : AppData.BLACK,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal:20.0),
              child: GestureDetector(
                onTap: (){
                  _rateUs();
                  _scaffoldKey.currentState.openEndDrawer();
                },
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.rate_review,
                          color: AppData.ALLCOLOR,
                        ),
                        SizedBox(width:40),
                        Text(
                          "Rate us",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppData.isDark == 1? AppData.WHITE : AppData.BLACK,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal:20.0),
              child: GestureDetector(
                onTap: (){
                  _scaffoldKey.currentState.openEndDrawer();
                  _sendMail();
                },
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.contact_mail,
                          color: AppData.ALLCOLOR,
                        ),
                        SizedBox(width:40),
                        Text(
                          "Contact Us",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppData.isDark == 1? AppData.WHITE : AppData.BLACK,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal:20.0),
              child: GestureDetector(
                onTap: (){
                  _shareWithOther();
                  _scaffoldKey.currentState.openEndDrawer();
                },
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.share,
                          color: AppData.ALLCOLOR,
                        ),
                        SizedBox(width:40),
                        Text(
                          "Share With Others",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppData.isDark == 1? AppData.WHITE : AppData.BLACK,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal:20.0),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SavedNews(homePageActivity:this)
                    ),
                  );
                  _scaffoldKey.currentState.openEndDrawer();
                },
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.bookmark,
                          color: AppData.ALLCOLOR,
                        ),
                        SizedBox(width:40),
                        Text(
                          "Saved News",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppData.isDark == 1? AppData.WHITE : AppData.BLACK,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal:20.0),
              child: GestureDetector(
                onTap: (){
                  _scaffoldKey.currentState.openEndDrawer();
                },
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Dark mode",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppData.isDark == 1? AppData.WHITE : AppData.BLACK,
                          ),
                        ),
                        SizedBox(width:40),
                        Container(
                          // color: Colors.red,
                          child: Switch(
                            value: _isDark, 
                            onChanged: (value){
                              setState(() {
                                _isDark = value;
                              }); 
                              _changetheme(value);
                            },
                            activeColor: AppData.ALLCOLOR,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),  


    ];
  }

  

}