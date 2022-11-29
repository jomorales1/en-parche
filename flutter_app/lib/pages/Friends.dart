

import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/domain/entities/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services_provider.dart';

class FriendsStateful extends StatefulWidget {
   const FriendsStateful({super.key});

   State<FriendsStateful> createState() => Friends();
}


class Friends extends State<FriendsStateful>{

   List<User> items = [];
   bool loaded = false;
   bool matched = false;
   SharedPreferences preferences = getIt();

   @override
   void initState(){
     super.initState();
     // _listUsers();
     // print(items.length);
   }

   @override
   void dispose(){
     super.dispose();
   }




   @override
   Widget build(BuildContext context){

     return FutureBuilder(
       future: _listUsers(),
       builder: (context, AsyncSnapshot<List<User>> snapshot){

         return Scaffold(
           appBar: AppBar(
             title: const Text("Amigos"),
           ),
           resizeToAvoidBottomInset: false,

           body: !matched? const LinearProgressIndicator(
             value: 5,
             semanticsLabel: 'Linear progress indicator'
           ):
           ListView.builder(
               padding: const EdgeInsets.all(16.0),
               itemCount: snapshot.data!.length,
               itemBuilder: (context, index){
                 final item = snapshot.data![index];

                 return ListTile(
                   title: Text(
                       item.isFriend == true? "Mi amigo " + item.name!: item.name!
                   ),
                   subtitle: Text(
                     item.email!
                   ),
                   onTap: (){
                     showDialog(
                         context: context,
                         builder: (context){
                           return AlertDialog(
                             title: const Text("Solicitud de amistad"),
                             content: const Text("Agregar amigo"),
                             actions: <Widget>[
                               TextButton(
                                 onPressed: () => Navigator.pop(context, 'Cancel'),
                                 child: const Text('Cancel'),
                               ),
                               TextButton(
                                   onPressed: (){
                                     addUser(friend1: preferences.getString("email")!, friend2: item.email!);
                                     Navigator.pop(context, 'OK');
                                     },
                                   child: const Text("Agregar")
                               )
                             ],
                           );

                         }
                     );
                   },
                   // onLongPress: (){
                   //
                   // },
                 );
               }),
         );


       },
     );


   }


    Future<List<User>> _listUsers() async{

     List<User> items = [];

      await FirebaseFirestore.instance.collection("users")
          .get()
          .then((value) => {
             value.docs.forEach((element) {
                User user = new User();
                user.email = element.data()['email'];
                user.name = element.data()['name'];
                items.add(user);
             })
      });

      loaded = true;

     _matchFriends(items).then((value) => {
       matched = true
     });

      sleep(const Duration(seconds: 4));
      return items;
   }


   Future<void> _matchFriends(List<User> items) async{

     await FirebaseFirestore.instance.collection("friendships")
          .where('friend1', isEqualTo: preferences.getString("email")!)
         .get()
         .then((value) => {
       value.docs.forEach((element) {
         for (User u in items){
           if(u.email == element.data()['friend2']){
             u.isFriend = true;
           }
         }
       })
     });

   }


   void addUser({required String friend1, required String friend2}) async{

     // FirebaseMessaging messaging = FirebaseMessaging.instance;

     await FirebaseFirestore.instance.collection("friendships").add({
       'friend1': friend1,
       'friend2': friend2
     });


     AwesomeNotifications().requestPermissionToSendNotifications();
     AwesomeNotifications().createNotification(
         content: NotificationContent(
             id: 1,
             channelKey: 'basic',
             title: 'En parche',
             body: 'agregaste un nuevo amigo'
         )
     );

   }

}