

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    TextEditingController _nameController = TextEditingController();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return MaterialApp(
      title: 'Registro',
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.PNG'),
                const SizedBox(height: 60.0),
                Container(
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    style: const TextStyle(fontSize: 20),
                    decoration: const InputDecoration(
                        hintText: "Ingrese el correo",
                        prefixIcon: Icon(Icons.mail, color: Colors.black,)
                    ),
                  ),
                ),
                const SizedBox(height: 26.0),
                Container(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _nameController,
                    style: const TextStyle(fontSize: 20),
                    decoration: const InputDecoration(
                        hintText: "Ingrese el nombre",
                        prefixIcon: Icon(Icons.person, color: Colors.black,)
                    ),
                  ),
                ),
                const SizedBox(height: 26.0),
                Container(
                  child: TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    style: const TextStyle(fontSize: 20),
                    decoration: const InputDecoration(
                        hintText: "Ingrese la contraseña",
                        prefixIcon: Icon(Icons.lock, color: Colors.black,)
                    ),
                  ),
                ),
                const SizedBox(height: 88.0),// SignUpButton(name: _nameController.text, email: _emailController.text, password: _passwordController.text)
              RawMaterialButton(fillColor: Color(0xFF0069FE),
                    elevation: 0.0,
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)
                    ),
                      onPressed: () async {
                    if(_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty){
                      Fluttertoast.showToast(msg: "Debe diligenciar todos los campos",
                          gravity: ToastGravity.BOTTOM);
                      return;
                    }

                    await _signUp(
                    name: _nameController.text,
                    email: _emailController.text,
                    password: _passwordController.text
                    );
                    Fluttertoast.showToast(msg: "Usuario creado",
                    gravity: ToastGravity.BOTTOM);
                    Navigator.pop(context);
                    },
                    child: const Text("Registrarse", style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0
                    ),)
              )
        ]
          ),
        ),
      )

    );
  }

  Future _signUp({required String name, required String email, required String password}) async {
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      print("se creo el usuario");
      uploadUser(name: name, mail: email);
    }finally{

    }
  }

  Future<void> uploadUser({required String name, required String mail}) async{
    await FirebaseFirestore.instance.collection("users").add({
      'name': name,
      'email': mail
    });
    print("usuario agregado");
  }


}

class SignUpButton extends StatelessWidget{
  final String name;
  final String email;
  final String password;

  SignUpButton({required this.name, required this.email, required this.password});


  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: () async {
      await _signUp(
          name: name,
          email: email,
          password: password
      );
      Navigator.pop(context);
    },
        child: Text("Registrarse")
    );
  }

  Future _signUp({required String name, required String email, required String password}) async {
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      print("se creo el ususario");
    }finally{

    }
  }

}