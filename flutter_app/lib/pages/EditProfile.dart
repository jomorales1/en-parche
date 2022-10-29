
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/services_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileStateful extends StatefulWidget{
  const EditProfileStateful({super.key});

  State<EditProfileStateful> createState() => EditProfile();
}

class EditProfile extends State<EditProfileStateful> {

  SharedPreferences preferences = getIt();
  String email = "";
  String name = "";


  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getUser(preferences.getString("email")!);
    });

  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(

      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(email),
              Text(name)
            ]
        ),

      ),
    );
  }

  _getUser(String email) async {
    await FirebaseFirestore.instance.collection("users")
        .where('email', isEqualTo: email)
        .get()
        .then((value) {

          setState(() {
            name = value.docs.first.data().values.first;
            this.email = value.docs.first.data().values.last;
          });
    });
  }

}