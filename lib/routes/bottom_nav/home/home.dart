import 'package:confereus/components/button/filled_button.dart';
import 'package:confereus/components/button/text_button.dart';
import 'package:confereus/components/custom_text.dart';
import 'package:confereus/constants.dart';
import 'package:confereus/main.dart';
import 'package:confereus/provider/login_status_provider.dart';
import 'package:confereus/sign_up_APIs/email_and_password/logout.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../components/tiles/registered_tile_event/registered_event_tiles_small.dart';
import '../../../components/tiles/unregistered_tile_event/unregistered_event_tiles_small.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0,
        toolbarHeight: 70,
        leading: Container(),
        titleSpacing: 10,
        title: Row(
          children: [
            const CircleAvatar(
              foregroundImage: AssetImage('images/person.png'),
              radius: 23,
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                    'Hello, Yashvardhan',
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Consumer<LoginStatus>(
                    builder: (context,status,child) {
                      return CustomTextButton(
                        onPressed: () {
                          logout();
                          status.clearData();

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LogoPage(needsLogin: true),
                            ),
                            (route) => false,
                          );
                        },
                        child: const CustomText(
                          'Sign Out',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: kColorDark,
                        ),
                      );
                    }
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_rounded),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.message_outlined),
          ),
        ],
      ),
      body: ListView(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: const CustomText(
                          'Registered Conferences',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      CustomTextButton(
                        onPressed: () {},
                        child: const CustomText(
                          'See all',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: kColorDark,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 310,
                  width: deviceSize.width,
                  child: ListView(
                    shrinkWrap: true,
                    // primary: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      RegisteredConferenceCard(
                        eventLogo: 'images/firebaselogo.png',
                        eventName: 'Firebase Summit 2023',
                        location: 'Los Angles, USA',
                        start: DateTime(2023, 8, 20),
                        end: DateTime(2023, 8, 25),
                      ),
                      RegisteredConferenceCard(
                        eventLogo: 'images/microsoft.png',
                        eventName: 'Microsoft 365 EduCon DC 2023',
                        location: 'Los Angles, USA',
                        start: DateTime(2023, 9, 12),
                        end: DateTime(2023, 9, 15),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: const CustomText(
                          'Suggested Conferences',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      CustomTextButton(
                        onPressed: () {},
                        child: const CustomText(
                          'See all',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: kColorDark,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 350,
                  width: deviceSize.width,
                  child: ListView(
                    shrinkWrap: true,
                    // primary: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      UnregisteredConferenceCardSmall(
                        eventLogo: 'images/gdsclogo.png',
                        eventName: 'Android Dev Summit 2023',
                        location: 'Los Angles, USA',
                        start: DateTime(2023, 8, 12),
                        end: DateTime(2023, 8, 15),
                        onRegisterPressed: () {},
                      ),
                      UnregisteredConferenceCardSmall(
                        eventLogo: 'images/microsoft.png',
                        eventName: 'Microsoft Build',
                        location: 'Los Angles, USA',
                        start: DateTime(2023, 8, 20),
                        end: DateTime(2023, 8, 25),
                        onRegisterPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}