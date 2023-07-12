import 'package:confereus/API/conference_api.dart';
import 'package:confereus/components/button/add_button.dart';
import 'package:confereus/components/button/filled_button.dart';
import 'package:confereus/components/common_pages/add_members.dart';
import 'package:confereus/components/input_fields/text_form_field.dart';
import 'package:confereus/constants.dart';
import 'package:confereus/models/user%20model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/conference model/conference.model.dart';

void addEvents(BuildContext context, Conference data, DateTime date,
    List<Users> users) async {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    // useRootNavigator: true,
    builder: (_) {
      return AddEvents(
        data: data,
        users: users,
        date: date,
      );
    },
  );
}

class AddEvents extends StatefulWidget {
  const AddEvents({
    super.key,
    required this.data,
    required this.users,
    required this.date,
  });

  final Conference data;
  final List<Users> users;
  final DateTime date;

  @override
  State<AddEvents> createState() => _AddEventsState();
}

class _AddEventsState extends State<AddEvents> {
  TextEditingController subjectCtrl = TextEditingController();
  TextEditingController presenterCtrl = TextEditingController();
  TextEditingController locCtrl = TextEditingController();
  TextEditingController startDateCtrl = TextEditingController();
  TextEditingController endDateCtrl = TextEditingController();
  List<Users> selected = [];
  late DateTime start = widget.date.toUtc();
  late DateTime end = widget.date.toUtc();
  bool isSameDay = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      duration: kThemeAnimationDuration,
      child: BottomSheet(
        backgroundColor: kColorLight,
        onClosing: () {},
        builder: (BuildContext context) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20.0),
              shrinkWrap: true,
              // primary: true,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Add Event',
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
                                      ))) ??
                          [];
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
                              start = start.copyWith(
                                  hour: data.hour, minute: data.minute);
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
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                    hour: widget.date.hour,
                                    minute: widget.date.minute),
                              );

                              if (time != null) {
                                start = start.copyWith(
                                    hour: time.hour, minute: time.minute);
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
                          label: 'End',
                          controller: endDateCtrl,
                          hint: 'HH:MM',
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Field Required";
                            }
                            try {
                              final data = DateFormat.Hm().parseStrict(val);
                              start = start.copyWith(
                                  hour: data.hour, minute: data.minute);

                              setState(() {});
                            } catch (e) {
                              return "Invalid Format";
                            }
                            return null;
                          },
                          suffix: GestureDetector(
                            child: const Icon(Icons.calendar_today_rounded),
                            onTap: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                    hour: start.hour, minute: start.minute),
                              );
                              if (isSameDay) {
                                end = start.copyWith();
                                endDateCtrl.text = DateFormat.Hm().format(end);
                              }
                              setState(() {});
                              if (time != null) {
                                end = end.copyWith(
                                    hour: time.hour, minute: time.minute);

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
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Consumer<EventAPI>(builder: (context, confAPI, child) {
                    return CustomFilledButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          Event event = Event(
                              id: "",
                              subject: subjectCtrl.text,
                              presenter: selected.map((e) => e.id).toList(),
                              startTime: start,
                              endTime: end,
                              location: locCtrl.text);
                          final data =
                              await confAPI.addEvent(widget.data.id, event);
                          Navigator.pop(context, data);
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
