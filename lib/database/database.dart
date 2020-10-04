import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app/const.dart';
import 'package:news_app/model/news.dart';
import 'package:news_app/model/newsAdd.dart';
import 'package:news_app/res/dataTypeConvert.dart';

class Database{
  
  
  //collection refreence 
  final CollectionReference newsCollection = Firestore.instance.collection('news');
  final CollectionReference userNewsCollection = Firestore.instance.collection('userNews');
  final CollectionReference articleCollection = Firestore.instance.collection('article');
  final CollectionReference hotNewsCollection = Firestore.instance.collection('hotNews');
  final CollectionReference systemData = Firestore.instance.collection('systemData');


  Future addNews(NewNews news) async{
    await userNewsCollection.document(DateTime.now().microsecond.toString()).setData({
      "id":DateTime.now().microsecond.toString(),
      "name":news.name,
      "contactNm":news.contactNm,
      "content":news.content,
      "imageList":news.imageList,
      "timeStamp":DateTime.now().microsecond.toString(),
    });
  }

  Future<int> getNewsCount() async{
    int newsCount = 0;

    await systemData.document('news').get().then((document){
      newsCount = document['newsCount'];
    });

    return newsCount;

  }

  Future<int> getSystemData() async{
    int done = 0;

    await systemData.document('news').get().then((document){
      AppData.email = document['email'];
      AppData.appIdIos = document['appIdIos'];
      AppData.appIdAndroid = document['appIdAndriod'];
      done = 1;
    });

    return done;

  }

  Future<int> getArticaleCount() async{
    int articaleCount = 0;

    await systemData.document('news').get().then((document){
      articaleCount = document['articaleCount'];
    });

    return articaleCount;

  }

  Future<String> updateNewsCount(int newId) async{
    

    await systemData.document('news').updateData({
      'newsCount':newId
    });

    return 'done';

  }

  Future<String> updateArticaleCount(int newId) async{

    await systemData.document('news').updateData({
      'articaleCount':newId
    });

    return "done";

  }

  Future<List<News>> readNews(int lastId) async{
    List<News> newsList = [];
    News news;
    QuerySnapshot querySnapshot;

    int timestamp = DateTime.now().subtract(Duration(days:30)).millisecondsSinceEpoch;

    if(lastId == 0){
      querySnapshot = await newsCollection.where('timeStamp',isGreaterThan:timestamp).getDocuments();
    }else{
      querySnapshot = await newsCollection.where('id',isGreaterThan:lastId).getDocuments();
    }
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
        type:newsTypeCovert(item["type"]),
        timeStamp:item["timeStamp"],
      );
      newsList.add(news);
    }

    

    return newsList;
  }

  Future<List<int>> deleteArticles() async{
    
    List<int> deleteArticleIdList = [];

    await systemData.document('deleteArticles').get().then((document){
      if(document['id'] != null){
        deleteArticleIdList = (document['id'] as List<dynamic>).cast<int>();
      }
    });
    
    return deleteArticleIdList;

  }

  Future<List<int>> deleteNews() async{
    
    List<int> deleteNewsIdList = [];

    await systemData.document('deleteNews').get().then((document){
      if(document['id'] != null){
        deleteNewsIdList = (document['id'] as List<dynamic>).cast<int>();
      }
    });
    
    return deleteNewsIdList;

  }

  Future<List<News>> readArticles(int lastId) async{
    List<News> articleList = [];
    News article;
    
    QuerySnapshot querySnapshot = await articleCollection.where('id',isGreaterThan:lastId).getDocuments();
    for (var item in querySnapshot.documents) {
      

      List imageList = item["imgUrl"];
      List<String> imageListString = imageList.cast<String>().toList();
          

      article = News(
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
        type:newsTypeCovert(item["type"]),
        timeStamp:item["timeStamp"],
      );
      articleList.add(article);
    }

    

    return articleList;
  }

  Future<List<News>> readHotNews() async{
    List<News> newsList = [];
    News news;
    
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

    

    return newsList;
  }




}