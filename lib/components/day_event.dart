import 'package:confereus/components/bottom_drawers/add_event.dart';
import 'package:confereus/components/button/filled_button.dart';
import 'package:confereus/components/shimmer_widget.dart';
import 'package:confereus/models/user%20model/user_model.dart';
import 'package:confereus/sockets/socket_stream.dart';
import 'package:confereus/stream_socket.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/conference model/conference.model.dart';
import 'bottom_drawers/edit_event.dart';
import 'button/add_button.dart';
import 'custom_text.dart';
import 'tiles/event_tile.dart';

class DayEvent extends StatefulWidget {
  const DayEvent({
    super.key,
    required this.data,
    required this.date,
    required this.isAdmin,
    required this.conf,
    // required this.updateState,
    // required this.items,
    // required this.addEvent,
    required this.registered,
  });

  final List<Event> data;
  final Conference conf;
  final DateTime date;
  final bool isAdmin;
  final bool registered;
  // final List<Widget> items;
  // final VoidCallback addEvent;

  @override
  State<DayEvent> createState() => _DayEventState();
}

class _DayEventState extends State<DayEvent>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;
  late List<Event> events;
  final _streamSocketUsers = SocketController<List<Users>?>();
  final _streamSocketEvents = SocketController<List<Event>?>();

  bool expand = true;

  void initControllerEvent(dynamic eventdata) {
    _streamSocketEvents
        .add((eventdata as List).map((e) => Event.fromJson(e)).toList());
  }

  void initControllerUser(dynamic eventdata) {
    _streamSocketUsers
        .add((eventdata as List).map((e) => Users.fromJson(e)).toList());
  }

  @override
  void initState() {
    super.initState();
    final prov = Provider.of<SocketStream>(context, listen: false);
    prov.fetchAllDocuments(
        initControllerEvent, 'events', {"confId": widget.conf.id});
    events = widget.data.where(
      (v) {
        return v.startTime.day == widget.date.day;
      },
    ).toList();
    prov.fetchAllDocuments(initControllerUser, 'users');
    prepareAnimations();
    _runExpandCheck();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.ease,
    );
  }

  void _runExpandCheck() {
    if (expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(DayEvent oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.data.toJson());
    return StreamBuilder<List<Event>?>(
        stream: _streamSocketEvents.get,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            events = snapshot.data!.where(
              (v) {
                return v.startTime.day == widget.date.day;
              },
            ).toList();
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: StreamBuilder<List<Users>?>(
                stream: _streamSocketUsers.get,
                builder: (context, userList) {
                  if (!userList.hasData) {
                    return const ShimmerWidget(
                        height: 50, width: double.infinity);
                  }
                  return Container(
                    // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: kColorLight,
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              expand = !expand;
                              _runExpandCheck();
                              setState(() {});
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: CustomText(
                                    DateFormat.yMMMMd().format(widget.date),
                                    // fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    expand = !expand;
                                    _runExpandCheck();
                                    setState(() {});
                                  },
                                  icon: Icon((expand)
                                      ? Icons.arrow_drop_up_rounded
                                      : Icons.arrow_drop_down_rounded),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizeTransition(
                          sizeFactor: animation,
                          axisAlignment: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(
                                  color: Colors.black,
                                  height: 0,
                                ),
                                if (events.isNotEmpty)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(
                                      events.length,
                                      (index) {
                                        return EventTile(
                                          event: events[index],
                                          isAdmin: widget.isAdmin,
                                          data: widget.conf,
                                          users: userList.data!,
                                          isRegistered: widget.registered,
                                        );
                                      },
                                    ),
                                  ),
                                if (events.isEmpty)
                                  const Center(
                                      child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: CustomText('No Events on this day!'),
                                  )),
                                if (widget.isAdmin)
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: AddButton(
                                        text: 'Add Event',
                                        onPressed: () async {
                                          await addEvents(
                                            context,
                                            widget.conf,
                                            widget.date,
                                          );
                                        }),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          );
        });
  }
}
