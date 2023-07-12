import 'package:confereus/components/tiles/event_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../API/conference_api.dart';
import '../API/user_api.dart';
import '../constants.dart';
import '../main.dart';
import '../models/conference model/conference.model.dart';
import 'bottom_drawers/add_event.dart';
import 'button/add_button.dart';
import 'custom_text.dart';

class DayEvent extends StatefulWidget {
  const DayEvent({
    super.key,
    required this.data,
    required this.date,
  });

  final Conference data;
  final DateTime date;

  @override
  State<DayEvent> createState() => _DayEventState();
}

class _DayEventState extends State<DayEvent>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;
  bool expand = false;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _runExpandCheck();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
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
                    icon: const Icon(Icons.arrow_drop_down_rounded),
                  )
                ],
              ),
            ),
          ),
          FutureBuilder<List<Event>?>(
              future: Provider.of<EventAPI>(context).getEvent(widget.data.id),
              builder: (context, event) {
                List<Event> events = [];
                if (event.hasData) {
                  for (Event e in event.data!) {
                    bool isDate = DateFormat.yMd().format(e.startTime) ==
                        DateFormat.yMd().format(widget.date);
                    // print(DateFormat.yMd().format(
                    //     e.startTime));
                    // print(widget.date);
                    if (isDate) {
                      events.add(e);
                    }
                  }
                }
                return SizeTransition(
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
                        if (event.hasData)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              events.length,
                                  (index) {
                                return EventTile(
                                  event: events[index],
                                  isAdmin: (widget.data.admin
                                      .toString()
                                      .compareTo(storage.read('userId')) ==
                                      0),
                                  data: widget.data,
                                  // eventName: '',
                                  // location: 'Gwalior, Madhya Pradesh',
                                  // presenter: 'Yash Kashyap',
                                  // start: DateTime(2023, 3, 4, 7, 30),
                                  // end: DateTime(2023, 3, 4, 9, 30),
                                );
                              },
                            ),
                            // EventTile(
                            //   eventName: 'Breakfast',
                            //   location: 'Landmark NX,,Gwalior, Madhya Pradesh',
                            //   start: DateTime(2023, 3, 4, 9, 30),
                            //   end: DateTime(2023, 3, 4, 10),
                            // ),
                            // EventTile(
                            //   eventName: 'Product Management Conference',
                            //   location: 'Landmark NX,,Gwalior, Madhya Pradesh',
                            //   presenter: 'Yash Kashyap, Harsh Khurana',
                            //   start: DateTime(2023, 3, 4, 10),
                            //   end: DateTime(2023, 3, 4, 11, 45),
                            // ),
                            // SizedBox(
                            //   height: 5,
                            // ),
                          ),
                        if (widget.data.admin
                            .toString()
                            .compareTo(storage.read('userId')) ==
                            0)
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: AddButton(
                              text: 'Add Event',
                              onPressed: () async {
                                await Provider.of<UserAPI>(context,
                                    listen: false)
                                    .getAllUsers(context)
                                    .then(
                                      (value) => addEvents(
                                    context,
                                    widget.data,
                                    widget.date,
                                    value ?? [],
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}