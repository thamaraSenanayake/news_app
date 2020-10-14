import 'package:flutter/material.dart';

// enum LanguageList{
//   Sinhala,
//   English,
//   Tamil
// }

enum NewsType{
  Local,
  Foreign,
  Sport,
  Whether,
  AllTop
}

enum TabType{
  News,
  Article
}

enum HomePageActivity{
  MenuOpen,
  SavedNewsPageBack
}

class AppData{
  static const String LOGODARK = 'assets/images/darkLogo.jpg';
  static const String LOGO = 'assets/images/logo.png';
  static const String LOGOLIGHT = 'assets/images/lightLogo.jpg';
  static const String BACKGROUND = 'assets/images/background.jpg';
  static const Color BLACK = Color(0xff393939);
  static const Color DARKGRAY = Color(0xff6B6B6B);
  static const Color GRAY = Color(0xffA0A0A0);
  static const Color WHITE = Color(0xffF9F9F9);
  static const Color ALLCOLOR = Color(0xffE8562B);
  static const Color LOCALCOLOR = Color(0xff9946AA);
  static const Color FORIGNCOLOR = Color(0xff2880F0);
  static const Color SPORTCOLOR = Color(0xffD34274);
  static const Color WEATHERCOLOR = Color(0xffC2D835);

  static int isDark = 0;
  static String appIdAndroid ="";
  static String appIdIos ="";
  static String email ="";
  static String addIdAndroid ="";
}






