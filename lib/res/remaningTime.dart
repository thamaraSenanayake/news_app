import 'package:intl/intl.dart';

class TimeCalculater{
  static String timeDifferentCalculator(var date, var time){
    var dateTime = date + " " + time + "Z";
    var currentTime = new DateTime.now();
    Duration difference = currentTime.difference(DateTime.parse(dateTime));
    if (difference.inSeconds < 0) {
      return dateTime = DateFormat("dd/MM/yyyy").add_jm().format(DateTime.parse(dateTime));
    }
    else if (difference.inSeconds < 59) {
      return difference.inSeconds.toString()+"S ago" ;
    } 
    else if (difference.inMinutes < 59) {
      return difference.inMinutes.toString()+"min ago" ;
    }
    else if (difference.inHours < 23) {
      return difference.inHours.toString()+"hours ago" ;
    }
    else {
      return dateTime = DateFormat("dd/MM/yyyy").add_jm().format(DateTime.parse(dateTime));
    }
    
  }
}