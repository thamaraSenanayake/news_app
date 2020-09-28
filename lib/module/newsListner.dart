import 'package:news_app/model/news.dart';

abstract class NewsClickListener{
  clickedNews(News news);
  savedNews(News news);
  clickedArticle(News news);
  savedArticle(News news);
}