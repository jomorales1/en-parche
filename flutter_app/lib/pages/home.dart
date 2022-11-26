import 'package:flutter/material.dart';
import 'package:flutter_app/components/carousel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app/components/news_carousel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inicio"),
      ),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: const <Widget> [
            Carousel(title: 'Eventos hoy', number: 0),
            Carousel(title: 'Durante el almuerzo', number: 1),
            Carousel(title: 'Facultad de ingeniería', number: 2),
            Carousel(title: 'Otros', number: 3),
            CarouselNews(title: 'Noticias')
          ],
        ),
      ),

    );
  }
}