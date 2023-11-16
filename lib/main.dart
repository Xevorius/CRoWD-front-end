import 'package:crowd_front_end/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/login_page.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
     runApp(MyApp(token: prefs.getString('token'),));
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
      home: (token == null)?LoginPage():(JwtDecoder.isExpired(token) == false)?HomePage(token: token):LoginPage()
      // home: LoginPage()
    );
  }
}