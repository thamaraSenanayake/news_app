import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:news_app/const.dart';

import 'homePageListner.dart';

class SavedNews extends StatefulWidget {
  final HomePageListner homePageActivity;
  SavedNews({Key key, this.homePageActivity}) : super(key: key);

  @override
  _SavedNewsState createState() => _SavedNewsState();
}

class _SavedNewsState extends State<SavedNews> {
  double _height = 0.0;
  double _width = 0.0;
  ScrollController _controller;
  String _title ="Saved News";
  bool _rightArrow = true;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
  }

  _scrollListener() {
    //news scroll to next tab
    if (_controller.position.userScrollDirection == ScrollDirection.reverse) {
      if (_controller.position.pixels >   40 ) {
        _controller.animateTo(_width,duration: Duration(milliseconds: 500), curve: Curves.linear);
        setState(() {
          _title ="Saved Article";
        });
      }
    }
    //news scroll to previous step
    else if (_controller.position.userScrollDirection == ScrollDirection.forward) {
      if (_controller.position.pixels < _width - 40 ) {
        _controller.animateTo(0,duration: Duration(milliseconds: 500), curve: Curves.linear);
        setState(() {
          _title ="Saved News";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _height = MediaQuery.of(context).size.height;
      _width = MediaQuery.of(context).size.width;
    });
    return Container(
      height: _height,
      width: _width,
      child: Column(
        children: <Widget>[
          
          //top bar
          Container(
            height: 80,
            width: _width,
            color: AppData.ALLCOLOR,
            child: Stack(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left:8.0,bottom:5),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: GestureDetector(
                      onTap: (){
                        widget.homePageActivity.homePageActivityClick(HomePageActivity.SavedNewsPAgeback);
                      },
                      child: Card(
                        child: Container(
                          height: 40,
                          width:40,
                          
                          child:Icon(
                            Icons.arrow_back,
                            color: AppData.BLACK,
                          ),
                          decoration: BoxDecoration(
                            color: AppData.WHITE,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom:5.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      _title,
                      style:TextStyle(
                        color: AppData.WHITE,
                        fontSize: 28,
                        fontFamily: "lato",
                        fontWeight: FontWeight.w600
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                !_rightArrow?Padding(
                  padding: const EdgeInsets.only(left:50.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Icon(
                      Icons.arrow_left,
                      color: AppData.WHITE,
                      size: 40,
                    ),
                  )
                ):Container(),

                _rightArrow?Padding(
                  padding: const EdgeInsets.only(bottom:0.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(
                      Icons.arrow_right,
                      color: AppData.WHITE,
                      size: 40,
                    ),
                  )
                ):Container(),

              ],
            ),
            
          ),

          Container(
            width: _width,
            height: _height-80,
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView(
                scrollDirection: Axis.horizontal,
                controller:_controller,
                children: <Widget>[
                  Container(
                    width: _width,
                    height: _height-80,
                    color: Colors.amber,
                  ),
                  Container(
                    width: _width,
                    height: _height-80,
                    color: Colors.blueAccent,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}