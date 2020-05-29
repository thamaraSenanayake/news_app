import 'package:news_app/const.dart';

LanguageList languageConvert(var language){
  if(language == LanguageList.English){
    return LanguageList.English;
  }
  else if(language == LanguageList.Sinhala){
    return LanguageList.Sinhala;
  }
  else{
    return LanguageList.Tamil;
  }
}

NewsType newsTypeCovert(var type){
  NewsType newsType;
  if(type == NewsType.Local.toString()){
    newsType = NewsType.Local; 
  }
  else if(type == NewsType.Forign.toString()){
    newsType = NewsType.Forign; 
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