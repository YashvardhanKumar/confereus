import 'package:confereus/API/user_api.dart';
import 'package:confereus/API/user_profile_api.dart';
import 'package:confereus/components/button/text_button.dart';
import 'package:confereus/components/current_conference_card.dart';
import 'package:confereus/components/custom_text.dart';
import 'package:confereus/constants.dart';
import 'package:confereus/main.dart';
import 'package:confereus/models/conference%20model/conference.model.dart';
import 'package:confereus/provider/login_status_provider.dart';
import 'package:confereus/routes/bottom_nav/home/app_bar/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../API/conference_api.dart';
import '../../../components/common_pages/see_all_page.dart';
import '../../../components/tiles/registered_event_tiles_small.dart';
import '../../../components/tiles/unregistered_event_tiles_small.dart';
import '../../../models/user model/user_model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = PageController();
  int pageNo = 0;

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0,
        toolbarHeight: 70,
        leading: Container(),
        titleSpacing: 10,
        title: Consumer<UserProfileAPI>(builder: (context, userAPI, child) {
          return StreamBuilder<Users?>(
              stream: userAPI.userProfile(context).asStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.transparent,
                    ),
                  );
                }
                final data = snapshot.data!;
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const Profile()));
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.grey.shade200,
                        radius: 23,
                        child: data.profileImageURL != null
                            ? Image.network(data.profileImageURL!)
                            : const Icon(
                                Icons.person,
                                size: 30,
                                color: Colors.grey,
                              ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            'Hello, ${data.name.split(" ").first}',
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
                                    builder: (_) =>
                                        const LogoPage(needsLogin: true),
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
                );
              });
        }),
      ),
      body: Consumer<ConferenceAPI>(builder: (context, confApi, _) {
        return RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: ListView(
            padding: const EdgeInsets.all(10),
            // mainAxisSize: MainAxisSize.min,
            children: [
              StreamBuilder<List<Conference>?>(
                  stream: confApi
                      .getRegisteredConferences(storage.read('userId'))
                      .asStream(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data!.isEmpty) {
                      return Container();
                    }
                    final data = snapshot.data!.where((e) {
                      final now = DateTime.now().toUtc();
                      final today = now.copyWith(hour: 0, second: 0);
                      bool isOngoingOrToday = e.startTime.day == today.day ||
                          e.endTime.compareTo(now) <= 0;
                      return e.registered!.contains(storage.read('userId')) &&
                          isOngoingOrToday;
                    }).toList();

                    if (data.isEmpty) {
                      return Container();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: CustomText(
                            'Current Conference',
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 186,
                          child: PageView.builder(
                            controller: controller,
                            // scrollDirection: Axis.vertical,
                            onPageChanged: (numb) {
                              pageNo = numb;
                              setState(() {});
                            },
                            itemCount: data.length,
                            itemBuilder: (context, i) {
                              return CurrentConferenceCard(data: data[i]);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Stack(
                            children: [
                              Container(
                                height: 5,
                                width: deviceSize.width - 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2.5),
                                  color: Colors.grey.shade200,
                                ),
                              ),
                              Row(
                                children: [
                                  AnimatedContainer(
                                    height: 5,
                                    width: pageNo *
                                        (deviceSize.width - 40) /
                                        data.length,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2.5),
                                    ),
                                    duration: const Duration(milliseconds: 200),
                                  ),
                                  Container(
                                    height: 5,
                                    width:
                                        (deviceSize.width - 40) / data.length,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(2.5),
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  }),
              // if (false)
              StreamBuilder<List<Conference>?>(
                  stream: confApi
                      .getRegisteredConferences(storage.read('userId'))
                      .asStream(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data!.isEmpty) {
                      return Container();
                    }
                    final data = snapshot.data!
                        .where((e) =>
                            e.registered!.contains(storage.read('userId')))
                        .toList();
                    return Padding(
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
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => SeeAllPage(
                                          stream: confApi
                                              .getRegisteredConferences(
                                                  storage.read('userId'))
                                              .asStream(),
                                        ),
                                      ),
                                    );
                                  },
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
                            child: ListView.builder(
                              shrinkWrap: true,
                              // primary: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: data.length,
                              itemBuilder: (_, i) {
                                return RegisteredConferenceCard(
                                  data: data[i],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              StreamBuilder<List<Conference>?>(
                  stream: confApi.fetchConference('all').asStream(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data!.isEmpty) {
                      return Container();
                    }
                    return Padding(
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
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => SeeAllPage(
                                          stream: confApi
                                              .fetchConference('all')
                                              .asStream(),
                                        ),
                                      ),
                                    );
                                  },
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
                            child: ListView.builder(
                              shrinkWrap: true,
                              // primary: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.hasData &&
                                      snapshot.requireData != null
                                  ? snapshot.requireData!.length
                                  : 0,
                              itemBuilder: (_, i) {
                                final data = snapshot.requireData![i];
                                bool isRegistered = data.registered!
                                    .contains(storage.read('userId'));
                                return UnregisteredConferenceCardSmall(
                                  data: data,
                                  onRegisterPressed: () async {
                                    if (snapshot.hasData) {
                                      await confApi.registerConference(
                                          snapshot.data![i].id);
                                      setState(() {});
                                    }
                                  },
                                  isRegistered: isRegistered,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  })
            ],
          ),
        );
      }),
    );
  }
}
