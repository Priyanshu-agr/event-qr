import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;


class Data extends ChangeNotifier{

  // final address = String.fromEnvironment("ADDRESS");
  final address = "https://hackjnu-3-qrcode.onrender.com";
  Future<String> sendData(String id) async {
    if (kDebugMode) {
      print("before sending request $id");
    }
    final url = Uri.parse("$address/scan");
    if (kDebugMode) {
      print(url);
    }
    DateTime dinner_start = DateTime(2024,1,27,19,30); // 7:30 PM
    DateTime dinner_end = DateTime(2024,1,27,21,30);  // 9:30 PM
    
    DateTime lunch_start = DateTime(2024,1,27,13,00); // 1:00 PM
    DateTime lunch_end = DateTime(2024,1,27,15,00);   // 3:00 PM
    
    DateTime breakfast_start = DateTime(2024,1,28,7,30); // 7:30 AM
    DateTime breakfast_end = DateTime(2024,1,28,9,30);   // 9:30 AM
    
    // Time change for testing
    // DateTime breakfast_start = DateTime(2024,1,26,18,0); // 8:00 AM
    // DateTime breakfast_end = DateTime(2024,1,26,11,50);

    String time = "";
    if(DateTime.now().isAfter(dinner_start) && DateTime.now().isBefore(dinner_end))
    {
      time = "dinner";
    }else if(DateTime.now().isAfter(lunch_start) && DateTime.now().isBefore(lunch_end)){
      time = "lunch";
    }else if(DateTime.now().isAfter(breakfast_start) && DateTime.now().isBefore(breakfast_end)){
      time = "breakfast";
    }else{
      return "wrong_time";
    }
    print(time);
    print("SENDING REQUEST....\n\n");
    final response = await http.post(url, body: {
      "time" : time,
      "email" : id
    });
    print("REQUEST SUCCESSFULL...\n\n");
    if (kDebugMode) {
      print("response: \n ${response.body}");
      print("response type: \n ${response.body.runtimeType}");
    }
    return response.body;
  }

}



