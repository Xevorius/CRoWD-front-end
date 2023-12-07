import 'package:crowd_front_end/api_service.dart';
import 'package:crowd_front_end/pages/home%20tabs/map_tab.dart';
import 'package:crowd_front_end/pages/home%20tabs/profile_tab.dart';
import 'package:crowd_front_end/pages/qrcode_page.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';


class NewHomePage extends StatelessWidget {
  final token;
  const NewHomePage({Key? key, this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableHome(
      leading: const Icon(Icons.arrow_back_ios),
      title: const Text("C R o W D"),
      headerWidget: headerWidget(context),
      headerBottomBar: headerBottomBarWidget(context),
      body: [
        GlassContainer(
            height: 200,
            width: 350,
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.40),
                Colors.white.withOpacity(0.10),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderGradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.60),
                Colors.white.withOpacity(0.10),
                Colors.purpleAccent.withOpacity(0.05),
                Colors.purpleAccent.withOpacity(0.60),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 0.39, 0.40, 1.0],
            ),
            blur: 20,
            borderRadius: BorderRadius.circular(24.0),
            borderWidth: 1.0,
            elevation: 3.0,
            isFrostedGlass: true,
            shadowColor: Colors.purple.withOpacity(0.20),
            child: const Center(child: Text("Balance: ", style: TextStyle(fontSize: 25, color: Colors.black)),),
          ),
        Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: ElevatedButton(
          onPressed:  () async {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MapTab()),);
          }, child: const Icon(Icons.map_outlined),
        ) ,) 
      ],
      fullyStretchable: true,
      expandedBody: const QRViewExample(),
      backgroundColor: Colors.white,
      appBarColor: Colors.deepPurple[300],
    );
  }

  Row headerBottomBarWidget(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileTab()),);}, icon: const Icon(Icons.settings)),
      ],
    );
  }

  Widget headerWidget(BuildContext context) {
    return Container(
      color: Colors.deepPurple[200],
      child: 
        Stack(children: [Center(child: ClipRRect(
        borderRadius: BorderRadius.circular(50.0),
        child: Image.asset('lib/images/google.png', height: 100,))),Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 50),
        child:         FutureBuilder<String>(
        future: profile(), // async work
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
           switch (snapshot.connectionState) {
             case ConnectionState.waiting: return const CircularProgressIndicator(
              color: Colors.deepPurple,
            );
             default:
               if (snapshot.hasError) {
                 return Text('Error: ${snapshot.error}');
              } else {
                 return Text(snapshot.data.toString(),style: Theme.of(context)
              .textTheme
              .displayMedium!
              .copyWith(color: Colors.grey[800]),);
              }
        
            }
          },
        )))
        ,])
    );
  }
}