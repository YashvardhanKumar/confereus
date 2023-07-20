import 'package:confereus/components/button/filled_button.dart';
import 'package:confereus/components/custom_text.dart';
import 'package:confereus/models/user%20model/user_model.dart';
import 'package:confereus/routes/bottom_nav/add_conference/event_visibility.dart';
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

class AddEvents extends StatefulWidget {
  const AddEvents(
      {Key? key,
      required this.data,
      required this.isAdmin,
      required this.isEdit})
      : super(key: key);
  final Conference data;
  final bool isAdmin;
  final bool isEdit;

  @override
  State<AddEvents> createState() => _AddEventsState();
}

class _AddEventsState extends State<AddEvents> {
  @override
  Widget build(BuildContext context) {
    // print(widget.data.events?.last.toJson().toString());
    return Scaffold(
      appBar: AppBar(
        title: CustomText((widget.isEdit)
            ? 'Add Events'
            : (widget.isAdmin)
                ? "Edit Events"
                : 'Show Events'),
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
          Consumer2<EventAPI, UserAPI>(
              builder: (context, eventsApi, userApi, child) {
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: StreamBuilder<List<Users>?>(
                  stream: userApi.getAllUsers(context).asStream(),
                  builder: (context, userList) {
                    return StreamBuilder<List<Event>?>(
                        stream: eventsApi.getEvent(widget.data.id).asStream(),
                        builder: (context, event) {
                          if (event.hasData && userList.hasData) {
                            final today = DateTime.now().toUtc();
                            final e = widget.data.startTime.day < today.day
                                ? today
                                : widget.data.startTime;
                            print(event.data?.map((e) => e.toJson()));
                            return ListView.builder(
                              itemCount: widget.data.endTime.day - e.day + 1,
                              itemBuilder: (context, index) {
                                final dat = event.data!.where(
                                  (v) {
                                    return v.startTime.day == e.day + index;
                                  },
                                ).toList();
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: DayEvent(
                                    data: dat,
                                    date: e.copyWith(day: e.day + index),
                                    isAdmin: widget.isAdmin,
                                    conf: widget.data,
                                    updateState: () => setState(() {}),
                                    items: List.generate(
                                      dat.length,
                                      (index) {
                                        return EventTile(
                                          event: dat[index],
                                          isAdmin: widget.isAdmin,
                                          data: widget.data,
                                          updateState: () {
                                            setState(() {});
                                          },
                                          onEdit: () async {
                                            await editEvents(
                                              context,
                                              widget.data,
                                              dat[index].startTime,
                                              dat[index],
                                              userList.data ?? [],
                                            );
                                            setState(() {});
                                          },
                                        );
                                      },
                                    ),
                                    addEvent: () async {
                                      await addEvents(
                                        context,
                                        widget.data,
                                        e.copyWith(day: e.day + index),
                                        // value ?? [],
                                      );
                                      setState(() {});
                                    },
                                  ),
                                );
                              },
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        });
                  }),
            );
          })
        ],
      ),
      bottomNavigationBar: (widget.isAdmin && !widget.isEdit)
          ? Padding(
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
                      builder: (_) => EventVisibility(data: widget.data),
                    ),
                  );
                },
              ),
            )
          : null,
    );
  }
}
