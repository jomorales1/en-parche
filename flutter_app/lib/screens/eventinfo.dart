import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/event.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/services_provider.dart';

class EventInfo extends StatefulWidget {
  const EventInfo({super.key, required this.event});

  final EventModel event;

  @override
  State<EventInfo> createState() => _EventInfoState();
}

class _EventInfoState extends State<EventInfo> {
  String? message = 'Registrarse', email = '';

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
    SharedPreferences preferences = getIt();
    email = preferences.getString("email");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('En parche')),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.event.title!,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              widget.event.image_url!,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Fecha: ${widget.event.event_date!}',
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Hora: ${widget.event.start_time!}',
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Lugar: ${widget.event.place!}',
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Organizador: ${widget.event.organizer!}',
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Descripción: ${widget.event.description!}',
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: RawMaterialButton(
                  fillColor: Color(0xFF0069FE),
                  elevation: 0.0,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  onPressed: () async {
                    var user = await FirebaseFirestore.instance
                        .collection("users")
                        .where("email", isEqualTo: email)
                        .limit(1)
                        .get();
                    var userId = user.docs[0].id;
                    var eventId = "1";
                    await FirebaseFirestore.instance
                        .collection("events")
                        .where("title", isEqualTo: widget.event.title)
                        .get()
                        .then((value) => {eventId = value.docs[0].id});
                    List eventsList = user.docs[0].data()['events'];
                    if (message == 'Registrarse') {
                      if (!eventsList.contains(eventId)) {
                        eventsList.add(eventId);
                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(userId)
                            .update({"events": eventsList}).then(
                                (value) => message = "Registrado",
                                onError: (e) =>
                                    {print("Error updating document $e")});
                      }
                      setState(() {
                       message = "Registrado"; 
                      });
                    } else if (message == "") {
                      if (eventsList.contains(eventId)) {
                        setState(() {
                          message = "Registrado"; 
                        });
                      } else {
                        setState(() {
                          message = "Registrado"; 
                        });
                      }
                    }
                    if (message == '') {
                      setState(() {
                       message = "Registrarse"; 
                      });
                    }
                  },
                  child: Text(
                    message!,
                    style: const TextStyle(color: Colors.white, fontSize: 18.0),
                  ))),
        ],
      ),
    );
  }
}
