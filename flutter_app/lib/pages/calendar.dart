import 'package:dartz/dartz_unsafe.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/services_provider.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  String? _eventTitle,
      _eventDate,
      _eventStartTime,
      _eventEndTime,
      _eventPlace,
      _eventOrganizer,
      _eventDescription,
      _eventImage,
      _timeDetails,
      _subjectText,
      _dateText;

  @override
  void initState() {
    _eventTitle = '';
    _eventDate = '';
    _eventStartTime = '';
    _eventPlace = '';
    _eventOrganizer = '';
    _eventDescription = '';
    _eventImage = '';
    _timeDetails = '';
    _subjectText = '';
    _dateText = '';
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
  }

  Future<QuerySnapshot> retrieveEvents() async {
    SharedPreferences preferences = getIt();
    String? email = preferences.getString("email");
    Future<QuerySnapshot> events;
    var user = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .limit(1)
        .get();
    var eventsList = user.docs[0].data()['events'];
    var query = FirebaseFirestore.instance
        .collection("events")
        .where(FieldPath.documentId, whereIn: eventsList);
    events = query.get();
    return events;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendar"),
      ),
      body: FutureBuilder(
          future: retrieveEvents(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              var snap = snapshot.data;
              List docs = snap!.docs;
              return SfCalendar(
                view: CalendarView.month,
                selectionDecoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  shape: BoxShape.rectangle,
                ),
                showNavigationArrow: true,
                cellEndPadding: 5,
                showCurrentTimeIndicator: true,
                todayHighlightColor: Colors.blue,
                firstDayOfWeek: 1,
                dataSource: getCalendarDataSource(docs),
                onTap: calendarTapped,
                monthViewSettings: MonthViewSettings(
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.appointment),
              );
            }
            return SfCalendar(
              view: CalendarView.month,
              selectionDecoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                shape: BoxShape.rectangle,
              ),
              showNavigationArrow: true,
              cellEndPadding: 5,
              showCurrentTimeIndicator: true,
              todayHighlightColor: Colors.blue,
              firstDayOfWeek: 1,
              onTap: calendarTapped,
              monthViewSettings: MonthViewSettings(
                  appointmentDisplayMode:
                      MonthAppointmentDisplayMode.appointment),
            );
          }),
    );
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.appointment ||
        calendarTapDetails.targetElement == CalendarElement.agenda) {
      final Appointment appointmentDetails =
          calendarTapDetails.appointments![0];
      _eventTitle = appointmentDetails.subject;
      _eventDate = DateFormat('MMMM dd, yyyy')
          .format(appointmentDetails.startTime)
          .toString();
      _eventStartTime =
          DateFormat('hh:mm a').format(appointmentDetails.startTime).toString();
      _eventEndTime =
          DateFormat('hh:mm a').format(appointmentDetails.endTime).toString();
      _timeDetails = '$_eventStartTime - $_eventEndTime';
      _eventPlace = appointmentDetails.location;
    } else if (calendarTapDetails.targetElement ==
        CalendarElement.calendarCell) {
      _subjectText = "You have tapped cell";
      _dateText = DateFormat('MMMM dd, yyyy')
          .format(calendarTapDetails.date!)
          .toString();
      _timeDetails = '';
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Container(child: new Text('$_subjectText')),
            content: Container(
              height: 80,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        '$_dateText',
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: <Widget>[
                        Text(_timeDetails!,
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 15)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'))
            ],
          );
        });
  }
}

DataSource getCalendarDataSource(var events) {
  final List<Appointment> appointments = <Appointment>[];
  for (var element in events) {
    appointments.add(Appointment(
        startTime: DateTime.parse(element.docs[0].get("event_date") +
            " " +
            element.docs[0].get("start_time")),
        endTime: DateTime.parse(element.docs[0].get("event_date") +
                " " +
                element.docs[0].get("start_time"))
            .add(const Duration(hours: 2, days: -1)),
        subject: element.docs[0].get("title"),
        color: Colors.lightBlueAccent));
  }
  return DataSource(appointments);
}

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }
}
