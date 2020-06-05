import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:news_app/const.dart';
import 'package:news_app/model/news.dart';
import 'package:news_app/zoomPage.dart';

class FullPageNews extends StatefulWidget {
  final News news;
  FullPageNews({Key key,@required this.news}) : super(key: key);

  @override
  _FullPageNewsState createState() => _FullPageNewsState();
}

class _FullPageNewsState extends State<FullPageNews> {
  double _height = 0.0;
  double _width =0.0;
  ScrollController _controller;
  ScrollController _innerController;
  double _slidShowPostion = 0.0;
  int _currentPhoto = 0;
  Color _nextButtonColor = AppData.BLACK;
  Color _backButtonColor = AppData.GRAY;
  double _phtoContainerHeight = 300;
  List<Widget> _photoList = [];
  List<Widget> _tabList = [];
  bool _isButtonShow = true;
  bool _isArrowButtonShow = true;

  _innerControllerListener()
  {
    print(_innerController.position.userScrollDirection);
    if (_innerController.position.userScrollDirection == ScrollDirection.reverse) {
      if(_phtoContainerHeight > 100){
        setState(() {
          _phtoContainerHeight -= 10;
          _isButtonShow = false;
        });
      }
    }
    else if(_innerController.position.userScrollDirection == ScrollDirection.forward){
      if(_phtoContainerHeight <= 300){
        setState(() {
          _phtoContainerHeight += 10;
        });
      }
      else{
        setState(() {
          _isButtonShow = true;
        });
      }
    }
  }

  //photo scroll listner
  _scrollListener() {
    //photo scroll to next tab
    if (_controller.position.userScrollDirection == ScrollDirection.reverse) {
      if (_controller.position.pixels > _slidShowPostion + 40 && _slidShowPostion < _width*4) {
        _next();
      }
    }
    //photo scroll to previous step
    else if (_controller.position.userScrollDirection == ScrollDirection.forward) {
      if (_controller.position.pixels < _slidShowPostion - 40 && _slidShowPostion > 0) {
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
      _controller.animateTo(_width + _slidShowPostion,duration: Duration(milliseconds: 500), curve: Curves.linear);
      _slidShowPostion += _width;
      ++_currentPhoto;
      _setButtonColor();
      _tabLoad();
    }
  }

  _back(){
    if(_currentPhoto != 0){
      _controller.animateTo(_slidShowPostion - _width,duration: Duration(milliseconds: 500), curve: Curves.linear);
      _slidShowPostion -= _width;
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
          child: Image.network(
            item,
            fit: BoxFit.cover,
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
    for (var i = 0; i < widget.news.imgUrl.length; i++) {
      _tabListTemp.add(
        Padding(
          padding: EdgeInsets.all(
            2.5
          ),
          child: Container(
            height: 15,
            width: 15,
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
              //  color: Colors.amber,
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: <Widget>[
                   Padding(
                     padding: const EdgeInsets.only(left:10.0,top:8),
                     child: GestureDetector(
                       onTap: (){
                         Navigator.pop(context);
                       },
                       child: Icon(
                         Icons.arrow_back,
                         color:AppData.ALLCOLOR,
                         size: 30,
                       ),
                     ),
                   ),

                   Padding(
                     padding: const EdgeInsets.only(right:10.0),
                     child: Icon(
                       Icons.share,
                       color:AppData.ALLCOLOR,
                       size: 28,
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
                      height: _phtoContainerHeight,
                      width: _width,
                      //  color: Colors.amberAccent,
                       child: Stack(
                        children: <Widget>[

                          //photo view
                          AnimatedContainer(
                            duration: Duration(milliseconds:1),
                            height: _phtoContainerHeight,
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

                          //forwaordButton
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

                          //zoomButton
                          _isButtonShow? Padding(
                            padding:  EdgeInsets.only(right:10.0,bottom: 10.0),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.of(context).push(ZoomPage(image: widget.news.imgUrl[_currentPhoto]));
                                },
                                child: Card(
                                  child:Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Icon(
                                      Icons.zoom_in,
                                      color: AppData.BLACK,
                                    ),
                                  )
                                ),
                              )
                            ),
                          ):Container()
                          
                        ],
                      ),
                     ),

                     Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              widget.news.titleEnglish,
                              style: TextStyle(
                                fontFamily: 'lato',
                                fontSize: 23,
                                color: AppData.BLACK,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(bottom:15.0),
                            child: Text(
                              '1 Sec ago',
                              style: TextStyle(
                                letterSpacing:1.5,
                                wordSpacing:1,
                                fontFamily: 'lato',
                                color: AppData.ALLCOLOR
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(bottom:5.0),
                            child: Text(
                              widget.news.contentEnglish+""+widget.news.contentEnglish+""+widget.news.contentEnglish+""+widget.news.contentEnglish,
                              style: TextStyle(
                                letterSpacing:1.8,
                                wordSpacing:1,
                                height: 1.5,
                                fontFamily: 'lato',
                                color:AppData.isDark ==1 ?AppData.WHITE: AppData.BLACK,
                                fontSize: 16
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top:30.0),
                            child: Text(
                              'by: Xyz',
                              style: TextStyle(
                                fontFamily: 'lato',
                                color: AppData.ALLCOLOR,
                                fontWeight: FontWeight.w700
                              ),
                            ),
                          ),
                           
                         ],
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