import 'package:flutter/material.dart';
import 'package:flutter_app/services_provider.dart';
import 'package:flutter_app/src/presentation/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'package:flutter_app/pages/home.dart';
import 'package:flutter_app/screens/mainscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  // runApp(LoginPage());
  init();
  await getIt.allReady();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPageStateful()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: const StadiumBorder(),
                side: BorderSide(
                  width: 5,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              onPressed: () { Navigator.push(context,  MaterialPageRoute( builder: (context) => Mainscreen())); },
              child: const Text('Login', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),),
            ),

          ],
        ),
      )
    );
  }
}
