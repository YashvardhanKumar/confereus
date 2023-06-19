import 'package:confereus/components/custom_text.dart';
import 'package:confereus/components/tiles/registered_tile_event/registered_event_tiles_big.dart';
import 'package:flutter/material.dart';

class Explore extends StatelessWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText('Explore conferences'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search_rounded),
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          RegisteredConferenceBigCard(
            eventLogo: 'images/firebaselogo.png',
            eventName: 'Firebase Summit 2023',
            location: 'Los Angles, USA',
            start: DateTime(2023, 8, 20),
            end: DateTime(2023, 8, 25),
            onRegisterPressed: null,
          ),
          RegisteredConferenceBigCard(
            eventLogo: 'images/microsoft.png',
            eventName: 'Microsoft 365 EduCon DC 2023',
            location: 'Los Angles, USA',
            start: DateTime(2023, 9, 12),
            end: DateTime(2023, 9, 15),
            onRegisterPressed: null,
          ),
          RegisteredConferenceBigCard(
            eventLogo: 'images/gdsclogo.png',
            eventName: 'Android Dev Summit 2023',
            location: 'Los Angles, USA',
            start: DateTime(2023, 8, 12),
            end: DateTime(2023, 8, 15),
            onRegisterPressed: () {},
          ),
          RegisteredConferenceBigCard(
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
