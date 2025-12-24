import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import '../util/ApiClient.dart';

class RemoteServices {
  static var client = http.Client();

  // static const String baseUrl = "https://anshinfra.appcartsystems.com/";       //new Live URL
  // static const String baseUrl =
  //     "https://anshinfra.macsysonline.com/"; //old live URL
  // static const String baseUrl  = "http://192.168.1.29/anshinfra/";
  // static const String baseUrl = "http://192.168.1.48/anshinfra/"; //LAN IP
  //static const String baseUrl = "http://192.168.1.35/anshinfra/"; // WIFI
  static const String baseUrl = "http://192.168.1.41/anshinfra/"; // WIFI
  //static const String baseUrl = "https://assettrack.macsysonline.com/";
  //static const String baseUrl = "https://stageanshinfra.macsysonline.com/";

  static var header = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  // Get Method for call Apis
  static Future<http.Response> fetchGetData(String url) async {
    print('$baseUrl$url');
    print('token : ${ApiClient.box.read('token')}');
    var clients = http.Client();
    try {
      var response = await clients.get(Uri.parse('$baseUrl$url'), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${ApiClient.box.read('token')}'
      });
      return response;
    } finally {
      clients.close();
    }
  }

  // Post Method for call Apis
  static Future<http.Response> postMethod(String url, Map map) async {
    print('$baseUrl$url');
    print("map :: ${jsonEncode(map)}");
    var h = {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': '*/*',
      "App-Version": "${ApiClient.box.read("version")}",
    };
    var appVersion = ApiClient.box.read("version");

    print("Type of App-Version: ${appVersion.runtimeType}");
    log("App-Version : ${ApiClient.box.read("version")}");
    try {
      var response = await http.Client().post(Uri.parse('$baseUrl$url'),
          headers: h, body: JsonEncoder().convert(map));
      print(response.statusCode);
      print('response.body ${response.body}');
      return response;
    } finally {}
  }

  static Future<http.Response> postMethodWithToken(String url, Map map) async {
    print('$baseUrl$url');
    print('Token ::${ApiClient.box.read('token')}');
    print("map :: ${jsonEncode(map)}");
    var h = {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': '*/*',
      'Authorization': 'Bearer ${ApiClient.box.read('token')}',
      'App-Version': '${ApiClient.box.read("version")}',
    };
    print("Header : $h");
    try {
      var response = await http.Client().post(Uri.parse('$baseUrl$url'),
          headers: h, body: JsonEncoder().convert(map));
      // print(response.statusCode);
      // print('response.body ${response.body}');
      return response;
    } finally {}
  }

  static Future<http.Response> postMethodWithTokenAndImages(
      String url, Map map, List<String> imagePaths) async {
    print('$baseUrl$url');
    print('Token ::${ApiClient.box.read('token')}');
    print("map :: ${jsonEncode(map)}");
    var h = {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': '*/*',
      'Authorization': 'Bearer ${ApiClient.box.read('token')}'
    };
    try {
      var response = await http.Client().post(Uri.parse('$baseUrl$url'),
          headers: h, body: JsonEncoder().convert(map));
      // print(response.statusCode);
      // print('response.body ${response.body}');
      return response;
    } finally {}
  }

  // Put Method for call Apis
  static Future<http.Response> fetchPutData(Map map, String url) async {
    // print('$baseUrl$url');
    var client = http.Client();
    try {
      var response = await client.put(Uri.parse('$baseUrl$url'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${ApiClient.box.read('token')}'
          },
          body: const JsonEncoder().convert(map));
      return response;
    } finally {
      client.close();
    }
  }

  // Delete Method for call Apis
  static Future<http.Response> deleteData(Map map, String url) async {
    // print('$baseUrl$url');
    var clients = http.Client();
    try {
      var response = await clients.delete(Uri.parse('$baseUrl$url'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${ApiClient.box.read('token')}'
          },
          body: JsonEncoder().convert(map));
      return response;
    } finally {
      clients.close();
    }
  }
}
