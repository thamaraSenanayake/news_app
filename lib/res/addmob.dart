import 'dart:io';

class AddMobSerivce{
  
  String getAppId(){
    if(Platform.isIOS){
      return "ca-app-pub-4827514016608108~6770601600";
    }else{
      return "ca-app-pub-4827514016608108~7352700315";
    }
  }

  String getBannerAddId(){
    if(Platform.isIOS){
      // return "ca-app-pub-4827514016608108/6579029918";
       return "ca-app-pub-3940256099942544/6300978111";
    }else{
      return "ca-app-pub-3940256099942544/6300978111";
      // return "ca-app-pub-4827514016608108/1901418300";
    }
  }

}