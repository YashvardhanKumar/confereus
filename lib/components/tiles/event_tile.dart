import 'package:confereus/API/conference_api.dart';
import 'package:confereus/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../API/user_api.dart';
import '../../main.dart';
import '../../models/conference model/conference.model.dart';
import '../../models/user model/user_model.dart';
import '../bottom_drawers/add_abstract_link.dart';
import '../button/text_button.dart';
import '../custom_text.dart';

class EventTile extends StatefulWidget {
  const EventTile({
    super.key,
    required this.event,
    required this.isAdmin,
    required this.data,
    required this.updateState,
    required this.onEdit,
    required this.isRegistered,
  });

  final Event event;
  final bool isAdmin;
  final Conference data;
  final VoidCallback updateState;
  final VoidCallback onEdit;
  final bool isRegistered;

  @override
  State<EventTile> createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  @override
  Widget build(BuildContext context) {
    final isAdmin = (widget.data.admin
        .where((e) => (e.contains(storage.read('userId'))))).isNotEmpty;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: IntrinsicHeight(
        child: Row(
          children: [
            SizedBox(
              width: 50,
              child: CustomText(
                DateFormat.Hm().format(widget.event.startTime),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const VerticalDivider(
              color: Colors.black,
              width: 20,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    widget.event.subject,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  if (widget.event.presenter != null &&
                      widget.event.presenter!.isEmpty)
                    const SizedBox(
                      height: 5,
                    ),
                  if (widget.event.presenter != null &&
                      widget.event.presenter!.isEmpty)
                    Row(
                      children: [
                        const Icon(
                          Icons.present_to_all_rounded,
                          size: 18,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        CustomText(
                          widget.event.presenter!.join(", "),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          // fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        size: 15,
                        color: Color(0xff8B8B8B),
                      ),
                      const SizedBox(width: 5),
                      CustomText(
                        '${DateFormat.Hm().format(widget.event.startTime)} '
                        '-'
                        ' ${DateFormat.Hm().format(widget.event.endTime)}',
                        fontSize: 12,
                        color: const Color(0xff8B8B8B),
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        size: 15,
                        color: Color(0xff8B8B8B),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      CustomText(
                        widget.event.location,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff8B8B8B),
                        // fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  if (!isAdmin && widget.isRegistered)
                    FutureBuilder<Users?>(
                      future: Provider.of<UserAPI>(context).getCurUsers(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: CupertinoButton(
                              color: kColorDark,
                              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                              minSize: 25,
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AddAbstractLinkDrawer(
                                      data: widget.data,
                                      curUser: snapshot.requireData!,
                                      dataEvent: widget.event,
                                    ),
                                  ),
                                );
                                setState(() {});
                              },

                              // icon: const Icon(Icons.edit_document),
                              // color: Colors.white,
                              // style: TextButton.styleFrom(
                              //     backgroundColor: Colors.black26),
                              child: CustomText(
                                '+ Add Abstract',
                              ),
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                ],
              ),
            ),
            // if(!widget.isAdmin)
            // if (!isAdmin && widget.isRegistered)
            //   FutureBuilder<Users?>(
            //       future: Provider.of<UserAPI>(context).getCurUsers(),
            //       builder: (context, snapshot) {
            //         if (snapshot.hasData) {
            //           return CupertinoButton(
            //             onPressed: () async {
            //               Navigator.push(
            //                 context,
            //                 MaterialPageRoute(
            //                   builder: (_) => AddAbstractLinkDrawer(
            //                     data: widget.data,
            //                     curUser: snapshot.requireData!,
            //                     dataEvent: widget.event,
            //                   ),
            //                 ),
            //               );
            //               setState(() {});
            //             },
            //
            //             // icon: const Icon(Icons.edit_document),
            //             // color: Colors.white,
            //             // style: TextButton.styleFrom(
            //             //     backgroundColor: Colors.black26),
            //             child: CustomText(
            //               '+ Add Abstract',
            //               fontSize: 12,
            //             ),
            //           );
            //         }
            //         return CircularProgressIndicator();
            //       }),
            if (widget.isAdmin)
              Column(
                children: [
                  CustomTextButton(
                    onPressed: () {
                      widget.onEdit();
                      setState(() {});
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Icon(Icons.edit_rounded),
                    ),
                  ),
                  CustomTextButton(
                    onPressed: () async {
                      await Provider.of<EventAPI>(context, listen: false)
                          .deleteEvent(widget.data.id, widget.event.id);
                      widget.updateState();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Icon(Icons.delete_forever_rounded),
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
