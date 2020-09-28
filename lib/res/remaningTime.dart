import 'package:intl/intl.dart';

class TimeCalculator{
  //2020-06-02 14:08:57.495216
  static String timeDifferentCalculator(var fullTime){
    var date =  fullTime.toString().split(" ")[0];
    var time =  fullTime.toString().split(" ")[1];
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
      return dateTime = DateFormat("dd/MM/yyyy").format(DateTime.parse(dateTime));
    }
    
  }

}