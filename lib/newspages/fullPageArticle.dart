import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:news_app/const.dart';
import 'package:news_app/database/sqlLitedatabase.dart';
import 'package:news_app/model/news.dart';
import 'package:news_app/res/remaningTime.dart';
import 'package:share/share.dart';


class FullPageArticle extends StatefulWidget {
  final News article;
  FullPageArticle({Key key,@required this.article}) : super(key: key);

  @override
  _FullPageArticleState createState() => _FullPageArticleState();
}

class _FullPageArticleState extends State<FullPageArticle> {
  double _height = 0.0;
  double _width =0.0;
  List<Widget> _displayArticle = [];
  String title ='';
  List<String> contentList = [];
  String fontFamily ="Lato";



  @override
  void initState() {
    super.initState();
    if(AppData.language == LanguageList.Sinhala){
      fontFamily = "Abhaya";
    }
    else if(AppData.language == LanguageList.Tamil){
      fontFamily = "HindMadurai";
    }
    else{
      fontFamily = "Lato";
    }
    _loadArticle();
    _setArticleAsRead();
  }

  _setArticleAsRead(){
    DBProvider.db.markAsReadArticale(widget.article.id.toString());
  }

  _loadArticle(){
    List<Widget> _displayArticleTemp = [];
    String content = '';
    
    if(AppData.language == LanguageList.Sinhala){
      content = widget.article.contentSinhala;
      title= widget.article.titleSinhala;
    }
    else if(AppData.language == LanguageList.Tamil){
      content = widget.article.contentTamil;
      title= widget.article.titleTamil;
    }
    else {
      content = widget.article.contentEnglish;
      title= widget.article.titleEnglish;
    }

    contentList= content.split("[PICTURE]");

    int currentPhoto =0;
    for (var item in contentList) {
      
      _displayArticleTemp.add(
        Container(
          height: 300,
          width: _width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            image: DecorationImage(
              image: CachedNetworkImageProvider(widget.article.imgUrl[currentPhoto].trim()),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
      currentPhoto++;

      if(contentList.indexOf(item)==0){

        _displayArticleTemp.add(
          SizedBox(
            height:15
          )
        );
        
        _displayArticleTemp.add(
          Padding(
             padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
            child: Text(
              title,
              style: TextStyle(
                fontFamily: fontFamily,
                fontSize: 23,
                color: AppData.isDark == 1? AppData.WHITE: AppData.BLACK,
                fontWeight: FontWeight.w600
              ),
            ),
          ),                 
        );

        _displayArticleTemp.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "by: "+widget.article.author,
              style: TextStyle(
                letterSpacing:1.5,
                wordSpacing:1,
                fontFamily: 'Lato',
                color: AppData.BLACK
              ),
            ),
          ),
        );

        _displayArticleTemp.add(
          Padding(
            padding: const EdgeInsets.only(bottom:15.0,left:10,right:10),
            child: Text(
              TimeCalculater.timeDifferentCalculator(widget.article.date),
              style: TextStyle(
                letterSpacing:1.5,
                wordSpacing:1,
                fontFamily: 'Lato',
                color: AppData.ALLCOLOR
              ),
            ),
          ),
        );
      }

      _displayArticleTemp.add(
        Padding(
          padding: const EdgeInsets.only(bottom:5.0,left:20,right:20),
          child: Text(
            item,
            style: TextStyle(
              letterSpacing:1.8,
              wordSpacing:1,
              height: 1.5,
              fontFamily: fontFamily,
              color:AppData.isDark ==1 ?AppData.WHITE: AppData.BLACK,
              fontSize: 17
            ),
            textAlign: TextAlign.justify,
          ),
        ),
      );
      
    }

    setState(() {
      _displayArticle = _displayArticleTemp;
    });

  }

  _share(){
    Share.share(contentList.toString()+'\nDownload Online පත්තරේ for more news \nAndriod https://play.google.com/store/apps/details?id='+AppData.appIdAndriod+' \niOS https://apps.apple.com/us/app/clash-of-clans/id'+AppData.appIdIos+'', subject: title);
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
               child: Stack(
                 
                 children: <Widget>[
                   Align(
                     alignment: Alignment.bottomLeft,
                     child: Padding(
                       padding: const EdgeInsets.only(left:10.0,bottom:10),
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
                   ),

                   Align(
                     alignment: Alignment.bottomRight,
                     child: Padding(
                       padding: const EdgeInsets.only(right:10.0,bottom:10),
                       child: GestureDetector(
                         onTap: (){
                           _share();
                         },
                         child: Icon(
                           Icons.share,
                           color:AppData.ALLCOLOR,
                           size: 28,
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
                  children: _displayArticle
                ),
              )
            ),

          ]
        )
      ),
    );
  }
}