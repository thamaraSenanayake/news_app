import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app/model/newsAdd.dart';
import 'const.dart';

class AddNews extends StatefulWidget {
  AddNews({Key key}) : super(key: key);

  @override
  _AddNewsState createState() => _AddNewsState();
}

class _AddNewsState extends State<AddNews> {
  double _height = 0.0;
  double _width = 0.0;
  List<File> _image =[];
  List<String> _imagePathList = [];
  List<Widget> _imageList = [];
  String _imageError = "";
  String _nameError = "";
  String _contactNumberError = "";
  String _contentError = "";
  FirebaseStorage _storage;
  var chars = "abcdefghijklmnopqrstuvwxyz0123456789";

  final _nameController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() { 
    super.initState();
    _imageList.add(
      _addImageWidget()
    );
    _storage = FirebaseStorage.instance;
  }

  _addNews() async {
    bool _validation = true;
    NewNews newNews;
    if(_nameController.text.isNotEmpty){
      setState(() {
        _nameError = "Required Felid";
      });
      _validation = false;
    }
    if(_contactNumberController.text.isNotEmpty){
      setState(() {
        _contactNumberError = "Required Felid";
      });
      _validation = false;
    }
    if(_contentController.text.isNotEmpty){
      setState(() {
        _contentError = "Required Felid";
      });
      _validation = false;
    }

    if(_validation){
      await uploadPic();
      newNews = NewNews(
        name: _nameController.text,
        contactNm: _contactNumberController.text,
        content: _contentController.text,
        imageList: _imagePathList,
      );

    }
  }


  Future uploadPic() async { 
    for (var item in _image) {
      Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);

      print("upload pic");
      String imageName = new DateTime.now().millisecondsSinceEpoch.toString();
      
      for (var i = 0; i < 10; i++) {
        imageName += chars[rnd.nextInt(chars.length)];
      }

      // Create a reference to the location you want to upload to in firebase  
      StorageReference reference = _storage.ref().child(imageName);

      //Upload the file to firebase 
      StorageUploadTask uploadTask = reference.putFile(item);
      var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

      
      //returns the download url 
      _imagePathList.add(downloadUrl);
      
    }
  }

  _picUploadDialog(context){
    if(_imageList.length == 4){
      setState(() {
        _imageError = "Can't add more than 3 images";
      });
      return;
    }
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
        return Container(
          child: Wrap(
            children: <Widget>[

              ListTile(
                leading: Icon(Icons.camera_enhance),
                title: Text('Camera'),
                onTap: () {
                  _getImage(true);
                  Navigator.pop(context);
                }          
              ),

              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  _getImage(false);
                  Navigator.pop(context);
                },          
              ),
            ],
          ),
        );
      }
    );
  
  }

  Future _getImage(bool isCamera) async {
    var image;
    final picker = ImagePicker();

    if (isCamera) {
      image = await picker.getImage(source: ImageSource.camera);
    } else {
      image = await picker.getImage(source: ImageSource.gallery);
    }

    if(image != null){
      setState(() {
        _image.add(File(image.path));
        // _imageError = "";
      });
      _loadImageList();
    }
  }

  _deleteImage(File item){
    _image.remove(item);
    _loadImageList();
  }

  _loadImageList(){

    List<Widget> _imageListTemp = [];
    _imageListTemp.add(
      _addImageWidget()
    );
    for (var item in _image) {
      _imageListTemp.add(
        Padding(
          padding: const EdgeInsets.only(right:8.0),
          child: Container(
            height: 100,
            width:100,
            child: Stack(
              children: [
                Container(
                  height: 100,
                  width:100,
                  child: Image.file(
                    item,
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: (){
                        _deleteImage(item);
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      );
    }
    setState(() {
      _imageList =_imageListTemp; 
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _height = MediaQuery.of(context).size.height;
      _width = MediaQuery.of(context).size.width;
    });
    return Scaffold(
      body: Container(
        height:_height,
        width:_width,
        child: Stack(
          children: [

            Container(
              height: 80,
              width: _width,
              
              child: Stack(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left:8.0,bottom:5),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Card(
                          child: Container(
                            height: 40,
                            width:40,
                            
                            child:Icon(
                              Icons.arrow_back,
                              color: AppData.isDark == 1? AppData.WHITE: AppData.BLACK,
                            ),
                            decoration: BoxDecoration(
                              color: AppData.WHITE,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom:5.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        "Add News",
                        style:TextStyle(
                          color: AppData.ALLCOLOR,
                          fontSize: 28,
                          fontFamily: "lato",
                          fontWeight: FontWeight.w600
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )

                ],
              ),
              decoration: BoxDecoration(
                color: AppData.isDark != 1? AppData.WHITE: AppData.BLACK,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black54,
                      blurRadius: 5.0,
                      offset: Offset(0.0, 0.50)
                  )
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top:80.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //top bar
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10 ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppData.BLACK
                          ),
                          borderRadius: BorderRadius.circular(3.0)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10 ),
                        child: TextField(
                          style: TextStyle(color: Colors.black, fontSize: 15),
                          controller: _nameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Your name",
                            hintStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xffB3A9A9),
                              height: 1.8
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          onChanged: (value){
                            // _authorErrorRemove();
                          },
                          onSubmitted: (value){
                            
                          },
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10 ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppData.BLACK
                          ),
                          borderRadius: BorderRadius.circular(3.0)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10 ),
                        child: TextField(
                          style: TextStyle(color: Colors.black, fontSize: 15),
                          controller: _contactNumberController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Contact number",
                            hintStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xffB3A9A9),
                              height: 1.8
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          onChanged: (value){
                            // _authorErrorRemove();
                          },
                          onSubmitted: (value){
                            
                          },
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10 ),
                      child: Container(
                        constraints: BoxConstraints(
                          minHeight: 300
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppData.BLACK
                          ),
                          borderRadius: BorderRadius.circular(3.0)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10 ),
                        child: TextField(
                          style: TextStyle(color: Colors.black, fontSize: 15),
                          controller: _contentController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Content",
                            hintStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xffB3A9A9),
                              height: 1.8
                            ),
                          ),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          onChanged: (value){
                            // _authorErrorRemove();
                          },
                          onSubmitted: (value){
                            
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:20.0),
                      child: Container(
                        width: _width,
                        child: Text(
                          _imageError,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 15
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height:100,
                      width: _width-40,
                      child: MediaQuery.removePadding(
                        context: context, 
                        removeTop: true,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: _imageList,
                        )
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10 ),
                      child: Container(
                        height:50,
                        width: _width-20,
                        decoration: BoxDecoration(
                          color: AppData.ALLCOLOR,
                          borderRadius: BorderRadius.circular(3)
                        ),
                        child: Center(
                          child: Text(
                            "Add News",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: "lato"
                            ),
                          ),
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addImageWidget(){
    return(
      GestureDetector(
        onTap: (){
          _picUploadDialog(context);
        },
        child: Padding(
          padding: const EdgeInsets.only(right:8.0),
          child: Container(
            height: 100,
            width:100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: AppData.ALLCOLOR.withOpacity(0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image,
                  color: AppData.BLACK,
                  size: 25,
                ),
                Text(
                  "Add Image",
                  style: TextStyle(
                    color: AppData.BLACK,
                    fontSize: 15,
                    fontFamily: "lato"
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}