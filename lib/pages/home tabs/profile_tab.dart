import 'package:crowd_front_end/api_service.dart';
import 'package:crowd_front_end/pages/home%20tabs/map_tab.dart';
import 'package:crowd_front_end/pages/login_page.dart';
import 'package:crowd_front_end/pages/qrcode_page.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple[200],
      child: SafeArea(child: Column(
      children: [
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
        ,]),
      FutureBuilder(
          future: fetchQr(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Image.memory(snapshot.data!);
            }
          },
        ),
        Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: ElevatedButton(
          onPressed:  
          () async {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.confirm,
              text: 'Do you want to logout',
              confirmBtnText: 'Yes',
              cancelBtnText: 'No',
              confirmBtnColor: Colors.green,
              onConfirmBtnTap: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.clear();
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()),);}
            );
            
          }, child: Text("Logout"),
        ) ,) 
      ],
    )));
  }

}