// api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchChats() async {
  var url = Uri.parse('https://crowd.pythonanywhere.com/chats/');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load chats');
  }
}

Future<List<dynamic>> fetchMessages(int chatId) async {
  var url = Uri.parse('http://crowd.pythonanywhere.com/chats/$chatId/messages/');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load messages');
  }
}

Future<void> sendMessage(int chatId, String text) async {
  var url = Uri.parse('http://crowd.pythonanywhere.com/chats/$chatId/messages/');
  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'text': text,
      'user': '1',
    }),
  );

  if (response.statusCode != 201) {
    throw Exception('Failed to send message');
  }
}
