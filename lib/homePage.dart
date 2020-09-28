import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_app/homePageListner.dart';
import 'package:news_app/Splash/splash.dart';
import 'package:news_app/Splash/splashListner.dart';
import 'package:news_app/const.dart';
import 'package:news_app/database/sqlLitedatabase.dart';
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

class _HomePageState extends State<HomePage>with SingleTickerProviderStateMixin  implements SplashStateListener, HomePageListener{

  double _height = 0.0;
  double _width = 0.0;
  bool _isDark = false;
  
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<NewsPageState> _newsPageState = GlobalKey();
  bool _finishLoading = false;
  FancyDrawerController _fancyController;

  @override
  void initState() {
    super.initState();
    _fancyController = FancyDrawerController(
        vsync: this, duration: Duration(milliseconds: 250))
      ..addListener(() {
        setState(() {});
      });
    // _firebaseMessaging.subscribeToTopic(language.toString());
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppData.ALLCOLOR, 
    ));
    setState(() {
      _height = MediaQuery.of(context).size.height;
      _width = MediaQuery.of(context).size.width;
    });
    return Material(
      child: FancyDrawerWrapper(
        backgroundColor: AppData.BLACK,
        controller: _fancyController,
        drawerItems:  _appDrawerContent(context),
        child:Scaffold(
          
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xffFFFFFF), Color.fromRGBO(255, 255, 255, 0.8)]
              ),
            ),
            child:Column(
              children: <Widget>[
                
                !_finishLoading? Container(
                  height: _height,
                  width: _width,
                  child: Column(
                    children: <Widget>[
                      Splash(splashStateListener: this),
                    ],
                  )
                ):

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
        ),
      )
    );
  }

  @override
  loadingState(bool load) {
    //load news
    //_newsPageState

    //callling news page
    // _newsPageState.currentState.loadNews();
    setState(() {
      _finishLoading = true;
    });
  }


  @override
  homePageActivityClick(HomePageActivity homePageActivity) {
    if(homePageActivity == HomePageActivity.MenuOpen){
      _fancyController.toggle();
      //_scaffoldKey.currentState.openDrawer();
    }
    else if(homePageActivity == HomePageActivity.SavedNewsPageBack){
      _newsPageState.currentState.loadNews();
    }
  }

  @override
  moveToNewsPage(int isDark) {
    setState(() {
      AppData.isDark = isDark;
      _isDark = isDark==1?true:false;
    });
    // _controller.animateTo(_width,duration: Duration(milliseconds: 500), curve: Curves.linear);
  }

  _changeTheme(bool value) async{
    
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

    
    await DBProvider.db.addSystemData(AppData.isDark);
    _newsPageState.currentState.reloadNews();
    // _controller.animateTo(_width,duration: Duration(milliseconds: 500), curve: Curves.linear);
  }

  _shareWithOther(){
    Share.share('Android https://play.google.com/store/apps/details?id='+AppData.appIdAndroid, subject: 'Check This new News App');
  }

  _rateUs(){
    LaunchReview.launch(androidAppId: AppData.appIdAndroid,iOSAppId: AppData.appIdIos);
  }

  _sendMail() async{
    
    var emailAddress = 'mailto:'+AppData.email;

    if(await canLaunch(emailAddress)) {
      await launch(emailAddress);
    }   
  
  }

  //app drawer
  List<Widget> _appDrawerContent(context) {
    return [
      Container(
        // color: AppData.BLACK,
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

      // SizedBox(
      //   height:20
      // ),

      Container(
        // height: _height -170,
        // width: _width,
        
        // color: AppData.isDark == 1? AppData.BLACK: Colors.white,
        child: Column(
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.symmetric(horizontal:20.0),
              child: GestureDetector(
                onTap: (){
                  _rateUs();
                  _fancyController.close();
                  // _scaffoldKey.currentState.openEndDrawer();
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
                            color: AppData.WHITE
                            // color: AppData.isDark == 1? AppData.WHITE : AppData.BLACK,
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
                  _fancyController.close();
                  // _scaffoldKey.currentState.openEndDrawer();
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
                            color: AppData.WHITE
                            // color: AppData.isDark == 1? AppData.WHITE : AppData.BLACK,
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
                  // _scaffoldKey.currentState.openEndDrawer();
                  _fancyController.close();
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
                            color: AppData.WHITE
                            // color: AppData.isDark == 1? AppData.WHITE : AppData.BLACK,
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
                  // _scaffoldKey.currentState.openEndDrawer();
                  _fancyController.close();
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
                          "Saved",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppData.WHITE
                            // color: AppData.isDark == 1? AppData.WHITE : AppData.BLACK,
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
                  // _scaffoldKey.currentState.openEndDrawer();
                  _fancyController.close();
                },
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.add_comment,
                          color: AppData.ALLCOLOR,
                        ),
                        SizedBox(width:40),
                        Text(
                          "Add news",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppData.WHITE
                            // color: AppData.isDark == 1? AppData.WHITE : AppData.BLACK,
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
                  // _scaffoldKey.currentState.openEndDrawer();
                  _fancyController.close();
                },
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.video_label,
                          color: AppData.ALLCOLOR,
                        ),
                        SizedBox(width:40),
                        Text(
                          "YouTube Chanel ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppData.WHITE
                            // color: AppData.isDark == 1? AppData.WHITE : AppData.BLACK,
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
                  // _scaffoldKey.currentState.openEndDrawer();
                  _fancyController.close();
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
                            color: AppData.WHITE
                            // color: AppData.isDark == 1? AppData.WHITE : AppData.BLACK,
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
                              _changeTheme(value);
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