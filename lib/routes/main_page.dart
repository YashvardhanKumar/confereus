import 'package:confereus/routes/bottom_nav/add_conference/add_conference.dart';
import 'package:confereus/routes/bottom_nav/explore/explore.dart';
import 'package:confereus/routes/bottom_nav/home/home.dart';
import 'package:flutter/material.dart';

import '../components/bottom_nav.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.email}) : super(key: key);
  final String? email;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int idx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(
        items: [
          Icons.home_rounded,
          Icons.explore_rounded,
          Icons.notifications_rounded,
          Icons.groups_rounded,
        ],

        onChanged: (int value) {
          idx = value;
          setState(() {});
        }, onAddClicked: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => CreateNewConference()));
      },
      ),
      body: [
        Home(),
        Explore(),
        Home(),
        Home(),
      ][idx],
    );
  }
}
