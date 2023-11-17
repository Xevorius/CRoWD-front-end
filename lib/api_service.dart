// api_service.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:http/http.dart' as http;
import 'package:http_client_helper/http_client_helper.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/html.dart' as html;

Future<List<dynamic>> fetchChats() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  var response;
  if (!kIsWeb) {
    var dio = Dio();
    var cj = CookieJar();
    dio.interceptors.add(CookieManager(cj));

    var url = 'http://crowd.pythonanywhere.com/chats/';

    // Add the JWT token to the cookies
    (cj).saveFromResponse(
      Uri.parse(url), 
      [Cookie('jwt', pref.getString('token').toString())]
    );

    // Send the request
    response = await dio.get(url);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      // print(response!.request?.headers);
      throw Exception('Failed to load chats');
    }
  }else{
      var url = 'http://crowd.pythonanywhere.com/chats/';

      // Set the JWT token as a cookie
      html.document.cookie = 'jwt=${pref.getString('token')};';

      // Send the HTTP request
      response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        // print(response!.request?.headers);
        throw Exception('Failed to load chats');
      }
  }


}

Future<List<dynamic>> fetchMessages(int chatId) async {
  var response;
  SharedPreferences pref = await SharedPreferences.getInstance();

  var url = 'http://crowd.pythonanywhere.com/chats/$chatId/messages/';

  // Add the JWT token to the cookies 
    var dio = Dio();
    var cj = CookieJar();
    dio.interceptors.add(CookieManager(cj));

    (cj).saveFromResponse(
      Uri.parse(url), 
      [Cookie('jwt', pref.getString('token').toString())]
    );

  // Send the request
  response = await dio.get(url);
  if (response.statusCode == 200) {
    return response.data;
  } else {
    // print(response!.request?.headers);
    throw Exception('Failed to load messages');
  }
}

Future<void> sendMessage(int chatId, String text) async {
  var response;
  final prefs = SharedPreferences.getInstance();
  SharedPreferences pref = await SharedPreferences.getInstance();

  var url = 'http://crowd.pythonanywhere.com/chats/$chatId/messages/';

  // Add the JWT token to the cookies 
    var dio = Dio();
    var cj = CookieJar();
    dio.interceptors.add(CookieManager(cj));

    (cj).saveFromResponse(
      Uri.parse(url), 
      [Cookie('jwt', pref.getString('token').toString())]
    );

  // Send the request
  response = await dio.post(url, data: {
      'text': text,
      'user': JwtDecoder.decode(pref.getString('token').toString())['id'],
    });
  if (response.statusCode == 200) {
    return response.data;
  } else {
    // print(response!.request?.headers);
    throw Exception('Failed to send messages');
  }
}

Future<String> login(String username, String password) async {
  var url = Uri.parse('http://crowd.pythonanywhere.com/auth/login/');
  final response = await HttpClientHelper.post(
    url,
    body: {
      'username': username,
      'password': password,
    }
  );

  if (response!.statusCode == 200) {
    return (json.decode(response.body)['jwt']);
  } else {
    throw Exception('Failed to login');
  }
}

Future<void> signup(String username, String password) async {
  var url = Uri.parse('https://crowd.pythonanywhere.com/auth/register');
  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Referer": "https://yoursite.com",
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'password': password,
    }),
  );

  if (response.statusCode != 201) {
    throw Exception('Failed to signup');
  }
}

Future<void> profile() async {
var response;
  SharedPreferences pref = await SharedPreferences.getInstance();

  var url = 'http://crowd.pythonanywhere.com/auth/user';

  // Add the JWT token to the cookies 
    var dio = Dio();
    var cj = CookieJar();
    dio.interceptors.add(CookieManager(cj));

    (cj).saveFromResponse(
      Uri.parse(url), 
      [Cookie('jwt', pref.getString('token').toString())]
    );

  // Send the request
  response = await dio.get(url,);
  if (response.statusCode == 200) {
    return response.data;
  } else {
    // print(response!.request?.headers);
    throw Exception('Failed to retrieve profile');
  }
}

Future<List<int>?> fetchQr(String token) async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  var url = 'http://crowd.pythonanywhere.com/auth/qr';

  // Add the JWT token to the cookies 
    var dio = Dio();
    var cj = CookieJar();
    dio.interceptors.add(CookieManager(cj));

    (cj).saveFromResponse(
      Uri.parse(url), 
      [Cookie('jwt', pref.getString('token').toString())]
    );

  // Send the request
  final response = await dio.get<List<int>>(url, options: Options(responseType: ResponseType.bytes));
  if (response.statusCode == 200) {
    return response.data;
  } else {
    // print(response!.request?.headers);
    throw Exception('Failed to retrieve profile');
  }
}

Future<void> createChatForQr(int newFriend) async {
  var response;
  final prefs = SharedPreferences.getInstance();
  SharedPreferences pref = await SharedPreferences.getInstance();

  var url = 'http://crowd.pythonanywhere.com/chats/';

  // Add the JWT token to the cookies 
    var dio = Dio();
    var cj = CookieJar();
    dio.interceptors.add(CookieManager(cj));

    (cj).saveFromResponse(
      Uri.parse(url), 
      [Cookie('jwt', pref.getString('token').toString())]
    );

  // Send the request
  response = await dio.post(url, data: {
      'users': [JwtDecoder.decode(pref.getString('token').toString())['id'], newFriend],
    });
  if (response.statusCode == 200) {
    return response.data;
  } else {
    // print(response!.request?.headers);
    throw Exception('Failed to send messages');
  }
}