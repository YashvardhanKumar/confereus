import 'dart:async';

import 'package:confereus/components/button/filled_button.dart';
import 'package:confereus/components/button/text_button.dart';
import 'package:confereus/common_pages/abstract_page.dart';
import 'package:confereus/components/custom_text.dart';
import 'package:confereus/constants.dart';
import 'package:confereus/main.dart';
import 'package:confereus/models/user%20model/user_model.dart';
import 'package:confereus/stream_socket.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../API/conference_api.dart';
import '../../../API/user_api.dart';
import '../../../components/bottom_drawers/add_event.dart';
import '../../../components/bottom_drawers/edit_event.dart';
import '../../../components/day_event.dart';
import '../../../components/tiles/event_tile.dart';
import '../../../models/conference model/conference.model.dart';
import '../../../sockets/socket_stream.dart';

class AddEvents extends StatefulWidget {
  const AddEvents({
    Key? key,
    required this.data,
    required this.isAdmin,
    required this.isEdit,
    this.isRegistered = false,
  }) : super(key: key);
  final Conference data;
  final bool isAdmin;
  final bool isEdit;
  final bool isRegistered;

  @override
  State<AddEvents> createState() => _AddEventsState();
}

class _AddEventsState extends State<AddEvents> {
  final _streamSocketEvents = SocketController<List<Event>?>();
  final _streamSocketConf = SocketController<Conference?>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final prov = Provider.of<SocketStream>(context, listen: false);
    prov.fetchAllDocuments(
        initControllerEvent, 'events', {"confId": widget.data.id});
    prov.fetchOneDocument(
        initControllerConf, 'conferences', {"confId": widget.data.id});
  }

  void initControllerEvent(dynamic eventdata) {
    _streamSocketEvents
        .add((eventdata as List).map((e) => Event.fromJson(e)).toList());
  }

  void initControllerConf(dynamic eventdata) {
    _streamSocketConf.add(Conference.fromJson(eventdata));
  }

  // @override
  // void dispose() {
  //   _streamSocketEvents.dispose();
  //   _streamSocketUsers.dispose();
  //   // TODO: implement dispose
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // print(widget.data.events?.last.toJson().toString());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: CustomText(widget.isAdmin
            ? ((widget.isEdit) ? 'Add Events' : "Edit Events")
            : 'Show Events'),
        actions: [
          if (!widget.isAdmin)
            CustomTextButton(
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: CustomText(
                  'Your Abstracts',
                  color: kColorDark,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AbstractPage(
                      isAdmin: widget.isAdmin,
                      conference: widget.data,
                    ),
                  ),
                );
              },
            )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CustomText(
            '${DateFormat.MMMMd().format(widget.data.startTime)} -'
            ' ${DateFormat.yMMMMd().format(widget.data.endTime)}',
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(
            height: 35,
          ),
          StreamBuilder<Conference?>(
              stream: _streamSocketConf.get,
              builder: (context, conf) {
                return StreamBuilder<List<Event>?>(
                    stream: _streamSocketEvents.get,
                    builder: (context, event) {
                      print(event);
                      print(conf);
                      if (event.hasData && conf.hasData) {
                        final today = DateTime.now().toUtc();
                        final e =
                            widget.data.startTime.difference(today).inDays < 0
                                ? today
                                : widget.data.startTime;
                        return Column(
                          children: List.generate(
                            widget.data.endTime.day - e.day + 1,
                            (index) {
                              return DayEvent(
                                data: event.data!,
                                date: e.copyWith(day: e.day + index),
                                isAdmin: widget.isAdmin,
                                conf: conf.data!,
                                registered: conf.data!.registered
                                    .contains(storage.read('userId')),
                              );
                            },
                          ),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    });
              }),
        ],
      ),
      bottomNavigationBar: (widget.isAdmin && !widget.isEdit)
          ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomFilledButton(
                child: const CustomText(
                  'Add Events',
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                onPressed: () {
                  while (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
              ),
            )
          : null,
    );
  }
}
