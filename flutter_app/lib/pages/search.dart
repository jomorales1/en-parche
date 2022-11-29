import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/carousel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app/pages/new_event.dart';
import 'package:flutter_app/screens/eventinfo.dart';

import '../models/event.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
  }

  Future<List<EventModel>> allEvents(String query) async {
    QuerySnapshot<Map<String, dynamic>> document =  await FirebaseFirestore.instance.collection('events').get();
    List docs = document!.docs;
    List<EventModel> events = List<EventModel>.generate(docs.length, (index) => EventModel.fromJson(docs[index].data()));
    return events;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buscar"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  //updateCount(value);
                });
              },
              controller: editingController,
              decoration: const InputDecoration(
                  labelText: "Busqueda",
                  hintText: "Busqueda",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future:
                allEvents(editingController.text),
              builder: (context, AsyncSnapshot<List<EventModel>> snapshot) {
                if (snapshot.hasData) {
                  List<EventModel> events = snapshot.data!;
                  return  ListView.builder(
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.all(20.0),
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          EventModel event = events[index];
                          if(event.title!.toLowerCase().contains(editingController.text.toLowerCase())){
                            return createCard(event);
                          }else{
                            return SizedBox.fromSize();
                          }
                        },
                  );
                } else {
                  return const Center(
                    child: Text('No Feeds'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}