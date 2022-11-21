import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/event.dart';
import 'package:flutter_app/screens/eventinfo.dart';
import 'package:intl/intl.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key, required this.title, required this.number});

  final String title;
  final int number;

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {

  Future<QuerySnapshot> retrieveEvent(int number) async {
    QuerySnapshot<Map<String, dynamic>> document;
    String date = DateFormat("yyyy-MM-dd").format(DateTime.now());

    if(number == 0){
      document = await FirebaseFirestore.instance.collection('events').where("event_date", isEqualTo: date).get();
    }else if(number == 1){
      document = await FirebaseFirestore.instance.collection('events').where("start_time", isEqualTo: "13:00").get();
    }else if(number == 2){
      document = await FirebaseFirestore.instance.collection('events').where("organizer", isEqualTo: "Facultad de Ingeniería").get();
    }else{
      document = await FirebaseFirestore.instance.collection('events').limit(15).get();
    }
    return document;
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
  }

  TextButton createCard(EventModel event){
    return TextButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute( builder: (context) => EventInfo(event: event)));
        },
        child: Stack(
            children: <Widget> [
              Image.network(
                event.image_url!,
              ),
              Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      event.title!,
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
            retrieveEvent(widget.number),
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
                    EventModel event = EventModel.fromJson(docs[index].data());
                    return Container(
                      margin: const EdgeInsets.only(right: 15.0),
                      padding: const EdgeInsets.all(5.0),
                      child: createCard(event),
                    );
                },
              )
            );
          } else {
              return const Center(
              child: Text('No Feeds'),
            );
          }
        },
        ),
      ],
    );
  }
}