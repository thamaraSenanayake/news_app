import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:news_app/Splash/splashListner.dart';
import 'package:news_app/const.dart';
import 'package:news_app/database/database.dart';
import 'package:news_app/database/sqlLitedatabase.dart';
import 'package:news_app/language/language.dart';
import 'package:news_app/language/languageListner.dart';
import 'package:news_app/model/news.dart';
import 'package:news_app/model/systemInfo.dart';
import 'package:news_app/res/curvePainter.dart';

class Splash extends StatefulWidget {
  final SplashStateListner splashStateListner;
  final LanguageStateListner languageStateListner;
  final Key languageKey;
  Splash({Key key,@required this.splashStateListner, this.languageStateListner, this.languageKey}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  double _height = 0.0;
  double _width = 0.0;
  double _screenHeight = 0.0;
  double _logoPostion = 0.0;
  double _loadingPostion = 0.0;
  double _languagePageHeight = 0.0;

  bool _loadingData = false;
  bool _waitTimeComplete = false;
  bool _firstLoading = true;
  bool _moveTolanguageScreen = true;
  bool _loadingSystemData = false;
  bool _loadComplete = false;


  @override
  void initState() {
    super.initState();
    print("splah page run"+_loadComplete.toString());
    WidgetsBinding.instance.addPostFrameCallback((_) { 
      if(!_loadComplete){
        _setPosition();
        _loadData();
        _loadingTime();
        _loadSystemData();
      }
    });
  }

  _loadingTime() async{
    await new Future.delayed(const Duration(seconds : 3));
    _waitTimeComplete = true;
    _exitFormPage();
  }

  _exitFormPage(){
    if(_loadingData && _waitTimeComplete && _loadingSystemData){

      setState(() {
        _loadComplete = true;
      });

      widget.splashStateListner.loadingState(true);
      print("set height");

      if(_moveTolanguageScreen){
        setState(() {
          _screenHeight = 0.0;
          _languagePageHeight = _height;
        });
      }
      else{
        widget.splashStateListner.moveToNewsPage(AppData.isDark);
        _screenHeight = 0.0;
        _languagePageHeight = _height;
      }
    }
  }

  _loadData() async{
    List<News> newsList = [];
    List<News> articleList = [];
    List<News> hotNewsList = [];
    Database database = Database();

    //get firebase last added news only use when add news
    int firebaseNewsCount =await database.getNewsCount();

    //get firebase last added news only use when add news
    int firebaseArticleCount =await database.getArticaleCount();

    //get sql lite last added news only use when retrive news
    int id = await DBProvider.db.getLastNewsId();

    //get sql lite last added article id only use when retrive news
    int articleiId = await DBProvider.db.getLastArticaleId();
    
    print("last firsbase id "+firebaseNewsCount.toString());
    print("last sql ite id "+id.toString());

    print("last artcle firsbase id "+firebaseNewsCount.toString());
    print("last sqllite artcle id "+id.toString());

    var timeStamp = new DateTime.now().millisecondsSinceEpoch;
    var currentData = new DateTime.now();
    
    // News news = News(
    //   id:++firebaseNewsCount,
    //   titleEnglish:"local news 1 English",
    //   titleSinhala:"local news 1 Sinhala",
    //   titleTamil:"local news 1 Tamil",
    //   imgUrl:["https://cdn.newsfirst.lk/english-uploads/2020/05/13b23a13-97cc2493-f18fe9cb-cbsl_850x460_acf_cropped_850x460_acf_cropped.jpg"],
    //   contentEnglish: "English Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   contentSinhala:"Sinhala Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   contentTamil:"Tamil Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea",
    //   date:currentData.toString(),
    //   author:"author",
    //   bigNews:0,
    //   isRead:0,
    //   type:NewsType.Local,
    //   timeStamp:timeStamp
    // );

    String contentEnglish = "Coral reefs are large underwater structures composed of the skeletons of colonial marine invertebrates called coral. The coral species that build reefs are known as hermatypic, or 'hard,' corals because they extract calcium carbonate from seawater to create a hard, durable exoskeleton that protects their soft, sac-like bodies. Other species of corals that are not involved in reef-building are known as “soft” corals. These types of corals are flexible organisms often resembling plants and trees and include species such as sea fans and sea whips, according to the Coral Reef Alliance (CORAL), a nonprofit environmental organization.";
contentEnglish +="Each individual coral is referred to as a polyp. Coral polyps live on the calcium carbonate exoskeletons of their ancestors, adding their own exoskeleton to the existing coral structure. As the centuries pass, the coral reef gradually grows, one tiny exoskeleton at a time, until they become massive features of the marine environment.";
contentEnglish +="Corals are found all over the world's oceans, from the Aleutian Islands off the coast of Alaska to the warm tropical waters of the Caribbean Sea. The biggest coral reefs are found in the clear, shallow waters of the tropics and subtropics. The largest of these coral reef systems, the Great Barrier Reef in Australia, is more than 1,500 miles long (2,400 kilometers).";
    String contentSinhala ="කොරල් පර යනු කොරල් ලෙස හැඳින්වෙන යටත් විජිත සමුද්‍ර අපෘෂ් b වංශීන්ගේ ඇටසැකිලි වලින් සමන්විත විශාල දිය යට ව්‍යුහයකි. ගල්පර ගොඩනඟන කොරල් විශේෂය හර්මැටිපික් හෝ 'තද' කොරල් ලෙස හැඳින්වේ. මන්දයත් මුහුදු ජලයෙන් කැල්සියම් කාබනේට් නිස්සාරණය කර ඔවුන්ගේ මෘදු, මල සිරුරු වැනි ශරීර ආරක්ෂා කරන දෘඩ, කල් පවතින එක්ස්කොලේටනයක් නිර්මාණය කිරීමයි. ගල්පර තැනීමට සම්බන්ධ නොවන වෙනත් කොරල් විශේෂ “මෘදු” කොරල් ලෙස හැඳින්වේ. ලාභ නොලබන පාරිසරික සංවිධානයක් වන කොරල් රීෆ් එලායන්ස් (CORAL) ට අනුව මෙම කොරල් වර්ග බොහෝ විට ශාක හා ගස් වලට සමාන නම්යශීලී ජීවීන් වන අතර මුහුදු පංකා සහ මුහුදු කස වැනි විශේෂද ඇතුළත් වේ.";
contentSinhala +="සෑම තනි කොරල් වර්ගයක්ම පොලිප් ලෙස හැඳින්වේ. කොරල් පොලිප්ස් ඔවුන්ගේ මුතුන් මිත්තන්ගේ කැල්සියම් කාබනේට් එක්ස්කොලේටෝන මත ජීවත් වන අතර, පවතින කොරල් ව්‍යුහයට තමන්ගේම එක්ස්කොලේටනය එක් කරයි. ශතවර්ෂ ගණනාව ගෙවී යත්ම, කොරල් පරය ක්‍රමයෙන් වර්ධනය වේ, වරකට එක් කුඩා එක්ස්කොලේටනයක්, ඒවා සමුද්‍ර පරිසරයේ දැවැන්ත ලක්ෂණ බවට පත්වන තෙක්.";
contentSinhala +="ඇලස්කාවේ වෙරළට ඔබ්බෙන් වූ ඇලූටියන් දූපත් වල සිට කැරිබියානු මුහුදේ උණුසුම් නිවර්තන ජලය දක්වා ලොව පුරා සාගරවල කොරල් දක්නට ලැබේ. විශාලතම කොරල් පර දක්නට ලැබෙන්නේ නිවර්තන සහ උපනිවර්තන කලාපවල පැහැදිලි, නොගැඹුරු ජලයේ ය. මෙම කොරල් පර පද්ධති වලින් විශාලතම ඕස්ට්‍රේලියාවේ මහා බාධක පරය සැතපුම් 1,500 කට වඩා දිගු (කිලෝමීටර් 2,400) වේ.";

String contentTamil ="பவளப்பாறைகள் பவளம் எனப்படும் காலனித்துவ கடல் முதுகெலும்பில்லாத எலும்புக்கூடுகளால் ஆன பெரிய நீருக்கடியில் கட்டமைப்புகள். பாறைகளை உருவாக்கும் பவள இனங்கள் ஹெர்மடிபிக் அல்லது 'கடினமான' பவளப்பாறைகள் என அழைக்கப்படுகின்றன, ஏனெனில் அவை கடல் நீரிலிருந்து கால்சியம் கார்பனேட்டை பிரித்தெடுக்கின்றன, ஏனெனில் அவை மென்மையான, சாக் போன்ற உடல்களைப் பாதுகாக்கும் கடினமான, நீடித்த எக்ஸோஸ்கெலட்டனை உருவாக்குகின்றன. ரீஃப் கட்டிடத்தில் ஈடுபடாத பிற வகை பவளப்பாறைகள் “மென்மையான” பவளப்பாறைகள் என்று அழைக்கப்படுகின்றன. இந்த வகையான பவளப்பாறைகள் பெரும்பாலும் தாவரங்கள் மற்றும் மரங்களை ஒத்திருக்கும் நெகிழ்வான உயிரினங்கள் மற்றும் கடல் ரசிகர்கள் மற்றும் கடல் சவுக்கை போன்ற உயிரினங்களை உள்ளடக்குகின்றன என்று பவளப்பாறை கூட்டணி (CORAL), ஒரு இலாப நோக்கற்ற சுற்றுச்சூழல் அமைப்பு கூறுகிறது.";
contentTamil +="ஒவ்வொரு தனி பவளமும் ஒரு பாலிப் என குறிப்பிடப்படுகிறது. பவள பாலிப்கள் தங்கள் மூதாதையர்களின் கால்சியம் கார்பனேட் எக்ஸோஸ்கெலட்டன்களில் வாழ்கின்றன, அவற்றின் சொந்த எக்ஸோஸ்கெலட்டனை ஏற்கனவே இருக்கும் பவள அமைப்பில் சேர்க்கின்றன. பல நூற்றாண்டுகள் கடந்து செல்லும்போது, ​​பவளப்பாறை படிப்படியாக வளர்கிறது, ஒரு நேரத்தில் ஒரு சிறிய வெளிப்புற எலும்புக்கூடு, அவை கடல் சூழலின் மிகப்பெரிய அம்சங்களாக மாறும் வரை.";
contentTamil +="அலாஸ்கா கடற்கரையிலிருந்து அலூட்டியன் தீவுகள் முதல் கரீபியன் கடலின் வெப்பமண்டல நீர் வரை உலகப் பெருங்கடல்கள் முழுவதும் பவளப்பாறைகள் காணப்படுகின்றன. வெப்பமண்டல மற்றும் துணை வெப்பமண்டலங்களின் தெளிவான, ஆழமற்ற நீரில் மிகப்பெரிய பவளப்பாறைகள் காணப்படுகின்றன. இந்த பவளப்பாறை அமைப்புகளில் மிகப்பெரியது, ஆஸ்திரேலியாவில் உள்ள கிரேட் பேரியர் ரீஃப் 1,500 மைல்களுக்கு மேல் (2,400 கிலோமீட்டர்) நீளமானது.";

    News article = News(
      id:++firebaseArticleCount,
      titleEnglish:"coral reefs",
      titleSinhala:"කොරල් පර",
      titleTamil:"பவள பாறைகள்",
      imgUrl:["https://cdn.newsfirst.lk/english-uploads/2020/05/13b23a13-97cc2493-f18fe9cb-cbsl_850x460_acf_cropped_850x460_acf_cropped.jpg",
      "https://images.squarespace-cdn.com/content/v1/5a5906400abd0406785519dd/1551885339303-MGZTNKH30KZJ6MVGCNFC/ke17ZwdGBToddI8pDm48kPRR_KKDCce2j1Ft9BtH2rMUqsxRUqqbr1mOJYKfIPR7LoDQ9mXPOjoJoqy81S2I8N_N4V1vUb5AoIIIbLZhVYxCRW4BPu10St3TBAUQYVKcOOcoRbwmUbJTw_Uzl2L4LnjGPIbt-pMe5GQISGa57zDrLoLxlVXU3BOkJIyoYjNR/Screen+Shot+2019-03-06+at+10.15.09+AM.png?format=300w",
      "https://images.squarespace-cdn.com/content/v1/5a5906400abd0406785519dd/1534530575930-8QCOFI1QEU1WEBCKGPDO/ke17ZwdGBToddI8pDm48kLkXF2pIyv_F2eUT9F60jBl7gQa3H78H3Y0txjaiv_0fDoOvxcdMmMKkDsyUqMSsMWxHk725yiiHCCLfrh8O1z4YTzHvnKhyp6Da-NYroOW3ZGjoBKy3azqku80C789l0iyqMbMesKd95J-X4EagrgU9L3Sa3U8cogeb0tjXbfawd0urKshkc5MgdBeJmALQKw/IYORBank_CoralReefs_ErikLukas_01.jpg?format=300w"],
      contentEnglish: contentEnglish,
      contentSinhala:contentSinhala,
      contentTamil:contentTamil,
      date:currentData.toString(),
      author:"author",
      timeStamp:timeStamp
    );

    // await database.addNews(news);


    //insert article id
    await database.addArticle(article);
    await database.updateArticaleCount(firebaseArticleCount);

    //get articles
    articleList = await database.readArticles(articleiId);
    
    //get normal news
    newsList = await database.readNews(id);

    //get hot news
    hotNewsList = await database.readHotNews();
    print(newsList.length);

    if(newsList.length != 0){
      await DBProvider.db.addNewsData(newsList);
    }

    if(hotNewsList.length != 0){
      await DBProvider.db.addHotNewsData(hotNewsList);
    }

    if(articleList.length != 0){
      await DBProvider.db.addAtricaleData(articleList);
    }

    _loadingData = true;
    _exitFormPage();
  }

  _loadSystemData() async{
    SystemInfo systemInfo = await DBProvider.db.getSystemData();
    if(systemInfo == null){
      _moveTolanguageScreen = true;
    }
    else{
      print("splash");
      print(systemInfo.isDrak);
      AppData.language = systemInfo.language;
      AppData.isDark = systemInfo.isDrak;
      _moveTolanguageScreen = false;
    }

    _loadingSystemData =true;
    _exitFormPage();
  }

  _setPosition(){
    setState(() {
      _logoPostion = 125;
      _loadingPostion = 150;
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _height = MediaQuery.of(context).size.height;
      _width = MediaQuery.of(context).size.width;
      if(_firstLoading){
        _screenHeight = _height;
        _firstLoading =false;
      }
    });

    return Container(
      height: _height,
      width: _width,
      child: Stack(
        children: <Widget>[

          //canves
          Container(
            height: _height,
            width:_width,
            child: CustomPaint(
              painter:CurvePainter() ,
            ),
          ),
          
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                AnimatedContainer(
                  duration: Duration(milliseconds: 1000),
                  height: _screenHeight,
                  width: _width,
                  child: Stack(
                    children: <Widget>[

                      //logo
                      AnimatedPositioned(
                        duration: Duration(milliseconds:1000),
                        top:_logoPostion,
                        child: Container(
                          width: _width,
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 160,
                              width: 160,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Image.asset(
                                    AppData.LOGO
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xff161617),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2.0,
                                    spreadRadius: 2.0, 
                                    offset: Offset(
                                      1.0,
                                      2.0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ), 
                      ),

                      //loading
                      !_loadComplete?AnimatedPositioned(
                        duration: Duration(milliseconds:1000),
                        bottom:_loadingPostion,
                        child: Container(
                          width: _width,
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 50,
                              width: 50,
                              child: SpinKitFadingCube(
                                color: AppData.ALLCOLOR,
                                size: 50.0,
                              ),
                            ),
                          ),
                        ), 
                      ):Container(),


                    ],
                  ),
                ),

                AnimatedContainer(
                  height: _languagePageHeight,
                  width: _width,
                  duration: Duration(milliseconds: 500),
                  color: Colors.grey[200].withOpacity(0.7),
                  child: SingleChildScrollView(
                    child: Language(languageStateListner: widget.languageStateListner,key:widget.languageKey)
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}