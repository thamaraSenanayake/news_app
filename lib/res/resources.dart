import 'dart:async';
import 'dart:io';

class Resources{
  static Future<bool> checkInternetConnectivity() async{

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }

    return false;

  }
}