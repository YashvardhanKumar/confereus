import 'dart:io';
import 'dart:typed_data';

import 'package:confereus/API/conference_api.dart';
import 'package:confereus/components/button/filled_button.dart';
import 'package:confereus/components/custom_text.dart';
import 'package:confereus/components/input_fields/text_form_field.dart';
import 'package:confereus/models/conference%20model/conference.model.dart';
import 'package:confereus/routes/bottom_nav/add_conference/add_events.dart';
import 'package:confereus/sockets/socket_stream.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';

class CreateNewConference extends StatefulWidget {
  const CreateNewConference({Key? key, this.old}) : super(key: key);
  final Conference? old;

  @override
  State<CreateNewConference> createState() => _CreateNewConferenceState();
}

class _CreateNewConferenceState extends State<CreateNewConference> {
  late final subjectCtrl = TextEditingController(text: widget.old?.subject);
  late final aboutCtrl = TextEditingController(text: widget.old?.about);
  late final locCtrl = TextEditingController(text: widget.old?.location);
  late final startDateCtrl = TextEditingController(
      text: widget.old != null
          ? DateFormat("dd/MM/yy").format(widget.old!.startTime)
          : null);
  late final endDateCtrl = TextEditingController(
      text: widget.old != null
          ? DateFormat("dd/MM/yy").format(widget.old!.endTime)
          : null);
  // late final startTimeCtrl = TextEditingController(
  //     text: widget.old != null
  //         ? DateFormat.Hm().format(widget.old!.startTime)
  //         : null);
  // late final endTimeCtrl = TextEditingController(
  //     text: widget.old != null
  //         ? DateFormat.Hm().format(widget.old!.endTime)
  //         : null);
  late final _formKey = GlobalKey<FormState>();
  late DateTime? start = widget.old?.startTime, end = widget.old?.endTime;
  bool isSameDay = false;
  File? eventLogoFile;
  Uint8List? eventLogoBytes;
  bool isClicked = false;

  late bool isPrivateEvent = widget.old?.visibility == null ||
      (widget.old!.visibility == "private" ? true : false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: const CustomText('Create New Conference'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            if (widget.old == null)
              GestureDetector(
                onTap: () async {
                  var data = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (data == null) return;
                  eventLogoFile = File(data.path);
                  eventLogoBytes = await eventLogoFile?.readAsBytes();
                  setState(() {});
                },
                child: (eventLogoBytes != null)
                    ? Image.memory(eventLogoBytes!)
                    : Row(
                        children: [
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(10),
                                height: 120,
                                width: 120,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade200,
                                ),
                                child: const Icon(
                                  Icons.image_rounded,
                                  size: 96,
                                  color: Colors.grey,
                                ),
                              ),
                              const Icon(
                                Icons.add_circle_rounded,
                                color: Colors.grey,
                                size: 32,
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          const Flexible(
                            child: CustomText(
                              'Add Company logo/ Poster of Conference',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
              ),
            const SizedBox(height: 10),
            CustomTextFormField(
              label: 'Subject of Conference',
              controller: subjectCtrl,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return "Field Required";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            CustomTextFormField(
              label: 'About the Conference',
              controller: aboutCtrl,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return "Field Required";
                }
                return null;
              },
              minLines: 5,
              hint: 'Brief about the events',
            ),
            const SizedBox(height: 10),
            CustomTextFormField(
              label: 'Location',
              controller: locCtrl,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return "Field Required";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Flexible(
                  child: CustomTextFormField(
                    label: 'Start Date',
                    controller: startDateCtrl,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Field Required";
                      }
                      return null;
                    },
                    hint: 'DD/MM/YYYY',
                    suffix: GestureDetector(
                      child: const Icon(Icons.calendar_today_rounded),
                      onTap: () async {
                        start = await showDatePicker(
                          context: context,
                          initialDate: start ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: end ??
                              DateTime.now()
                                  .add(const Duration(days: 365, hours: 6)),
                        );
                        if (start != null) {
                          String formattedDate =
                              DateFormat('dd/MM/yyyy').format(start!);
                          setState(() {
                            startDateCtrl.text = formattedDate;
                          });
                        }
                      },
                    ),
                  ),
                ),
                // const SizedBox(width: 10),
                // Flexible(
                //   child: CustomTextFormField(
                //     label: 'Start Time',
                //     controller: startTimeCtrl,
                //     hint: 'HH/MM',
                //     validator: (val) {
                //       if (val == null || val.isEmpty) {
                //         return "Field Required";
                //       }
                //       return null;
                //     },
                //     suffix: GestureDetector(
                //       child: const Icon(Icons.calendar_today_rounded),
                //       onTap: () async {
                //         final time = await showTimePicker(
                //           context: context,
                //           initialTime: const TimeOfDay(hour: 0, minute: 0),
                //           // firstDate: DateTime(1800),
                //           // lastDate: DateTime.now(),
                //         );
                //
                //         if (start != null) {
                //           if (time != null) {
                //             start = start!
                //                 .copyWith(hour: time.hour, minute: time.minute);
                //             setState(() {});
                //           }
                //           String formattedDate = DateFormat.Hm().format(start!);
                //           setState(() {
                //             startTimeCtrl.text = formattedDate;
                //           });
                //         }
                //       },
                //     ),
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Flexible(
                  child: CustomTextFormField(
                    label: 'End Date',
                    enabled: !isSameDay,
                    controller: endDateCtrl,
                    validator: isSameDay
                        ? null
                        : (val) {
                            if (val == null || val.isEmpty) {
                              return "Field Required";
                            }
                            return null;
                          },
                    hint: 'DD/MM/YYYY',
                    suffix: GestureDetector(
                      onTap: () async {
                        end = await showDatePicker(
                          context: context,
                          initialDate: end ?? start ?? DateTime.now(),
                          firstDate: start ?? DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365, hours: 6),
                          ),
                        );

                        // end = await showDatePicker(
                        //   context: context,
                        //   initialDate: DateTime.now(),
                        //   firstDate: start ?? DateTime.now(),
                        //   lastDate:
                        //       DateTime.now().add(Duration(days: 365, hours: 6)),
                        // );
                        // start = range?.start;
                        // end = range?.end;
                        setState(() {});
                        if (end != null && start != null) {
                          setState(() {
                            endDateCtrl.text =
                                DateFormat('dd/MM/yyyy').format(end!);
                            // startDateCtrl.text =
                            //     DateFormat('dd/MM/yyyy').format(start!);
                          });
                        }
                      },
                      child: const Icon(Icons.calendar_today_rounded),
                    ),
                  ),
                ),
                // const SizedBox(width: 10),
                // Flexible(
                //   child: CustomTextFormField(
                //     label: 'End Time',
                //     controller: endTimeCtrl,
                //     validator: (val) {
                //       if (val == null || val.isEmpty) {
                //         return "Field Required";
                //       }
                //       try {
                //         final data = DateFormat.Hm().parseStrict(val);
                //         if (isSameDay && start != null) {
                //           end = start!
                //               .copyWith(hour: data.hour, minute: data.minute);
                //         }
                //         setState(() {});
                //       } catch (e) {
                //         return "Invalid Format";
                //       }
                //       return null;
                //     },
                //     hint: 'HH/MM',
                //     suffix: GestureDetector(
                //       child: const Icon(Icons.calendar_today_rounded),
                //       onTap: () async {
                //         final time = await showTimePicker(
                //           context: context,
                //           initialTime: const TimeOfDay(hour: 0, minute: 0),
                //           // firstDate: DateTime(1800),
                //           // lastDate: DateTime.now(),
                //         );
                //         // if (time != null) {
                //         //   end?.copyWith(hour: time.hour, minute: time.minute);
                //         //   setState(() {});
                //         //   print(end);
                //         // }
                //         if (isSameDay && start != null) {
                //           end = start!.copyWith();
                //           endDateCtrl.text =
                //               DateFormat('dd/MM/yyyy').format(end!);
                //         }
                //         setState(() {});
                //         if (end != null) {
                //           if (time != null) {
                //             end = end!
                //                 .copyWith(hour: time.hour, minute: time.minute);
                //
                //             setState(() {});
                //           }
                //           String formattedDate = DateFormat.Hm().format(end!);
                //           setState(() {
                //             endTimeCtrl.text = formattedDate;
                //           });
                //         }
                //       },
                //     ),
                //   ),
                // ),
              ],
            ),
            // SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                isSameDay = !isSameDay;
                if (start != null && end != null) {
                  end = start!.copyWith(hour: end!.hour, minute: end!.minute);
                  endDateCtrl.text = DateFormat('dd/MM/yyyy').format(end!);
                }
                setState(() {});
              },
              child: Row(
                children: [
                  Checkbox(
                    value: isSameDay,
                    onChanged: (val) {
                      isSameDay = !isSameDay;
                      if (start != null && end != null) {
                        end = start!
                            .copyWith(hour: end!.hour, minute: end!.minute);
                        endDateCtrl.text =
                            DateFormat('dd/MM/yyyy').format(end!);
                      }
                      setState(() {});
                    },
                  ),
                  const CustomText('Held on Same Day'),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                isPrivateEvent = !isPrivateEvent;
                setState(() {});
              },
              child: Row(
                children: [
                  Checkbox(
                    value: isPrivateEvent,
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (val) {
                      isPrivateEvent = !isPrivateEvent;
                      setState(() {});
                    },
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const CustomText(
                    'Private Event',
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Consumer<SocketStream>(
          builder: (context, conferenceAPI, child) {
            return CustomFilledButton(
              child: CustomText(
                widget.old != null ? 'Update' : 'Create Conference',
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  isClicked = true;
                  setState(() {});
                  if (widget.old != null) {
                    conferenceAPI.editDocument(
                      'conferences',
                      {
                        if (subjectCtrl.text != widget.old!.subject)
                          'subject': subjectCtrl.text,
                        if (aboutCtrl.text != widget.old!.about)
                          'about': aboutCtrl.text,
                        // if (eventLogo != conference.eventLogo && eventLogo != null)
                        //   'eventLogo': eventLogo,
                        if (locCtrl.text != widget.old!.location)
                          'location': locCtrl.text,
                        // if (admin != null && !listEquals(admin, conference.admin))
                        //   'admin': admin,
                        // if (reviewer != null && !listEquals(reviewer, conference.reviewer))
                        //   'reviewer': reviewer,
                        // if(registeredID != null && !(conference.registered?.contains(registeredID) ?? false)) 'registered': registeredID,
                        'visibility': isPrivateEvent ? "private" : "public",
                        // if (abstractLink != conference.abstractLink && abstractLink != null)
                        //   'abstractLink': abstractLink,
                        if ((start ?? widget.old!.startTime)
                                .compareTo(widget.old!.startTime) !=
                            0)
                          'startTime': start!.toIso8601String(),
                        if ((end ?? widget.old!.endTime)
                                .compareTo(widget.old!.endTime) !=
                            0)
                          'endTime': end!.toIso8601String(),
                      },
                      // widget.old!.id,
                      // widget.old!,
                      // subject: subjectCtrl.text,
                      // location: locCtrl.text,
                      // about: aboutCtrl.text,
                      // startTime: start,
                      // endTime: end,
                    );
                    //   .then((value) async {
                    // // if (eventLogoFile != null) {
                    // //   await conferenceAPI.uploadConf(eventLogoFile!);
                    // // }
                    isClicked = false;
                    setState(() {});
                    Navigator.pop(context);
                    // });
                    return;
                  }

                  Conference conference = Conference(
                    id: "",
                    subject: subjectCtrl.text,
                    about: aboutCtrl.text,
                    location: locCtrl.text,
                    startTime: start!,
                    visibility: isPrivateEvent ? "Private" : "Public",
                    endTime: end ?? start!,
                    admin: [storage.read('userId')],
                    admin_data: [],
                    events_data: [],
                    reviewer: [],
                    registered: [],
                    creator: storage.read('userId'),
                  );
                  // final data = await
                  Conference? data;
                  conferenceAPI.changedDocumentListener((p0) async {
                    data = Conference.fromJson(p0);
                    if (eventLogoFile != null) {
                      String confUrl =
                          await conferenceAPI.uploadConf(eventLogoFile!);
                      print(confUrl);
                      conferenceAPI
                          .editDocument("conferences", {"eventLogo": confUrl});

                      isClicked = false;
                      setState(() {});
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddEvents(
                            data: data!,
                            isAdmin:
                                (data!.admin.contains(storage.read('userId'))),
                            isEdit: false,
                          ),
                        ),
                      );
                    }
                  }, "conferences");
                  conferenceAPI.addDocument("conferences", conference.toJson());
                  if (data != null) {}
                }
              },
            );
          },
        ),
      ),
    );
  }
}
