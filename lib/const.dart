import 'package:flutter/material.dart';

enum LanguageList{
  Sinhala,
  English,
  Tamil
}

enum NewsType{
  Local,
  Forign,
  Sport,
  Whether,
  AllTop
}

class AppData{
  static const String LOGODARK = 'assets/images/darkLogo.jpg';
  static const String LOGOLIGHT = 'assets/images/lightLogo.jpg';
  static const String BACKGROUND = 'assets/images/background.jpg';
  static const Color BLACK = Color(0xff393939);
  static const Color DARKGRAY = Color(0xff6B6B6B);
  static const Color GRAY = Color(0xffA0A0A0);
  static const Color WHITE = Color(0xffF9F9F9);

  static LanguageList language = LanguageList.Sinhala;
  static int isDark = 0;
}






