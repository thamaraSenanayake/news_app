import 'package:flutter/material.dart';
import 'package:news_app/Splash/dialoagLister.dart';
import 'package:news_app/const.dart';

class NoInternet extends StatefulWidget {
  final NoInterNetTryAginListen netTryAginListen;
  
  NoInternet({Key key, this.netTryAginListen}) : super(key: key);

  @override
  _NoInternetState createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: Container(
        width: 260.0,
        height: 250.0,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Text(
                    'Alert',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.info,
                  color: Colors.red,
                )
              ],
            ),

            // dialog centre
            Container(
              child: Text(
                'No internet conection connnect the aplication to internet and try again',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // dialog button
                Padding(
                  padding: const EdgeInsets.only(bottom:8.0),
                  child: GestureDetector(
                    onTap: () {
                      widget.netTryAginListen.tryAgainClick();
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: AppData.DARKGRAY,
                      ),
                      child: Text(
                        'Try Again',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),

              ]
            ),
          ],
        ),
      ),
    );
  }
}
