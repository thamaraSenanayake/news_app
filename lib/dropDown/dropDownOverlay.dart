import 'package:flutter/material.dart';
import 'package:news_app/const.dart';

import 'dropDownListner.dart';

class DropDownOverlay extends ModalRoute<void> {
  final DropDownListner dropDownListner;
  DropDownOverlay({this.dropDownListner});

  @override
  Duration get transitionDuration => Duration(milliseconds: 200);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(BuildContext context,Animation<double> animation,Animation<double> secondaryAnimation,) {
    
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Container(
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right:10.0),
            child: Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white
                    ),
                    shape: BoxShape.circle
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:40.0),
                child: Card(
                  child: GestureDetector(
                    onTap: (){
                      dropDownListner.dropDownClickListner(PageList.AllNews);
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50,
                      child:Center(
                        child: Text(
                          "All news",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "lato",
                            color: AppData.ALLCOLOR,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      )
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal:40.0),
                child: Card(
                  child: GestureDetector(
                    onTap: (){
                      dropDownListner.dropDownClickListner(PageList.Articles);
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50,
                      child:Center(
                        child: Text(
                          "Articles",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "lato",
                            color: AppData.ALLCOLOR,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      )
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal:40.0),
                child: Card(
                  child: GestureDetector(
                    onTap: (){
                      dropDownListner.dropDownClickListner(PageList.Local);
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50,
                      child:Center(
                        child: Text(
                          "Local News",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "lato",
                            color: AppData.ALLCOLOR,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      )
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal:40.0),
                child: Card(
                  child: GestureDetector(
                    onTap: (){
                      dropDownListner.dropDownClickListner(PageList.Forign);
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50,
                      child:Center(
                        child: Text(
                          "Forign News",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "lato",
                            color: AppData.ALLCOLOR,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      )
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal:40.0),
                child: Card(
                  child: GestureDetector(
                    onTap: (){
                      dropDownListner.dropDownClickListner(PageList.Sport);
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50,
                      child:Center(
                        child: Text(
                          "Sports News",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "lato",
                            color: AppData.ALLCOLOR,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      )
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal:40.0),
                child: Card(
                  child: GestureDetector(
                    onTap: (){
                      dropDownListner.dropDownClickListner(PageList.Whether);
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50,
                      child:Center(
                        child: Text(
                          "Weather News",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "lato",
                            color: AppData.ALLCOLOR,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      )
                    ),
                  ),
                ),
              ),

            ],
          ),
          Container()
        ],
      ),
    );
  }

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}