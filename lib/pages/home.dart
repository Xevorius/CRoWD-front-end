import 'dart:typed_data';

import 'package:crowd_front_end/api_service.dart';
import 'package:crowd_front_end/pages/message_page.dart';
import 'package:crowd_front_end/pages/qrcode_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget{
  final token;
  const HomePage({@required this.token,super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('C R o W D')),
        ),
        body: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.home,
                    color: Colors.deepPurple,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.map,
                    color: Colors.deepPurple,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.person,
                    color: Colors.deepPurple,
                  ),
                )
              ]
            ),
            Expanded(
              child: TabBarView(children: [
                FutureBuilder<List<dynamic>>(
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
                Center(
                  child: FutureBuilder(
                    future: fetchQr(token),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Image.memory(snapshot.data!);
                      }
                    },
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed:  () async {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const QRViewExample()),);
                    }, child: const Text('Scan code'),
                    ) ,
                  
                ),
              ]),
            )
          ],
        ),)
    );
  }
}