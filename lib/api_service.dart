import 'dart:convert';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:crowd_front_end/models/power_share_models.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  // Add the JWT token to the cookies 
    var dio = Dio();
    var cj = CookieJar();
    dio.interceptors.add(CookieManager(cj));

    (cj).saveFromResponse(
      Uri.parse(url), 
      [Cookie('jwt', pref.getString('token').toString())]
    );

      // Send the HTTP request
      response = await dio.get(url);
      if (response.statusCode == 200) {
        return response.data;
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

Future<Response> login(String username, String password) async {
  var url = 'http://crowd.pythonanywhere.com/auth/login/';
  var dio = Dio();
  var response = await dio.post(url, data: {'username': username,'password': password,});
  return response;
}

Future<Response> signup(String username, String password) async {
  var url = 'http://crowd.pythonanywhere.com/auth/register/';
  var dio = Dio();
  var response = await dio.post(url, data: {'username': username,'password': password,});
  return response;

}

Future<String> profile() async {
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
    return response.data['username'];
  } else {
    // print(response!.request?.headers);
    throw Exception('Failed to retrieve profile');
  }
}

Future<List<int>?> fetchQr() async {
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



class PowerShareAPI{
  String endpoint = 'http://crowd.pythonanywhere.com/powershare/';
  Future<List<PowerShareStationModel>> fetchAllStations() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var dio = Dio();
    var cj = CookieJar();
    dio.interceptors.add(CookieManager(cj));

    (cj).saveFromResponse(
      Uri.parse(endpoint), 
      [Cookie('jwt', pref.getString('token').toString())]
    );

    final response = await dio.get(endpoint);
    final List mappable = jsonDecode(jsonEncode(response.data));
    if (response.statusCode == 200) {
      return mappable.map((e) => PowerShareStationModel.fromJson(e)).toList();
    } else {
      // print(response!.request?.headers);
      throw Exception('Failed to load power share stations.');
    }
  }

  fetchUserOrders() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var dio = Dio();
    var cj = CookieJar();
    dio.interceptors.add(CookieManager(cj));

    (cj).saveFromResponse(
      Uri.parse(endpoint), 
      [Cookie('jwt', pref.getString('token').toString())]
    );

    final response = await dio.get(endpoint+"/order");

    if (response.statusCode == 200) {
      final List result = jsonDecode(response.data);
      return result.map((e) => PowerShareOrderModel.fromJson(e)).toList();
    } else {
      // print(response!.request?.headers);
      throw Exception('Failed to load power share stations.');
    }
  }
}

final powerShareStationProvider = Provider<PowerShareAPI>((ref)=>PowerShareAPI());

