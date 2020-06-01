import 'package:flutter/material.dart';
import 'package:news_app/homePageListner.dart';
import 'package:news_app/Splash/splash.dart';
import 'package:news_app/Splash/splashListner.dart';
import 'package:news_app/const.dart';
import 'package:news_app/database/sqlLitedatabase.dart';
import 'package:news_app/language/languageListner.dart';
import 'package:news_app/newsPage.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> implements SplashStateListner, LanguageStateListner, HomePageListner{

  double _height = 0.0;
  double _width = 0.0;
  ScrollController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isDark = false;
  final GlobalKey<NewsPageState> _newsPageState = GlobalKey();

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
            children: _appDrawerContent(),
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
                  Splash(splashStateListner: this,languageStateListner: this,),
                ],
              )
            ),

            Container(
              height: _height,
              width: _width,
              // color: Colors.blue,
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
    DBProvider.db.addSystemData(AppData.language,AppData.isDark);
    print(language);
    _controller.animateTo(_width,duration: Duration(milliseconds: 500), curve: Curves.linear);
  }

  @override
  homePageActivityClick(HomePageActivity homePageActivity) {
    if(homePageActivity == HomePageActivity.MenuOpen){
      _scaffoldKey.currentState.openDrawer();
    }
  }


  //app drawer
  List<Widget> _appDrawerContent() {
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
                    decoration: BoxDecoration(
                      // color: Colors.red,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image:AssetImage(
                          AppData.LOGODARK,
                        ),
                        fit:BoxFit.fill
                      ),
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
        color: Colors.white,
        child: Column(
          children: <Widget>[

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
                            color: AppData.BLACK,
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
                            color: AppData.BLACK,
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
                            color: AppData.BLACK,
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
                            color: AppData.BLACK,
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
                            color: AppData.BLACK,
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
                            color: AppData.BLACK,
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