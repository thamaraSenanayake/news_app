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