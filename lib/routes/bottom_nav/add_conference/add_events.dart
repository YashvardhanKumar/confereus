import 'package:confereus/components/button/filled_button.dart';
import 'package:confereus/components/custom_text.dart';
import 'package:confereus/routes/bottom_nav/add_conference/event_visibility.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../components/day_event.dart';
import '../../../main.dart';
import '../../../models/conference model/conference.model.dart';

class AddEvents extends StatefulWidget {
  const AddEvents({Key? key, required this.data}) : super(key: key);
  final Conference data;

  @override
  State<AddEvents> createState() => _AddEventsState();
}

class _AddEventsState extends State<AddEvents> {
  @override
  Widget build(BuildContext context) {
    // print(widget.data.events?.last.toJson().toString());
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
            (widget.data.admin.toString().compareTo(storage.read('userId')) ==
                    0)
                ? "Events"
                : 'Add Events'),
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
      bottomNavigationBar:
          (widget.data.admin.toString().compareTo(storage.read('userId')) == 0)
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



