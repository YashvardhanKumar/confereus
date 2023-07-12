import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import '../../models/conference model/conference.model.dart';
import '../custom_text.dart';
import '../day_event.dart';

class EditEvents extends StatefulWidget {
  const EditEvents({Key? key, required this.data}) : super(key: key);
  final Conference data;

  @override
  State<EditEvents> createState() => _AddEventsState();
}

class _AddEventsState extends State<EditEvents> {
  @override
  Widget build(BuildContext context) {
    // print(widget.data.events?.last.toJson().toString());
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
            (widget.data.admin.toString().compareTo(storage.read('userId')) ==
                0)
                ? "Edit Events"
                : 'Show Events'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CustomText(
            '${DateFormat.MMMMd().format(widget.data.startTime)} - ${DateFormat.yMMMMd().format(widget.data.endTime)}',
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(
            height: 35,
          ),
          Column(
            children: List.generate(
              widget.data.endTime.day - widget.data.startTime.day + 1,
                  (index) {
                final e = widget.data.startTime;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: DayEvent(
                    data: widget.data,
                    date: DateTime(
                      e.year,
                      e.month,
                      e.day + index,
                      e.hour,
                      e.minute,
                    ),
                  ),
                );
              },
            ),
          )

        ],
      ),
    );
  }
}