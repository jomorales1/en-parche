
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/services_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../src/domain/entities/UserToUpdate.dart';

class EditProfileStateful extends StatefulWidget{
  const EditProfileStateful({super.key});

  State<EditProfileStateful> createState() => EditProfile();
}

class EditProfile extends State<EditProfileStateful> {

  final emailController = TextEditingController();
  final nameController = TextEditingController();

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
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.mail, color: Colors.black,)
                ),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person, color: Colors.black,)
                ),
              ),
              const SizedBox(height: 26.0),
              RawMaterialButton(fillColor: Color(0xFF0069FE),
                  elevation: 0.0,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)
                  ),
                  onPressed: () async {
                    if(nameController.text.isEmpty || emailController.text.isEmpty){
                      Fluttertoast.showToast(msg: "Debe diligenciar todos los campos",
                          gravity: ToastGravity.BOTTOM);
                      return;
                    }

                    await _updateUser(
                        emailController.text,
                        nameController.text
                    );
                    Fluttertoast.showToast(msg: "Usuario actualizado",
                        gravity: ToastGravity.BOTTOM);
                    Navigator.pop(context);
                  },
                  child: const Text("Editar", style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0
                  ),)
              )

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
            nameController.text = name;
            this.email = value.docs.first.data().values.last;
            emailController.text = email;
          });
    });
  }

  _updateUser(String email, String name) async {

    print(email);
    final Map<String, Object> params = {
      "name": name,
      "email": email
    };

    final user  = FirebaseAuth.instance.currentUser;
    if(user != null){
      await user?.updateEmail(email);
    }
    await FirebaseFirestore.instance.collection("users")
        .where('email', isEqualTo: this.email)
        .get()
        .then((value) {
      setState(() {
          FirebaseFirestore.instance.collection("users")
              .doc(value.docs.first.id)
              .update(params);

      });
    });
    
  }

}