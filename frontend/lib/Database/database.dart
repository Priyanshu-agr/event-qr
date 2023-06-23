import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';


class Data extends ChangeNotifier{

  final address = "http://10.102.141.76:3000";
  Future<String> sendData(String id) async {
    print("before sending request $id");
    // final url = Uri.parse("$address/scan/").replace(queryParameters: {"id": id});
    final url = Uri.parse("$address/scan/$id");
    print(url);
    final response = await http.post(url);
    print("response: \n ${response.body}");
    print("response type: \n ${response.body.runtimeType}");
    return response.body;
  }

}



