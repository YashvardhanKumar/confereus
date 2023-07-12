import 'package:confereus/components/custom_text.dart';
import 'package:confereus/components/tiles/event_tiles_big.dart';
import 'package:flutter/material.dart';

class Explore extends StatelessWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText('Explore conferences'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_rounded),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          ConferenceBigCard(
            eventLogo: 'images/firebaselogo.png',
            eventName: 'Firebase Summit 2023',
            location: 'Los Angles, USA',
            start: DateTime(2023, 8, 20),
            end: DateTime(2023, 8, 25),
            onRegisterPressed: null,
          ),
          ConferenceBigCard(
            eventLogo: 'images/microsoft.png',
            eventName: 'Microsoft 365 EduCon DC 2023',
            location: 'Los Angles, USA',
            start: DateTime(2023, 9, 12),
            end: DateTime(2023, 9, 15),
            onRegisterPressed: null,
          ),
          ConferenceBigCard(
            eventLogo: 'images/gdsclogo.png',
            eventName: 'Android Dev Summit 2023',
            location: 'Los Angles, USA',
            start: DateTime(2023, 8, 12),
            end: DateTime(2023, 8, 15),
            onRegisterPressed: () {},
          ),
          ConferenceBigCard(
            eventLogo: 'images/microsoft.png',
            eventName: 'Microsoft Build',
            location: 'Los Angles, USA',
            start: DateTime(2023, 8, 20),
            end: DateTime(2023, 8, 25),
            onRegisterPressed: () {},
          ),
        ],
      ),
    );
  }
}
