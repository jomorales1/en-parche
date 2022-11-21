import 'package:flutter/material.dart';
import 'package:flutter_app/pages/EditProfile.dart';
import 'package:flutter_app/pages/home.dart';
import 'package:animations/animations.dart';
import 'package:flutter_app/pages/search.dart';

import '../pages/auxiliar.dart';
import '../pages/new_event.dart';

class Mainscreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<Mainscreen> {
  int _page = 0;

  List pages = [
    {
      'title': 'Home',
      'icon': Icons.home,
      'page': const HomePage(),
      'index': 0,
    },
    {
      'title': 'Search',
      'icon': Icons.search,
      'page': const SearchPage(),
      'index': 1,
    },
    {
      'title': 'Add',
      'icon': Icons.add_box,
      'page': const newEventPage(),
      'index': 2,
    },
    {
      'title': 'Calendar',
      'icon': Icons.calendar_month,
      'page': const AuxPage(),
      'index': 3,
    },
    {
      'title': 'Profile',
      'icon': Icons.person,
      'page': const EditProfileStateful(),
      'index': 4,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTransitionSwitcher(
        transitionBuilder: (
            Widget child,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            ) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: pages[_page]['page'],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 5),
            for (Map item in pages)
                  Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: IconButton(
                        icon: Icon(
                          item['icon'],
                          color: item['index'] != _page
                              ? Colors.grey
                              : Theme.of(context).colorScheme.secondary,
                          size: 20.0,
                        ),
                        onPressed: () => navigationTapped(item['index']),
                      ),
                    ),
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }

  buildFab() {
    return Container(
      height: 45.0,
      width: 45.0,
      // ignore: missing_required_param
    );
  }

  void navigationTapped(int page) {
    setState(() {
      _page = page;
    });
  }
}