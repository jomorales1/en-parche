

import 'package:flutter_app/src/domain/entities/User.dart';
import 'package:flutter_app/src/domain/repository/User_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserServerRepository extends UserRepository {

  @override
  Future<void> add(String? name, String? email) async{
    await FirebaseFirestore.instance.collection("users").add({
      'name': name,
      'email': email
    });
  }


  @override
  Future<void> signUp(String email, String password) async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
    }finally{

    }
  }

  @override
  Future<String> login(String email, String password) async {
     FirebaseAuth auth = FirebaseAuth.instance;
    try{
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      print("sirviooo");
      return "exit";
    }on FirebaseAuthException catch(e){
      print(e);
      if(e.code == "user-not-found") {
        print("autenticacion fallo");
        return "user-not-found";
      } else if(e.code == 'wrong-password'){
        return "wrong-password";
      }

    }
    return "fail";
  }

}