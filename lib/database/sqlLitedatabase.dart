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

  databaseAvalablity() {
    if (_database != null) {
      return false;
    }
    return true;
  }

  //create the databse in app Directory
  initDB() async {
    print("create DB");
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "news3.db");
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
          "type TEXT NOT NULL,"
          "timeStamp INTEGER NOT NULL"
          ")");

      await db.execute("CREATE TABLE SystemInfo ("
          "langId TEXT NOT NULL,"
          "isDark INTEGER NOT NULL"
          ")");
    });
  }

  // add system to sql lite
  addSystemData(LanguageList language, int isDark) async {
    final db = await database;
    var res = 'done';

    try {
      await db.execute("DELETE FROM `SystemInfo`");
      await db.execute("INSERT INTO SystemInfo (langId, isDark)VALUES ('" +
          language.toString() +
          "','" +
          isDark.toString() +
          "')");
    } catch (e) {
      print(e);
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
          language: languageConvert(item["language"]) ,
          isDrak:item["isDrak"],
        );
      }
      
    } catch (e) {
      print(e);
      
    }

    return systemInfo;
  }

  // add news to sql lite
  addNewsData(List<News> newsList) async {
    print("+++++++++++++++++++++++++++");
    print(newsList.length);
    final db = await database;
    var res = 'done';
    String sql =
        "INSERT INTO News (id ,imgUrl,titleSinhala,titleEnglish,titleTamil,contentSinhala,contentEnglish,contentTamil,date,author,bigNews,isRead,type,timeStamp)VALUES ";

    for (var item in newsList) {
      sql += "(" +
          item.id.toString() +
          ",'" +
          item.imgUrl[0] +
          "','" +
          item.titleSinhala +
          "','" +
          item.titleEnglish +
          "','" +
          item.titleTamil +
          "','" +
          item.contentSinhala +
          "','" +
          item.contentEnglish +
          "','" +
          item.contentTamil +
          "','" +
          item.date +
          "','" +
          item.author +
          "'," +
          item.bigNews.toString() +
          "," +
          item.isRead.toString() +
          ",'" +
          item.type.toString() +
          "'," +
          item.timeStamp.toString() +
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


  //delete news older than 7 days
  deleteOldNews() async{
    final db = await database;
    var res = "done";
    var date = new DateTime.now().subtract(Duration(days:7));

    try {
      await db.execute("DELETE FROM `news` WHERE timeStamp > " + date.toString());
    } catch (e) {
      print(e);
      return e.toString();
    }

    return res;
  }

  Future<List<News>> viewNews(LanguageList selectedLang) async{
    final db = await database;
    List<News> newsList = [];
    News news;
    
    try {
      var res = await db.query("News",where: "langId = "+selectedLang.toString());
      for (var item in res) {
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
          type:item["type"],
          timeStamp:item["timeStamp"],
        );
        newsList.add(news);
        
      }
    } catch (e) {
      print(e.toString());
      // return e.toString();
    }
    return newsList;
  }


  // add question tye to sql lite
  markAsRead(String id) async {
    final db = await database;
    var res = 'done';

    try {
      await db.execute("UPDATE `News` SET `idRead`=1 WHERE `id` < "+id);
    } catch (e) {
      print(e);
      return e.toString();
    }

    return res;
  }






}

// INSERT INTO News (id ,imgUrl,titleSinhala,titleEnglish,titleTamil,contentSinhala,contentEnglish,contentTamil,date,author,bigNews,isRead,type,timeStamp)VALUES (1,'url','title Sinhala','title English','title Tamil','Sinhala Lorem ipsum dolor sit amet','English Lorem ipsum dolor sit amet','Tamil Lorem ipsum dolor sit amet','date','author',0,0,'NewsType.Local','1589723003961),(2,'url1','title 1 Sinhala','title 1 English','title 1 Tamil','Sinhala Lorem ipsum dolor sit amet','English Lorem ipsum dolor sit amet','Tamil Lorem ipsum dolor sit amet','date1','author1',1,0,'NewsType.Forign','1589723003961)