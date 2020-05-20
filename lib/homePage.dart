import 'package:flutter/material.dart';
import 'package:news_app/Splash/splash.dart';
import 'package:news_app/Splash/splashListner.dart';
import 'package:news_app/const.dart';
import 'package:news_app/language/language.dart';
import 'package:news_app/language/languageListner.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> implements SplashStateListner, LanguageStateListner{

  double _height = 0.0;
  double _width = 0.0;
  bool _splashLoading = false;

  @override
  void initState() {
    
    super.initState();
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
          children: <Widget>[
            Container(
              height: _height,
              width: _width,
              child: Column(
                children: <Widget>[
                  Splash(splashStateListner: this,),
                  // Language(languageStateListner: this,loading:_splashLoading)
                ],
              )
            ),
          ],
        )
       ),
    );
  }

  @override
  loadingState(bool load) {
    print(load);
    setState(() {
      _splashLoading = load;
    });
  }

  @override
  languageState(LanguageList language) {
    // TODO: implement languageState
    return null;
  }
}