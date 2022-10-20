
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/screens/mainscreen.dart';
import 'package:flutter_app/src/presentation/register_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

// class LoginStatefulWidget extends StatefulWidget{
//   const LoginStatefulWidget({Key? key}) : super(key: key);
//
//   @override
//   State<LoginStatefulWidget> createState() => LoginPage();
// }

class LoginPage extends StatelessWidget{
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return MaterialApp(
      title: 'En Parche',
      home: Scaffold(
        // appBar: AppBar(
        // ),
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
                      controller: emailController,
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(
                        hintText: "Ingrese el usuario",
                        prefixIcon: Icon(Icons.mail, color: Colors.black,)
                      ),
                      validator: (value){
                        if(value!.isEmpty) return 'Ingrese el usuario';
                      },
                    ),
                ),
                const SizedBox(height: 26.0),
                Container(
                  child: TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    style: const TextStyle(fontSize: 20),
                    decoration: const InputDecoration(
                        hintText: "Ingrese la contraseña",
                        prefixIcon: Icon(Icons.lock, color: Colors.black)
                    ),
                  ),
                ),
                const SizedBox(height: 88.0),
                goToMain(emailController: emailController, passwordController: passwordController,),
                loginWidget()
              ],
            )
        ),
      ),

    );

  }

  static Future<User?> login({required String email, required String password})  async{
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try{
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);    user = userCredential.user;
      print("sirviooo");
    }on FirebaseAuthException catch(e){
      if(e.code == "user-not-found") {
        print("autenticacion fallo");
      }
    }
  }

}

class loginWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>
        RegisterPage()
      )
      );
    },
        child: Text("Registrate")
    );
  }

}

class goToMain extends StatelessWidget {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();


  // ignore: no_leading_underscores_for_local_identifiers
  goToMain

  ({super.key, required TextEditingController emailController, required TextEditingController passwordController}) {
  this._emailController = _emailController;
  this._passwordController = _passwordController;
  }

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
        fillColor: Color(0xFF0069FE),
        elevation: 0.0,
        padding: EdgeInsets.symmetric(vertical: 20.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0)
        ),
        onPressed: () async {
          // if(_emailController.text.isEmpty || _passwordController.text.isEmpty){
          //   Fluttertoast.showToast(msg: "Todos los campos son obligatorios;",
          //       gravity: ToastGravity.BOTTOM);
          //   return;
          // }

          bool? isLogged = await login(
              email: _emailController.text, password: _passwordController.text);
          // ignore: use_build_context_synchronously
          Navigator.push(context, MaterialPageRoute( builder: (context) => Mainscreen()));
          if(isLogged != null && isLogged){
            Navigator.push(context, MaterialPageRoute( builder: (context) => Mainscreen()));
          }else{
            Fluttertoast.showToast(msg: "Usuario no encontrado, debe registrarse",
            gravity: ToastGravity.BOTTOM);
          }
        },
        child: const Text("Ingresar",
          style: TextStyle(
              color: Colors.white,
              fontSize: 18.0
          ),)
    );
  }

  static Future<bool?> login({required String email, required String password})  async{
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    print(email);
    print(password);
    try{
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
      print("sirviooo");
      return true;
    }on FirebaseAuthException catch(e){
      print(e);
      if(e.code == "user-not-found") {
        print("autenticacion fallo");
      }
      return false;

    }
  }
}