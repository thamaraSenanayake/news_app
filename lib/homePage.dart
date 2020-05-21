import 'package:flutter/material.dart';
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

class _HomePageState extends State<HomePage> implements SplashStateListner, LanguageStateListner{

  double _height = 0.0;
  double _width = 0.0;
  ScrollController _controller;

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
              child: NewsPage(),
            ),

          ],
        )
       ),
    );
  }

  @override
  loadingState(bool load) {
    print(load);

  }

  @override
  languageState(LanguageList language) {
    AppData.language = language;
    DBProvider.db.addSystemData(AppData.language,AppData.isDark);
    print(language);
    _controller.animateTo(_width,duration: Duration(milliseconds: 500), curve: Curves.linear);
  }
}