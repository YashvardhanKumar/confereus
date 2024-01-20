import 'dart:math';

import 'package:confereus/API/conference_api.dart';
import 'package:confereus/API/user_api.dart';
import 'package:confereus/components/button/add_button.dart';
import 'package:confereus/components/button/filled_button.dart';
import 'package:confereus/common_pages/add_members.dart';
import 'package:confereus/components/custom_text.dart';
import 'package:confereus/components/input_fields/text_form_field.dart';
import 'package:confereus/models/user%20model/user_model.dart';
import 'package:confereus/sockets/socket_stream.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/conference model/conference.model.dart';

Future addEvents(BuildContext context, Conference data, DateTime date) async {
  return await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Colors.white,
    // useRootNavigator: true,
    builder: (_) {
      return AddEvents(
        data: data,
      );
    },
  );
}

class AddEvents extends StatefulWidget {
  const AddEvents({
    super.key,
    required this.data,
  });

  final Conference data;

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
  late DateTime start = widget.data.startTime;
  late DateTime end = widget.data.startTime;
  bool isSameDay = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      duration: kThemeAnimationDuration,
      child: FutureBuilder<List<Users>?>(
          future: Provider.of<UserAPI>(context).getAllUsers(context),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return BottomSheet(
                backgroundColor: Colors.white,
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10),
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
                        Padding(
                          padding: const EdgeInsets.all(1.5),
                          child: Row(
                            children: List.generate(
                              selected.length,
                              (index) => Padding(
                                padding: const EdgeInsets.all(1.5),
                                child: InputChip(
                                  backgroundColor: kColorLight,
                                  label: CustomText(selected[index].name),
                                  labelPadding: EdgeInsets.zero,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10),
                          child: AddButton(
                            onPressed: () async {
                              selected = await Navigator.push<List<Users>>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AddMembers(
                                        totalUsers: snapshot.data!,
                                        selectedUsers: selected, includeCurUser: true,
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10),
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
                                      final data =
                                          DateFormat.Hm().parseStrict(val);
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
                                    child: const Icon(
                                        Icons.calendar_today_rounded),
                                    onTap: () async {
                                      final now = DateTime.now();
                                      final time = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay(
                                          hour: now.hour,
                                          minute: now.minute,
                                        ),
                                      );

                                      if (time != null) {
                                        start = DateTime(
                                          start.year,
                                          start.month,
                                          start.day,
                                          time.hour,
                                          time.minute,
                                        );
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
                                      final data =
                                          DateFormat.Hm().parseStrict(val);
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
                                  suffix: GestureDetector(
                                    child: const Icon(
                                        Icons.calendar_today_rounded),
                                    onTap: () async {
                                      final now = DateTime.now();
                                      final time = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay(
                                          hour: now.hour,
                                          minute: now.minute,
                                        ),
                                      );
                                      if (isSameDay) {
                                        end = start.copyWith();
                                        endDateCtrl.text =
                                            DateFormat.Hm().format(end);
                                      }
                                      setState(() {});
                                      if (time != null) {
                                        end = DateTime(
                                          end.year,
                                          end.month,
                                          end.day,
                                          time.hour,
                                          time.minute,
                                        );

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
                          child: Consumer<SocketStream>(
                              builder: (context, confAPI, child) {
                            return CustomFilledButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  Event event = Event(
                                      id: "",
                                      subject: subjectCtrl.text,
                                      presenter:
                                          selected.map((e) => e.id).toList(growable: true),
                                      startTime: start,
                                      endTime: end,
                                      location: locCtrl.text);
                                  final finalmap = event.toJson();
                                  finalmap.addAll({"confId": widget.data.id});
                                  confAPI.addDocument(
                                    'events',
                                    finalmap,
                                  );
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
              );
            }
            return const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              ],
            );
          }),
    );
  }
}
