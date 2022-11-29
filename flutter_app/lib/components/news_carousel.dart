import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/news.dart';
import 'package:flutter_app/screens/newsinfo.dart';

class CarouselNews extends StatefulWidget {
  const CarouselNews({super.key, required this.title});

  final String title;

  @override
  State<CarouselNews> createState() => _CarouseNewslState();
}

class _CarouseNewslState extends State<CarouselNews> {

  Future<QuerySnapshot> retrieveNew() async {
    QuerySnapshot<Map<String, dynamic>> document = await FirebaseFirestore.instance.collection('news').get();
    return document;
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
  }

  TextButton createCard(NewsModel news){
    return TextButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute( builder: (context) => NewsInfo(news: news)));
      },
      child: Stack(
          children: <Widget> [
            Image.network(
              news.image_url!,
            ),
            Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    news.title!,
                    style: const TextStyle(fontSize: 17,fontWeight: FontWeight.bold, color: Colors.white, backgroundColor: Colors.black),
                  ),
                )
            )
          ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: <Widget>[
        Text(
          widget.title,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        FutureBuilder(
          future:
          retrieveNew(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              var snap = snapshot.data;
              List docs = snap!.docs;
              return SizedBox(
                  height: 175.0,
                  width: 225.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(10.0),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      NewsModel news = NewsModel.fromJson(docs[index].data());
                      return Container(
                        margin: const EdgeInsets.only(right: 15.0),
                        padding: const EdgeInsets.all(5.0),
                        child: createCard(news),
                      );
                    },
                  )
              );
            } else {
              return const Center(
                child: Text('No News'),
              );
            }
          },
        ),
      ],
    );
  }
}