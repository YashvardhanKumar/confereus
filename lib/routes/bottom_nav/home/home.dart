import 'dart:async';

import 'package:confereus/API/user_api.dart';
import 'package:confereus/API/user_profile_api.dart';
import 'package:confereus/common_pages/register_event.dart';
import 'package:confereus/components/button/text_button.dart';
import 'package:confereus/components/tiles/current_conference_card.dart';
import 'package:confereus/components/custom_text.dart';
import 'package:confereus/components/shimmer_widget.dart';
import 'package:confereus/constants.dart';
import 'package:confereus/main.dart';
import 'package:confereus/models/conference%20model/conference.model.dart';
import 'package:confereus/provider/login_status_provider.dart';
import 'package:confereus/routes/bottom_nav/home/app_bar/profile.dart';
import 'package:confereus/sockets/socket_stream.dart';
import 'package:confereus/stream_socket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../API/conference_api.dart';
import '../../../common_pages/see_all_page.dart';
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
  final _streamControllerConf = SocketController<List<Conference>?>();
  final _streamControllerUser = SocketController<Users?>();

  int pageNo = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final streamSocket = Provider.of<SocketStream>(context, listen: false);
    // Provider.of<SocketStream>(context, listen: false)
    streamSocket.fetchAllDocuments(initControllerConference, 'conferences');
    streamSocket.fetchOneDocument(
        initControllerUser, 'users', {"userId": storage.read('userId')});
    // Provider.of<SocketStream>(context, listen: false);
  }

  void initControllerConference(dynamic eventdata) {
    _streamControllerConf
        .add((eventdata as List).map((e) => Conference.fromJson(e)).toList());
  }

  void initControllerUser(dynamic eventdata) {
    print(eventdata);
    _streamControllerUser.add(Users.fromJson(eventdata));
  }

  @override
  void dispose() {
    // _streamControllerConf.dispose();
    // _streamControllerUser.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String curUserId = storage.read('userId');

    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 0,
        toolbarHeight: 70,
        leading: Container(),
        titleSpacing: 10,
        backgroundColor: Colors.white,
        title: Consumer<SocketStream>(builder: (context, streamSocket, child) {
          return StreamBuilder<Users?>(
              stream: _streamControllerUser.get,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Row(
                    children: [
                      ShimmerWidget.circular(radius: 23),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerWidget(height: 16, width: 180),
                          SizedBox(height: 10),
                          ShimmerWidget(height: 14, width: 100),
                        ],
                      ),
                    ],
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
                    const SizedBox(width: 10),
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
      body: Consumer<SocketStream>(builder: (context, socketStream, _) {
        return RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: StreamBuilder<List<Conference>?>(
              stream: _streamControllerConf.get,
              builder: (context, confSnapshot) {
                List<Conference>? regData;
                List<Conference>? liveConf;
                List<Conference>? allData = confSnapshot.data;
                if (allData != null) {
                  regData = allData
                      .where((e) => e.registered.contains(curUserId))
                      .toList(growable: true);
                  liveConf = allData.where((e) {
                    final now = DateTime.now().toUtc();
                    final today = now.copyWith(hour: 0, second: 0).day;
                    return (e.registered.contains(curUserId) &&
                            (e.startTime.day <= today ||
                                e.endTime.compareTo(now) <= 0)) ||
                        e.admin.contains(curUserId);
                  }).toList();
                }
                return RefreshIndicator(
                  onRefresh: () async {},
                  child: ListView(
                    padding: const EdgeInsets.all(10),
                    physics: allData == null
                        ? const NeverScrollableScrollPhysics()
                        : null,
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      if (allData != null && allData.isEmpty)
                        const Center(
                          child: CustomText("Nothing to show!"),
                        ),
                      if (liveConf?.isNotEmpty ?? true)
                        Column(
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  color: Colors.white,
                                  height: liveConf != null && liveConf.isEmpty
                                      ? 80
                                      : 186,
                                  child: Builder(builder: (context) {
                                    if (liveConf != null && liveConf.isEmpty) {
                                      return const Center(
                                        child: CustomText("Nothing to show!"),
                                      );
                                    }
                                    return PageView.builder(
                                      controller: controller,
                                      // scrollDirection: Axis.vertical,
                                      onPageChanged: (numb) {
                                        pageNo = numb;
                                        setState(() {});
                                      },
                                      itemCount: liveConf?.length ?? 1,
                                      itemBuilder: (context, i) {
                                        return CurrentConferenceCard(
                                          data: liveConf?[i],
                                        );
                                      },
                                    );
                                  }),
                                ),
                                if ((liveConf?.length ?? 0) > 1)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      liveConf!.length,
                                      (index) => AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 2.5, vertical: 10),
                                        height: 8,
                                        width: index == pageNo ? 25 : 8,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.black),
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ],
                        ),
                      if (regData?.isNotEmpty ?? true)
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
                                    if (regData != null && regData.isNotEmpty)
                                      CustomTextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => SeeAllPage(
                                                stream:
                                                    _streamControllerConf.get,
                                                isRegistered: true,
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
                                height: regData != null && regData.isEmpty
                                    ? 80
                                    : 310,
                                width: deviceSize.width,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  // primary: true,
                                  physics: regData == null
                                      ? const NeverScrollableScrollPhysics()
                                      : null,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: regData?.length ?? 2,
                                  itemBuilder: (_, i) {
                                    return RegisteredConferenceCard(
                                      data: regData?[i],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (allData?.isNotEmpty ?? true)
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
                                    if (allData != null && allData.isNotEmpty)
                                      CustomTextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => SeeAllPage(
                                                stream:
                                                    _streamControllerConf.get,
                                                isRegistered: false,
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
                                height: allData != null && allData.isEmpty
                                    ? 80
                                    : 350,
                                width: deviceSize.width,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  // primary: true,
                                  physics: allData == null
                                      ? const NeverScrollableScrollPhysics()
                                      : null,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: allData == null
                                      ? 2
                                      : allData.isNotEmpty
                                          ? allData.length
                                          : 0,
                                  itemBuilder: (_, i) {
                                    Conference? data;
                                    bool? isRegistered;
                                    if (allData != null) {
                                      data = allData[i];
                                      isRegistered =
                                          data.registered.contains(curUserId);
                                    }
                                    return UnregisteredConferenceCardSmall(
                                      data: data,
                                      onRegisterPressed: () async {
                                        if (allData != null) {
                                          // await socketStream.registerConference(
                                          //     allData[i].id);
                                          // setState(() {});
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => RegisterEvent(
                                                conf: allData[i],
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      isRegistered: isRegistered,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              }),
        );
      }),
    );
  }
}
