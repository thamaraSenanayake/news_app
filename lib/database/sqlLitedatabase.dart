import 'dart:async';
import 'dart:io';
import 'package:news_app/const.dart';
import 'package:news_app/model/news.dart';
import 'package:news_app/model/systemInfo.dart';
import 'package:news_app/res/dataTypeConvert.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  //check database avalablity
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    } else {
      //if _database is null, instantiate it
      _database = await initDB();
      return _database;
    }
  }

  databaseAvailability() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "news7.db");
    bool avalablity = await databaseFactory.databaseExists(path);

    return avalablity;
  }

  //create the databse in app Directory
  initDB() async {
    
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "news7.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE News ("
          "id INTEGER PRIMARY KEY,"
          "imgUrl TEXT NOT NULL,"
          "titleSinhala TEXT NOT NULL,"
          "titleEnglish TEXT NOT NULL,"
          "titleTamil TEXT NOT NULL,"
          "contentSinhala TEXT NOT NULL,"
          "contentEnglish TEXT NOT NULL,"
          "contentTamil TEXT NOT NULL,"
          "date TEXT NOT NULL,"
          "author TEXT NOT NULL,"
          "bigNews INTEGER NOT NULL,"
          "isRead INTEGER NOT NULL,"
          "isSaved INTEGER NOT NULL,"
          "type TEXT NOT NULL,"
          "timeStamp INTEGER NOT NULL"
          ")");
      

      await db.execute("CREATE TABLE HotNews ("
          "type TEXT PRIMARY KEY,"
          "id INTEGER NOT NULL,"
          "imgUrl TEXT NOT NULL,"
          "titleSinhala TEXT NOT NULL,"
          "titleEnglish TEXT NOT NULL,"
          "titleTamil TEXT NOT NULL,"
          "contentSinhala TEXT NOT NULL,"
          "contentEnglish TEXT NOT NULL,"
          "contentTamil TEXT NOT NULL,"
          "date TEXT NOT NULL,"
          "author TEXT NOT NULL,"
          "bigNews INTEGER NOT NULL,"
          "isRead INTEGER NOT NULL,"
          "isSaved INTEGER NOT NULL,"
          "timeStamp INTEGER NOT NULL"
          ")");

        await db.execute("CREATE TABLE Articale ("
          "id INTEGER PRIMARY KEY,"
          "imgUrl TEXT NOT NULL,"
          "titleSinhala TEXT NOT NULL,"
          "titleEnglish TEXT NOT NULL,"
          "titleTamil TEXT NOT NULL,"
          "contentSinhala TEXT NOT NULL,"
          "contentEnglish TEXT NOT NULL,"
          "contentTamil TEXT NOT NULL,"
          "date TEXT NOT NULL,"
          "author TEXT NOT NULL,"
          "isRead INTEGER NOT NULL,"
          "isSaved INTEGER NOT NULL"
          ")");
        
      await db.execute("CREATE TABLE SystemInfo ("
          "langId TEXT NOT NULL,"
          "isDark INTEGER NOT NULL"
          ")");
    });
  }

  // add system to sql lite
  addSystemData(int isDark) async {
    final db = await database;
    var res = 'done';
    

    try {
      await db.execute("DELETE FROM `SystemInfo`");
      await db.execute("INSERT INTO SystemInfo (langId, isDark)VALUES ('" +
          "LanguageList.Sinhala" +
          "','" +
          isDark.toString() +
          "')");
    } catch (e) {
      
      return e.toString();
    }

    return res;
  }

  // get system to sql lite
  Future<SystemInfo> getSystemData() async {
    final db = await database;
    SystemInfo systemInfo;

    try {
      var res = await db.query("SystemInfo");
      for (var item in res) {

        
        systemInfo = SystemInfo(
          isDrak:item["isDark"],
        );
      }
      
    } catch (e) {
      print(e);
      
    }

    return systemInfo;
  }

  // add news to sql lite
  addNewsData(List<News> newsList) async {
    
  
    final db = await database;
    var res = 'done';
    String sql =
        "INSERT INTO News (id ,imgUrl,titleSinhala,titleEnglish,titleTamil,contentSinhala,contentEnglish,contentTamil,date,author,bigNews,isRead,type,timeStamp,isSaved)VALUES ";

    for (var item in newsList) {

      sql += "(" +
          item.id.toString() +
          ",'" +
          item.imgUrl.toString() +
          "','" +
          item.titleSinhala.replaceAll('\'', "*") +
          "','" +
          item.titleEnglish.replaceAll('\'', "*") +
          "','" +
          item.titleTamil.replaceAll('\'', "*") +
          "','" +
          item.contentSinhala.replaceAll('\'', "*") +
          "','" +
          item.contentEnglish.replaceAll('\'', "*") +
          "','" +
          item.contentTamil.replaceAll('\'', "*") +
          "','" +
          item.date +
          "','" +
          item.author +
          "'," +
          item.bigNews.toString() +
          ",0,'" +
          item.type.toString() +
          "'," +
          item.timeStamp.toString() +
          ",0" +
          ")";
      if (newsList.indexOf(item) != newsList.length - 1) {
        sql += ",";
      }
    }

    try {
      await db.execute(sql);
    } catch (e) {
      print(e);
      return e.toString();
    }

    return res;
  }

  deleteNews(List<int> delteList) async {
    final db = await database;
    var res = 'done';

    try {
      for (var item in delteList) {
        
        await db.execute("DELETE FROM `News` where id = "+item.toString());
      }

    } catch (e) {
      print(e);
      return e.toString();
    }

    return res;
  }


  // add hot news to sql lite
  addHotNewsData(List<News> newsList) async {
    
    
  
    final db = await database;
    var res = 'done';
    String sql =
        "REPLACE INTO HotNews (id ,imgUrl,titleSinhala,titleEnglish,titleTamil,contentSinhala,contentEnglish,contentTamil,date,author,bigNews,isRead,type,timeStamp,isSaved)VALUES ";

    for (var item in newsList) {

      sql += "(" +
          item.id.toString() +
          ",'" +
          item.imgUrl.toString() +
          "','" +
          item.titleSinhala.replaceAll('\'', "*") +
          "','" +
          item.titleEnglish.replaceAll('\'', "*") +
          "','" +
          item.titleTamil.replaceAll('\'', "*") +
          "','" +
          item.contentSinhala.replaceAll('\'', "*") +
          "','" +
          item.contentEnglish.replaceAll('\'', "*") +
          "','" +
          item.contentTamil.replaceAll('\'', "*") +
          "','" +
          item.date +
          "','" +
          item.author +
          "'," +
          item.bigNews.toString() +
          "," +
          0.toString() +
          ",'" +
          item.type.toString() +
          "'," +
          item.timeStamp.toString() +
          ",0" +
          ")";
      if (newsList.indexOf(item) != newsList.length - 1) {
        sql += ",";
      }
    }

    try {
      await db.execute(sql);
    } catch (e) {
      print(e);
      return e.toString();
    }

    return res;
  }

  // add Articale to sql lite
  addArticleData(List<News> newsList) async {
    
  
    final db = await database;
    var res = 'done';
    String sql =
        "INSERT INTO Articale (id ,imgUrl,titleSinhala,titleEnglish,titleTamil,contentSinhala,contentEnglish,contentTamil,date,author,isRead,isSaved)VALUES ";

    for (var item in newsList) {

      sql += "(" +
          item.id.toString() +
          ",'" +
          item.imgUrl.toString() +
          "','" +
          item.titleSinhala.toString().replaceAll('\'', "*") +
          "','" +
          item.titleEnglish.toString().replaceAll('\'', "*") +
          "','" +
          item.titleTamil.toString().replaceAll('\'', "*") +
          "','" +
          item.contentSinhala.toString().replaceAll('\'', "*") +
          "','" +
          item.contentEnglish.toString().replaceAll('\'', "*") +
          "','" +
          item.contentTamil.toString().replaceAll('\'', "*") +
          "','" +
          item.date +
          "','" +
          item.author +
          "'," +
          0.toString() +
          "," +
          0.toString() +
          ")";
      if (newsList.indexOf(item) != newsList.length - 1) {
        sql += ",";
      }
    }

    try {
      await db.execute(sql);
    } catch (e) {
      print(e);
      return e.toString();
    }

    return res;
  }

  deleteArticle(List<int> delteList) async {
    final db = await database;
    var res = 'done';

    try {
      for (var item in delteList) {
        await db.execute("DELETE FROM `Articale` where id = "+item.toString());
      }

    } catch (e) {
      print(e);
      return e.toString();
    }

    return res;
  }

  


  // get last insert news
  Future<int> getLastNewsId() async {
    final db = await database;
    var reply = 0;
    try {
      var res = await db.rawQuery("SELECT id FROM News ORDER BY id DESC LIMIT 1");
      for (var item in res) {
          reply = item['id'];
      }
    } catch (e) {
      print(e.toString());
      // return e.toString();
    }
    return reply;
  }


  // get last insert Articale
  Future<int> getLastArticleId() async {
    final db = await database;
    var reply = 0;
    try {
      var res = await db.rawQuery("SELECT id FROM Articale ORDER BY id DESC LIMIT 1");
      for (var item in res) {
          reply = item['id'];
      }
    } catch (e) {
      print(e.toString());
      // return e.toString();
    }
    return reply;
  }


  //delete news older than 7 days
  deleteOldNews() async{
    final db = await database;
    var res = "done";
    var date = new DateTime.now().subtract(Duration(days:7));
    try {
      await db.execute("DELETE FROM `news` WHERE isSaved = 0 and timeStamp  <" + date.toString().split(" ")[0]);
    } catch (e) {
      print(e);
      return e.toString();
    }

    return res;
  }

  Future<List<News>> viewNews() async{
    final db = await database;
    List<News> newsList = [];
    News news;
    String imageList = "";
    int timestamp = DateTime.now().subtract(Duration(days:7)).millisecondsSinceEpoch;
    
    try {
      var res = await db.query("News",orderBy:'id DESC',where: 'timeStamp >'+timestamp.toString());
      for (var item in res) {
        //remove brackets
        imageList = item["imgUrl"].toString().replaceAll("[", "");
        imageList = imageList.replaceAll("]", "");
        
        news = News(
          id:item["id"],
          imgUrl:imageList.split(","),
          titleSinhala:item["titleSinhala"].replaceAll('*', "\'"),
          titleTamil:item["titleTamil"].replaceAll('*', "\'"),
          titleEnglish:item["titleEnglish"].replaceAll('*', "\'"),
          contentSinhala:item["contentSinhala"].replaceAll('*', "\'"),
          contentTamil:item["contentTamil"].replaceAll('*', "\'"),
          contentEnglish:item["contentEnglish"].replaceAll('*', "\'"),
          date:item["date"],
          author:item["author"],
          bigNews:item["bigNews"],
          isRead:item["isRead"],
          type:newsTypeCovert(item["type"]),
          timeStamp:item["timeStamp"],
          isSaved: item["isSaved"],
        );
        newsList.add(news);
        
      }
    } catch (e) {
      print(e.toString());
      // return e.toString();
    }
    return newsList;
  }

  Future<List<News>> viewSavedNews() async{
    final db = await database;
    List<News> newsList = [];
    News news;
    String imageList = "";
    
    
    try {
      var res = await db.query("News",orderBy:'id DESC',where:"isSaved = 1"  );
      for (var item in res) {
        //remove brackets
        imageList = item["imgUrl"].toString().replaceAll("[", "");
        imageList = imageList.replaceAll("]", "");

        news = News(
          id:item["id"],
          imgUrl:imageList.split(","),
          titleSinhala:item["titleSinhala"].replaceAll('*', "\'"),
          titleTamil:item["titleTamil"].replaceAll('*', "\'"),
          titleEnglish:item["titleEnglish"].replaceAll('*', "\'"),
          contentSinhala:item["contentSinhala"].replaceAll('*', "\'"),
          contentTamil:item["contentTamil"].replaceAll('*', "\'"),
          contentEnglish:item["contentEnglish"].replaceAll('*', "\'"),
          date:item["date"],
          author:item["author"],
          bigNews:item["bigNews"],
          isRead:item["isRead"],
          type:newsTypeCovert(item["type"]),
          timeStamp:item["timeStamp"],
          isSaved: item["isSaved"],
        );
        newsList.add(news);
        
      }
    } catch (e) {
      print(e.toString());
      // return e.toString();
    }
    return newsList;
  }

  Future<List<News>> viewArticle() async{
    final db = await database;
    List<News> newsList = [];
    News news;
    String imageList = "";
    
    try {
      var res = await db.query("Articale",orderBy: "isRead ASC ,id DESC");
      for (var item in res) {
        imageList = item["imgUrl"].toString().replaceAll("[", "");
        imageList = imageList.replaceAll("]", "");
        news = News(
          id:item["id"],
          imgUrl:imageList.split(","),
          titleSinhala:item["titleSinhala"].replaceAll('*', "\'"),
          titleTamil:item["titleTamil"].replaceAll('*', "\'"),
          titleEnglish:item["titleEnglish"].replaceAll('*', "\'"),
          contentSinhala:item["contentSinhala"].replaceAll('*', "\'"),
          contentTamil:item["contentTamil"].replaceAll('*', "\'"),
          contentEnglish:item["contentEnglish"].replaceAll('*', "\'"),
          date:item["date"],
          author:item["author"],
          isRead:item["isRead"],
          isSaved: item["isSaved"],
        );
        newsList.add(news);
      }
    } catch (e) {
      print(e.toString());
      // return e.toString();
    }
    return newsList;
  }


  //view saved articale
  Future<List<News>> viewSavedArticle() async{
    final db = await database;
    List<News> newsList = [];
    News news;
    String imageList = "";
    
    try {
      var res = await db.query("Articale",orderBy: "isRead ASC , id DESC",where: "isSaved = 1");
      for (var item in res) {
        imageList = item["imgUrl"].toString().replaceAll("[", "");
        imageList = imageList.replaceAll("]", "");
        news = News(
          id:item["id"],
          imgUrl:imageList.split(","),
          titleSinhala:item["titleSinhala"].replaceAll('*', "\'"),
          titleTamil:item["titleTamil"].replaceAll('*', "\'"),
          titleEnglish:item["titleEnglish"].replaceAll('*', "\'"),
          contentSinhala:item["contentSinhala"].replaceAll('*', "\'"),
          contentTamil:item["contentTamil"].replaceAll('*', "\'"),
          contentEnglish:item["contentEnglish"].replaceAll('*', "\'"),
          date:item["date"],
          author:item["author"],
          isRead:item["isRead"],
          isSaved: item["isSaved"],
        );
        newsList.add(news);
        
      }
    } catch (e) {
      print(e.toString());
      // return e.toString();
    }
    return newsList;
  }

  Future<List<News>> viewHotNews() async{
    final db = await database;
    List<News> newsList = [];
    News news;
    String imageList = "";
    
    try {
      var res = await db.query("HotNews");
      for (var item in res) {

        //remove brackets
        imageList = item["imgUrl"].toString().replaceAll("[", "");
        imageList = imageList.replaceAll("]", "");
        
        news = News(
          id:item["id"],
          imgUrl:imageList.split(","),
          titleSinhala:item["titleSinhala"].replaceAll('*', "\'"),
          titleTamil:item["titleTamil"].replaceAll('*', "\'"),
          titleEnglish:item["titleEnglish"].replaceAll('*', "\'"),
          contentSinhala:item["contentSinhala"].replaceAll('*', "\'"),
          contentTamil:item["contentTamil"].replaceAll('*', "\'"),
          contentEnglish:item["contentEnglish"].replaceAll('*', "\'"),
          date:item["date"],
          author:item["author"],
          bigNews:item["bigNews"],
          isRead:item["isRead"],
          type:newsTypeCovert(item["type"]),
          timeStamp:item["timeStamp"],
          isSaved:item['isSaved']
        );
        newsList.add(news);
        
      }
    } catch (e) {
      print(e.toString());
      // return e.toString();
    }
    return newsList;
  }

  


  // add mark the news as read
  markAsReadNews(String id) async {
    final db = await database;
    var res = 'done';

    try {
      await db.execute("UPDATE `News` SET `isRead`=1 WHERE `id` = "+id);
    } catch (e) {
      print(e);
      return e.toString();
    }

    return res;
  }

  // add mark the news as read
  markAsReadArticles(String id) async {
    final db = await database;
    var res = 'done';

    try {
      await db.execute("UPDATE `Articale` SET `isRead`=1 WHERE `id` = "+id);
    } catch (e) {
      print(e);
      return e.toString();
    }

    return res;
  }

  // save news
  saveUnSaveNewsDB(String id,int save) async {
    final db = await database;
    var res = 'done';

    try {
      await db.execute("UPDATE `News` SET `isSaved`="+save.toString()+" WHERE `id` = "+id);
    } catch (e) {
      print(e);
      return e.toString();
    }

    return res;
  }

  // save articles
  saveUnsavedArticlesDB(String id,int save) async {
    final db = await database;
    var res = 'done';

    try {
      await db.execute("UPDATE `Articale` SET `isSaved`="+save.toString()+" WHERE `id` = "+id);
    } catch (e) {
      print(e);
      return e.toString();
    }

    return res;
  }






}

// INSERT INTO News (id ,imgUrl,titleSinhala,titleEnglish,titleTamil,contentSinhala,contentEnglish,contentTamil,date,author,bigNews,isRead,type,timeStamp)VALUES (1,'url','title Sinhala','title English','title Tamil','Sinhala Lorem ipsum dolor sit amet','English Lorem ipsum dolor sit amet','Tamil Lorem ipsum dolor sit amet','date','author',0,0,'NewsType.Local','1589723003961),(2,'url1','title 1 Sinhala','title 1 English','title 1 Tamil','Sinhala Lorem ipsum dolor sit amet','English Lorem ipsum dolor sit amet','Tamil Lorem ipsum dolor sit amet','date1','author1',1,0,'NewsType.Forign','1589723003961)

