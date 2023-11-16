// chat_page.dart
import 'package:flutter/material.dart';
import '../api_service.dart';
import 'message_page.dart';

class ChatsPage extends StatelessWidget {
  final token;
  const ChatsPage({@required this.token,super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chats',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('CRoWD Chats'),
        ),
        body: FutureBuilder<List<dynamic>>(
          future: fetchChats(token: token),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Chat ${snapshot.data![index]['id']}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MessagePage(chatId: snapshot.data![index]['id'],)),
                      );
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
