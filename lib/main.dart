import 'package:crowd_front_end/pages/combined.dart';
import 'package:crowd_front_end/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/login_page.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
     runApp(ProviderScope(child: MyApp(token: prefs.getString('token'),)));
}

class MyApp extends StatelessWidget {
  final token;
  const MyApp({
      @required this.token,
      super.key,
    });

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRoWD',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: (token == null)?LoginPage():(JwtDecoder.isExpired(token) == false)?NewHomePage(token: token):LoginPage()
    );
  }
}