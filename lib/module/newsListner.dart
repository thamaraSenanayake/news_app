import 'package:news_app/model/news.dart';

abstract class NewsClickListner{
  clickedNews(News news);
  savedNews(News news);
}