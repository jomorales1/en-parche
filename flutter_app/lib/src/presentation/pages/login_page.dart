import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/mainscreen.dart';
import 'package:flutter_app/services_provider.dart';
import 'package:flutter_app/src/presentation/register_page.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPageStateful extends StatefulWidget{
  const LoginPageStateful({super.key});

  @override
  State<LoginPageStateful> createState() => LoginPage();
}

class LoginPage extends State<LoginPageStateful>{
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose(){
    email.dispose();
    password.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'En Parche',
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
            child: ListView(
              children: [
                Image.asset('assets/images/logo.PNG'),
                const SizedBox(height: 60.0),
                Container(
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: email,
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
                    controller: password,
                    style: const TextStyle(fontSize: 20),
                    decoration: const InputDecoration(
                        hintText: "Ingrese la contraseña",
                        prefixIcon: Icon(Icons.lock, color: Colors.black)
                    ),
                  ),
                ),
                const SizedBox(height: 88.0),
             RawMaterialButton(
                      fillColor: Color(0xFF0069FE),
                    elevation: 0.0,
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)
                    ),
                    onPressed: () async {

                      bool? isLogged = await login(
                          email: email.text, password: password.text);

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
            ),
                loginWidget(),
                SignInButton(
                    Buttons.Google,
                    text: "Ingresar con Google",
                    onPressed: () async {
                      bool? isLoggedWithGoogle = await logInWithGoogle();
                      if(isLoggedWithGoogle){
                        Navigator.push(context, MaterialPageRoute( builder: (context) => Mainscreen()));
                      }else{
                        Fluttertoast.showToast(msg: "Usuario no encontrado, debe registrarse",
                            gravity: ToastGravity.BOTTOM);
                      }
                    }
                )
              ],
            )
        ),
      ),

    );

  }

  static Future<bool?> login({required String email, required String password})  async{
    FirebaseAuth auth = FirebaseAuth.instance;
    SharedPreferences preferences = getIt();
    User? user;
    print(email);
    try{
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;

      preferences.setString("email", email);

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

  static Future<bool> logInWithGoogle() async{

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    String email = "";
    SharedPreferences preferences = getIt();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if(googleSignInAccount != null){
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken:  googleSignInAuthentication.idToken
      );

      try{
        final UserCredential userCredential = await auth.signInWithCredential(authCredential);

        user = userCredential.user;
        if(user?.email != null){
          email = user?.email ?? "";
        }
        preferences.setString("email", email);
        return true;
      } on FirebaseAuthException catch(e){
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        }
        else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
      }

    }


    return false;
  }



}

class loginWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>
        RegisterPageSateful()
      )
      );
    },
        child: Text("Registrate")
    );
  }

}

class goToMain extends State<LoginPageStateful> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();


  // ignore: no_leading_underscores_for_local_identifiers
  goToMain

  ({required TextEditingController emailController, required TextEditingController passwordController}) {
  this._emailController = _emailController;
  this._passwordController = _passwordController;

  print(_emailController.text);
  print(_passwordController.text);
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

          bool? isLogged = await login(
              email: _emailController.text, password: _passwordController.text);
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