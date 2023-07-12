import 'package:confereus/API/user_api.dart';
import 'package:confereus/components/button/text_button.dart';
import 'package:confereus/components/custom_text.dart';
import 'package:confereus/constants.dart';
import 'package:confereus/main.dart';
import 'package:confereus/models/conference%20model/conference.model.dart';
import 'package:confereus/provider/login_status_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../API/conference_api.dart';
import '../../../components/tiles/unregistered_event_tiles_small.dart';

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
                  Consumer2<LoginStatus, UserAPI>(
                      builder: (context, status, userAPI, child) {
                    return CustomTextButton(
                      onPressed: () {
                        userAPI.logout();
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
                  }),
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
                      const Expanded(
                        child: CustomText(
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
                    children: const [
                      // RegisteredConferenceCard(
                      //   eventLogo: 'images/firebaselogo.png',
                      //   eventName: 'Firebase Summit 2023',
                      //   location: 'Los Angles, USA',
                      //   start: DateTime(2023, 8, 20),
                      //   end: DateTime(2023, 8, 25),
                      //   description:
                      //       'Lorem ipsum dolor sit amet. At possimus repudiandae '
                      //       'sit quisquam assumenda et inventore sunt est fugit possimus'
                      //       ' ab quos voluptas sed iste repudiandae qui enim modi. Aut '
                      //       'numquam quod non similique dolore et omnis molestias et '
                      //       'corporis rerum sit dolore quia et explicabo quae. Sed Quis '
                      //       'optio aut magni consequuntur eum reprehenderit dolorem sit '
                      //       'dolor quisquam est quod voluptate eos possimus ullam et quasi '
                      //       'voluptate. Cum voluptas placeat qui exercitationem velit '
                      //       'ut voluptate repudiandae et accusantium repellendus.',
                      // ),
                      // RegisteredConferenceCard(
                      //   eventLogo: 'images/microsoft.png',
                      //   eventName: 'Microsoft 365 EduCon DC 2023',
                      //   location: 'Los Angles, USA',
                      //   start: DateTime(2023, 9, 12),
                      //   end: DateTime(2023, 9, 15),
                      //   description:
                      //       'Lorem ipsum dolor sit amet. At possimus repudiandae '
                      //       'sit quisquam assumenda et inventore sunt est fugit possimus'
                      //       ' ab quos voluptas sed iste repudiandae qui enim modi. Aut '
                      //       'numquam quod non similique dolore et omnis molestias et '
                      //       'corporis rerum sit dolore quia et explicabo quae. Sed Quis '
                      //       'optio aut magni consequuntur eum reprehenderit dolorem sit '
                      //       'dolor quisquam est quod voluptate eos possimus ullam et quasi '
                      //       'voluptate. Cum voluptas placeat qui exercitationem velit '
                      //       'ut voluptate repudiandae et accusantium repellendus.',
                      // ),
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
                      const Expanded(
                        child: CustomText(
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
                  child: FutureBuilder<List<Conference>?>(
                      future: Provider.of<ConferenceAPI>(context)
                          .fetchConference('all'),
                      builder: (context, snapshot) {
                        return ListView.builder(
                          shrinkWrap: true,
                          // primary: true,
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              snapshot.hasData && snapshot.requireData != null
                                  ? snapshot.requireData!.length
                                  : 0,
                          itemBuilder: (_, i) {
                            final data = snapshot.requireData![i];
                            return UnregisteredConferenceCardSmall(
                              data: data,
                              onRegisterPressed: () {},
                            );
                          },
                          //   UnregisteredConferenceCardSmall(
                          //     eventLogo: 'images/microsoft.png',
                          //     eventName: 'Microsoft Build',
                          //     location: 'Los Angles, USA',
                          //     start: DateTime(2023, 8, 20),
                          //     end: DateTime(2023, 8, 25),
                          //     description:
                          //         'Lorem ipsum dolor sit amet. At possimus repudiandae '
                          //         'sit quisquam assumenda et inventore sunt est fugit possimus'
                          //         ' ab quos voluptas sed iste repudiandae qui enim modi. Aut '
                          //         'numquam quod non similique dolore et omnis molestias et '
                          //         'corporis rerum sit dolore quia et explicabo quae. Sed Quis '
                          //         'optio aut magni consequuntur eum reprehenderit dolorem sit '
                          //         'dolor quisquam est quod voluptate eos possimus ullam et quasi '
                          //         'voluptate. Cum voluptas placeat qui exercitationem velit '
                          //         'ut voluptate repudiandae et accusantium repellendus.',
                          //     onRegisterPressed: () {},
                          //   ),
                          // ],
                        );
                      }),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
