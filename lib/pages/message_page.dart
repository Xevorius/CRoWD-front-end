// message_page.dart
import 'package:flutter/material.dart';
import '../api_service.dart';

class MessagePage extends StatefulWidget {
  final int chatId;

  const MessagePage({super.key, required this.chatId});

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat ${widget.chatId}'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: fetchMessages(widget.chatId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data![index]['text']),
                        subtitle: Text('Sent by ${snapshot.data![index]['user']}'),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Type a message',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              sendMessage(widget.chatId, _controller.text);
              _controller.clear();
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}
