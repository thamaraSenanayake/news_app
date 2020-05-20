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
  double _pageHeight = 0.0;
  

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setPageHeight();
    });
  }

  _setPageHeight(){
    print("set height language");
    if(widget.loading){
      setState(() {
        _pageHeight = _height;
      });
    }
  }

  

  @override
  Widget build(BuildContext context) {
    setState(() {
      _height = MediaQuery.of(context).size.height;
      _width = MediaQuery.of(context).size.width;
    });

    return SingleChildScrollView(
      child: AnimatedContainer(
        height: _pageHeight,
        width: _width,
        duration: Duration(milliseconds: 500),
        color: Colors.red,
        child: Stack(
          children: <Widget>[

            
        

          ],
        ),
      ),
    );
  }
}