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
  String? _eventStartTime,
      _eventEndTime,
      _timeDetails,
      _subjectText,
      _dateText,
      _eventTitle,
      _eventDate,
      _eventPlace,
      _option;

  @override
  void initState() {
    _eventStartTime = '';
    _eventEndTime = '';
    _timeDetails = '';
    _subjectText = '';
    _dateText = '';
    _eventTitle = '';
    _eventDate = '';
    _eventPlace = '';
    _option = 'month';
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
    super.initState();
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

  CalendarView getCalendarOption() {
    if (_option == 'day') {
      return CalendarView.day;
    }
    if (_option == 'week') {
      return CalendarView.week;
    }
    return CalendarView.month;
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
                allowedViews: const [
                  CalendarView.month,
                  CalendarView.week,
                  CalendarView.day
                ],
                view: getCalendarOption(),
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
                monthViewSettings: const MonthViewSettings(
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.appointment,
                    showAgenda: true),
              );
            }
            return SfCalendar(
              allowedViews: const [
                CalendarView.month,
                CalendarView.week,
                CalendarView.day
              ],
              view: getCalendarOption(),
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
              monthViewSettings: const MonthViewSettings(
                  appointmentDisplayMode:
                      MonthAppointmentDisplayMode.appointment,
                  showAgenda: true),
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
      _subjectText = "Día seleccionado:";
      _dateText = DateFormat('MMMM dd, yyyy')
          .format(calendarTapDetails.date!)
          .toString();
      _timeDetails = '';
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('$_subjectText'),
            content: SizedBox(
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
        startTime: DateTime.parse(
            element.get("event_date") + " " + element.get("start_time")),
        endTime: DateTime.parse(
                element.get("event_date") + " " + element.get("start_time"))
            .add(const Duration(hours: 2, days: -1)),
        subject: element.get("title"),
        location: element.get("place"),
        color: Colors.lightBlueAccent));
  }
  return DataSource(appointments);
}

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }
}
