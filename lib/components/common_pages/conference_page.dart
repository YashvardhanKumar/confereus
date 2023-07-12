import 'package:confereus/API/conference_api.dart';
import 'package:confereus/components/bottom_drawers/add_abstract_link.dart';
import 'package:confereus/components/common_pages/conference_register_page.dart';
import 'package:confereus/components/common_pages/edit_events.dart';
import 'package:confereus/components/custom_text.dart';
import 'package:confereus/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/conference model/conference.model.dart';
import '../../routes/bottom_nav/add_conference/add_conference.dart';
import '../button/filled_button.dart';

class ConferencePage extends StatefulWidget {
  const ConferencePage({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Conference data;

  @override
  State<ConferencePage> createState() => _ConferencePageState();
}

class _ConferencePageState extends State<ConferencePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ConferenceAPI>(builder: (context, data, _) {
      return FutureBuilder<List<Conference>?>(
          future: data.fetchConference("all"),
          builder: (context, snapshot) {
            // if (snapshot.hasData || snapshot.data == null) return const Scaffold();
            // print(snapshot.data?.first.toJson());
            // final data = snapshot.data?.map((e) => )
            final data = snapshot.data?.where((element) => element.id == widget.data.id).first ?? widget.data;
            return Scaffold(
              floatingActionButton: FloatingActionButton.extended(
                // isExtended: false,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => EditEvents(data: data)));
                },
                icon: const Icon(
                  Icons.event,
                  size: 24,
                ),
                label: const CustomText('Show Events'),
              ),
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_rounded),
                  color: Colors.white,
                  style: IconButton.styleFrom(backgroundColor: Colors.black26),
                ),
                actions: [
                  if (data.admin
                      .toString()
                      .compareTo(storage.read('userId')) ==
                      0)
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CreateNewConference(
                                  old: data,
                                ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit_rounded),
                      color: Colors.white,
                      style:
                      IconButton.styleFrom(backgroundColor: Colors.black26),
                    ),
                  if (data.admin
                      .toString()
                      .compareTo(storage.read('userId')) ==
                      0)
                    IconButton(
                      onPressed: () {
                        addAbstract(context, data);
                      },
                      icon: const Icon(Icons.edit_document),
                      color: Colors.white,
                      style:
                      IconButton.styleFrom(backgroundColor: Colors.black26),
                    ),
                ],
                backgroundColor: Colors.transparent,
              ),
              extendBodyBehindAppBar: true,
              body: SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('images/firebase-summit-2022.png'),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                        color: Colors.white,
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey.shade200,
                                radius: 30,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: data.eventLogo != null
                                      ? Image.asset(data.eventLogo!)
                                      : const Icon(
                                    Icons.image,
                                    color: Colors.grey,
                                    size: 40,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    data.subject,
                                    fontWeight: FontWeight.w600,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 22,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_today_rounded,
                                        size: 20,
                                        color: Color(0xff8B8B8B),
                                      ),
                                      const SizedBox(width: 5),
                                      CustomText(
                                        '${DateFormat.MMMd().format(
                                            data.startTime)} '
                                            '-'
                                            ' ${DateFormat.yMMMd().format(
                                            data.endTime)}',
                                        fontSize: 16,
                                        color: const Color(0xff8B8B8B),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_rounded,
                                        size: 18,
                                        color: Color(0xff8B8B8B),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      CustomText(
                                        'Online',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff8B8B8B),
                                        // fontWeight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    FutureBuilder<Map<String, dynamic>?>(
                        future: data.abstractLink != null
                            ? fetch(data.abstractLink!)
                            : null,
                        builder: (context, snapshot) {
                          final data = snapshot.data?['title'];
                          if (data == null) return Container();
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: InputChip(
                              label: CustomText(data ?? 'Abstract'),
                              avatar: const Icon(Icons.attach_file),
                              backgroundColor: Colors.white,
                              elevation: 1,
                              shadowColor: Colors.black,
                              side: BorderSide.none,
                              onPressed: () {
                                launchUrl(Uri.parse(data.abstractLink!));
                              },
                            ),
                          );
                        }),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                        elevation: 0,
                        color: Colors.white,
                        clipBehavior: Clip.hardEdge,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomText(
                                'Description',
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                              CustomText(
                                data.about,
                                color: Colors.grey.shade700,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 5.0),
                    //   child: CustomFilledButton(
                    //     height: 30,
                    //     onPressed: onRegisterPressed,
                    //     child: CustomText(
                    //       (onRegisterPressed != null) ? 'Register' : 'Registered',
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              bottomNavigationBar: data.admin
                  .toString()
                  .compareTo(storage.read('userId')) ==
                  0
                  ? null
                  : Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomFilledButton(
                  child: const CustomText(
                    'Next',
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ConferenceRegisterPage(),
                      ),
                    );
                  },
                ),
              ),
            );
          });
    });
  }
}
