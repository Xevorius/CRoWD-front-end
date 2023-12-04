import 'package:crowd_front_end/pages/home%20tabs/map_tab.dart';
import 'package:crowd_front_end/pages/home%20tabs/profile_tab.dart';
import 'package:crowd_front_end/pages/home%20tabs/chat_tab.dart';
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
        body: const Column(
          children: [
            TabBar(
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
                ChatTab(),
                MapTab(),
                ProfileTab()
              ]),
            )
          ],
        ),)
    );
  }
}