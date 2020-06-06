import 'package:news_app/model/news.dart';

abstract class NewsClickListner{
  clickedNews(News news);
  savedNews(News news);
  clickedArticle(News news);
  savedArticle(News news);
}