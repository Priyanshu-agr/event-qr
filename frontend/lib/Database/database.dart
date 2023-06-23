import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;


class Data extends ChangeNotifier{

  final address = String.fromEnvironment("ADDRESS");
  Future<String> sendData(String id) async {
    if (kDebugMode) {
      print("before sending request $id");
    }
    // final url = Uri.parse("$address/scan/").replace(queryParameters: {"id": id});
    final url = Uri.parse("$address/scan/$id");
    if (kDebugMode) {
      print(url);
    }
    final response = await http.post(url);
    if (kDebugMode) {
      print("response: \n ${response.body}");
      print("response type: \n ${response.body.runtimeType}");
    }
    return response.body;
  }

}



