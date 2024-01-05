import 'package:confereus/API/conference_api.dart';
import 'package:confereus/components/common_pages/conference_register_page.dart';
import 'package:confereus/components/custom_text.dart';
import 'package:confereus/constants.dart';
import 'package:confereus/main.dart';
import 'package:confereus/routes/bottom_nav/home/app_bar/public_profile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/conference model/conference.model.dart';
import '../../routes/bottom_nav/add_conference/add_conference.dart';
import '../../routes/bottom_nav/add_conference/add_events.dart';
import '../button/filled_button.dart';
import 'abstract_page.dart';

class ConferencePage extends StatefulWidget {
  const ConferencePage({
    Key? key,
    required this.data,
    required this.isRegistered,
    required this.onRegister,
  }) : super(key: key);

  final Conference data;
  final bool isRegistered;
  final Future<void> Function() onRegister;

  @override
  State<ConferencePage> createState() => _ConferencePageState();
}

class _ConferencePageState extends State<ConferencePage> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ConferenceAPI>(
      builder: (context, data, _) {
        return FutureBuilder<List<Conference>?>(
          future: data.fetchConference("all"),
          builder: (context, snapshot) {
            // if (snapshot.hasData || snapshot.data == null) return const Scaffold();
            // print(snapshot.data?.first.toJson());
            // final data = snapshot.data?.map((e) => )
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final data = snapshot.data!
                .where((element) => element.id == widget.data.id)
                .first;
            print(storage.read('userId'));
            final isAdmin = (data.admin
                .where((e) => (e.contains(storage.read('userId'))))).isNotEmpty;
            return Scaffold(
              backgroundColor: Colors.white,
              floatingActionButton: FloatingActionButton.extended(
                // isExtended: false,
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddEvents(
                          data: data,
                          isAdmin: isAdmin,
                          isEdit: true,
                          isRegistered: !isAdmin && widget.isRegistered),
                    ),
                  );
                  setState(() {});
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
                  if (isAdmin)
                    IconButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CreateNewConference(
                              old: data,
                            ),
                          ),
                        );
                        setState(() {});
                      },
                      icon: const Icon(Icons.edit_rounded),
                      color: Colors.white,
                      style:
                          IconButton.styleFrom(backgroundColor: Colors.black26),
                    ),
                  // if (!isAdmin && widget.isRegistered)
                  //   FutureBuilder<Users?>(
                  //     future: Provider.of<UserAPI>(context).getCurUsers(),
                  //     builder: (context, snapshot) {
                  //       if (snapshot.hasData) {
                  //         return IconButton(
                  //           onPressed: () async {
                  //             Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                 builder: (_) =>
                  //                     AddAbstractLinkDrawer(
                  //                       data: data, curUser: snapshot.requireData!,),
                  //               ),
                  //             );
                  //             setState(() {});
                  //           },
                  //           icon: const Icon(Icons.edit_document),
                  //           color: Colors.white,
                  //           style:
                  //           IconButton.styleFrom(
                  //               backgroundColor: Colors.black26),
                  //         );
                  //       }
                  //       return CircularProgressIndicator();
                  //     }
                  //   ),
                ],
                backgroundColor: Colors.transparent,
              ),
              extendBodyBehindAppBar: (data.eventLogo != null),
              body: RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (data.eventLogo != null)
                        Image.network("${data.eventLogo}"),
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
                                  foregroundImage: data.eventLogo != null
                                      ? NetworkImage('${data.eventLogo}')
                                      : null,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: data.eventLogo != null
                                        ? null
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
                                          '${DateFormat.MMMd().format(data.startTime)} '
                                          '-'
                                          ' ${DateFormat.yMMMd().format(data.endTime)}',
                                          fontSize: 16,
                                          color: const Color(0xff8B8B8B),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    if (data.location != null)
                                      Row(
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
                                            data.location!,
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
                      // FutureBuilder<Map<String, dynamic>?>(
                      //     future: data.abstractLink != null
                      //         ? fetch(data.abstractLink!)
                      //         : null,
                      //     builder: (context, snapshot) {
                      //       final data = snapshot.data?['title'];
                      //       if (data == null) return Container();
                      //       return Padding(
                      //         padding:
                      //             const EdgeInsets.symmetric(horizontal: 10.0),
                      //         child: InputChip(
                      //           label: CustomText(data ?? 'Abstract'),
                      //           avatar: const Icon(Icons.attach_file),
                      //           backgroundColor: Colors.white,
                      //           elevation: 1,
                      //           shadowColor: Colors.black,
                      //           side: BorderSide.none,
                      //           onPressed: () async {
                      //             await launchUrl(
                      //                 Uri.parse(data.abstractLink!));
                      //             setState(() {});
                      //           },
                      //         ),
                      //       );
                      //     }),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                        child: Card(
                          elevation: 0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(10)),
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
                      ),
                      if (data.admin_data != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                          child: Card(
                            elevation: 0,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.grey.shade200),
                                borderRadius: BorderRadius.circular(10)),
                            clipBehavior: Clip.hardEdge,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CustomText(
                                    'Admininstrators',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  Row(
                                    children: List.generate(
                                      data.admin_data!.length,
                                      (index) => InputChip(
                                        labelPadding: EdgeInsets.zero,
                                        visualDensity: VisualDensity.compact,
                                        label: CustomText(
                                            data.admin_data![index].name),
                                        onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (_) => PublicProfile(userId: data.admin_data![index].id, email: data.admin_data![index].email,)));
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomFilledButton(
                  color: (widget.isRegistered) ? kColorLight : null,
                  onPressed: isClicked
                      ? null
                      : () async {
                          if (!widget.isRegistered) {
                            isClicked = true;
                            setState(() {});

                            await widget.onRegister().then((value) {
                              isClicked = false;
                              setState(() {});
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ConferenceRegisterPage(),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AbstractPage(
                                  isAdmin: isAdmin,
                                  conference: data,
                                ),
                              ),
                            );
                          }
                        },
                  child: CustomText(
                    !isAdmin
                        ? (widget.isRegistered ? 'Your Abstracts' : "Register")
                        : 'Show Abstracts',
                    color: (widget.isRegistered) ? kColorDark : Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
