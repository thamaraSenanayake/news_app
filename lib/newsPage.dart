import 'package:flutter/material.dart';
import 'package:news_app/const.dart';

class NewsPage extends StatefulWidget {
  NewsPage({Key key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  double _height = 0.0;
  double _width = 0.0;

  @override
  Widget build(BuildContext context) {
    setState(() {
      _height = MediaQuery.of(context).size.height;
      _width = MediaQuery.of(context).size.width;
    });

    return Container(
      height: _height,
      width: _width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xffFFFFFF), Color.fromRGBO(255, 255, 255, 0.8)]
        ),
      ),
      child: Column(
        children: <Widget>[

          //top bar
          Container(
            height: 100,
            width: _width,
            child: Stack(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left:8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 50,
                      width:50,
                      child:Icon(
                        Icons.menu,
                        color: AppData.BLACK,
                      ),
                      decoration: BoxDecoration(
                        color: AppData.WHITE,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(right:8.0,top:20.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child:Container(
                      width:80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Local",
                            style:TextStyle(
                              color: Colors.blue,
                              fontSize: 18,
                              fontFamily: "lato",
                            )
                          ),
                          SizedBox(
                            width:5
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.blue,
                          )
                        ],
                      ),
                    ),
                  )
                ),

                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "All News",
                    style:TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontFamily: "lato",
                    ),
                    textAlign: TextAlign.center,
                  ),
                )


              ],
            ),
            decoration: BoxDecoration(
              color: AppData.BLACK,
              boxShadow: [
                // BoxShadow(
                //   color: Colors.grey,
                //   blurRadius: 2.0,
                //   spreadRadius: 2.0, 
                //   offset: Offset(
                //     1.0,
                //     2.0,
                //   ),
                // )
              ],
            ),
          ),

          //news container
          Container(
            width: _width,
            height: _height-100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                
                //all news 
                Container(
                  width: _width,
                  height: _height-100,

                  child: Column(
                    children: <Widget>[

                      //Top news
                      Container(
                        height:250,
                        width: _width,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height:250,
                              width: _width,
                              padding: EdgeInsets.all(3),
                              child: Image.network(
                                "https://ichef.bbci.co.uk/news/490/cpsprodpb/14C2E/production/_112383058_mediaitem112383057.jpg",
                                fit: BoxFit.cover,
                              ),
                            ),

                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.only(left:3,right:3),
                                child: Container(
                                  height:50,
                                  width: _width-6,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [AppData.BLACK.withOpacity(0.8), Color.fromRGBO(255, 255, 255, 0.0)]
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal:10.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "News title News title News title News title",
                                          style:TextStyle(
                                            color: AppData.WHITE,
                                            fontSize: 20,
                                            fontFamily: "lato",
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                        Container(
                                          width: _width-6,
                                          child: Text(
                                            "1 S ago",
                                            style:TextStyle(
                                              color: Colors.orange,
                                              fontSize: 12,
                                              fontFamily: "lato",
                                            ),
                                            textAlign: TextAlign.right,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
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
                      )
                    ],
                  ),
                )
              ],
            ),
          )

        ],
      ),
    );
  }
}