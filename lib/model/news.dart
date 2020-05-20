import 'package:news_app/const.dart';

class News{
  final int id;
  final String imgUrl;
  final String titleSinhala;
  final String titleTamil;
  final String titleEnglish;
  final String contentSinhala;
  final String contentTamil;
  final String contentEnglish;
  final String date;
  final String author;
  final int bigNews;
  final int isRead;
  final NewsType type;
  final int timeStamp;

  News( {this.timeStamp, this.id, this.imgUrl,this.titleSinhala, this.titleTamil, this.titleEnglish, this.contentSinhala, this.contentTamil, this.contentEnglish, this.date, this.author, this.bigNews, this.isRead, this.type});
}