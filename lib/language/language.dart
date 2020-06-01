import 'package:flutter/material.dart';
import 'package:news_app/const.dart';
import 'languageListner.dart';

class Language extends StatefulWidget {
  final LanguageStateListner languageStateListner;
  final bool loading;
  Language({Key key,@required this.languageStateListner, this.loading}) : super(key: key);

  @override
  _LanguageState createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  double _height = 0.0;
  double _width = 0.0;
  List<int> _colorList = [1,0,0];
  LanguageList selectedLanguage;
  

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setPageHeight();
    });
  }

  _setPageHeight(){
    print("set height language");
  }

  

  @override
  Widget build(BuildContext context) {
    setState(() {
      _height = MediaQuery.of(context).size.height;
      _width = MediaQuery.of(context).size.width;
    });

    return Container(
      height: _height,
      width:_width,
      child: Stack(
        children: <Widget>[
          
          Container(
            height: _height,
            width:_width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                //sinhala
                GestureDetector(
                  onTap: (){
                    setState(() {
                      _colorList = [1,0,0];
                    });
                    selectedLanguage =  LanguageList.Sinhala;
                  },
                  child: Container(
                    child:Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Sinhala",
                            style: TextStyle(
                              color: _colorList[0] == 1? AppData.ALLCOLOR:AppData.BLACK,
                              fontFamily: "Lato",
                              fontSize: 20,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(right:15.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.check,
                              color: _colorList[0] == 1? AppData.ALLCOLOR:AppData.WHITE,
                              size:25
                            ),
                          ),
                        ),
                      ],
                    ),
                    width:_width-80,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _colorList[0] != 1? AppData.WHITE:AppData.BLACK,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2.0,
                          spreadRadius: 2.0, 
                          offset: Offset(
                            1.0,
                            2.0,
                          ),
                        )
                      ],
                      borderRadius: BorderRadius.circular(3)
                    ),
                  ),
                ),

                SizedBox(
                  height:20
                ),

                //tamil
                GestureDetector(
                  onTap: (){
                    setState(() {
                      _colorList = [0,1,0];
                    });
                    selectedLanguage =  LanguageList.Tamil;
                  },
                  child: Container(
                    child:Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Tamil",
                            style: TextStyle(
                              color: _colorList[1] == 1? AppData.ALLCOLOR:AppData.BLACK,
                              fontFamily: "Lato",
                              fontSize: 20,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(right:15.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.check,
                              color: _colorList[1] == 1? AppData.ALLCOLOR:AppData.WHITE,
                              size:25
                            ),
                          ),
                        ),
                      ],
                    ),
                    width:_width-80,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _colorList[1] != 1? AppData.WHITE:AppData.BLACK,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2.0,
                          spreadRadius: 2.0, 
                          offset: Offset(
                            1.0,
                            2.0,
                          ),
                        )
                      ],
                      borderRadius: BorderRadius.circular(3)
                    ),
                  ),
                ),
                
                SizedBox(
                  height:20
                ),
                
                //English
                GestureDetector(
                  onTap: (){
                    setState(() {
                      _colorList = [0,0,1];
                    });
                    selectedLanguage =  LanguageList.English;
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds:200),
                    child:Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "English",
                            style: TextStyle(
                              color: _colorList[2] == 1? AppData.ALLCOLOR:AppData.BLACK,
                              fontFamily: "Lato",
                              fontSize: 20,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(right:15.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.check,
                              color: _colorList[2] == 1? AppData.ALLCOLOR:AppData.WHITE,
                              size:25
                            ),
                          ),
                        ),
                      ],
                    ),
                    width:_width-80,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _colorList[2] != 1? AppData.WHITE:AppData.BLACK,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2.0,
                          spreadRadius: 2.0, 
                          offset: Offset(
                            1.0,
                            2.0,
                          ),
                        )
                      ],
                      borderRadius: BorderRadius.circular(3)
                    ),
                  ),
                )
                
              ],
            ),
          ),


          //counitune 
          Padding(
            padding: const EdgeInsets.only(bottom:20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: (){
                  widget.languageStateListner.languageState(selectedLanguage);
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds:200),
                  child:Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Countinue",
                      style: TextStyle(
                        color: AppData.ALLCOLOR,
                        fontFamily: "Lato",
                        fontSize: 20,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                  width:_width-80,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppData.BLACK,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 2.0,
                        spreadRadius: 2.0, 
                        offset: Offset(
                          1.0,
                          2.0,
                        ),
                      )
                    ],
                    borderRadius: BorderRadius.circular(3)
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}