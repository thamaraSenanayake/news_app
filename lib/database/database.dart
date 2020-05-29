import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app/const.dart';
import 'package:news_app/model/news.dart';
import 'package:news_app/res/dataTypeConvert.dart';

class Database{
  
  
  //collection refreence 
  final CollectionReference newsCollection = Firestore.instance.collection('news');
  final CollectionReference hotNewsCollection = Firestore.instance.collection('hotNews');
  final CollectionReference systemData = Firestore.instance.collection('systemData');


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

  Future addHotNews(News news, NewsType type) async{
    await hotNewsCollection.document(type.toString()).setData({
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

  Future<int> getNewsCount() async{
    int newsCount = 0;

    await systemData.document('news').get().then((document){
      newsCount = document['newsCount'];
    });

    return newsCount;

  }

  Future<List<News>> readNews(int lastId) async{
    List<News> newsList = [];
    News news;
    
    QuerySnapshot querySnapshot = await newsCollection.where('id',isGreaterThan:lastId).getDocuments();
    for (var item in querySnapshot.documents) {
      

      List imageList = item["imgUrl"];
      List<String> imageListString = imageList.cast<String>().toList();
          

      news = News(
        id:item["id"],
        imgUrl:imageListString,
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
        type:newsTypeCovert(item["type"]),
        timeStamp:item["timeStamp"],
      );
      newsList.add(news);
    }

    print(newsList.length);

    return newsList;
  }

  Future<List<News>> readHotNews() async{
    List<News> newsList = [];
    News news;
    List imageList = [];
    List<String> imageListString = [];
    
    QuerySnapshot querySnapshot = await hotNewsCollection.getDocuments();
    for (var item in querySnapshot.documents) {
      List imageList = item["imgUrl"];
      List<String> imageListString = imageList.cast<String>().toList();
    
      news = News(
        id:item["id"],
        imgUrl:imageListString,
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
        type:newsTypeCovert(item["type"]),
        timeStamp:item["timeStamp"],
      );
      newsList.add(news);
    }

    print(newsList.length);

    return newsList;
  }



}