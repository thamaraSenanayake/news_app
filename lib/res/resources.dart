import 'dart:async';
import 'dart:io';

class Resousers{
  static Future<bool> checkInternetConectivity() async{
    print("Check conectivity");

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return true;
      }
    } on SocketException catch (_) {
      print('not connected');
      return false;
    }

    return false;

  }
}