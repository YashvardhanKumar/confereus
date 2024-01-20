import 'package:confereus/API/conference_api.dart';
import 'package:confereus/components/button/add_button.dart';
import 'package:confereus/components/button/filled_button.dart';
import 'package:confereus/common_pages/add_members.dart';
import 'package:confereus/components/input_fields/text_form_field.dart';
import 'package:confereus/constants.dart';
import 'package:confereus/models/user%20model/user_model.dart';
import 'package:confereus/sockets/socket_stream.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/conference model/conference.model.dart';

Future editEvents(BuildContext context, Conference data, DateTime date,
    Event event, List<Users> users) async {
  return await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    // useRootNavigator: true,
    builder: (_) {
      return EditEvents(
        data: data,
        users: users,
        date: date,
        event: event,
      );
    },
  );
}

class EditEvents extends StatefulWidget {
  const EditEvents({
    super.key,
    required this.data,
    required this.users,
    required this.date,
    required this.event,
  });

  final Conference data;
  final List<Users> users;
  final DateTime date;
  final Event event;

  @override
  State<EditEvents> createState() => _EditEventsState();
}

class _EditEventsState extends State<EditEvents> {
  late final subjectCtrl = TextEditingController(text: widget.event.subject);

  // late final presenterCtrl = TextEditingController(text: widget.event.presenter.join(','));
  late final locCtrl = TextEditingController(text: widget.event.location);
  late final startDateCtrl = TextEditingController(
      text: DateFormat.Hm().format(widget.event.startTime));
  late final endDateCtrl =
      TextEditingController(text: DateFormat.Hm().format(widget.event.endTime));
  List<Users> selected = [];
  late DateTime start = widget.event.startTime;
  late DateTime end = widget.event.endTime;
  bool isSameDay = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (Users e in widget.users) {
      for (var z in widget.event.presenter!) {
        if (e.id == z) selected.add(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BottomSheet(
        backgroundColor: kColorLight,
        onClosing: () {},
        builder: (BuildContext context) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20.0),
              // shrinkWrap: true,
              // primary: true,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Edit Event',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                  child: CustomTextFormField(
                    label: 'Subject of Event',
                    controller: subjectCtrl,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Field Required";
                      }
                      return null;
                    },
                  ),
                ),
                Row(
                  children: List.generate(
                    selected.length,
                    (index) => InputChip(label: Text(selected[index].name)),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                  child: AddButton(
                    onPressed: () async {
                      selected = await Navigator.push<List<Users>>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddMembers(
                                totalUsers: widget.users,
                                selectedUsers: selected,
                                includeCurUser: true,
                              ),
                            ),
                          ) ??
                          selected;
                      setState(() {});
                    },
                    text: 'Add Presenters',
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                  child: CustomTextFormField(
                    label: 'Location (optional)',
                    controller: locCtrl,
                    hint: 'Eg. Bandra, India',
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10),
                        child: CustomTextFormField(
                          label: 'Start',
                          controller: startDateCtrl,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Field Required";
                            }
                            try {
                              final data = DateFormat.Hm().parseStrict(val);
                              start = DateTime(
                                start.year,
                                start.month,
                                start.day,
                                data.hour,
                                data.minute,
                              );
                              // start.copyWith(
                              //     hour: data.hour, minute: data.minute);
                              setState(() {});
                            } catch (e) {
                              return "Invalid Format";
                            }
                            return null;
                          },
                          hint: 'HH:MM',
                          suffix: GestureDetector(
                            child: const Icon(Icons.calendar_today_rounded),
                            onTap: () async {
                              // start = await showDatePicker(
                              //   context: context,
                              //   initialDate: DateTime.now(),
                              //   firstDate: DateTime(1800),
                              //   lastDate: DateTime.now(),
                              // );
                              // if (start != null) {
                              //   String formattedDate =
                              //       DateFormat('MM/yyyy').format(start!);
                              //   setState(() {
                              //     startDateCtrl.text = formattedDate;
                              //   });
                              // }
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                    hour: widget.date.hour,
                                    minute: widget.date.minute),
                                // firstDate: DateTime(1800),
                                // lastDate: DateTime.now(),
                              );

                              if (time != null) {
                                start = DateTime(start.year, start.month,
                                    start.day, time.hour, time.minute);
                                setState(() {});
                              }
                              String formattedDate =
                                  DateFormat.Hm().format(start);
                              setState(() {
                                startDateCtrl.text = formattedDate;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10),
                        child: CustomTextFormField(
                          enabled: !isSameDay,
                          label: 'End',
                          controller: endDateCtrl,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Field Required";
                            }
                            try {
                              final data = DateFormat.Hm().parseStrict(val);
                              end = DateTime(
                                end.year,
                                end.month,
                                end.minute,
                                data.hour,
                                data.minute,
                              );

                              setState(() {});
                            } catch (e) {
                              return "Invalid Format";
                            }
                            return null;
                          },
                          hint: 'HH:MM',
                          suffix: GestureDetector(
                            child: const Icon(Icons.calendar_today_rounded),
                            onTap: () async {
                              // end = await showDatePicker(
                              //   context: context,
                              //   initialDate: DateTime.now(),
                              //   firstDate: DateTime(1800),
                              //   lastDate: DateTime.now(),
                              // );
                              // if (end != null) {
                              //   String formattedDate =
                              //       DateFormat('MM/yyyy').format(end!);
                              //   setState(() {
                              //     endDateCtrl.text = formattedDate;
                              //   });
                              // }
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                    hour: start.hour, minute: start.minute),
                                // firstDate: DateTime(1800),
                                // lastDate: DateTime.now(),
                              );
                              // if (isSameDay) {
                              //   end = DateTime(start.year, start.month,
                              //       start.day, time.hour, time.minute);
                              //   endDateCtrl.text = DateFormat.Hm().format(end);
                              // }
                              setState(() {});
                              if (time != null) {
                                end = DateTime(end.year, end.month, end.day,
                                    time.hour, time.minute);

                                setState(() {});
                              }
                              String formattedDate =
                                  DateFormat.Hm().format(end);
                              setState(() {
                                endDateCtrl.text = formattedDate;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    isSameDay = !isSameDay;
                    end = DateTime(
                      start.year,
                      start.month,
                      start.day,
                      end.hour,
                      end.minute,
                    );
                    endDateCtrl.text = DateFormat.Hm().format(end);
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        value: isSameDay,
                        onChanged: (val) {
                          isSameDay = !isSameDay;
                          end = DateTime(start.year, start.month, start.day,
                              end.hour, end.minute);
                          endDateCtrl.text = DateFormat.Hm().format(end);
                          setState(() {});
                        },
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      Text(
                        'Same Day',
                        style: GoogleFonts.poppins(),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Consumer<SocketStream>(
                      builder: (context, confAPI, child) {
                    return CustomFilledButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          confAPI.editDocument('events', [
                            {
                              if (subjectCtrl.text != widget.event.subject)
                                'subject': subjectCtrl.text,
                              if (locCtrl.text != widget.event.location)
                                'location': locCtrl.text,
                              if (!listEquals(
                                  selected.map((e) => e.id).toList(),
                                  widget.event.presenter))
                                'presenter': selected,
                              if ((start).compareTo(widget.event.startTime) !=
                                  0)
                                'startTime': start.toIso8601String(),
                              if ((end).compareTo(widget.event.endTime) != 0)
                                'endTime': end.toIso8601String(),
                            },
                            {
                              'eventId': widget.event.id,
                            },
                          ]);
                          // widget.data.id,
                          // widget.event,
                          // location: locCtrl.text,
                          // subject: subjectCtrl.text,
                          // startTime: start,
                          // endTime: end,
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        'Add',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
