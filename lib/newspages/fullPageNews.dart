import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:news_app/const.dart';
import 'package:news_app/database/sqlLitedatabase.dart';
import 'package:news_app/model/news.dart';
import 'package:news_app/res/remaningTime.dart';
import 'package:share/share.dart';


class FullPageNews extends StatefulWidget {
  final News news;
  FullPageNews({Key key,@required this.news}) : super(key: key);

  @override
  listener createState() => listener();
}

class listener extends State<FullPageNews> {
  double _height = 0.0;
  double _width =0.0;
  ScrollController _controller;
  ScrollController _innerController;
  double _slidShowPosition = 0.0;
  int _currentPhoto = 0;
  Color _nextButtonColor = AppData.BLACK;
  Color _backButtonColor = AppData.GRAY;
  double _photoContainerHeight = 300;
  List<Widget> _photoList = [];
  List<Widget> _tabList = [];
  bool _isButtonShow = true;
  bool _isArrowButtonShow = true;
  String fontFamily = "Abhaya";


  _share(){
    String content = "";
    String title = "";
    content = widget.news.contentSinhala;
    title = widget.news.titleSinhala;
    Share.share(content+'\nDownload Online පත්තරේ for more news \nAndroid https://play.google.com/store/apps/details?id='+AppData.appIdAndroid, subject: title);
  }


  _innerControllerListener()
  {
    if (_innerController.position.userScrollDirection == ScrollDirection.reverse) {
      if(_photoContainerHeight > 100){
        setState(() {
          _photoContainerHeight -= 10;
          _isButtonShow = false;
        });
      }
    }
    else if(_innerController.position.userScrollDirection == ScrollDirection.forward){
      if(_photoContainerHeight <= 300){
        setState(() {
          _photoContainerHeight += 10;
        });
      }
      else{
        setState(() {
          _isButtonShow = true;
        });
      }
    }
  }

  //photo scroll listener
  _scrollListener() {
    //photo scroll to next tab
    if (_controller.position.userScrollDirection == ScrollDirection.reverse) {
      if (_controller.position.pixels > _slidShowPosition + 40 && _slidShowPosition < _width*4) {
        _next();
      }
    }
    //photo scroll to previous step
    else if (_controller.position.userScrollDirection == ScrollDirection.forward) {
      if (_controller.position.pixels < _slidShowPosition - 40 && _slidShowPosition > 0) {
        _back();
      }
    }
  }

  _setButtonColor(){
    if(_currentPhoto == 0){
      setState(() {
        _backButtonColor = AppData.GRAY;
        _nextButtonColor = AppData.BLACK;
      });
    }
    else if(_currentPhoto == 2){
      setState(() {
        _backButtonColor = AppData.BLACK;
        _nextButtonColor = AppData.GRAY;
      });
    }
    else{
      setState(() {
        _backButtonColor = AppData.BLACK;
        _nextButtonColor = AppData.BLACK;
      });
    }
  }


  _next(){
    if(_currentPhoto != widget.news.imgUrl.length-1){
      _controller.animateTo(_width + _slidShowPosition,duration: Duration(milliseconds: 500), curve: Curves.linear);
      _slidShowPosition += _width;
      ++_currentPhoto;
      _setButtonColor();
      _tabLoad();
    }
  }

  _back(){
    if(_currentPhoto != 0){
      _controller.animateTo(_slidShowPosition - _width,duration: Duration(milliseconds: 500), curve: Curves.linear);
      _slidShowPosition -= _width;
      --_currentPhoto;
      _setButtonColor();
      _tabLoad();
    }
  }

  _loadPhotos(){
    List<Widget> _photoListTemp =[]; 
    
    for (var item in widget.news.imgUrl) {
      _photoListTemp.add(
        Container(
          height: 300,
          width: _width,
          color: Colors.amber,
          child: CachedNetworkImage(
            fit: BoxFit.cover, 
            imageUrl: item.trim(),
          ),
        ),
      );
    }
    setState(() {
      _photoList = _photoListTemp;
    });
  }

  _tabLoad(){
    List<Widget> _tabListTemp = [];

    if(widget.news.imgUrl.length == 1){
      setState(() {
        _tabList = _tabListTemp;
      });
      return;
    }
    for (var i = 0; i < widget.news.imgUrl.length; i++) {
      _tabListTemp.add(
        Padding(
          padding: EdgeInsets.all(
            2.5
          ),
          child: Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentPhoto == i? AppData.DARKGRAY:AppData.GRAY
            ),
          ),
        )
      );
    }
    setState(() {
      _tabList = _tabListTemp;
    });
  }

  _setNewsAsRead() {
    DBProvider.db.markAsReadNews(widget.news.id.toString());
  }

  @override
  void initState() {
    super.initState();
    
    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    _innerController = ScrollController();
    _innerController.addListener(_innerControllerListener);
    _tabLoad();
    _loadPhotos();
    if(widget.news.imgUrl.length == 1){
      setState(() {
        _isArrowButtonShow = false;
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) { 
      _loadPhotos();
    });
    _setNewsAsRead();

  }


  @override
  Widget build(BuildContext context) {
    setState(() {
      _height = MediaQuery.of(context).size.height;
      _width = MediaQuery.of(context).size.width;
    });
    return Scaffold(
       body: Container(
         height: _height,
         width: _width,
         decoration: BoxDecoration(
          gradient: AppData.isDark == 1? 
            LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppData.BLACK, Color.fromRGBO(0, 0, 0, 0.8)]
            )
          
            :LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xffFFFFFF), Color.fromRGBO(255, 255, 255, 0.8)]
            ),
        ),
         child: Column(
           children: <Widget>[

             //app bar
             Container(
               height: 70,
               width: _width,
               decoration: BoxDecoration(
                  color: AppData.isDark != 1? AppData.WHITE: AppData.BLACK,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.black54,
                        blurRadius: 5.0,
                        offset: Offset(0.0, 0.50)
                    )
                  ],
                ),
               child: Stack(
                 
                 children: <Widget>[
                   Padding(
                     padding: const EdgeInsets.only(left:10.0,bottom:8.0),
                     child: Align(
                       alignment: Alignment.bottomLeft,
                       child: GestureDetector(
                         onTap: (){
                           Navigator.pop(context);
                         },
                         child: Container(
                           child: Icon(
                             Icons.arrow_back,
                             color:AppData.ALLCOLOR,
                             size: 30,
                           ),
                         ),
                       ),
                     ),
                   ),

                   Padding(
                     padding: const EdgeInsets.only(right:10.0,bottom: 10.0),
                     child: Align(
                       alignment: Alignment.bottomRight,
                       child: GestureDetector(
                         onTap: (){
                           _share();
                         },
                         child: Container(
                           child: Icon(
                             Icons.share,
                             color:AppData.ALLCOLOR,
                             size: 28,
                           ),
                         ),
                       ),
                     ),
                   )
                 ],
               ),
             ),
            

            //page container
             Container(
               height: _height -70,
               padding: EdgeInsets.symmetric(horizontal: 3),
               child: MediaQuery.removePadding(
                 context: context,
                 removeTop: true,
                 child: ListView(
                   controller: _innerController,
                   children: <Widget>[
                    
                    //photo slider
                     AnimatedContainer(
                      duration: Duration(milliseconds:1),
                      height: _photoContainerHeight,
                      width: _width,
                      //  color: Colors.amberAccent,
                       child: Stack(
                        children: <Widget>[

                          //photo view
                          AnimatedContainer(
                            duration: Duration(milliseconds:1),
                            height: _photoContainerHeight,
                            width: _width,
                            child: MediaQuery.removePadding(
                              context: context, 
                              removeTop: false,
                              child: ListView(
                                scrollDirection:Axis.horizontal,
                                controller: _controller,
                                children: _photoList,
                              )
                            ),
                          ),

                          //tabView
                          Padding(
                            padding: const EdgeInsets.only(bottom:8.0),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: _tabList,
                              ),
                            ),
                          ),

                          //backButton
                          _isArrowButtonShow && _isButtonShow? Padding(
                            padding: EdgeInsets.only(left:10.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: (){
                                  _back();
                                },
                                child: Card(
                                  child:Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: _backButtonColor,
                                    ),
                                  )
                                ),
                              )
                            ),
                          ):Container(),

                          //forwardButton
                          _isArrowButtonShow && _isButtonShow? Padding(
                            padding:  EdgeInsets.only(left:10.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: (){
                                  _next();
                                },
                                child: Card(
                                  child:Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: _nextButtonColor,
                                    ),
                                  )
                                ),
                              )
                            ),
                          ):Container(),

                        ],
                      ),
                     ),

                     Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: AnimationLimiter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: AnimationConfiguration.toStaggeredList(
                              duration: const Duration(milliseconds: 500),
                              childAnimationBuilder: (widget) => SlideAnimation(
                                horizontalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: widget,
                                ),
                              ),
                              // children: ,
                              children: <Widget>[

                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  widget.news.titleSinhala,
                                  style: TextStyle(
                                    fontFamily: fontFamily,
                                    fontSize: 23,
                                    color:AppData.isDark ==1 ?AppData.WHITE:AppData.BLACK,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(bottom:15.0),
                                child: Text(
                                  TimeCalculator.timeDifferentCalculator(widget.news.date),
                                  style: TextStyle(
                                    letterSpacing:1.5,
                                    wordSpacing:1,
                                    fontFamily: "Lato",
                                    color: AppData.ALLCOLOR
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(bottom:5.0),
                                child: Text(
                                  widget.news.contentSinhala,
                                  style: TextStyle(
                                    letterSpacing:1.8,
                                    wordSpacing:1,
                                    height: 1.5,
                                    fontFamily: fontFamily,
                                    color:AppData.isDark ==1 ?AppData.WHITE: AppData.BLACK,
                                    fontSize: 16
                                  ),
                                  // textAlign: TextAlign.justify,
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top:30.0,bottom: 10.0),
                                child: Text(
                                  'by: '+widget.news.author,
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    color: AppData.ALLCOLOR,
                                    fontWeight: FontWeight.w700
                                  ),
                                ),
                              ),
                              
                            ],
                            ),
                       ),
                      ),
                     ),


                   ],
                 ),
               ),
             )
           ],
         ),

       ),
    );
  }
}