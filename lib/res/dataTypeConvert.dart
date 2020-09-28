import 'package:news_app/const.dart';

NewsType newsTypeCovert(var type){
  NewsType newsType;
  if(type == NewsType.Local.toString()){
    newsType = NewsType.Local; 
  }
  else if(type == NewsType.Foreign.toString()){
    newsType = NewsType.Foreign; 
  }
  else if(type == NewsType.Sport.toString()){
    newsType = NewsType.Sport; 
  }
  else if(type == NewsType.Whether.toString()){
    newsType = NewsType.Whether; 
  }
  else if(type == NewsType.AllTop.toString()){
    newsType = NewsType.AllTop; 
  }
  return newsType;
}