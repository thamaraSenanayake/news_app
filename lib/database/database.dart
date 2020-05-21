import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app/const.dart';
import 'package:news_app/model/news.dart';

class Database{
  
  

  //collection refreence 
  final CollectionReference newsCollection = Firestore.instance.collection('news');


  Future addNews(News news) async{
    await newsCollection.document(news.id.toString()).setData({
      "id":news.id,
      "imgUrl":news.imgUrl,
      "titleSinhala":news.titleSinhala,
      "titleTamil":news.titleTamil,
      "titleEnglish":news.titleEnglish,
      "contentSinhala":news.contentSinhala,
      "contentTamil":news.contentTamil,
      "contentEnglish":news.contentEnglish,
      "date":news.date,
      "author":news.author,
      "bigNews":news.bigNews,
      "isRead":news.isRead,
      "type":news.type.toString(),
      "timeStamp":news.timeStamp,
    });
  }

  Future<List<News>> readNews(int lastId) async{
    List<News> newsList = [];
    News news;
    
    QuerySnapshot querySnapshot = await newsCollection.where('id',isGreaterThan:lastId).getDocuments();
    for (var item in querySnapshot.documents) {
      
      NewsType newsType;
          
          if(item["type"] == NewsType.Local.toString()){
            newsType = NewsType.Local; 
          }
          else if(item["type"] == NewsType.Forign.toString()){
            newsType = NewsType.Forign; 
          }
          else if(item["type"] == NewsType.Sport.toString()){
            newsType = NewsType.Sport; 
          }
          else if(item["type"] == NewsType.Whether.toString()){
            newsType = NewsType.Whether; 
          }
          print(item["titleSinhala"]);

          news = News(
            id:item["id"],
            imgUrl:item["imgUrl"],
            titleSinhala:item["titleSinhala"],
            titleTamil:item["titleTamil"],
            titleEnglish:item["titleEnglish"],
            contentSinhala:item["contentSinhala"],
            contentTamil:item["contentTamil"],
            contentEnglish:item["contentEnglish"],
            date:item["date"],
            author:item["author"],
            bigNews:item["bigNews"],
            isRead:item["isRead"],
            type:newsType,
            timeStamp:item["timeStamp"],
          );
          newsList.add(news);
    }

    print(newsList.length);

    return newsList;
  }



}