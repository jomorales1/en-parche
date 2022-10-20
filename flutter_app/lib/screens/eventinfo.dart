import 'package:flutter/material.dart';
import 'package:flutter_app/models/event.dart';

class EventInfo extends StatefulWidget {
  const EventInfo({super.key, required this.event});

  final EventModel event;

  @override
  State<EventInfo> createState() => _EventInfoState();
}

class _EventInfoState extends State<EventInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('En parche')
      ),
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
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Hora: ${widget.event.start_time!}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Lugar: ${widget.event.place!}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Organizador: ${widget.event.organizer!}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Descripción: ${widget.event.description!}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),
            ),

          ],
      ),
    );
  }

}